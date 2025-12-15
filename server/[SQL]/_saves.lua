-- ====================================================================================--
if not c.sql then c.sql = {} end
c.sql.save = {}
-- ====================================================================================--

--[[ Players ]] --

local PlayerSaveData = -1
MySQL.Async.store(
    "UPDATE `characters` SET `Health` = @Health, `Armour` = @Armour, `Hunger` = @Hunger, `Thirst` = @Thirst, `Stress` = @Stress, `Coords` = @Coords, `Skills` = @Skills, `Accounts` = @Accounts, `Modifiers` = @Modifiers, `Inventory` = @Inventory, `Ammo` = @Ammo, `Job` = @Job WHERE `Character_ID` = @Character_ID;",
    function(id)
        PlayerSaveData = id
    end)

--- Save Single User/Character
---@param data table "xPlayer table"
---@param cb function "To be called on SQL 'UPDATE' statement completion."
function c.sql.save.User(data, cb)
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
    MySQL.Async.insert(PlayerSaveData, {
        -- Other Variables.
        ["@Health"] = Health,
        ["@Armour"] = Armour,
        ["@Hunger"] = Hunger,
        ["@Thirst"] = Thirst,
        ["@Stress"] = Stress,
        -- Table Informaiton.
        ["@Skills"] = Skills,
        ["@Coords"] = Coords,
        ["@Accounts"] = Accounts,
        ["@Modifiers"] = Modifiers,
        ["@Inventory"] = Inventory,
        ["@Ammo"] = Ammo,

        ["@Job"] = Job,
        -- Where Conditions
        ["@Character_ID"] = Character_ID
    }, function(r)
        data.ClearDirty()
    end)
    if cb then
        cb()
    end
end

--- Save All Characters from the xPLayer Table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function c.sql.save.Users(cb)
    local startTime = os.clock()
    local saveCount = 0
    local xPlayers = c.data.GetPlayers()
    for k, v in pairs(xPlayers) do
        local data = c.data.GetPlayer(k)
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
            MySQL.Async.insert(PlayerSaveData, {
                -- Other Variables.
                ["@Health"] = Health,
                ["@Armour"] = Armour,
                ["@Hunger"] = Hunger,
                ["@Thirst"] = Thirst,
                ["@Stress"] = Stress,
                -- Table Informaiton.
                ["@Skills"] = Skills,
                ["@Coords"] = Coords,
                ["@Accounts"] = Accounts,
                ["@Modifiers"] = Modifiers,
                ["@Inventory"] = Inventory,
                ["@Ammo"] = Ammo,

                ["@Job"] = Job,
                -- Where Conditions
                ["@Character_ID"] = Character_ID
            }, function(r)
                data.ClearDirty()
            end)
        end
    end
    local elapsed = (os.clock() - startTime) * 1000
    print(string.format("^2[SQL] Saved %d players in %.2fms^7", saveCount, elapsed))
    if cb then
        cb()
    end
end

--[[ Vehicles ]] --

local VehicleSaveData = -1
MySQL.Async.store(
    "UPDATE `vehicles` SET `Fuel` = @Fuel, `Coords` = @Coords, `Keys` = @Keys, `Condition` = @Condition, `Modifications` = @Modifications, `Inventory` = @Inventory, `Parked` = @Parked, `Impound` = @Impound, `Wanted` = @Wanted  WHERE `Plate` = @Plate", -- AND `Parked` = TRUE;
    function(id)
        VehicleSaveData = id
    end)

--- Save Single User/Character
---@param data table "xCar table"
---@param cb function "To be called on SQL 'UPDATE' statement completion."
function c.sql.save.Vehicle(data, cb)
    if not data or data.Owner == false or not data.Save or not data.GetIsDirty() then
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
    local Updated = c.func.Timestamp()
    -- The Key
    local Plate = data.GetPlate()
    --
    MySQL.Async.insert(VehicleSaveData, {
        -- Other Variables.
        ["@Fuel"] = Fuel,
        -- Booleans
        ["@Impound"] = Impound,
        ["@Parked"] = Parked,
        ["@Wanted"] = Wanted,
        -- Table Informaiton.
        ["@Keys"] = Keys,
        ["@Coords"] = Coords,
        ["@Condition"] = Condition,
        ["@Modifications"] = Modifications,
        ["@Inventory"] = Inventory,
        ["@Updated"] = Updated,

        -- Where conditions
        ["@Plate"] = Plate
    }, function(r)
        data.Saved()
        data.ClearDirty()
    end)
    if cb then
        cb()
    end
