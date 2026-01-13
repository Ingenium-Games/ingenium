-- ====================================================================================--
-- Job Payroll System (Player Class State-Based)
-- Processes employee payments every 30 minutes based on on-duty status and minimum work time
-- Uses in-memory Lua table with player.State.Duty for tracking (zero database overhead)
-- ====================================================================================--

if not ig.payroll then ig.payroll = {} end

-- In-memory tracking table: {CharacterId} -> {job, onDutyStart, sourceId}
-- Populated via player.State.Duty changes, used for payroll processing
local onDutyPlayers = {}

-- ====================================================================================--
-- PLAYER STATE CHANGE HANDLER - Track duty status via player class
-- ====================================================================================--

-- Listen for duty status changes via player.State.Duty
-- This is called when SetDuty() is invoked on a player object
AddEventHandler('playerStateChange', function(player, key, value)
    if key == 'Duty' then
        local characterId = player.character_id
        local job = player.job.name or "unknown"
        local sourceId = player.source
        
        if value then
            -- Player going on-duty via player:SetDuty(true)
            onDutyPlayers[characterId] = {
                job = job,
                onDutyStart = os.time(),
                sourceId = sourceId
            }
            ig.log.Info("Payroll", characterId .. " on-duty for " .. job)
            
            -- Notify player
            TriggerClientEvent('chat:addMessage', sourceId, {
                args = {"Payroll", "You are now ^2on-duty^7. You will receive payments every 30 minutes (min 20 min work time)"},
                color = {0, 255, 0}
            })
        else
            -- Player going off-duty via player:SetDuty(false)
            if onDutyPlayers[characterId] then
                ig.log.Info("Payroll", characterId .. " off-duty from " .. job)
                onDutyPlayers[characterId] = nil
                
                -- Notify player
                TriggerClientEvent('chat:addMessage', sourceId, {
                    args = {"Payroll", "You are now ^1off-duty^7. No payments will be received"},
                    color = {255, 0, 0}
                })
            end
        end
    end
end)

-- ====================================================================================--
-- SERVER EVENT - Handle /duty command from client
-- ====================================================================================--

RegisterNetEvent('Character:SetDutyStatus', function(onDuty)
    local src = source
    local xPlayer = ig.player.GetPlayer(src)
    
    if not xPlayer then
        return TriggerClientEvent('chat:addMessage', src, {
            args = {"Payroll", "Error: Unable to load player data"},
            color = {255, 0, 0}
        })
    end
    
    -- Call SetDuty on player object
    -- This will trigger the playerStateChange event above
    xPlayer.SetDuty(onDuty)
end)

-- ====================================================================================--
-- MAIN PAYROLL PROCESSING FUNCTION
-- ====================================================================================--

function ig.payroll.ProcessPayroll()
    if not conf.enablejobpayroll then
        return
    end
    
    ig.log.Info("Payroll", "Starting payroll processing cycle...")
    
    -- Get all configured job payment amounts
    local jobConfigs = conf.jobpayroll or {}
    local jobEmployees = {} -- Group employees by job
    
    -- Group on-duty players by job
    for characterId, dutyData in pairs(onDutyPlayers) do
        local job = dutyData.job
        if not jobEmployees[job] then
            jobEmployees[job] = {}
        end
        table.insert(jobEmployees[job], {
            characterId = characterId,
            sourceId = dutyData.sourceId,
            onDutyStart = dutyData.onDutyStart
        })
    end
    
    -- Process each job with employees
    for jobName, employees in pairs(jobEmployees) do
        local config = jobConfigs[jobName]
        if config and config.enabled then
            ProcessJobPayroll(jobName, config, employees)
        end
    end
    
    ig.log.Info("Payroll", "Payroll cycle completed")
end

