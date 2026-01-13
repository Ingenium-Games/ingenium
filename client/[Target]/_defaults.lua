
local GetEntityBoneIndexByName = GetEntityBoneIndexByName
local GetWorldPositionOfEntityBone = GetWorldPositionOfEntityBone
local GetVehicleDoorLockStatus = GetVehicleDoorLockStatus

local function toggleDoor(vehicle, door)
    if GetVehicleDoorLockStatus(vehicle) ~= 2 then
        if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
            SetVehicleDoorShut(vehicle, door, false)
        else
            SetVehicleDoorOpen(vehicle, door, false, false)
        end
    end
end

ig.target.addGlobalVehicle({
    {
        name = 'ig.target:driverF',
        icon = 'fa-solid fa-car-side',
        label = 'Toggle front driver door',
        bones = { 'door_dside_f', 'seat_dside_f' },
        interact = function(entity, distance, coords, name, bone)
            if ig.util.IsVehicleLocked(entity) then return end
            -- door bone has 0.5 threshold, seat bone has 0.72 threshold
            -- since bone is already the closest, just check with a combined threshold
            return ig.util.CheckBoneDistance(entity, bone, coords, 0.72)
        end,
        action = function(data)
            toggleDoor(data.entity, 0)
        end
    }
})

ig.target.addGlobalVehicle({
    {
        name = 'ig.target:passengerF',
        icon = 'fa-solid fa-car-side',
        label = 'Toggle front passenger door',
        bones = { 'door_pside_f', 'seat_pside_f' },
        interact = function(entity, distance, coords, name, bone)
            if ig.util.IsVehicleLocked(entity) then return end
            return ig.util.CheckBoneDistance(entity, bone, coords, 0.72)
        end,
        action = function(data)
            toggleDoor(data.entity, 1)
        end
    }
})

ig.target.addGlobalVehicle({
    {
        name = 'ig.target:driverR',
        icon = 'fa-solid fa-car-side',
        label = 'Toggle rear driver door',
        bones = { 'door_dside_r', 'seat_dside_r' },
        interact = function(entity, distance, coords, name, bone)
            if ig.util.IsVehicleLocked(entity) then return end
            return ig.util.CheckBoneDistance(entity, bone, coords, 0.72)
        end,
        action = function(data)
            toggleDoor(data.entity, 2)
        end
    }
})

ig.target.addGlobalVehicle({
    {
        name = 'ig.target:passengerR',
        icon = 'fa-solid fa-car-side',
        label = 'Toggle rear passenger door',
        bones = { 'door_pside_r', 'seat_pside_r' },
        interact = function(entity, distance, coords, name, bone)
            if ig.util.IsVehicleLocked(entity) then return end
            return ig.util.CheckBoneDistance(entity, bone, coords, 0.72)
        end,
        action = function(data)
            toggleDoor(data.entity, 3)
        end
    }
})


ig.target.addGlobalVVehicle({
    {
        name = 'ig.target:bonnet',
        icon = 'fa-solid fa-car',
        label = 'Toggle hood',
        bones = 'bonnet',
        interact = function(entity, distance, coords, name, boneId)
            if ig.util.IsVehicleLocked(entity) then return end
            return ig.util.CheckBoneDistance(entity, boneId, coords, 0.9)
        end,
        action = function(data)
            toggleDoor(data.entity, 4)
        end
    }
})

ig.target.addGlobalVehicle({
    {
        name = 'ig.target:trunk',
        icon = 'fa-solid fa-car-rear',
        label = 'Toggle trunk',
        bones = 'boot',
        interact = function(entity, distance, coords, name, boneId)
            if ig.util.IsVehicleLocked(entity) then return end
            return ig.util.CheckBoneDistance(entity, boneId, coords, 0.9)
        end,
        action = function(data)
            toggleDoor(data.entity, 5)
        end
    }
})
