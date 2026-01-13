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
-- ====================================================================================--
-- PERSISTENT VEHICLE FUNCTIONS
-- ====================================================================================--
-- NOTE: Persistent vehicle state tracked in Lua + JSON file, not in SQL tables
-- Owned vehicles (Character_ID present) remain in DB always
-- Persistent tracked vehicles loaded from DB at startup, managed in Lua
-- ====================================================================================--

--- Register a vehicle as persistent (player has interacted)
---@param plate string Vehicle plate
---@param vehicleType string Type: 'owned', 'npc', 'world'
---@param npcOwner string NPC identifier if applicable
---@param cb function Callback function
function ig.sql.veh.RegisterPersistent(plate, vehicleType, npcOwner, cb)
    ig.sql.Update(
        "UPDATE `vehicles` SET `Is_Persistent` = 1, `Persistent_Type` = ?, `NPC_Owner` = ?, `Last_Interaction` = NOW(), `Interaction_Count` = `Interaction_Count` + 1 WHERE `Plate` = ?;",
        {vehicleType or 'npc', npcOwner, plate},
        function(affectedRows)
            if conf.persistence.logging.enabled then
                ig.log.Info("Vehicle registered as persistent: " .. plate)
            end
            if cb then
                cb(affectedRows)
            end
        end)
end

--- Update vehicle position (called during batch update)
---@param plate string Vehicle plate
---@param coords table Coordinates {x, y, z, h}
---@param cb function Callback function
function ig.sql.veh.UpdatePosition(plate, coords, cb)
    local coordsJson = json.encode({x = coords.x, y = coords.y, z = coords.z, h = coords.w or coords.h})
    ig.sql.Update(
        "UPDATE `vehicles` SET `Coords` = ?, `Last_Position` = ?, `Last_Interaction` = NOW() WHERE `Plate` = ?;",
        {coordsJson, coordsJson, plate},
        function(affectedRows)
            if cb then
                cb(affectedRows)
            end
        end)
end

--- Update vehicle condition/state (damage, statebag)
---@param plate string Vehicle plate
---@param condition table Vehicle damage/condition data
---@param statebag table Statebag data to save
---@param cb function Callback function
function ig.sql.veh.UpdateVehicleState(plate, condition, statebag, cb)
    ig.sql.Update(
        "UPDATE `vehicles` SET `Condition` = ?, `Last_Condition` = ?, `Statebag_Data` = ?, `Last_Interaction` = NOW() WHERE `Plate` = ?;",
        {json.encode(condition), json.encode(condition), json.encode(statebag), plate},
        function(affectedRows)
            if conf.persistence.logging.enabled then
                ig.log.Debug("Vehicle state updated: " .. plate)
            end
            if cb then
                cb(affectedRows)
            end
        end)
end

--- Update vehicle fuel and mileage
---@param plate string Vehicle plate
---@param fuel number Current fuel level
---@param mileage number Current mileage
---@param cb function Callback function
function ig.sql.veh.UpdateVehicleStats(plate, fuel, mileage, cb)
    ig.sql.Update(
        "UPDATE `vehicles` SET `Fuel` = ?, `Mileage` = ? WHERE `Plate` = ?;",
        {fuel, mileage, plate},
        function(affectedRows)
            if cb then
                cb(affectedRows)
            end
        end)
end

--- Get all persistent tracked vehicles (loaded at server start)
---@param cb function Callback function returning vehicle data
function ig.sql.veh.GetPersistentVehicles(cb)
    local result = ig.sql.Query(
        "SELECT * FROM `vehicles` WHERE `Is_Persistent` = 1 AND `Character_ID` IS NULL ORDER BY `Last_Interaction` DESC;",
        {})
    if cb then
        cb(result)
    end
    return result
end

--- Get vehicles by NPC owner
---@param npcOwner string NPC identifier
---@param cb function Callback function
function ig.sql.veh.GetByNpcOwner(npcOwner, cb)
    local result = ig.sql.Query(
        "SELECT * FROM `vehicles` WHERE `NPC_Owner` = ? AND `Is_Persistent` = 1;",
        {npcOwner})
    if cb then
        cb(result)
    end
    return result
end

--- Get abandoned vehicles that exceeded timeout (only tracks vehicles last_interaction)
---@param timeoutMs number Timeout in milliseconds
---@param vehicleType string Optional: filter by type ('npc', 'world')
---@param cb function Callback function
function ig.sql.veh.GetAbandonedVehicles(timeoutMs, vehicleType, cb)
    local timeoutSeconds = math.floor(timeoutMs / 1000)
    local query = "SELECT * FROM `vehicles` WHERE `Is_Persistent` = 1 AND `Character_ID` IS NULL AND TIMESTAMPDIFF(SECOND, `Last_Interaction`, NOW()) > ?"
    local params = {timeoutSeconds}
    
    if vehicleType then
        query = query .. " AND `Persistent_Type` = ?"
        table.insert(params, vehicleType)
    end
    
    local result = ig.sql.Query(query .. ";", params)
    if cb then
        cb(result)
    end
    return result
end

--- Clean up abandoned tracked vehicles from database
---@param timeoutMs number Timeout in milliseconds
---@param vehicleType string Optional: type to clean ('npc', 'world')
---@param cb function Callback function
function ig.sql.veh.CleanupAbandonedVehicles(timeoutMs, vehicleType, cb)
    local timeoutSeconds = math.floor(timeoutMs / 1000)
    local query = "DELETE FROM `vehicles` WHERE `Is_Persistent` = 1 AND `Character_ID` IS NULL AND TIMESTAMPDIFF(SECOND, `Last_Interaction`, NOW()) > ?"
    local params = {timeoutSeconds}
    
    if vehicleType then
        query = query .. " AND `Persistent_Type` = ?"
        table.insert(params, vehicleType)
    end
    
    ig.sql.Update(query .. ";", params, function(affectedRows)
        if conf.persistence.logging.enabled then
            local typeStr = vehicleType and vehicleType .. " " or ""
            ig.log.Info("Cleaned up " .. affectedRows .. " abandoned " .. typeStr .. "vehicles")
        end
        if cb then
            cb(affectedRows)
        end
    end)
end