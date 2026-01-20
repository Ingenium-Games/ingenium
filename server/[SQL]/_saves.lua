-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.save = {}
-- ====================================================================================--

--[[ Prepared Query Status Tracking ]] --

local preparedQueriesReady = {
    PlayerSaveData = false,
    VehicleSaveData = false,
    ObjectSaveData = false
}

--- Check if all prepared queries are ready
---@return boolean All queries ready
function ig.sql.save.ArePreparedQueriesReady()
    for name, ready in pairs(preparedQueriesReady) do
        if not ready then
            return false
        end
    end
    return true
 end

--- Wait for all prepared queries to be ready
---@param timeout number Timeout in milliseconds
---@return boolean Success
function ig.sql.save.AwaitPreparedQueries(timeout)
    local p = promise.new()
    local timeoutMs = timeout or 10000
    local startTime = GetGameTimer()
    
    -- Use SetTimeout chain instead of blocking Wait()
    local function CheckReady()
        if ig.sql.save.ArePreparedQueriesReady() then
            ig.log.Info("SQL", "All prepared queries ready")
            p:resolve(true)
        else
            local elapsed = GetGameTimer() - startTime
            if elapsed >= timeoutMs then
                ig.log.Error("SQL", "Timeout waiting for prepared queries to initialize")
                p:resolve(false)
            else
                -- Check again in 50ms without blocking
                SetTimeout(50, CheckReady)
            end
        end
    end
    
    -- Start checking
    CheckReady()
    
    -- Wait for promise to resolve
    return Citizen.Await(p)
end

--[[ Performance Monitoring Wrapper ]] --

--- Wrapper for monitoring save operation performance
---@param saveName string "Name of the save operation"
---@param saveFunc function "The save function to execute"
---@param cb function "Callback to execute after save"
local function MonitoredSave(saveName, saveFunc, cb)
    local startTime = os.clock()
    local originalCb = cb
    
    saveFunc(function()
        local elapsed = (os.clock() - startTime) * 1000
        if elapsed > 100 then
            ig.log.Warn("SQL", "%s took %.2fms", saveName, elapsed)
        else
            ig.log.Info("SQL", "%s completed in %.2fms", saveName, elapsed)
        end
        if originalCb then originalCb() end
    end)
end

--[[ Prepared Query Variables ]] --

local PlayerSaveData = -1
local VehicleSaveData = -1
local ObjectSaveData = -1

--[[ Prepared Query Initialization ]] --

--- Initialize all prepared queries (must be called after SQL is ready)
function ig.sql.save.InitializePreparedQueries()
    ig.log.Info("SQL", "Initializing prepared queries for save system...")
    
    -- Player save query
    ig.sql.PrepareQuery(
        "UPDATE `characters` SET `Health` = ?, `Armour` = ?, `Hunger` = ?, `Thirst` = ?, `Stress` = ?, `Coords` = ?, `Skills` = ?, `Modifiers` = ?, `Inventory` = ?, `Ammo` = ?, `Job` = ? WHERE `Character_ID` = ?;",
        function(id)
            PlayerSaveData = id
            preparedQueriesReady.PlayerSaveData = true
            ig.log.Debug("SQL", "PlayerSaveData prepared query initialized with ID: " .. id)
        end)
    
    -- Vehicle save query
    ig.sql.PrepareQuery(
        "UPDATE `vehicles` SET `Fuel` = ?, `Coords` = ?, `Keys` = ?, `Condition` = ?, `Modifications` = ?, `Inventory` = ?, `Parked` = ?, `Impound` = ?, `Wanted` = ?  WHERE `Plate` = ?;",
        function(id)
            VehicleSaveData = id
            preparedQueriesReady.VehicleSaveData = true
            ig.log.Debug("SQL", "VehicleSaveData prepared query initialized with ID: " .. id)
        end)
    
    -- Object save query
    ig.sql.PrepareQuery(
        "UPDATE `objects` SET `Inventory` = ?, `Coords` = ? WHERE `UUID` = ?;",
        function(id)
            ObjectSaveData = id
            preparedQueriesReady.ObjectSaveData = true
            ig.log.Debug("SQL", "ObjectSaveData prepared query initialized with ID: " .. id)
        end)
end

--[[ Players ]] --

