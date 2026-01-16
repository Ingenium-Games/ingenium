
-- ====================================================================================--

function ig.sql.bank.AddAccount(Character_ID, Account_Number, IBan, cb)
    if not startingloan then
    local Amount = ig.check.Number(conf.default.bank)
    ig.sql.Insert(
        "INSERT INTO `banking_accounts` (`Character_ID`, `Account_Number`, `Bank`, `Iban`) VALUES (?, ?, ?, ?);",
        {Character_ID, Account_Number, Amount, IBan},
        function(insertId)
            if cb then
                cb(insertId)
            end
        end)
    else
    local Amount = ig.check.Number(conf.default.bank) + ig.check.Number(conf.banking.startingloanamount)
    local Loan = conf.banking.startingloanamount
    local Duration = conf.banking.startingloanduration -- 30 days
    ig.sql.Insert(
        "INSERT INTO `banking_accounts` (`Character_ID`, `Account_Number`, `Bank`, `Iban`, `Loan`, `Duration`) VALUES (?, ?, ?, ?, ?, ?);",
        {Character_ID, Account_Number, Amount, IBan, Loan, Duration},
        function(insertId)
            if cb then
                cb(insertId)
            end
        end)
    end
end

--- Get - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.bank.GetBank(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Bank` FROM `banking_accounts` WHERE `Character_ID` = ?;", {character_id})
    if cb then
        cb(result)
    end
    return result
end

--- SET - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- @Bank - INT VALUE
-- cb if any.
function ig.sql.bank.SetBank(character_id, bank, cb)
    ig.sql.Update("UPDATE `banking_accounts` SET `Bank` = ? WHERE `Character_ID` = ?;", {bank, character_id}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

function ig.sql.bank.TakeOutLoan(character_id, amount, duration, cb)
    local Character_ID = character_id
    local Bank = ig.sql.char.GetBank(Character_ID)
    local Amount = amount
    local NewBank = Bank + Amount
    local Duration = duration
    --
    ig.sql.SetCharacterBank(Character_ID, NewBank, function()
        ig.sql.SetCharacterLoan(Character_ID, Amount, Duration)
    end)
end

--- Get - The `Loan` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.bank.GetLoan(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Loan` FROM `banking_accounts` WHERE `Character_ID` = ?;", {character_id})
    if cb then
        cb(result)
    end
    return result
end

--- SET - The `Loan` from the `Character_ID`
-- @`Character_ID`
-- @Loan - INT VALUE
-- @Duration - INT VALUE
-- cb if any.
function ig.sql.bank.SetLoan(character_id, loan, duration, cb)
    ig.sql.Update(
        "UPDATE `banking_accounts` SET `Loan` = ?, `Duration` = ?, `Active` = TRUE WHERE `Character_ID` = ?;",
        {loan, duration, character_id},
        function(affectedRows)
            if cb then
                cb(affectedRows)
            end
        end)
end

-- cb if any.
function ig.sql.bank.TickOverLoanInterest(cb)
    ig.sql.Update("UPDATE `banking_accounts` SET `Loan` = Loan * 3.5 WHERE `Duration` >= 1;", {}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

-- cb if any.
function ig.sql.bank.TickOverLoanDuration(cb)
    ig.sql.Update("UPDATE `banking_accounts` SET `Duration` = Duration - 1 WHERE `Active` = TRUE;", {}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

-- cb if any.
function ig.sql.bank.TickOverLoansInactive(cb)
    ig.sql.Update("UPDATE `banking_accounts` SET `Active` = FALSE WHERE `Duration` = 0;", {}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Get all loan-enabled accounts with outstanding loans
-- Returns a table of accounts with active loans
-- @param cb callback function with results table
function ig.sql.bank.GetAllLoansEnabled(cb)
    local query = [[
        SELECT `Character_ID`, `Bank`, `Loan`, `Duration`, `Active` 
        FROM `banking_accounts` 
        WHERE `Loan` > 0 AND `Active` = TRUE
    ]]
    
    local result = ig.sql.Query(query, {})
    if cb then
        cb(result or {})
    end
    return result or {}
end

--- Process interest on all active loans
-- Adds interest percentage to all outstanding loans with rounding to 2 decimal places
-- @param interestRate percentage rate (e.g., 3.5 for 3.5%)
-- @param cb callback function with affected rows count
function ig.sql.bank.ProcessLoanInterest(interestRate, cb)
    local rate = (tonumber(interestRate) or 0) / 100
    local query = [[
        UPDATE `banking_accounts` 
        SET `Loan` = ROUND(`Loan` * (1 + ?), 2) 
        WHERE `Loan` > 0 AND `Active` = TRUE
    ]]
    
    ig.sql.Update(query, {rate}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Process loan payment from bank balance using bulk query
-- Allows accounts to go negative to enable debt functionality
-- Processes all accounts in a single query via ig.sql.Batch
-- @param loans table Array of loan accounts
-- @param cb callback function with affected rows
function ig.sql.bank.ProcessBulkLoanPayments(loans, cb)
    if not loans or #loans == 0 then
        if cb then cb(0) end
        return
    end
    
    local queries = {}
    
    for i = 1, #loans do
        local loan = loans[i]
        local characterId = loan.Character_ID
        local currentLoan = tonumber(loan.Loan) or 0
        local paymentAmount = math.ceil(currentLoan * 0.1) -- 10% of loan
        
        table.insert(queries, {
            query = [[
                UPDATE `banking_accounts` 
                SET 
                    `Bank` = `Bank` - ?,
                    `Loan` = `Loan` - ?
                WHERE `Character_ID` = ? AND `Loan` > 0
            ]],
            parameters = {paymentAmount, paymentAmount, characterId}
        })
    end
    
    -- Execute all payment queries as a batch
    ig.sql.Batch(queries, function(results)
        if cb then
            cb(results and #results or 0)
        end
    end)
end

--- Process loan payment from bank balance
-- Deducts payment amount from bank balance and reduces loan
-- Allows account to go negative to enable debt functionality
-- @param characterId Character ID
-- @param paymentAmount Amount to deduct from bank and loan
-- @param cb callback function
function ig.sql.bank.ProcessLoanPayment(characterId, paymentAmount, cb)
    local amount = tonumber(paymentAmount) or 0
    local query = [[
        UPDATE `banking_accounts` 
        SET 
            `Bank` = `Bank` - ?,
            `Loan` = `Loan` - ?
        WHERE `Character_ID` = ? AND `Loan` > 0
    ]]
    
    ig.sql.Update(query, {amount, amount, characterId}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Get all accounts with insufficient bank balance for loan payments
-- Used to identify accounts that went negative after payment attempt
-- @param cb callback function with results
function ig.sql.bank.GetAccountsWithNegativeBalance(cb)
    local query = [[
        SELECT `Character_ID`, `Bank`, `Loan` 
        FROM `banking_accounts` 
        WHERE `Bank` < 0
    ]]
    
    local result = ig.sql.Query(query, {})
    if cb then
        cb(result or {})
    end
    return result or {}
end

--- Update loan payment status and mark as inactive if fully paid
-- @param characterId Character ID
-- @param cb callback function
function ig.sql.bank.CheckAndFinalizeLoan(characterId, cb)
    local query = [[
        UPDATE `banking_accounts` 
        SET `Active` = FALSE 
        WHERE `Character_ID` = ? AND `Loan` <= 0
    ]]
    
    ig.sql.Update(query, {characterId}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

--- Get all accounts with negative balance
-- Returns a table of accounts with negative bank balance (overdraft)
-- @param cb callback function with results table
function ig.sql.bank.GetNegativeBalanceAccounts(cb)
    local query = [[
        SELECT `Character_ID`, `Bank` 
        FROM `banking_accounts` 
        WHERE `Bank` < 0
    ]]
    
    local result = ig.sql.Query(query, {})
    if cb then
        cb(result or {})
    end
    return result or {}
end

--- Apply overdraft fee to all negative accounts
-- Deducts overdraft fee from all accounts with negative balance
-- @param feeAmount Fee amount to charge
-- @param cb callback function with affected rows count
function ig.sql.bank.ApplyOverdraftFees(feeAmount, cb)
    local fee = tonumber(feeAmount) or 0
    local query = [[
        UPDATE `banking_accounts` 
        SET `Bank` = `Bank` - ? 
        WHERE `Bank` < 0
    ]]
    
    ig.sql.Update(query, {fee}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end
