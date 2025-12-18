-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.char = {}
-- ====================================================================================--
-- SHould remake htis one..
function ig.sql.char.Add(t, cb)
    ig.sql.Insert(
        "INSERT INTO `characters` (`Created`, `Last_Seen`, `Primary_ID`, `Character_ID`, `City_ID`, `First_Name`, `Last_Name`, `Iban`, `Phone`, `Coords`, `Accounts`, `Modifiers`, `Appearance`, `Skills`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
        {
            ig.funig.Timestamp(),
            ig.funig.Timestamp(),
            t.Primary_ID,
            t.Character_ID,
            t.City_ID,
            t.First_Name,
            t.Last_Name,
            t.Iban,
            t.Phone,
            t.Coords,
            t.Accounts,
            t.Modifiers,
            t.Appearance,
            t.Skills
        }, function(insertId)
            TriggerEvent("txaLogger:CommandExecuted", "Adding new Character for Primary_ID: "..t.Primary_ID)
            if cb then
                cb(insertId)
            end
        end)
end

--- Get - Info on the characters owned to prefill the multicharacter selection
-- @License_ID
function ig.sql.char.GetAll(primary_id, cb)
    local result = ig.sql.Query("SELECT * FROM `characters` WHERE `Primary_ID` = ?;", {primary_id})
    if cb then
        cb()
    end
    return result
end

--- Get - Info on the characters owned to prefill the multicharacter selection
-- @License_ID
function ig.sql.char.GetAllNotDead(primary_id, cb)
    local result = ig.sql.Query("SELECT * FROM `characters` WHERE `Primary_ID` = ? AND `Is_Dead` = FALSE;", {primary_id})
    if cb then
        cb()
    end
    return result
end


--- Get - Info on the characters owned to prefill the multicharacter selection
-- @License_ID
function ig.sql.char.GetAllPermited(primary_id, slots, cb)
    local result = ig.sql.Query("SELECT * FROM `characters` WHERE `Primary_ID` = ? AND `Is_Dead` = FALSE LIMIT ?;", {primary_id, slots})
    if cb then
        cb()
    end
    return result
end

function ig.sql.char.ReviveDeadCharacters(cb)
    local result = ig.sql.Update(
        "UPDATE `characters` SET `Health` = 150, `Is_Dead` = FALSE, `Coords` = ?, `Dead_Time` = NULL, `Dead_Data` = ? WHERE `Dead_Time` <= (? - '604800')",
        {
            json.encode({["z"]=43.28,["h"]=337.32,["x"]=327.52,["y"]=-603.03}), -- Pillbox Elevators
            json.encode({["RevivedAt"]= ig.funig.Timestamp(), ["By"]="Server"}),
            ig.funig.Timestamp()
        },
        function(affectedRows)
            if cb then
                cb(affectedRows)
            end
        end)
    return result
end

