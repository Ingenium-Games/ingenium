-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.veh = {}
-- ====================================================================================--

--[[
NOTES.
    - All sql querys should have a call back as a function at the end to chain code execution upon completion.
    - All data should be encoded or decoded here, if possible. the fetchALL commands are decoded in the _data.lua
]] --

--- Takes Vehicle information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function ig.sql.veh.GetVehicles(cb)
    local result = ig.sql.Query("SELECT * FROM `vehicles`", {})
    if cb then
        cb()
    end
    return result
end
--


function ig.sql.veh.Reset(cb)
    ig.sql.Update("UPDATE `vehicles` SET `Parked` = TRUE", {}, function(affectedRows)
        if cb then
            cb(affectedRows)
        end
    end)
end

function ig.sql.veh.GetAll(Character_ID, cb)
    local result = ig.sql.Query("SELECT * FROM vehicles WHERE `Character_ID` = ?;", {Character_ID})
    if cb then
        cb()
    end
    return result
end

function ig.sql.veh.GetID(Plate, cb)
    local result = ig.sql.FetchScalar("SELECT `ID` FROM vehicles WHERE `Plate` = ? LIMIT 1;", {Plate})
    if cb then
        cb()
    end
    return result
end

function ig.sql.veh.GetByPlate(Plate, cb)
    local data = ig.sql.Query("SELECT * FROM vehicles WHERE `Plate` = ? LIMIT 1;", {Plate})
    local result = data[1]
    if cb then
        cb()
    end
    return result
end

function ig.sql.veh.Add(data, cb)
    local Data = data
    ig.sql.Insert(
        "INSERT INTO `vehicles` (`Character_ID`, `Model`, `Plate`, `Condition`, `Modifications`, `Updated`) VALUES (?, ?, ?, ?, ?, ?);",
        {Data.Character_ID, Data.Model, Data.Plate, json.encode(Data.Condition), json.encode(Data.Modifications), ig.func.Timestamp()},
        function(insertId)
            TriggerEvent("txaLogger:CommandExecuted", " [DB] -- Adding Vehicle: "..Data.Plate.." | Owner "..Data.Character_ID)
            if cb then
                cb(insertId)
            end
        end)
end

function ig.sql.veh.ChangeOwner(data, cb)
    local Data = data
    ig.sql.Update(
        "UPDATE `vehicles` SET `Character_ID` = ?, `Updated` = ? WHERE `Plate` = ?;",
        {Data.Character_ID, ig.func.Timestamp(), Data.Plate},
        function(affectedRows)
            TriggerEvent("txaLogger:CommandExecuted", " [DB] -- Changing Vehicle : "..Data.Plate.." | Owner "..Data.Character_ID)
            if cb then
                cb(affectedRows)
            end
        end)
end
