
-- Check if player is near an machine
function IsNearMachine()
        local objFound = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 1.5, ig.garage._TicketMachine, 0, 0, 0)
        if DoesEntityExist(objFound) then
            TaskTurnPedToFaceEntity(PlayerPedId(), objFound, 3.0)
            return true
        end
    return false
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function MachineAnimation()
    local player = GetPlayerPed(-1)
    if IsNearMachine() then
        if (DoesEntityExist(player) and not IsEntityDead(player)) then

            loadAnimDict("amb@prop_human_atm@male@enter")
            loadAnimDict("amb@prop_human_atm@male@exit")
            loadAnimDict("amb@prop_human_atm@male@idle_a")

            if (ig.garage._UseMachine) then
                ClearPedTasks(PlayerPedId())
                TaskPlayAnim(player, "amb@prop_human_atm@male@exit", "exit", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
                ig.garage._UseMachine = false
                local finished = exports["ig.taskbar"]:Start(3000, "Retrieving Card")
                ClearPedTasks(PlayerPedId())
            else
                ig.garage._UseMachine = true
                TaskPlayAnim(player, "amb@prop_human_atm@male@idle_a", "idle_b", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
                local finished = exports["ig.taskbar"]:Start(1000, "Accessing Parking Machine")
                if finished == 100 then
                    ClearPedTasks(PlayerPedId())
                end
            end
        end
        RemoveAnimDict("amb@prop_human_atm@male@enter")
        RemoveAnimDict("amb@prop_human_atm@male@exit")
        RemoveAnimDict("amb@prop_human_atm@male@idle_a")
    else
        if (DoesEntityExist(player) and not IsEntityDead(player)) then

            loadAnimDict("mp_common")

            if (ig.garage._UseMachine) then
                ClearPedTasks(PlayerPedId())
                TaskPlayAnim(player, "mp_common", "givetake1_a", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
                ig.garage._UseMachine = false
                local finished = exports["ig.taskbar"]:Start(1000, "Retrieving Card")
                ClearPedTasks(PlayerPedId())
            else
                ig.garage._UseMachine = true
                TaskPlayAnim(player, "mp_common", "givetake1_a", 1.0, 1.0, -1, 49, 0, 0, 0, 0)
                local finished = exports["ig.taskbar"]:Start(1000, "Accessing Parking Machine")
                if finished == 100 then
                    ClearPedTasks(PlayerPedId())
                end
            end
        end
        RemoveAnimDict("mp_common")
    end
end

-- Open Gui and Focus NUI
function OGui()
    ig.garage._VehicleData = TriggerServerCallback({
        eventName = "GetCars",
        args = {}
    })
    MachineAnimation()
    Citizen.Wait(1400)
    SetNuiFocus(true, true)
    SendNUIMessage({
        message = "Open",
        data = ig.garage._VehicleData,
    })
end

-- Close Gui and disable NUI
function CGui()
    SetNuiFocus(false, false)
    SendNUIMessage({
        message = "Close",
        data = {},
    })
    ig.garage._VehicleData = {}
    ig.garage._OpenMachine = false
    Machine = nil
    ig.garage._MachinePosition = nil
    MachineAnimation()
end

AddEventHandler("Client:Interact:ParkingMachine", function(data)
    Machine = data.entity
    ig.garage._MachinePosition = GetEntityCoords(Machine)
    if IsNearMachine() then
        ig.garage._OpenMachine = true
        OGui()
    else
        TriggerEvent("Client:Notify", "No Parking Machine", 2)
        ig.garage._OpenMachine = false
        CGui()
    end
end)

RegisterNUICallback("GUI:Close", function(data, cb)
    CGui()
    cb("ok")
end)

RegisterNUICallback("GUI:SelectVehicle", function(data, cb)
    local Plate = data.Plate
    -- Optimized: Added early exit to avoid unnecessary iterations
    local Data = nil
    for k,v in pairs(ig.garage._VehicleData) do
        if v.Plate == Plate then
            Data = v
            break  -- Exit early once found
        end
    end
    
    local billed = TriggerServerCallback({eventName = "ParkingBill", args = {}})
    if not billed then
        TriggerEvent("Client:Notify","You dont have the cash to return your vehicle.")
        CGui()
        cb("ok")
        return
    end
    
    if Data == nil then 
        cb("ok")
        return 
    end
    
    -- Optimized: More efficient parking spot selection
    local Position = ig.garage._MachinePosition
    local bestSpot = nil
    local bestDistance = math.huge
    
    for _, spot in ipairs(conf.garage.parkingspots) do
        if c.func.IsVehicleSpawnClear(spot, 1.2) then
            local distance = #(vector3(spot.x, spot.y, spot.z) - Position)
            if distance < bestDistance then
                bestDistance = distance
                bestSpot = spot
            end
        end
    end
    
    if bestSpot then
        local net = TriggerServerCallback({eventName = "EnsurePlayerVehicle", args = {Data, bestSpot}})
    else
        TriggerEvent("Client:Notify", "No available parking spots nearby.", 2)
    end
    
    CGui()
    cb("ok")
end)