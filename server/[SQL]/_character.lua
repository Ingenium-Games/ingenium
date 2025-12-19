-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.char = {}
-- ====================================================================================--

-- SHould remake htis one..
function ig.sql.char.Add(t, cb)
    ig.sql.Insert(
        "INSERT INTO `characters` (`Created`, `Last_Seen`, `Primary_ID`, `Character_ID`, `City_ID`, `First_Name`, `Last_Name`, `Iban`, `Phone`, `Coords`, `Accounts`, `Modifiers`, `Appearance`, `Skills`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);",
        {
            ig.func.Timestamp(),
            ig.func.Timestamp(),
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
        },
        function(insertId)
            TriggerEvent("txaLogger:CommandExecuted", "Adding new Character for Primary_ID: "..t.Primary_ID)
            if cb then cb(insertId) end
        end
    )
end

--- Get - Info on the characters owned to prefill the multicharacter selection
-- @License_ID
function ig.sql.char.GetAll(primary_id, cb)
    local result = ig.sql.Query("SELECT * FROM `characters` WHERE `Primary_ID` = ?;", {primary_id})
    if cb then cb(result) end
    return result
end

--- Get - Info on the characters owned to prefill the multicharacter selection (not dead)
function ig.sql.char.GetAllNotDead(primary_id, cb)
    local result = ig.sql.Query("SELECT * FROM `characters` WHERE `Primary_ID` = ? AND `Is_Dead` = FALSE;", {primary_id})
    if cb then cb(result) end
    return result
end

--- Get - Info on the characters owned, up to permitted slot count (not dead)
function ig.sql.char.GetAllPermited(primary_id, slots, cb)
    local result = ig.sql.Query("SELECT * FROM `characters` WHERE `Primary_ID` = ? AND `Is_Dead` = FALSE LIMIT ?;", {primary_id, slots})
    if cb then cb(result) end
    return result
end

function ig.sql.char.ReviveDeadCharacters(cb)
    ig.sql.Update(
        "UPDATE `characters` SET `Health` = 150, `Is_Dead` = FALSE, `Coords` = ?, `Dead_Time` = NULL, `Dead_Data` = ? WHERE `Dead_Time` <= (? - '604800')",
        {
            json.encode({["z"]=43.28,["h"]=337.32,["x"]=327.52,["y"]=-603.03}), -- Pillbox Elevators
            json.encode({["RevivedAt"]= ig.func.Timestamp(), ["By"]="Server"}),
            ig.func.Timestamp()
        },
        function(affectedRows)
            if cb then cb(affectedRows) end
        end
    )
end

--- Get - The entire ROW of data from Characters table where the Character_ID is the character id.
function ig.sql.char.Get(character_id, cb)
    local result = ig.sql.Query("SELECT * FROM `characters` WHERE `Character_ID` = ? LIMIT 1;", {character_id})
    local row = (result and result[1]) or nil
    if cb then cb(row) end
    return row
end

--- Get - # of characters owned for Primary_ID
function ig.sql.char.GetCount(primary_id, cb)
    local result = ig.sql.FetchScalar("SELECT COUNT(`Primary_ID`) FROM `characters` WHERE `Primary_ID` = ?;", {primary_id})
    if cb then cb(result) end
    if result == nil then result = 0 end
    return result
end

function ig.sql.char.Delete(character_id, cb)
    ig.sql.Update("DELETE FROM `characters` WHERE `Character_ID` = ? LIMIT 1;", {character_id},
        function(affectedRows)
            if affectedRows > 0 then
                TriggerEvent("txaLogger:CommandExecuted", "Deleting Character: "..character_id)
            end
            if cb then cb(affectedRows) end
        end
    )
end

--- Get - The `Active` = TRUE `Character_ID` from the Primary_ID identifier
function ig.sql.char.Current(primary_id, cb)
    local result = ig.sql.FetchScalar(
        "SELECT `Character_ID` FROM `characters` WHERE `Active` IS TRUE AND `Primary_ID` = ?;", {primary_id}
    )
    if cb then cb(result) end
    return result
end

