-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.bank = {}
-- ====================================================================================--

function ig.sql.bank.AddAccount(Character_ID, Account_Number, cb)
    ig.sql.Insert(
        "INSERT INTO `character_accounts` (`Character_ID`, `Account_Number`, `Bank`) VALUES (?, ?, ?);",
        {Character_ID, Account_Number, conf.startingloan},
        function(insertId)
            if cb then
                cb(insertId)
            end
        end)
end

--- Get - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.bank.GetBank(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Bank` FROM `character_accounts` WHERE `Character_ID` = ?;", {character_id})
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
    ig.sql.Update("UPDATE `character_accounts` SET `Bank` = ? WHERE `Character_ID` = ?;", {bank, character_id}, function(affectedRows)
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
    local result = ig.sql.FetchScalar("SELECT `Loan` FROM `character_accounts` WHERE `Character_ID` = ?;", {character_id})
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
        "UPDATE `character_accounts` SET `Loan` = ?, `Duration` = ?, `Active` = TRUE WHERE `Character_ID` = ?;",
        {loan, duration, character_id},
        function(affectedRows)
            if cb then
                cb(affectedRows)
            end
        end)
end

-- cb if any.
function ig.sql.bank.TickOverLoanInterest(cb)
    ig.sql.Update("UPDATE `character_accounts` SET `Loan` = Loan * 3.5 WHERE `Duration` >= 1;", {}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

-- cb if any.
function ig.sql.bank.TickOverLoanDuration(cb)
    ig.sql.Update("UPDATE `character_accounts` SET `Duration` = Duration - 1 WHERE `Active` = TRUE;", {}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

-- cb if any.
function ig.sql.bank.TickOverLoansInactive(cb)
    ig.sql.Update("UPDATE `character_accounts` SET `Active` = FALSE WHERE `Duration` = 0;", {}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end
