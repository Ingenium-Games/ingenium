-- ====================================================================================--
if not c.sql then
    c.sql = {}
end
c.sql.save = {}

-- ====================================================================================--

--[[ Players ]] --

local PlayerSaveData = -1
MySQL.Async.store(
    "UPDATE `characters` SET `Health` = @Health, `Armour` = @Armour, `Hunger` = @Hunger, `Thirst` = @Thirst, `Stress` = @Stress, `Coords` = @Coords, `Accounts` = @Accounts, `Modifiers` = @Modifiers, `Inventory` = @Inventory, `Ammo` = @Ammo, `Job` = @Job WHERE `Character_ID` = @Character_ID;",
    function(id)
        PlayerSaveData = id
    end)

--- Save Single User/Character
---@param data table "xPlayer table"
---@param cb function "To be called on SQL 'UPDATE' statement completion."
function c.sql.save.User(data, cb)
    if data then
        -- Other Variables.
        local Health = data.GetHealth()
        local Armour = data.GetArmour()
        local Hunger = data.GetHunger()
        local Thirst = data.GetThirst()
        local Stress = data.GetStress()
        -- Tables require JSON Encoding.
        local Coords = json.encode(data.GetCoords())
        local Accounts = json.encode(data.GetAccounts())
        local Modifiers = json.encode(data.GetModifiers())
        local Inventory = json.encode(data.CompressInventory())
        local Ammo = json.encode(data.GetAmmos())
        local Job = json.encode(data.GetJob())
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
            ["@Coords"] = Coords,
            ["@Accounts"] = Accounts,
            ["@Modifiers"] = Modifiers,
            ["@Inventory"] = Inventory,
            ["@Ammo"] = Ammo,

            ["@Job"] = Job,
            -- Where Conditions
            ["@Character_ID"] = Character_ID
        }, function(r)
            -- do
        end)
        if cb then
            cb()
        end
    end
end

--- Save All Characters from the xPLayer Table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function c.sql.save.Users(cb)
    local xPlayers = c.data.GetPlayers()
    for k, v in pairs(xPlayers) do
        local data = c.data.GetPlayer(k)
        if data then
            -- Other Variables.
            local Health = data.GetHealth()
            local Armour = data.GetArmour()
            local Hunger = data.GetHunger()
            local Thirst = data.GetThirst()
            local Stress = data.GetStress()
            -- Tables require JSON Encoding.
            local Coords = json.encode(data.GetCoords())
            local Accounts = json.encode(data.GetAccounts())
            local Modifiers = json.encode(data.GetModifiers())
            local Inventory = json.encode(data.CompressInventory())
            local Ammo = json.encode(data.GetAmmos())
            local Job = json.encode(data.GetJob())
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
                ["@Coords"] = Coords,
                ["@Accounts"] = Accounts,
                ["@Modifiers"] = Modifiers,
                ["@Inventory"] = Inventory,
                ["@Ammo"] = Ammo,

                ["@Job"] = Job,
                -- Where Conditions
                ["@Character_ID"] = Character_ID
            }, function(r)
                -- Do nothing.
            end)
        end
    end
    if cb then
        cb()
    end
end

--[[ Vehicles ]] --

local VehicleSaveData = -1
MySQL.Async.store(
    "UPDATE `vehicles` SET `Coords` = @Coords, `Keys` = @Keys, `Condition` = @Condition, `Modifications` = @Modifications, `Garage` = @Garage, `Parked` = @Parked, `Impound` = @Impound, `Wanted` = @Wanted  WHERE `Plate` = @Plate", -- AND `Parked` = TRUE;
    function(id)
        VehicleSaveData = id
    end)

--- Save Single User/Character
---@param data table "xCar table"
---@param cb function "To be called on SQL 'UPDATE' statement completion."
function c.sql.save.Vehicle(data, cb)
    if data then
        if data.GetOwner() ~= false then
            if data.ShouldSave() == true then
                if DoesEntityExist(data.Entity) then
                    local Fuel = data.GetFuel()
                    local Garage = data.GetGarage()
                    -- Booleans
                    local Parked = data.GetParked()
                    local Impound = data.GetImpound()
                    local Wanted = data.GetWanted()
                    -- Tables require JSON Encoding.
                    local Keys = json.encode(data.GetKeys())
                    local Coords = json.encode(data.GetCoords())
                    local Condition = json.encode(data.GetCondition())
                    local Modifications = json.encode(data.GetModifications())
                    local Inventory = json.encode(data.CompressInventory())
                    local Updated = c.func.Timestamp()
                    -- The Key
                    local Plate = data.GetPlate()
                    --
                    MySQL.Async.insert(VehicleSaveData, {
                        -- Other Variables.
                        ["@Garage"] = Garage,
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
                    end)
                    if cb then
                        cb()
                    end
                end
            end
        end
    end
end

--- Save All Characters from the xPLayer Table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function c.sql.save.Vehicles(cb)
    local xVehicles = c.data.GetVehicles()
    for k, data in pairs(xVehicles) do
        if data then
            if data.GetOwner() ~= false then
                if data.ShouldSave() == true then
                    if DoesEntityExist(data.Entity) then
                        -- Other Variables.
                        local Fuel = data.GetFuel()
                        local Garage = data.GetGarage()
                        -- Booleans
                        local Parked = data.GetParked()
                        local Impound = data.GetImpound()
                        local Wanted = data.GetWanted()
                        -- Tables require JSON Encoding.
                        local Keys = json.encode(data.GetKeys())
                        local Coords = json.encode(data.GetCoords())
                        local Condition = json.encode(data.GetCondition())
                        local Modifications = json.encode(data.GetModifications())
                        local Inventory = json.encode(data.CompressInventory())
                        local Updated = c.func.Timestamp()
                        -- The Key
                        local Plate = data.GetPlate()
                        --
                        MySQL.Async.insert(VehicleSaveData, {
                            -- Other Variables.
                            ["@Garage"] = Garage,
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
                        end)
                    end
                end
            end
        end
    end
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
