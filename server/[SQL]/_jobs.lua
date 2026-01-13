-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.jobs = {}
-- ====================================================================================--

--- Get job account balance
-- Returns current bank balance for a job account
-- @param jobName Job name
-- @param cb callback function with balance
function ig.sql.jobs.GetJobAccountBalance(jobName, cb)
    local result = ig.sql.FetchScalar(
        "SELECT `Bank` FROM `banking_job_accounts` WHERE `Job` = ? LIMIT 1;",
        {jobName}
    )
    if cb then
        cb(result or 0)
    end
    return result or 0
end

--- Process single payroll payment
-- Deducts payment from job account (no negative balance allowed)
-- @param jobName Job name
-- @param paymentAmount Amount to pay
-- @param cb callback function with success status
function ig.sql.jobs.ProcessPayment(jobName, paymentAmount, cb)
    local amount = tonumber(paymentAmount) or 0
    
    local query = [[
        UPDATE `banking_job_accounts` 
        SET `Bank` = CASE 
            WHEN `Bank` >= ? THEN `Bank` - ?
            ELSE `Bank`
        END
        WHERE `Job` = ?
    ]]
    
    ig.sql.Update(query, {amount, amount, jobName}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Add payment to player's bank account
-- Deducts from job account and adds to player's personal bank account
-- @param jobName Job name (for deduction)
-- @param characterId Character ID
-- @param paymentAmount Amount to add/deduct
-- @param cb callback function
function ig.sql.jobs.AddPaymentToPlayer(jobName, characterId, paymentAmount, cb)
    local amount = tonumber(paymentAmount) or 0
    
    local queries = {}
    
    -- Deduct from job account
    table.insert(queries, {
        query = [[
            UPDATE `banking_job_accounts` 
            SET `Bank` = CASE 
                WHEN `Bank` >= ? THEN `Bank` - ?
                ELSE `Bank`
            END
            WHERE `Job` = ?
        ]],
        parameters = {amount, amount, jobName}
    })
    
    -- Add to player account
    table.insert(queries, {
        query = [[
            UPDATE `banking_accounts` 
            SET `Bank` = `Bank` + ? 
            WHERE `Character_ID` = ?
        ]],
        parameters = {amount, characterId}
    })
    
    ig.sql.Batch(queries, function(results)
        if cb then
            cb(results and #results or 0)
        end
    end)
end

--- Log job payroll transaction
-- Records transaction to banking_transactions table
-- @param characterId Character ID
-- @param jobName Job name
-- @param paymentAmount Amount paid
-- @param status Payment status (success/declined)
-- @param reason Decline reason if applicable
-- @param cb callback function
function ig.sql.jobs.LogPayrollTransaction(characterId, jobName, paymentAmount, status, reason, cb)
    local description = string.format(
        "Payroll from %s - %s",
        jobName,
        status == "success" and "" or ("Declined: " .. (reason or "Insufficient funds"))
    )
    
    local query = [[
        INSERT INTO `banking_transactions` 
        (`Character_ID`, `Type`, `Description`, `Amount`, `Date`) 
        VALUES (?, ?, ?, ?, NOW());
    ]]
    
    ig.sql.Insert(query, {characterId, "Payroll", description, status == "success" and paymentAmount or 0}, function(insertId)
        if cb then
            cb(insertId)
        end
    end)
end

--- Process bulk payroll payments in batch
-- Creates batch UPDATE queries for multiple employees
-- @param jobName Job name
-- @param payments Table array with {characterId, paymentAmount, status}
-- @param cb callback function
function ig.sql.jobs.ProcessBulkPayments(jobName, payments, cb)
    if not payments or #payments == 0 then
        if cb then cb(0) end
        return
    end
    
    local queries = {}
    local totalDeduction = 0
    
    -- Calculate total deduction needed
    for i = 1, #payments do
        if payments[i].status == "success" then
            totalDeduction = totalDeduction + (tonumber(payments[i].paymentAmount) or 0)
        end
    end
    
    -- Single query to deduct total from job account
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
                parameters = {payment.paymentAmount, payment.characterId}
            })
        end
    end
    
    -- Execute all queries as batch
    ig.sql.Batch(queries, function(results)
        if cb then
            cb(results and #results or 0)
        end
    end)
end

--- Get job account balance sync (for balance checks)
-- @param jobName Job name
-- @return current balance or 0
function ig.sql.jobs.GetJobAccountBalanceSync(jobName)
    return ig.sql.FetchScalar(
        "SELECT `Bank` FROM `banking_job_accounts` WHERE `Job` = ? LIMIT 1;",
        {jobName}
    ) or 0
end
