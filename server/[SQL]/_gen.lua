-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.gen = {}
-- ====================================================================================--

function ig.sql.gen.CharacterID(cb)
    local bool = false
    local new = nil
    repeat
        new = ig.rng.chars(50)
        local r = ig.sql.FetchScalar("SELECT `Primary_ID` FROM `characters` WHERE `Character_ID` = ? LIMIT 1;", {new})
        if r then
            bool = true
        else
            bool = false
        end
    until bool == false
    if cb then
        cb()
    end
    return new
end

function ig.sql.gen.CityID(cb)
    local bool = false
    local new = nil
    repeat
        local s1 = string.upper(ig.rng.let())
        local s2 = ig.rng.nums(5)
        new = string.format("%s-%s", s1, s2)
        local r = ig.sql.FetchScalar("SELECT `Primary_ID` FROM `characters` WHERE `City_ID` = ? LIMIT 1;", {new})
        if r then
            bool = true
        else
            bool = false
        end
    until bool == false
    if cb then
        cb()
    end
    return new
end

function ig.sql.gen.PhoneNumber(cb)
    local bool = false
    local new = nil
    repeat
        new = math.random(200000, 799999)
        local r = ig.sql.FetchScalar("SELECT `Primary_ID` FROM `characters` WHERE `Phone` = ? LIMIT 1;", {new})
        if r then
            bool = true
        else
            bool = false
        end
    until bool == false
    if cb then
        cb()
    end
    return new
end

function ig.sql.gen.AccountNumber(cb)
    local bool = false
    local new = nil
    repeat
        new = string.upper(ig.rng.chars(8))
        local r = ig.sql.FetchScalar("SELECT `Character_ID` FROM `character_accounts` WHERE `Account_Number` = ? LIMIT 1;", {new})
        if r then
            bool = true
        else
            bool = false
        end
    until bool == false
    if cb then
        cb()
    end
    return new
end

function ig.sql.gen.Iban(cb)
    local bool = false
    local new = nil
    repeat
        local s1 = ig.rng.nums(4)
        local s2 = ig.rng.nums(4)
        new = string.format("%s-%s", s1, s2)
        local r = ig.sql.FetchScalar("SELECT `Iban` FROM `characters` WHERE `Iban` = ? LIMIT 1;", {new})
        if r then
            bool = true
        else
            bool = false
        end
    until bool == false
    if cb then
        cb()
    end
    return new
end

function ig.sql.gen.CarPlate(cb)
    local bool = false
    local new = nil
    repeat
        new = string.upper(ig.rng.chars(8))
        local r = ig.sql.FetchScalar("SELECT `Plate` FROM `vehicles` WHERE `Plate` = ? LIMIT 1;", {new})
        if r then
            bool = true
        else
            bool = false
        end
    until bool == false
    if cb then
        cb()
    end
    return new
end