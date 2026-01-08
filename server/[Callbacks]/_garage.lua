-- ====================================================================================--
-- ig.garage - Server Callbacks
-- ====================================================================================--

--- Callback: Get available parking spots for a garage
local GetAvailableSpots = RegisterServerCallback({
    eventName = "GetAvailableSpots",
    eventCallback = function(source, garageId)
        local spots = ig.garage.GetAvailableSpots(garageId)
        return spots
    end
})

--- Callback: Get player's vehicles from database
local GetPlayerVehicles = RegisterServerCallback({
    eventName = "GetPlayerVehicles",
    eventCallback = function(source)
        local xPlayer = ig.data.GetPlayer(source)
        if not xPlayer then return {} end
        
        local characterId = xPlayer.GetCharacter_ID()
        local vehicles = ig.sql.veh.GetAll(characterId)
        
        return vehicles or {}
    end
})

--- Callback: Get parked vehicles for a specific garage
local GetGarageVehicles = RegisterServerCallback({
    eventName = "GetGarageVehicles",
    eventCallback = function(source, garageId)
        local xPlayer = ig.data.GetPlayer(source)
        if not xPlayer then return {} end
        
        local characterId = xPlayer.GetCharacter_ID()
        local allVehicles = ig.sql.veh.GetAll(characterId)
        local garageVehicles = {}
        
        for _, vehicle in ipairs(allVehicles) do
            -- Only show parked vehicles
            if vehicle.Parked == 1 then
                table.insert(garageVehicles, vehicle)
            end
        end
        
        return garageVehicles
    end
})

-- ====================================================================================--