--- Save Single User/Character
---@param data table "xPlayer table"
---@param cb function "To be called on SQL 'UPDATE' statement completion."
function ig.sql.save.User(data, cb)
    if not data or not data.GetIsDirty() then 
        if cb then cb() end
        return 
    end
    
    -- Guard: Check if prepared query is initialized
    if PlayerSaveData == -1 then
        ig.log.Warn("SQL", "PlayerSaveData prepared query not ready yet, skipping save")
        if cb then cb() end
        return
    end
    
    -- Other Variables.
    local Health = data.GetHealth()
    local Armour = data.GetArmour()
    local Hunger = data.GetHunger()
    local Thirst = data.GetThirst()
    local Stress = data.GetStress()
    -- Tables require JSON Encoding - Use cached versions
    local Skills = data.GetEncodedSkills()
    local Coords = data.GetEncodedCoords()
    local Modifiers = data.GetEncodedModifiers()
    local Inventory = data.GetEncodedInventory()
    local Ammo = data.GetEncodedAmmo()
    local Job = data.GetEncodedJob()
    -- 
    local Character_ID = data.GetCharacter_ID()
    ig.sql.ExecutePrepared(PlayerSaveData, {
        -- Other Variables.
        Health,
        Armour,
        Hunger,
        Thirst,
        Stress,
        -- Table Informaiton.
        Skills,
        Coords,
        Modifiers,
        Inventory,
        Ammo,
        Job,
        -- Where Conditions
        Character_ID
    }, function(r)
        data.ClearDirty()
    end)
    if cb then
        cb()
    end
    ig.log.Debug("SQL", "Saved player: ", Character_ID)
end

--- Save All Characters from the xPLayer Table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function ig.sql.save.Users(cb)
    -- Guard: Check if prepared query is initialized
    if PlayerSaveData == -1 then
        ig.log.Warn("SQL", "PlayerSaveData prepared query not ready yet, skipping batch save")
        if cb then cb() end
        return
    end
    
    local startTime = os.clock()
    local saveCount = 0
    local xPlayers = ig.data.GetPlayers()
    
    -- Pre-allocate to avoid table resizing during iteration
    for k, data in pairs(xPlayers) do
        -- Use data directly from pairs iteration instead of redundant GetPlayer call
        if data and data.GetIsDirty() then
            saveCount = saveCount + 1
            -- Other Variables.
            local Health = data.GetHealth()
            local Armour = data.GetArmour()
            local Hunger = data.GetHunger()
            local Thirst = data.GetThirst()
            local Stress = data.GetStress()
            -- Tables require JSON Encoding - Use cached versions
            local Skills = data.GetEncodedSkills()
            local Coords = data.GetEncodedCoords()
            local Modifiers = data.GetEncodedModifiers()
            local Inventory = data.GetEncodedInventory()
            local Ammo = data.GetEncodedAmmo()
            local Job = data.GetEncodedJob()
            -- 
            local Character_ID = data.GetCharacter_ID()
            ig.sql.ExecutePrepared(PlayerSaveData, {
                -- Other Variables.
                Health,
                Armour,
                Hunger,
                Thirst,
                Stress,
                -- Table Informaiton.
                Skills,
                Coords,
                Modifiers,
                Inventory,
                Ammo,
                Job,
                -- Where Conditions
                Character_ID
            }, function(r)
                data.ClearDirty()
            end)
        end
    end
    
    local elapsed = (os.clock() - startTime) * 1000
    if saveCount > 0 then
        ig.log.Debug("SQL", "Saved %d players in %.2fms", saveCount, elapsed)
        ig.log.Info("SQL", "Saved %d players in %.2fms", saveCount, elapsed)
    end
    if cb then
        cb()
    end
end

--[[ Vehicles ]] --

--- Save Single User/Character
---@param data table "xCar table"
---@param cb function "To be called on SQL 'UPDATE' statement completion."
function ig.sql.save.Vehicle(data, cb)
    if not data or data.Owner == false or not data.GetIsDirty() then
        if cb then cb() end
        return
    end
    
    -- Guard: Check if prepared query is initialized
    if VehicleSaveData == -1 then
        ig.log.Warn("SQL", "VehicleSaveData prepared query not ready yet, skipping save")
        if cb then cb() end
        return
    end
    
    local Fuel = data.GetFuel()
    -- Booleans
    local Parked = data.GetParked()
    local Impound = data.GetImpound()
    local Wanted = data.GetWanted()
    -- Tables require JSON Encoding - Use cached versions
    local Keys = data.GetEncodedKeys()
    local Coords = data.GetEncodedCoords()
    local Inventory = data.GetEncodedInventory()
    --
    local Condition = data.GetEncodedCondition()
    local Modifications = data.GetEncodedModifications()
    --
    local Updated = ig.func.Timestamp()
    -- The Key
    local Plate = data.GetPlate()
    --
    ig.sql.ExecutePrepared(VehicleSaveData, {
        -- Other Variables.
        Fuel,
        -- Tables
        Coords,
        Keys,
        Condition,
        Modifications,
        Inventory,
        -- Booleans
        Parked,
        Impound,
        Wanted,
        -- Where conditions
        Plate
    }, function(r)
        data.ClearDirty()
    end)
    if cb then
        cb()
    end
