-- ====================================================================================--

c.door = {} -- functions
c.doors = {} -- from server

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

function c.door.SetDoors(doors)
    c.doors = doors
end

function c.door.ToggleLock(hash)
    --
    while DoorSystemSetOpenRatio(hash) ~= 0.0 do
        Citizen.Wait(1000)
    end
    --
    local state = DoorSystemGetDoorState(hash)
    if DoorSystemGetDoorPendingState(hash) ~- state then
        if state == 0 then
            TriggerServerEvent("Server:Doors:SetState", hash, 1)
        elseif state == 1 then 
            TriggerServerEvent("Server:Doors:SetState", hash, 0)
        end
    end
end

function c.door.Add(d)
    local hash, model, coords, jobs, locked, item, time = d[1], d[2], d[3], d[4], d[5], d[6], d[7]
    AddDoorToSystem(hash, model, coords.x, coords.y, coords.z, false, false, false)
    DoorSystemSetDoorState(hash, locked, 0)
end

function c.door.Find(d)
    local hash = d[1]
    if IsDoorRegisteredWithSystem(hash) then
        return true
    else
        return false
    end
end

function c.door.AddDoorsToSystem(doors)
    for k,v in pairs(doors) do
        if not c.door.Find(v) then
            c.door.Add(v)
        end
    end
end

RegisterNetEvent("Client:Doors:Sync", function(hash, state)
    if IsDoorRegisteredWithSystem(hash) then
        DoorSystemSetDoorState(hash, state, 1)
    end
end)