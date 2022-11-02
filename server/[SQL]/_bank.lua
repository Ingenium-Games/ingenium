-- ====================================================================================--

if not c.sql then c.sql = {} end
c.sql.bank = {}

-- ====================================================================================--

function c.sql.bank.AddAccount(Character_ID, Account_Number, cb)
    MySQL.Async.execute(
        "INSERT INTO `character_accounts` (`Character_ID`, `Account_Number`, `Bank`) VALUES (@Character_ID, @Account_Number, @Bank);",{
            ["@Character_ID"] = Character_ID,
            ["@Account_Number"] = Account_Number,
            ["@Bank"] = conf.startingloan,
        }, function(data)
            if data then

            end
            if cb then
                cb()
            end
        end)
end

--- Get - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.bank.GetBank(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar("SELECT `Bank` FROM `character_accounts` WHERE `Character_ID` = @Character_ID;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- @Bank - INT VALUE
-- cb if any.
function c.sql.bank.SetBank(character_id, bank, cb)
    local Character_ID = character_id
    local Bank = bank
    MySQL.Async.execute("UPDATE `character_accounts` SET `Bank` = @Bank WHERE `Character_ID` = @Character_ID;", {
        ["@Bank"] = Bank,
        ["@Character_ID"] = Character_ID
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

function c.sql.bank.TakeOutLoan(character_id, amount, duration, cb)
    local Character_ID = character_id
    local Bank = c.sql.char.GetBank(Character_ID)
    local Amount = amount
    local NewBank = Bank + Amount
    local Duration = duration
    --
    c.sql.SetCharacterBank(Character_ID, NewBank, function()
        c.sql.SetCharacterLoan(Character_ID, Amount, Duration)
    end)
end

--- Get - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function c.sql.bank.GetLoan(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchScalar("SELECT `Loan` FROM `character_accounts` WHERE `Character_ID` = @Character_ID;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        if data then
            result = data
            IsBusy = false
        end
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Bank` from the `Character_ID`
-- @`Character_ID`
-- @Bank - INT VALUE
-- cb if any.
function c.sql.bank.SetLoan(character_id, loan, duration, cb)
    local Character_ID = character_id
    local Loan = loan
    local Duration = duration
    MySQL.Async.execute(
        "UPDATE `character_accounts` SET `Loan` = @Loan, `Duration` = @Duration, `Active` = TRUE WHERE `Character_ID` = @Character_ID;",
        {
            ["@Loan"] = Loan,
            ["@Duration"] = Duration,
            ["@Character_ID"] = Character_ID
        }, function(data)
            if data then
                --
            end
            if cb then
                cb()
            end
        end)
end

-- cb if any.
function c.sql.bank.TickOverLoanInterest(cb)
    MySQL.Async.execute("UPDATE `character_accounts` SET `Loan` = Loan * 3.5 WHERE `Duration` >= 1;", {}, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

-- cb if any.
function c.sql.bank.TickOverLoanDuration(cb)
    MySQL.Async.execute("UPDATE `character_accounts` SET `Duration` = Duration - 1 WHERE `Active` = TRUE;", {},
        function(data)
            if data then
                --
            end
            if cb then
                cb()
            end
        end)
end

-- cb if any.
function c.sql.bank.TickOverLoansInactive(cb)
    MySQL.Async.execute("UPDATE `character_accounts` SET `Active` = FALSE WHERE `Duration` = 0;", {}, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end