end

--- Save all vehicles from the xVehicle table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function ig.sql.save.Vehicles(cb)
    -- Guard: Check if prepared query is initialized
    if VehicleSaveData == -1 then
        ig.log.Warn("SQL", "VehicleSaveData prepared query not ready yet, skipping batch save")
        if cb then cb() end
        return
    end
    
    local startTime = os.clock()
    local saveCount = 0
    local xVehicles = ig.vehicle.GetVehicles()
    
    for k, data in pairs(xVehicles) do
        if data and data.Owner ~= false and data.GetIsDirty() then
            -- Check entity existence once before gathering data
            if DoesEntityExist(data.Entity) then
                saveCount = saveCount + 1
                -- Gather all data for the save operation
                local Fuel = data.GetFuel()
                local Parked = data.GetParked()
                local Impound = data.GetImpound()
                local Wanted = data.GetWanted()
                local Keys = data.GetEncodedKeys()
                local Coords = data.GetEncodedCoords()
                local Inventory = data.GetEncodedInventory()
                local Condition = data.GetEncodedCondition()
                local Modifications = data.GetEncodedModifications()
                local Plate = data.GetPlate()
                
                ig.sql.ExecutePrepared(VehicleSaveData, {
                    Fuel,
                    Coords,
                    Keys,
                    Condition,
                    Modifications,
                    Inventory,
                    Parked,
                    Impound,
                    Wanted,
                    Plate
                }, function(r)
                    data.ClearDirty()
                end)
            else
                -- Clean up non-existent vehicles
                ig.data.RemoveVehicle(k)
            end
        end
    end
    
    local elapsed = (os.clock() - startTime) * 1000
    if saveCount > 0 then
        ig.log.Info("SQL", "Saved %d vehicles in %.2fms", saveCount, elapsed)
    end
    if cb then
        cb()
    end
end

--[[ Jobs ]] --

--- Save All Jobs to JSON (Jobs are now JSON-based, not SQL)
---@param cb function "To be called on save completion."
function ig.sql.save.Jobs(cb)
    local startTime = os.clock()
    local saveCount = 0
    local xJobs = ig.data.GetJobs()
    local jobsData = {}
    
    -- Build jobs data structure from job objects
    for jobName, jobObj in pairs(xJobs) do
        if jobObj.GetIsDirty() then
            saveCount = saveCount + 1
            jobsData[jobName] = {
                label = jobObj.GetLabel(),
                description = jobObj.GetDescription(),
                boss = jobObj.GetBoss(),
                grades = jobObj.GetGrades(),
                members = jobObj.GetMembers(),
                prices = jobObj.GetPrices(),
                locations = jobObj.GetLocations(),
                memos = jobObj.GetMemos(),
                settings = jobObj.GetSettings()
            }
            jobObj.ClearDirty()
        else
            -- Keep existing data for non-dirty jobs
            if ig.jobs[jobName] then
                jobsData[jobName] = ig.jobs[jobName]
            end
        end
    end
    
    -- Write to JSON file
    if saveCount > 0 then
        ig.json.Write(conf.file.jobs, jobsData)
        -- Update runtime table
        ig.jobs = jobsData
        
        local elapsed = (os.clock() - startTime) * 1000
        ig.log.Info("SQL", "Saved %d jobs to JSON in %.2fms", saveCount, elapsed)
    end
    
    if cb then
        cb()
    end
end

--[[ Objects ]] --

--- Save All Job Accounts
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function ig.sql.save.Objects(cb)
    -- Guard: Check if prepared query is initialized
    if ObjectSaveData == -1 then
        ig.log.Warn("SQL", "ObjectSaveData prepared query not ready yet, skipping save")
        if cb then cb() end
        return
    end
    
    local xObjs = ig.object.GetObjects()
    for k, data in pairs(xObjs) do
        if data then
            if (tonumber(ig.func.Timestamp()) - tonumber(data.Updated)) >= 3000 or data.GetIsDirty() == true then
                if DoesEntityExist(data.Entity) then
                    -- Tables require JSON Encoding - Use cached versions
                    local Inventory = data.GetEncodedInventory()
                    local Coords = data.GetEncodedCoords()
                    --
                    local UUID = data.UUID
                    -- 
                    ig.sql.ExecutePrepared(ObjectSaveData, {
                        Inventory,
                        Coords,
                        -- Where Conditions
                        UUID
                    }, function(r)
                        data.ClearDirty()
                    end)
                end
            end
        end
    end
    if cb then
        cb()
    end
end