--- Get - The entire ROW of data from Characters table where the Character_ID is the character id.
-- @Primary_ID
function ig.sql.char.Get(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchAll("SELECT * FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        result = data[1]
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - # of characters owned = FALSE
-- @Primary_ID
function ig.sql.char.GetCount(primary_id, cb)
    local Primary_ID = primary_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT COUNT(`Primary_ID`) AS 'Count' FROM `characters` WHERE `Primary_ID` = @Primary_ID;",
        {
            ["@Primary_ID"] = Primary_ID
        }, function(data)
            result = data
            IsBusy = false
        end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    -- Always return a value.
    if result == nil then
        result = 0
    end
    --
    return result
end

function ig.sql.char.Delete(character_id, cb)
    local Character_ID = character_id
    MySQL.Asynig.execute("DELETE FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        if data then
            TriggerEvent("txaLogger:CommandExecuted", "Deleting Character: "..Character_ID)
        end
        if cb then
            cb()
        end
    end)
end

--- Get - The `Active` = TRUE `Character_ID` from the Primary_ID identifier
-- @Primary_ID
function ig.sql.char.Current(primary_id, cb)
    local Primary_ID = primary_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar(
        "SELECT `Character_ID` FROM `characters` WHERE `Active` IS TRUE AND `Primary_ID` = @Primary_ID", {
            ["@Primary_ID"] = Primary_ID
        }, function(data)
            result = data
            IsBusy = false
        end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- SET - The `Active` = BOOLEAN `Character_ID` from the Primary_ID identifier
-- @`Character_ID`
function ig.sql.char.SetActive(character_id, bool, cb)
    if type(bool) ~= "boolean" then ig.funig.Debug_1("ig.sql.char.SetActive, boolean was not passed") return end
    local Character_ID = character_id
    local Bool = bool
    MySQL.Asynig.execute("UPDATE `characters` SET `Active` = @Bool WHERE `Character_ID` = @Character_ID", {
        ["@Bool"] = Bool,
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

--- SET - The `Active` = BOOLEAN `Character_ID` from the Primary_ID identifier
-- @`Character_ID`
function ig.sql.char.SetDead(character_id, bool, data, cb)
    if type(bool) ~= "boolean" then ig.funig.Debug_1("ig.sql.char.SetDead, boolean was not passed") return end
    local Character_ID = character_id
    local Bool = bool
    local Data = json.encode(data)
    MySQL.Asynig.execute("UPDATE `characters` SET `Is_Dead` = @Bool, `Dead_Time` = @Time, `Dead_Data` = @Data WHERE `Character_ID` = @Character_ID", {
        ["@Bool"] = Bool,
        ["@Time"] = ig.funig.Timestamp(),
        ["@Data"] = Data,
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

--- SET - The `Instance` = ID `Character_ID` from the Primary_ID identifier
-- @`Character_ID`
function ig.sql.char.SetInstance(character_id, instance_id, cb)
    local Character_ID = character_id
    local Instance = instance_id
    MySQL.Asynig.execute("UPDATE `characters` SET `Instance` = @Instance WHERE `Character_ID` = @Character_ID", {
        ["@Instance"] = Instance,
        ["@Character_ID"] = Character_ID,
    }, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

-- Should the Server crash, this one is to reset all Active Characters Just incasethe Active Column is used to data identify users/characters in data pulls.
function ig.sql.ResetActiveCharacters(cb)
    MySQL.Asynig.execute("UPDATE `characters` SET `Active` = FALSE;", {}, function(data)
        if data then
            --
        end
        if cb then
            cb()
        end
    end)
end

--- Get ALL - The `Wanted` Boolean TRUE from the characters table
function ig.sql.char.GetAllWanted(cb)
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchAll("SELECT `Character_ID` FROM `characters` WHERE `Wanted` IS TRUE;", {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Set - The `Wanted` Boolean TRUE from the `Character_ID`
-- @`Character_ID`
function ig.sql.char.SetWanted(character_id, bool, cb)
    if type(bool) ~= "boolean" then ig.funig.Debug_1("ig.sql.char.SetActive, boolean was not passed") return end
    local Character_ID = character_id
    MySQL.Asynig.execute("UPDATE `characters` SET `Wanted` IS TRUE WHERE `Character_ID` = @Character_ID;", {
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

--- Get - The `City_ID` from the `Character_ID`
-- @`Character_ID`
function ig.sql.char.GetFromPhone(phone, cb)
    local Phone = phone
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Character_ID` FROM `characters` WHERE `Phone` = @Phone LIMIT 1;", {
        ["@Phone"] = Phone
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `City_ID` from the `Character_ID`
-- @`Character_ID`
function ig.sql.char.GetPhone(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Phone` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `City_ID` from the `Character_ID`
-- @`Character_ID`
function ig.sql.char.GetCityId(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `City_ID` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `Character_ID` from the `City_ID`
-- @`City_ID`
function ig.sql.char.GetFromCityId(city_id, cb)
    local City_ID = city_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Character_ID` FROM `characters` WHERE `City_ID` = @City_ID LIMIT 1;", {
        ["@City_ID"] = City_ID
    }, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    return result
end

--- Get - The `Coords` from the `Character_ID`
-- @`Character_ID`
function ig.sql.char.GetCoords(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Coords` FROM `characters` WHERE `Character_ID` = @Character_ID LIMIT 1;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        if data then
            result = json.decode(data)
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

--- SET - The `Coords` from the `Character_ID`
-- @`Character_ID`
-- @Table of coords. {x=32.2,y=etc}
-- cb if any.
function ig.sql.char.SetCoords(character_id, vector3, cb)
    local Character_ID = character_id
    local Coords = json.encode(vector3)
    MySQL.Asynig.execute("UPDATE `characters` SET `Coords` = @Coords WHERE `Character_ID` = @Character_ID;", {
        ["@Coords"] = Coords,
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

--- Get - The `Appearance` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.char.GetAppearance(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Appearance` FROM `characters` WHERE `Character_ID` = @Character_ID;", {
        ["@Character_ID"] = Character_ID
    }, function(data)
        if data then
            result = json.decode(data)
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

--- SET - The `Appearance` from the `Character_ID`
-- @`Character_ID`
-- @style - TABLE VALUE
-- cb if any.
function ig.sql.char.SetAppearance(character_id, style, cb)
    local Character_ID = character_id
    local Appearance = json.encode(style)
    MySQL.Asynig.execute("UPDATE `characters` SET `Appearance` = @Appearance WHERE `Character_ID` = @Character_ID;", {
        ["@Appearance"] = Appearance,
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

--- SET - The `Appearance` from the `Character_ID`
-- @`Character_ID`
-- @style - TABLE VALUE
-- cb if any.
function ig.sql.char.AddOutfit(Character_ID, Number, style, cb)
    local Appearance = json.encode(style)
    MySQL.Asynig.execute("INSERT INTO character_outfits (`Character_ID`, `Number`, `Appearance`) VALUES (@Character_ID, @Number, @Appearance);", {
        ["@Character_ID"] = Character_ID,
        ["@Number"] = Number,
        ["@Appearance"] = Appearance,
    }, function(data)
        if data then
            --
        end
        if cb ~= nil then
            cb()
        end
    end)
end

--- Get - All `Character_ID` that are currently marked as `Active` IS TRUE
function ig.sql.char.GetOutfitsAsCount(Character_ID, cb)
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchAll("SELECT COUNT(`Character_ID`) AS 'Count' FROM `character_outfits` WHERE Character_ID = @Character_ID;", {
        ["@Character_ID"] = Character_ID,
    }
    , function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    -- Always return a value.
    if result == nil then
        result = 0
    end
    --
    return result
end

--- Get - All `Character_ID` that are currently marked as `Active` IS TRUE
function ig.sql.char.GetOutfitByNumber(Character_ID, Number, cb)
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Appearance` FROM `character_outfits` WHERE `Character_ID` = @Character_ID AND `Number` = @Number;", {
        ["@Character_ID"] = Character_ID,
        ["@Number"] = Number,
    }
    , function(data)
        result = json.decode(data)
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    if cb then
        cb()
    end
    --
    return result
end

-----------------------
--- Character Statuses
-----------------------

--- Get - The `Health` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.char.GetHealth(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Health` FROM `characters` WHERE `Character_ID` = @Character_ID;", {
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

--- SET - The `Health` from the `Character_ID`
-- @`Character_ID`
-- @Health - Int VALUE
-- cb if any.
function ig.sql.char.SetHealth(character_id, health, cb)
    local Health = health
    local Character_ID = character_id
    MySQL.Asynig.execute("UPDATE `characters` SET `Health` = @Health WHERE `Character_ID` = @Character_ID;", {
        ["@Health"] = Health,
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

--- Get - The `Armour` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.char.GetArmour(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Armour` FROM `characters` WHERE `Character_ID` = @Character_ID;", {
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

--- SET - The `Armour` from the `Character_ID`
-- @`Character_ID`
-- @Armour - INT VALUE
-- cb if any.
function ig.sql.char.SetArmour(character_id, armour, cb)
    local Character_ID = character_id
    local Armour = armour
    MySQL.Asynig.execute("UPDATE `characters` SET `Armour` = @Armour WHERE `Character_ID` = @Character_ID;", {
        ["@Armour"] = Armour,
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

--- Get - The `Hunger` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.char.GetHunger(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Hunger` FROM `characters` WHERE `Character_ID` = @Character_ID;", {
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

--- SET - The `Hunger` from the `Character_ID`
-- @`Character_ID`
-- @Hunger - INT VALUE
-- cb if any.
function ig.sql.char.SetHunger(character_id, hunger, cb)
    local Character_ID = character_id
    local Hunger = hunger
    MySQL.Asynig.execute("UPDATE `characters` SET `Hunger` = @Hunger WHERE `Character_ID` = @Character_ID;", {
        ["@Hunger"] = Hunger,
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

--- Get - The `Thirst` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.char.GetThirst(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Thirst` FROM `characters` WHERE `Character_ID` = @Character_ID;", {
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

--- SET - The `Thirst` from the `Character_ID`
-- @`Character_ID`
-- @Thirst - INT VALUE
-- cb if any.
function ig.sql.char.SetThirst(character_id, thirst, cb)
    local Character_ID = character_id
    local Thirst = thirst
    MySQL.Asynig.execute("UPDATE `characters` SET `Thirst` = @Thirst WHERE `Character_ID` = @Character_ID;", {
        ["@Thirst"] = Thirst,
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

--- Get - The `Thirst` from the `Character_ID`
-- @`Character_ID`
-- cb if any.
function ig.sql.char.GetStress(character_id, cb)
    local Character_ID = character_id
    local IsBusy = true
    local result = nil
    MySQL.Asynig.fetchScalar("SELECT `Stress` FROM `characters` WHERE `Character_ID` = @Character_ID;", {
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

--- SET - The `Stress` from the `Character_ID`
-- @`Character_ID`
-- @Stress - INT VALUE
-- cb if any.
function ig.sql.char.SetStress(character_ID, stress, cb)
    local Character_ID = character_id
    local Stress = stress
    MySQL.Asynig.execute("UPDATE `characters` SET `Stress` = @Stress WHERE `Character_ID` = @Character_ID;", {
        ["@Stress"] = Stress,
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
