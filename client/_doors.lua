-- ====================================================================================--
-- Door management (ig.door, ig.doors initialized in client/_var.lua)
-- ====================================================================================--

--[[
[       script:ig.dev] [197] = {
[       script:ig.dev]     [1] = 89357677,
[       script:ig.dev]     [2] = 680601509,
[       script:ig.dev]     [3] = vec3(1018.692322, 67.176483, 70.010086),
[       script:ig.dev]     [4] = false,
[       script:ig.dev]     [5] = false,
[       script:ig.dev]     [6] = false,
[       script:ig.dev]     [7] = false,
[       script:ig.dev]     },
[       script:ig.dev] }
]]--

function ig.door.SetDoors(doors)
    ig.doors = doors
end

function ig.door.ToggleLock(hash)
    --
    --while DoorSystemSetOpenRatio(hash) ~= 0.0 do
    --    Citizen.Wait(1000)
    --end
    --
    local state = DoorSystemGetDoorState(hash)
    if DoorSystemGetDoorPendingState(hash) ~= state then
        if state == 0 then
            -- Use secure callback for door state change
            TriggerServerCallback({
                eventName = "Server:Doors:SetState",
                args = {hash, 1}
            })
        elseif state == 1 then 
            -- Use secure callback for door state change
            TriggerServerCallback({
                eventName = "Server:Doors:SetState",
                args = {hash, 0}
            })
        end
    end
end

local door_hashes = {}

function ig.door.Add(d)
    local hash, model, coords, jobs, locked, item, time = d[1], d[2], d[3], d[4], d[5], d[6], d[7]
    AddDoorToSystem(hash, model, coords.x, coords.y, coords.z, false, false, false)
    DoorSystemSetDoorState(hash, locked, 0)
    --
    table.insert(door_hashes, hash)
end

function ig.door.Find(d)
    local hash = d[1]
    if IsDoorRegisteredWithSystem(hash) then
        return true
    else
        return false
    end
end

function ig.door.GetModels()
    local models = {}
    for k,v in pairs(ig.doors) do
        local model = v[2]
        if not ig.table.MatchValue(models, model) then
            table.insert(models, model)
        end
    end    
    return models
end

--- func desc
---@param coords any
function ig.door.FindHash(hash)
    for k,v in pairs(ig.doors) do
        -- is the door in the table?
        if (v[1] == hash) then
            return true, k, v
        end
    end    
    return false, false
end

local start_scan = false
local target_cache = {}

function ig.door.AddDoorsToSystem(doors)
    for k,v in pairs(doors) do
        if not ig.door.Find(v) then
            ig.door.Add(v)
        end
    end
    if ig.doors ~= doors then
        ig.door.SetDoors(doors)
    end
    start_scan = true
end

local models_cache = false
local zones = {}

function ig.door.GenerateDoorsInRadius()
    if not models_cache then models_cache = ig.door.GetModels() end
    -- print("Checking Models")
    -- print(ig.table.Dump(models_cache))
    local entities = {}
    local ped = PlayerPedId()
    local ords = GetEntityCoords(ped)
    local objs = ig.func.GetObjectsInArea(ords, 16, false)
    -- print("Checking Objects")
    -- print(ig.table.Dump(objs))
    for k, v in pairs(objs) do
        if ig.table.MatchValue(models_cache, v.Model) then
            local bool, hash = DoorSystemFindExistingDoor(v.Coords.x, v.Coords.y, v.Coords.z, v.Model)
            if bool then
                entities[k] = hash
            end
        end
    end
    -- print("Checking Entities")
    -- print(ig.table.Dump(entities))
    for k, v in pairs(entities) do
        if DoesEntityExist(k) and not ig.table.MatchValue(target_cache, k) then
            --
            --print("Adding to cache: "..k)
            table.insert(target_cache, k)
            --
            local bool, key, values = ig.door.FindHash(v)
            --print("Checking ig.door.FindHash(hash) ")
            --print(bool, key, ig.table.Dump(values))
            --
            exports['ingenium']:AddEntityZone("DOOR_"..key, k, {
                name = "DOOR_"..key,
                heading = GetEntityHeading(k),
                debugPoly = false,
            }, {
                options = {
                {
                    label = "Door",
                    info = "Lock",
                    job = values[4],
                    interact = function()
                        local state = DoorSystemGetDoorState(v)
                        if state == 0 then
                            return true
                        end
                    end,
                    action = function()
                        ig.door.ToggleLock(v)
                    end
                },
                {
                    label = "Door",
                    info = "Unlock",
                    job = values[4],
                    interact = function()
                        local state = DoorSystemGetDoorState(v)
                        if state == 1 then
                            return true
                        end
                    end,
                    action = function()
                        ig.door.ToggleLock(v)
                    end
                },
            },
                distance = 2.5
            })
        end
    end
    -- print("Checking target_cache")
    -- print(ig.table.Dump(target_cache))
end

--- func desc
---@param coords any
function ig.door.SetState(hash, state)
    for k,v in pairs(ig.doors) do
        -- is the door in the table?
        if v[1] == hash then
            v[5] = state
        end
    end    
end

RegisterNetEvent("Client:Doors:Sync", function(hash, state)
    -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= GetCurrentResourceName() then
        CancelEvent()
        return
    end
    
    if IsDoorRegisteredWithSystem(hash) then
        ig.door.SetState(hash, state)
        DoorSystemSetDoorState(hash, state, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        if start_scan then
            ig.door.GenerateDoorsInRadius()
            Citizen.Wait(2200)
        else
            Citizen.Wait(500)
        end
    end
end)