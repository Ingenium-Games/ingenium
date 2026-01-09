-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.save = {}
-- ====================================================================================--

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
            print(string.format("^3[SQL WARNING] %s took %.2fms^7", saveName, elapsed))
        else
            print(string.format("^2[SQL] %s completed in %.2fms^7", saveName, elapsed))
        end
        if originalCb then originalCb() end
    end)
end

--[[ Players ]] --

local PlayerSaveData = -1
ig.sql.PrepareQuery(
    "UPDATE `characters` SET `Health` = ?, `Armour` = ?, `Hunger` = ?, `Thirst` = ?, `Stress` = ?, `Coords` = ?, `Skills` = ?, `Accounts` = ?, `Modifiers` = ?, `Inventory` = ?, `Ammo` = ?, `Job` = ? WHERE `Character_ID` = ?;",
    function(id)
        PlayerSaveData = id
    end)

--- Save Single User/Character
---@param data table "xPlayer table"
---@param cb function "To be called on SQL 'UPDATE' statement completion."
function ig.sql.save.User(data, cb)
    if not data or not data.GetIsDirty() then 
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
    local Accounts = data.GetEncodedAccounts()
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
        Accounts,
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
end

--- Save All Characters from the xPLayer Table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function ig.sql.save.Users(cb)
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
            local Accounts = data.GetEncodedAccounts()
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
                Accounts,
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
        print(string.format("^2[SQL] Saved %d players in %.2fms^7", saveCount, elapsed))
    end
    if cb then
        cb()
    end
end

--[[ Vehicles ]] --

local VehicleSaveData = -1
ig.sql.PrepareQuery(
    "UPDATE `vehicles` SET `Fuel` = ?, `Coords` = ?, `Keys` = ?, `Condition` = ?, `Modifications` = ?, `Inventory` = ?, `Parked` = ?, `Impound` = ?, `Wanted` = ?  WHERE `Plate` = ?", -- AND `Parked` = TRUE;
    function(id)
        VehicleSaveData = id
    end)

--- Save Single User/Character
---@param data table "xCar table"
---@param cb function "To be called on SQL 'UPDATE' statement completion."
function ig.sql.save.Vehicle(data, cb)
    if not data or data.Owner == false or not data.GetIsDirty() then
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

--- Save All Vehicles from the xVehicle Table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function ig.sql.save.Vehicles(cb)
    local startTime = os.clock()
    local saveCount = 0
    local xVehicles = ig.data.GetVehicles()
    
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
        print(string.format("^2[SQL] Saved %d vehicles in %.2fms^7", saveCount, elapsed))
    end
    if cb then
        cb()
    end
end

--[[ Jobs ]] --

local JobSaveData = -1
ig.sql.PrepareQuery("UPDATE `job_accounts` SET `Accounts` = ? WHERE `Name` = ?;", function(id)
    JobSaveData = id
end)

--- Save All Job Accounts
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function ig.sql.save.Jobs(cb)
    local xJobs = ig.data.GetJobs()
    for k, data in pairs(xJobs) do
        if (data.GetIsDirty() == true) then
            -- Tables require JSON Encoding.
            local Accounts = json.encode(data.GetAccounts(false))
            -- 
            local Name = data.GetName()
            ig.sql.ExecutePrepared(JobSaveData, {
                Accounts,
                -- Where Conditions
                Name
            }, function(r)
                data.ClearDirty()
            end)
        end
    end
    if cb then
        cb()
    end
end

--[[ Objects ]] --

local ObjectSaveData = -1
ig.sql.PrepareQuery("UPDATE `objects` SET `Inventory` = ?, `Coords` = ? WHERE `UUID` = ?;",
    function(id)
        ObjectSaveData = id
    end)

--- Save All Job Accounts
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function ig.sql.save.Objects(cb)
    local xObjs = ig.data.GetObjects()
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
