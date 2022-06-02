-- ====================================================================================--
if not c.sql then
    c.sql = {}
end
--
c.sql.save = {}
--[[
NOTES.
    - All sql querys should have a call back as a function at the end to chain code execution upon completion.
    - All data should be encoded or decoded here, if possible. the fetchALL commands are decoded in the _data.lua
]] --

-- ====================================================================================--

--[[    Players ]] --

local PlayerSaveData = -1
MySQL.Async.store(
    "UPDATE `characters` SET `Health` = @Health, `Armour` = @Armour, `Hunger` = @Hunger, `Thirst` = @Thirst, `Stress` = @Stress, `Coords` = @Coords, `Accounts` = @Accounts, `Modifiers` = @Modifiers, `Inventory` = @Inventory, `Job` = @Job WHERE `Character_ID` = @Character_ID;",
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

--[[    Vehicles ]] --

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
        if data.GetOwner() then

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
                -- Where conditions
                ["@Plate"] = Plate
            }, function(r)
                -- do
            end)
            if cb then
                cb()
            end

        end
    end
end

--- Save All Characters from the xPLayer Table.
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function c.sql.save.Vehicles(cb)
    local xVehicles = c.data.GetVehicles()
    for k, v in pairs(xVehicles) do
        local data = c.data.GetVehicle(k)
        if data then
            if data.GetOwner() then
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
                    -- Where Conditions
                    ["@Plate"] = Plate
                }, function(r)
                    -- Do nothing.
                end)
            end
        end
    end
    if cb then
        cb()
    end
end

--[[    Jobss ]] --

local JobSaveData = -1
MySQL.Async.store("UPDATE `job_accounts` SET `Accounts` = @Accounts WHERE `Name` = @Name;", function(id)
    JobSaveData = id
end)

--- Save All Job Accounts
---@param cb function "To be called on SQL 'UPDATE' statements are completed."
function c.sql.save.Jobs(cb)
    local xJobs = c.data.GetJobs()
    for k, v in pairs(xJobs) do
        -- Tables require JSON Encoding.
        local Accounts = json.encode(xJobs[k].GetAccounts(false))
        -- 
        local Name = xJobs[k].GetName()
        MySQL.Async.insert(JobSaveData, {
            ["@Accounts"] = Accounts,
            -- Where Conditions
            ["@Name"] = Name
        }, function(r)
            -- Do nothing.
        end)
    end
    if cb then
        cb()
    end
end
