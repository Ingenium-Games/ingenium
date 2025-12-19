-- ====================================================================================--
-- Vehicle Event Tracking System (Optimized)
-- Event-driven approach with lightweight fallback thread
-- Replaces polling-based vehicle tracking from ig.base
-- ====================================================================================--

-- Track current vehicle state
local currentVehicle = 0
local currentSeat = -1

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
                currentVehicle = vehicle
                currentSeat = seat
                
                local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                
                -- Trigger local event for other systems
                TriggerEvent("Client:EnteredVehicle", vehicle, seat, vehicleName, netId)
                
                -- Notify server if needed
                if conf.gamemode == "RP" then
                    TriggerServerEvent("Server:PlayerEnteredVehicle", netId, seat, vehicleName)
                end
                
                ig.func.Debug_3("Player entered vehicle: " .. vehicleName .. " in seat " .. seat)
            end
        end
    
    -- Handle vehicle exit event
    elseif eventName == "CEventNetworkPlayerLeftVehicle" then
        local ped = PlayerPedId()
        -- eventData[1] = ped, eventData[2] = vehicle
        if eventData[1] == ped then
            local vehicle = eventData[2] or currentVehicle
            local seat = currentSeat
            
            if DoesEntityExist(vehicle) then
                local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                
                -- Trigger local event for other systems
                TriggerEvent("Client:LeftVehicle", vehicle, seat, vehicleName, netId)
                
                -- Notify server if needed
                if conf.gamemode == "RP" then
                    TriggerServerEvent("Server:PlayerLeftVehicle", netId, seat, vehicleName)
                end
                
                ig.func.Debug_3("Player left vehicle: " .. vehicleName)
            end
            
            -- Reset tracking
            currentVehicle = 0
            currentSeat = -1
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
        if vehicle ~= 0 and vehicle ~= currentVehicle then
            local seat = -1
            for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                if GetPedInVehicleSeat(vehicle, i) == ped then
                    seat = i
                    break
                end
            end
            
            currentVehicle = vehicle
            currentSeat = seat
            
            local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            local netId = NetworkGetNetworkIdFromEntity(vehicle)
            
            TriggerEvent("Client:EnteredVehicle", vehicle, seat, vehicleName, netId)
            
            if conf.gamemode == "RP" then
                TriggerServerEvent("Server:PlayerEnteredVehicle", netId, seat, vehicleName)
            end
            
            ig.func.Debug_1("Vehicle entry detected via fallback thread")
        
        -- Player left vehicle but event didn't trigger
        elseif vehicle == 0 and currentVehicle ~= 0 then
            local vehicle = currentVehicle
            local seat = currentSeat
            
            if DoesEntityExist(vehicle) then
                local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                local netId = NetworkGetNetworkIdFromEntity(vehicle)
                
                TriggerEvent("Client:LeftVehicle", vehicle, seat, vehicleName, netId)
                
                if conf.gamemode == "RP" then
                    TriggerServerEvent("Server:PlayerLeftVehicle", netId, seat, vehicleName)
                end
            end
            
            currentVehicle = 0
            currentSeat = -1
            
            ig.func.Debug_1("Vehicle exit detected via fallback thread")
        end
    end
end)

-- ====================================================================================--
-- Helper Functions
-- ====================================================================================--

--- Get current vehicle player is in
---@return number vehicle entity
function ig.GetCurrentVehicle()
    return currentVehicle
end

--- Get current seat player is in
---@return number seat index (-1 = driver)
function ig.GetCurrentSeat()
    return currentSeat
end

--- Check if player is in a vehicle
---@return boolean
function ig.IsInVehicle()
    return currentVehicle ~= 0
end

-- Export helper functions
exports("GetCurrentVehicle", ig.GetCurrentVehicle)
exports("GetCurrentSeat", ig.GetCurrentSeat)
exports("IsInVehicle", ig.IsInVehicle)