--- Process payroll for a single job
-- @param jobName Name of the job
-- @param config Job configuration table {enabled, payment_amount, minimum_duty_minutes}
-- @param employees Array of on-duty employees {characterId, sourceId, onDutyStart}
local function ProcessJobPayroll(jobName, config, employees)
    ig.log.Info("Payroll", "Processing " .. jobName .. " with " .. #employees .. " employees")
    
    if not employees or #employees == 0 then
        return
    end
    
    -- Get job account balance
    ig.sql.jobs.GetJobAccountBalance(jobName, function(jobBalance)
        local payments = {}
        local totalNeeded = 0
        local paymentAmount = tonumber(config.payment_amount) or 0
        local minimumMinutes = tonumber(config.minimum_duty_minutes) or 20
        
        -- Validate each employee for payment eligibility
        for i = 1, #employees do
            local employee = employees[i]
            local characterId = employee.characterId
            local onDutyStart = employee.onDutyStart or 0
            
            -- Check minimum duty time
            local currentTime = os.time()
            local secondsWorked = currentTime - onDutyStart
            local minutesWorked = math.floor(secondsWorked / 60)
            
            local isEligible = minutesWorked >= minimumMinutes
            
            if isEligible then
                -- Employee qualifies for payment
                table.insert(payments, {
                    characterId = characterId,
                    sourceId = employee.sourceId,
                    paymentAmount = paymentAmount,
                    status = "pending"
                })
                totalNeeded = totalNeeded + paymentAmount
            else
                -- Employee worked less than minimum time
                table.insert(payments, {
                    characterId = characterId,
                    sourceId = employee.sourceId,
                    paymentAmount = 0,
                    status = "declined",
                    reason = "Insufficient work time (" .. minutesWorked .. "/" .. minimumMinutes .. " minutes)"
                })
                
                ig.log.Info("Payroll", characterId .. " ineligible: " .. minutesWorked .. "/" .. minimumMinutes .. " minutes")
            end
        end
        
        -- Check if job account has sufficient funds for all eligible payments
        local availableBalance = tonumber(jobBalance) or 0
        
        if availableBalance >= totalNeeded then
            -- Sufficient funds - process all eligible payments
            ig.log.Info("Payroll", jobName .. ": Sufficient balance ($" .. string.format("%.2f", availableBalance) .. ")")
            
            for i = 1, #payments do
                if payments[i].status == "pending" then
                    payments[i].status = "success"
                end
            end
            
            ProcessPaymentBatch(jobName, payments, paymentAmount)
        else
            -- Insufficient funds - no payments processed
            ig.log.Error("Payroll", jobName .. ": Insufficient balance ($" .. string.format("%.2f", availableBalance) .. " < $" .. string.format("%.2f", totalNeeded) .. ")")
            
            for i = 1, #payments do
                if payments[i].status == "pending" then
                    payments[i].status = "declined"
                    payments[i].reason = "Job account insufficient funds"
                end
            end
            
            ProcessPaymentBatch(jobName, payments, paymentAmount)
        end
    end)
end

--- Process a batch of payments with notifications
-- @param jobName Job name
-- @param payments Array of payment records
-- @param paymentAmount Amount each employee should receive
local function ProcessPaymentBatch(jobName, payments, paymentAmount)
    if not payments or #payments == 0 then
        return
    end
    
    -- Use ig.sql.Batch for all database operations
    local queries = {}
    local totalDeduction = 0
    
    -- Calculate total deduction needed from job account
    for i = 1, #payments do
        if payments[i].status == "success" then
            totalDeduction = totalDeduction + paymentAmount
        end
    end
    
    -- Add deduction from job account if there are successful payments
    if totalDeduction > 0 then
        table.insert(queries, {
            query = [[
                UPDATE `banking_job_accounts` 
                SET `Bank` = CASE 
                    WHEN `Bank` >= ? THEN `Bank` - ?
                    ELSE `Bank`
                END
                WHERE `Job` = ?
            ]],
            parameters = {totalDeduction, totalDeduction, jobName}
        })
    end
    
    -- Add payment to each player's account (only successful payments)
    for i = 1, #payments do
        local payment = payments[i]
        if payment.status == "success" then
            table.insert(queries, {
                query = [[
                    UPDATE `banking_accounts` 
                    SET `Bank` = `Bank` + ? 
                    WHERE `Character_ID` = ?
                ]],
                parameters = {paymentAmount, payment.characterId}
            })
        end
    end
    
    -- Execute all database queries as batch
    ig.sql.Batch(queries, function(results)
        -- After database operations complete, send notifications to players
        ProcessPaymentNotifications(jobName, payments, paymentAmount)
    end)
end

--- Send notifications and log transactions for all payments
-- @param jobName Job name
-- @param payments Array of payment records
-- @param paymentAmount Standard payment amount
local function ProcessPaymentNotifications(jobName, payments, paymentAmount)
    for i = 1, #payments do
        local payment = payments[i]
        local characterId = payment.characterId
        
        -- Log transaction
        ig.sql.jobs.LogPayrollTransaction(
            characterId,
            jobName,
            payment.status == "success" and paymentAmount or 0,
            payment.status,
            payment.reason,
            function() end
        )
        
        -- Notify player if online
        if payment.sourceId then
            if payment.status == "success" then
                TriggerClientEvent('chat:addMessage', payment.sourceId, {
                    args = {
                        "Payroll",
                        "You received ^2$" .. string.format("%.2f", paymentAmount) .. "^7 for your work at " .. jobName
                    },
                    color = {0, 255, 0}
                })
            else
                TriggerClientEvent('chat:addMessage', payment.sourceId, {
                    args = {
                        "Payroll",
                        "Payroll ^1declined^7: " .. (payment.reason or "Unknown reason")
                    },
                    color = {255, 0, 0}
                })
            end
        end
    end
end

-- ====================================================================================--
-- CRON JOB REGISTRATION - Run payroll every 30 minutes
-- ====================================================================================--

-- Register payroll processing as a cron job (every 30 minutes: :00 and :30 of each hour)
if ig.cron and ig.cron.RunAt then
    for hour = 0, 23 do
        -- Run at :00 of each hour
        ig.cron.RunAt(hour, 0, function()
            if conf.enablejobpayroll then
                ig.payroll.ProcessPayroll()
            end
        end)
        
        -- Run at :30 of each hour
        ig.cron.RunAt(hour, 30, function()
            if conf.enablejobpayroll then
                ig.payroll.ProcessPayroll()
            end
        end)
    end
    ig.log.Info("Payroll", "Initialized. Running payroll every 30 minutes via cron")
end

ig.log.Info("Payroll", "Loaded successfully - Using player class state-based tracking")
