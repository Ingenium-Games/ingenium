-- ====================================================================================--
ig.bank = {}
-- ====================================================================================--

local payments = false

-- Pulls all characters with loans and deducts money to pay the loan from their bank balance
--- Processes automatic loan payments at scheduled time using batch queries
function ig.bank.CalculatePayments()
    local xJob = ig.data.GetJob("bank")
    
    if not xJob then
        ig.func.Debug_1("Bank job not found for loan payment processing")
        return
    end
    
    -- Get all active loans from database
    ig.sql.bank.GetAllLoansEnabled(function(loans)
        if not loans or #loans == 0 then
            ig.func.Debug_1("No active loans to process for payment")
            return
        end
        
        local batchQueries = {}
        local transactionLog = {}
        local batchSize = 50 -- Process 50 accounts per batch to prevent thread hitching
        local totalBatches = math.ceil(#loans / batchSize)
        local totalPaymentsProcessed = 0
        local totalLoanReduction = 0
        
        -- Function to process a batch of loans
        local function processBatch(startIdx, endIdx, batchNum)
            Citizen.CreateThread(function()
                for i = startIdx, endIdx do
                    local loanAccount = loans[i]
                    local characterId = loanAccount.Character_ID
                    local currentBank = tonumber(loanAccount.Bank) or 0
                    local currentLoan = tonumber(loanAccount.Loan) or 0
                    local currentDuration = tonumber(loanAccount.Duration) or 1
                    
                    -- Calculate payment amount: Loan / Duration (divide remaining loan by remaining duration)
                    -- Round to 2 decimal places for currency precision using ig.math.Decimals()
                    local paymentAmount = ig.math.Decimals(currentLoan / math.max(1, currentDuration), 2)
                    
                    table.insert(batchQueries, {
                        query = [[
                            UPDATE `banking_accounts` 
                            SET 
                                `Bank` = `Bank` - ?,
                                `Loan` = `Loan` - ?,
                                `Duration` = `Duration` - 1
                            WHERE `Character_ID` = ? AND `Loan` > 0 AND `Duration` > 0
                        ]],
                        parameters = {paymentAmount, paymentAmount, characterId}
                    })
                    
                    -- Store transaction info for logging
                    table.insert(transactionLog, {
                        characterId = characterId,
                        paymentAmount = paymentAmount,
                        currentBank = currentBank,
                        currentLoan = currentLoan,
                        currentDuration = currentDuration
                    })
                end
                
                -- Execute this batch of queries
                if #batchQueries > 0 then
                    ig.sql.Batch(batchQueries, function(results)
                        -- Process results and log transactions
                        for i = 1, #transactionLog do
                            local txLog = transactionLog[i]
                            local characterId = txLog.characterId
                            local paymentAmount = txLog.paymentAmount
                            local currentBank = txLog.currentBank
                            local currentLoan = txLog.currentLoan
                            local currentDuration = txLog.currentDuration
                            
                            -- Log transaction
                            ig.sql.banking.AddTransaction(characterId, {
                                type = "Loan Payment",
                                description = "Automatic loan payment from bank account",
                                amount = -paymentAmount
                            })
                            
                            totalPaymentsProcessed = totalPaymentsProcessed + 1
                            totalLoanReduction = totalLoanReduction + paymentAmount
                            
                            -- Check if player is online and send notification
                            local xPlayer = ig.data.GetPlayer(characterId)
                            if xPlayer then
                                local newBank = currentBank - paymentAmount
                                local newLoan = math.max(0, currentLoan - paymentAmount)
                                local newDuration = currentDuration - 1
                                
                                TriggerClientEvent("Client:Notify", xPlayer.GetID(),
                                    "Automatic Loan Payment\n" ..
                                    "Amount Deducted: $" .. string.format("%.2f", paymentAmount) .. "\n" ..
                                    "New Bank Balance: $" .. string.format("%.2f", newBank) .. "\n" ..
                                    "Remaining Loan: $" .. string.format("%.2f", newLoan) .. "\n" ..
                                    "Days Remaining: " .. newDuration,
                                    "info", 5000)
                            end
                            
                            -- Check if this was the final payment (duration reached 0)
                            if currentDuration == 1 then
                                -- Verify loan is paid in full or mark as complete
                                ig.sql.bank.CheckAndFinalizeLoan(characterId, function(affectedRows)
                                    if xPlayer then
                                        TriggerClientEvent("Client:Notify", xPlayer.GetID(),
                                            "Loan Payment Plan Complete\n" ..
                                            "Your loan payment schedule has finished.",
                                            "success", 5000)
                                    end
                                end)
                            end
                        end
                        
                        -- Add payments to bank job account
                        local totalPayments = 0
                        for i = 1, #transactionLog do
                            totalPayments = totalPayments + transactionLog[i].paymentAmount
                        end
                        xJob.AddBank(totalPayments)
                        
                        ig.func.Debug_1("Loan payment batch " .. batchNum .. "/" .. totalBatches .. 
                                       " complete: " .. #transactionLog .. " processed")
                    end)
                end
                
                -- Clear batch for next iteration
                batchQueries = {}
                transactionLog = {}
                
                -- Small break to prevent thread hitching
                Citizen.Wait(50)
            end)
        end
        
        -- Process loans in batches with breaks between batches
        for batch = 1, totalBatches do
            local startIdx = ((batch - 1) * batchSize) + 1
            local endIdx = math.min(batch * batchSize, #loans)
            
            processBatch(startIdx, endIdx, batch)
            Citizen.Wait(100) -- Break between batch threads
        end
    end)
end

-- queued to add
AddEventHandler("onServerResourceStart", function()
    if not payments then
        ig.cron.RunAt(conf.loanpayment.h, conf.loanpayment.m, ig.bank.CalculatePayments)
        payments = true
    end -- ig.func.Debug_1("[E] Added Cron Job [F] ig.bank.CalculatePayments()")
end)
--

local interest = false
-- queued to add
AddEventHandler("onServerResourceStart", function()
    if not interest then
        ig.cron.RunAt(conf.loaninterest.h, conf.loaninterest.m, ig.bank.CalculateInterest)
        interest = true
    end -- ig.func.Debug_1("[E] Added Cron Job [F] ig.bank.CalculateInterest()")
end)

---- Updates the characters loan to add the interest on the outstanding amount each day.
--- Processes daily interest calculation on all active loans using batch queries
function ig.bank.CalculateInterest()
    local xJob = ig.data.GetJob("bank")
    
    if not xJob then
        ig.func.Debug_1("Bank job not found for interest calculation")
        return
    end
    
    local interestRate = conf.interestrate or 5 -- Default 5% if not configured
    
    -- Get all active loans from database
    ig.sql.bank.GetAllLoansEnabled(function(loans)
        if not loans or #loans == 0 then
            ig.func.Debug_1("No active loans to process for interest")
            return
        end
        
        local initialLoans = {}
        -- Store initial loan amounts for comparison
        for i = 1, #loans do
            initialLoans[loans[i].Character_ID] = tonumber(loans[i].Loan) or 0
        end
        
        -- Process interest on all loans via single SQL query
        ig.sql.bank.ProcessLoanInterest(interestRate, function(affectedRows)
            -- Retrieve updated loan amounts for notifications
            ig.sql.bank.GetAllLoansEnabled(function(updatedLoans)
                if updatedLoans and #updatedLoans > 0 then
                    local batchSize = 50
                    local totalBatches = math.ceil(#updatedLoans / batchSize)
                    local totalAccountsProcessed = 0
                    local totalInterestCharged = 0
                    
                    -- Function to process a batch of notifications
                    local function processBatch(startIdx, endIdx, batchNum)
                        Citizen.CreateThread(function()
                            for i = startIdx, endIdx do
                                local loanAccount = updatedLoans[i]
                                local characterId = loanAccount.Character_ID
                                local previousLoan = initialLoans[characterId] or 0
                                local newLoan = tonumber(loanAccount.Loan) or 0
                                local interestCharged = newLoan - previousLoan
                                
                                if interestCharged > 0 then
                                    totalInterestCharged = totalInterestCharged + interestCharged
                                    
                                    -- Log transaction
                                    ig.sql.banking.AddTransaction(characterId, {
                                        type = "Interest Charge",
                                        description = "Daily interest charge on outstanding loan (" .. interestRate .. "%)",
                                        amount = -interestCharged
                                    })
                                    
                                    -- Check if player is online and send notification
                                    local xPlayer = ig.data.GetPlayer(characterId)
                                    if xPlayer then
                                        -- Round interest values to 2 decimal places using ig.math.Decimals()
                                        local displayInterest = ig.math.Decimals(interestCharged, 2)
                                        local displayNewLoan = ig.math.Decimals(newLoan, 2)
                                        
                                        TriggerClientEvent("Client:Notify", xPlayer.GetID(),
                                            "Daily Loan Interest Applied\n" ..
                                            "Interest Rate: " .. interestRate .. "%\n" ..
                                            "Interest Charged: $" .. string.format("%.2f", displayInterest) .. "\n" ..
                                            "New Loan Balance: $" .. string.format("%.2f", displayNewLoan),
                                            "warning", 5000)
                                    end
                                end
                                
                                totalAccountsProcessed = totalAccountsProcessed + 1
                            end
                            
                            ig.func.Debug_1("Interest calculation batch " .. batchNum .. "/" .. totalBatches .. 
                                           " complete: " .. (endIdx - startIdx + 1) .. " accounts processed")
                            
                            -- Small break to prevent thread hitching
                            Citizen.Wait(50)
                        end)
                    end
                    
                    -- Process notifications in batches with breaks
                    for batch = 1, totalBatches do
                        local startIdx = ((batch - 1) * batchSize) + 1
                        local endIdx = math.min(batch * batchSize, #updatedLoans)
                        
                        processBatch(startIdx, endIdx, batch)
                        Citizen.Wait(100) -- Break between batch threads
                    end
                    
                    ig.func.Debug_1("Interest calculation complete: " .. affectedRows .. 
                                   " accounts processed, $" .. math.ceil(totalInterestCharged) .. " total interest charged")
                end
            end)
        end)
    end)
end


--- func desc
function ig.bank.CheckNegativeBalances()
    local xJob = ig.data.GetJob("bank")
    local xPlayers = ig.data.GetPlayers()
    for k, v in pairs(xPlayers) do
        if v then
            local xPlayer = v
            local bank = xPlayer.GetBank()
            if bank < 0 then
                TriggerClientEvent("Client:Notify", xPlayer.GetID(),
                    "Your Bank account is in negative. \nCurrent Balance is: $ " .. bank ..
                        ". \nOver Draw Fee Charged at: $" .. conf.bankoverdraw ..
                        ". \nThese fees apply every hour, on the hour, until balanced.", "error", 17500)
                xPlayer.RemoveBank(conf.bankoverdraw)
                xJob.AddBank(conf.bankoverdraw)
            end
        end
    end
    -- ig.func.Debug_1("Active clients notified of negative bank balances and Fees charged at $"..conf.bankoverdraw)
end

local negative = false
-- queued to add
-- Set so the server will debit bank accounts on the hour every hour if in negative balance.
AddEventHandler("onServerResourceStart", function()
    if not negative then
        for i = 0, 23, 1 do
            ig.cron.RunAt(i, 0, ig.bank.CheckNegativeBalances)
        end
        negative = true
    end
    -- ig.func.Debug_1("[E] Added Cron Job: [F] ig.bank.CheckNegativeBalances()")
end)