--- SET - The `Active` = BOOLEAN for the `Character_ID`
function ig.sql.char.SetActive(character_id, bool, cb)
    if type(bool) ~= "boolean" then ig.func.Debug_1("ig.sql.char.SetActive, boolean was not passed") return end
    ig.sql.Update("UPDATE `characters` SET `Active` = ? WHERE `Character_ID` = ?;", {bool, character_id}, function(data)
        if cb then cb(data) end
    end)
end

--- SET - The `Is_Dead` = BOOLEAN for the `Character_ID`
function ig.sql.char.SetDead(character_id, bool, data, cb)
    if type(bool) ~= "boolean" then ig.func.Debug_1("ig.sql.char.SetDead, boolean was not passed") return end
    ig.sql.Update("UPDATE `characters` SET `Is_Dead` = ?, `Dead_Time` = ?, `Dead_Data` = ? WHERE `Character_ID` = ?;",
        {bool, ig.func.Timestamp(), json.encode(data), character_id},
        function(affectedRows)
            if cb then cb(affectedRows) end
        end
    )
end

--- SET - The `Instance` = instance_id for the `Character_ID`
function ig.sql.char.SetInstance(character_id, instance_id, cb)
    ig.sql.Update("UPDATE `characters` SET `Instance` = ? WHERE `Character_ID` = ?;", {instance_id, character_id}, function(data)
        if cb then cb(data) end
    end)
end

-- Should the Server crash, reset all Active Characters (for safety)
function ig.sql.ResetActiveCharacters(cb)
    ig.sql.Update("UPDATE `characters` SET `Active` = FALSE;", {}, function(data)
        if cb then cb(data) end
    end)
end

--- Get ALL - The `Wanted` Boolean TRUE from the characters table
function ig.sql.char.GetAllWanted(cb)
    local result = ig.sql.Query("SELECT `Character_ID` FROM `characters` WHERE `Wanted` IS TRUE;", {})
    if cb then cb(result) end
    return result
end

--- Set - The `Wanted` Boolean
function ig.sql.char.SetWanted(character_id, bool, cb)
    if type(bool) ~= "boolean" then ig.func.Debug_1("ig.sql.char.SetWanted, boolean was not passed") return end
    ig.sql.Update("UPDATE `characters` SET `Wanted` = ? WHERE `Character_ID` = ?;", {bool, character_id}, function(data)
        if cb then cb(data) end
    end)
end

--- Get - The `Character_ID` by phone number
function ig.sql.char.GetFromPhone(phone, cb)
    local result = ig.sql.FetchScalar("SELECT `Character_ID` FROM `characters` WHERE `Phone` = ? LIMIT 1;", {phone})
    if cb then cb(result) end
    return result
end

