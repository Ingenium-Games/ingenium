-- ====================================================================================--

if not c.sql then c.sql = {} end
--
c.sql.gen = {}
--[[
NOTES

]] --

-- ====================================================================================--

function c.sql.gen.CharacterID(cb)
    local bool = false
    local new = nil
    repeat
        new = c.rng.chars(50)
        MySQL.Async.fetchScalar("SELECT `Primary_ID` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;",
            {
                ["@Character_ID"] = new
            }, function(r)
                if r then
                    bool = true
                else
                    bool = false
                end
            end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

function c.sql.gen.CityID(cb)
    local bool = false
    local new = nil
    repeat
        local s1 = string.upper(c.rng.let())
        local s2 = c.rng.nums(5)
        new = string.format("%s-%s", s1, s2)
        MySQL.Async.fetchScalar("SELECT `Primary_ID` FROM `characters` WHERE `City_ID` = @City_ID LIMIT 1;", {
            ["@City_ID"] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

function c.sql.gen.PhoneNumber(cb)
    local bool = false
    local new = nil
    repeat
        new = math.random(200000, 799999)
        MySQL.Async.fetchScalar("SELECT `Primary_ID` FROM `characters` WHERE `Phone` = @Phone LIMIT 1;", {
            ["@Phone"] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

function c.sql.gen.AccountNumber(cb)
    local bool = false
    local new = nil
    repeat
        new = string.upper(c.rng.chars(8))
        MySQL.Async.fetchScalar("SELECT `Character_ID` FROM `character_accounts` WHERE `Account_Number` = @Account_Number LIMIT 1;", {
            ["@Account_Number"] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

function c.sql.gen.Iban(cb)
    local bool = false
    local new = nil
    repeat
        local s1 = c.rng.nums(4)
        local s2 = c.rng.nums(4)
        new = string.format("%s-%s", s1, s2)
        MySQL.Async.fetchScalar("SELECT `Iban` FROM `characters` WHERE `Iban` = @Iban LIMIT 1;", {
            ["@Iban"] = new
        }, function(r)
            if r then
                bool = true
            else
                bool = false
            end
        end)
    until bool == false
    if cb then
        cb()
    end
    return new
end

function c.sql.gen.CarPlate(cb)
    local bool = false
    local new = nil
    repeat
        new = c.rng.chars(8)
        MySQL.Async.fetchScalar("SELECT `Plate` FROM `vehciles` WHERE `Plate` = @Plate LIMIT 1;",
            {
                ["@Plate"] = new
            }, function(r)
                if r then
                    bool = true
                else
                    bool = false
                end
            end)
    until bool == false
    if cb then
        cb()
    end
    return new
end