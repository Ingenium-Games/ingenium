-- ====================================================================================--
-- Vehicle Event Tracking System (Optimized)
-- Event-driven approach with lightweight fallback thread
-- Replaces polling-based vehicle tracking from ig.base
-- ====================================================================================--

ig.vehicles = {}
ig.vehicles.currentVehicle = 0
ig.vehicles.currentSeat = -1

-- ====================================================================================--
-- Event-Driven Vehicle Tracking using gameEventTriggered
-- ====================================================================================--

--- Handle vehicle entry via game events
---@param eventName string The name of the game event
---@param eventData table The event data
AddEventHandler("gameEventTriggered", function(eventName, eventData)
    -- Handle vehicle entry event
    if eventName == "CEventNetworkPlayerEnteredVehicle" then
        local ped = PlayerPedId()
        -- eventData[1] = ped, eventData[2] = vehicle, eventData[3] = seat
        if eventData[1] == ped then
            local vehicle = eventData[2]
            local seat = eventData[3]
            
            if DoesEntityExist(vehicle) then
                ig.vehicles.currentVehicle = vehicle
                ig.vehicles.currentSeat = seat
                
                local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                
                -- Trigger local event for other systems
                TriggerEvent("Client:EnteredVehicle", vehicle, seat, vehicleName, netId)
                TriggerServerEvent("Server:Vehicle:PlayerEntered", netId, seat, vehicleName)

                ig.log.Trace("Vehicle", "Player entered vehicle: " .. vehicleName .. " in seat " .. seat)
            end
        end
    
    -- Handle vehicle exit event
    elseif eventName == "CEventNetworkPlayerLeftVehicle" then
        local ped = PlayerPedId()
        -- eventData[1] = ped, eventData[2] = vehicle
        if eventData[1] == ped then
            local vehicle = eventData[2] or currentVehicle
            local seat = ig.vehicles.currentSeat
            
            if DoesEntityExist(vehicle) then
                local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                
                -- Trigger local event for other systems
                TriggerEvent("Client:LeftVehicle", vehicle, seat, vehicleName, netId)
                TriggerServerEvent("Server:Vehicle:PlayerLeft", netId, seat, vehicleName)
                
                ig.log.Trace("Vehicle", "Player left vehicle: " .. vehicleName)
            end
            
            -- Reset tracking
            ig.vehicles.currentVehicle = 0
            ig.vehicles.currentSeat = -1
        end
    end
end)

-- ====================================================================================--
-- Lightweight Fallback Thread (1 second check for edge cases)
-- Handles cases where game events might not trigger (teleportation, etig.)
-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Wait(1000) -- Check every 1 second (much better than 50ms polling)
        
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        -- Player entered a vehicle but event didn't trigger
        if vehicle ~= 0 and vehicle ~= ig.vehicles.currentVehicle then
            local seat = -1
            for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                if GetPedInVehicleSeat(vehicle, i) == ped then
                    seat = i
                    break
                end
            end
            
            ig.vehicles.currentVehicle = vehicle
            ig.vehicles.currentSeat = seat
            
            local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local netId = NetworkGetNetworkIdFromEntity(vehicle)
            
            TriggerEvent("Client:EnteredVehicle", vehicle, seat, vehicleName, netId)
            TriggerServerEvent("Server:Vehicle:PlayerEntered", netId, seat, vehicleName)
            
            ig.log.Debug("Vehicle", "Vehicle entry detected via fallback thread")
        
        -- Player left vehicle but event didn't trigger
        elseif vehicle == 0 and ig.vehicles.currentVehicle ~= 0 then
            local vehicle = ig.vehicles.currentVehicle
            local seat = ig.vehicles.currentSeat
            
            if DoesEntityExist(vehicle) then
                local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                
                TriggerEvent("Client:LeftVehicle", vehicle, seat, vehicleName, netId)
                TriggerServerEvent("Server:Vehicle:PlayerLeft", netId, seat, vehicleName)
                
            end
            
            ig.vehicles.currentVehicle = 0
            ig.vehicles.currentSeat = -1
            
            ig.log.Debug("Vehicle", "Vehicle exit detected via fallback thread")
        end
    end
end)