end

--- Save All Characters from the xPLayer Table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function c.sql.save.Vehicles(cb)
    local startTime = os.clock()
    local saveCount = 0
    local xVehicles = c.data.GetVehicles()
    for k, data in pairs(xVehicles) do
        if data and data.Owner ~= false and data.Save == true and data.GetIsDirty() then
            if DoesEntityExist(data.Entity) then
                saveCount = saveCount + 1
                -- Other Variables.
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
                local Updated = c.func.Timestamp()
                -- The Key
                local Plate = data.GetPlate()
                --
                MySQL.Async.insert(VehicleSaveData, {
                    -- Other Variables.
                    ["@Fuel"] = Fuel,
                    -- Booleans
                    ["@Impound"] = Impound,
                    ["@Parked"] = Parked,
                    ["@Wanted"] = Wanted,
                    -- Table Informaiton.
                    ["@Keys"] = Keys,
                    ["@Coords"] = Coords,
                    ["@Condition"] = Condition,
                    ["@Modifications"] = Modifications,
                    ["@Inventory"] = Inventory,
                    ["@Updated"] = Updated,

                    -- Where Conditions
                    ["@Plate"] = Plate
                }, function(r)
                    data.Saved()
                    data.ClearDirty()
                end)
            else
                c.data.RemoveVehicle(k)
            end
        end
    end
    local elapsed = (os.clock() - startTime) * 1000
    print(string.format("^2[SQL] Saved %d vehicles in %.2fms^7", saveCount, elapsed))
    if cb then
        cb()
    end
end

--[[ Jobs ]] --

local JobSaveData = -1
MySQL.Async.store("UPDATE `job_accounts` SET `Accounts` = @Accounts WHERE `Name` = @Name;", function(id)
    JobSaveData = id
end)

--- Save All Job Accounts
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function c.sql.save.Jobs(cb)
    local xJobs = c.data.GetJobs()
    for k, data in pairs(xJobs) do
        if (data.ShouldSave() == true) then
            -- Tables require JSON Encoding.
            local Accounts = json.encode(data.GetAccounts(false))
            -- 
            local Name = data.GetName()
            MySQL.Async.insert(JobSaveData, {
                ["@Accounts"] = Accounts,
                -- Where Conditions
                ["@Name"] = Name
            }, function(r)
                data.Saved()
            end)
        end
    end
    if cb then
        cb()
    end
end

--[[ Jobs ]] --

local ObjectSaveData = -1
MySQL.Async.store("UPDATE `objects` SET `Inventory` = @Inventory, `Coords` = @Coords WHERE `UUID` = @UUID;",
    function(id)
        ObjectSaveData = id
    end)

--- Save All Job Accounts
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function c.sql.save.Objects(cb)
    local xObjs = c.data.GetObjects()
    for k, data in pairs(xObjs) do
        if data then
            if (tonumber(c.func.Timestamp()) - tonumber(data.Updated)) >= 3000 or data.ShouldSave() == true then
                if DoesEntityExist(data.Entity) then
                    -- Tables require JSON Encoding.
                    local Inventory = json.encode(data.CompressInventory())
                    local Coords = json.encode(data.GetCoords())
                    --
                    local UUID = data.UUID
                    -- 
                    MySQL.Async.insert(ObjectSaveData, {
                        ["@Inventory"] = Inventory,
                        ["@Coords"] = Coords,
                        -- Where Conditions
                        ["@UUID"] = UUID
                    }, function(r)
                        data.Saved()
                    end)
                end
            end
        end
    end
    if cb then
        cb()
    end
end