--- Get - The `Phone` by Character_ID
function ig.sql.char.GetPhone(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Phone` FROM `characters` WHERE `Character_ID` = ? LIMIT 1;", {character_id})
    if cb then cb(result) end
    return result
end

--- Get - The `City_ID` by Character_ID
function ig.sql.char.GetCityId(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `City_ID` FROM `characters` WHERE `Character_ID` = ? LIMIT 1;", {character_id})
    if cb then cb(result) end
    return result
end

--- Get - The `Character_ID` by City_ID
function ig.sql.char.GetFromCityId(city_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Character_ID` FROM `characters` WHERE `City_ID` = ? LIMIT 1;", {city_id})
    if cb then cb(result) end
    return result
end

--- Get - The `Coords` by Character_ID
function ig.sql.char.GetCoords(character_id, cb)
    local data = ig.sql.FetchScalar("SELECT `Coords` FROM `characters` WHERE `Character_ID` = ? LIMIT 1;", {character_id})
    local result = data and json.decode(data) or nil
    if cb then cb(result) end
    return result
end

--- SET - The `Coords` for Character_ID
function ig.sql.char.SetCoords(character_id, vector3, cb)
    ig.sql.Update("UPDATE `characters` SET `Coords` = ? WHERE `Character_ID` = ?;", {json.encode(vector3), character_id}, function(data)
        if cb then cb(data) end
    end)
end

--- Get - The `Appearance` by Character_ID
function ig.sql.char.GetAppearance(character_id, cb)
    local data = ig.sql.FetchScalar("SELECT `Appearance` FROM `characters` WHERE `Character_ID` = ?;", {character_id})
    local result = data and json.decode(data) or nil
    if cb then cb(result) end
    return result
end

--- SET - The `Appearance` for Character_ID
function ig.sql.char.SetAppearance(character_id, style, cb)
    ig.sql.Update("UPDATE `characters` SET `Appearance` = ? WHERE `Character_ID` = ?;", {json.encode(style), character_id}, function(data)
        if cb then cb(data) end
    end)
end

--- Add outfit to character_outfits
function ig.sql.char.AddOutfit(character_id, number, style, cb)
    ig.sql.Insert("INSERT INTO character_outfits (`Character_ID`, `Number`, `Appearance`) VALUES (?, ?, ?);",
        {character_id, number, json.encode(style)},
        function(insertId)
            if cb then cb(insertId) end
        end
    )
end

--- Get count of character outfits by Character_ID
function ig.sql.char.GetOutfitsAsCount(character_id, cb)
    local result = ig.sql.Query("SELECT COUNT(`Character_ID`) AS 'Count' FROM `character_outfits` WHERE `Character_ID` = ?;", {character_id})
    if cb then cb(result) end
    if result == nil then result = 0 end
    return result
end

--- Get outfit Appearance by number
function ig.sql.char.GetOutfitByNumber(character_id, number, cb)
    local data = ig.sql.FetchScalar("SELECT `Appearance` FROM `character_outfits` WHERE `Character_ID` = ? AND `Number` = ?;", {character_id, number})
    local result = data and json.decode(data) or nil
    if cb then cb(result) end
    return result
end

-----------------------
--- Character Statuses
-----------------------

--- Get - The `Health` by Character_ID
function ig.sql.char.GetHealth(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Health` FROM `characters` WHERE `Character_ID` = ?;", {character_id})
    if cb then cb(result) end
    return result
end

--- SET - The `Health` by Character_ID
function ig.sql.char.SetHealth(character_id, health, cb)
    ig.sql.Update("UPDATE `characters` SET `Health` = ? WHERE `Character_ID` = ?;", {health, character_id}, function(data)
        if cb then cb(data) end
    end)
end

--- Get - The `Armour` by Character_ID
function ig.sql.char.GetArmour(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Armour` FROM `characters` WHERE `Character_ID` = ?;", {character_id})
    if cb then cb(result) end
    return result
end

--- SET - The `Armour` by Character_ID
function ig.sql.char.SetArmour(character_id, armour, cb)
    ig.sql.Update("UPDATE `characters` SET `Armour` = ? WHERE `Character_ID` = ?;", {armour, character_id}, function(data)
        if cb then cb(data) end
    end)
end

--- Get - The `Hunger` by Character_ID
function ig.sql.char.GetHunger(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Hunger` FROM `characters` WHERE `Character_ID` = ?;", {character_id})
    if cb then cb(result) end
    return result
end

--- SET - The `Hunger` by Character_ID
function ig.sql.char.SetHunger(character_id, hunger, cb)
    ig.sql.Update("UPDATE `characters` SET `Hunger` = ? WHERE `Character_ID` = ?;", {hunger, character_id}, function(data)
        if cb then cb(data) end
    end)
end

--- Get - The `Thirst` by Character_ID
function ig.sql.char.GetThirst(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Thirst` FROM `characters` WHERE `Character_ID` = ?;", {character_id})
    if cb then cb(result) end
    return result
end

--- SET - The `Thirst` by Character_ID
function ig.sql.char.SetThirst(character_id, thirst, cb)
    ig.sql.Update("UPDATE `characters` SET `Thirst` = ? WHERE `Character_ID` = ?;", {thirst, character_id}, function(data)
        if cb then cb(data) end
    end)
end

--- Get - The `Stress` by Character_ID
function ig.sql.char.GetStress(character_id, cb)
    local result = ig.sql.FetchScalar("SELECT `Stress` FROM `characters` WHERE `Character_ID` = ?;", {character_id})
    if cb then cb(result) end
    return result
end

--- SET - The `Stress` by Character_ID
function ig.sql.char.SetStress(character_id, stress, cb)
    ig.sql.Update("UPDATE `characters` SET `Stress` = ? WHERE `Character_ID` = ?;", {stress, character_id}, function(data)
        if cb then cb(data) end
    end)
end
