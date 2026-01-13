--[[
    Locate Vehicles Command
    
    Allows players to locate vehicles they have keys for
    Creates GPS blips for 1 minute then removes them
    Works with both database vehicles and persistent vehicles
]]

-- ====================================================================================--
-- Server-Side Locate Vehicles
-- ====================================================================================--

---Locate all vehicles where player has keys
---@param playerId number Player server ID
---@param characterId number Character ID to search for in keys
function ig.vehicle.LocatePlayerVehicles(playerId, characterId)
    if not characterId then
        TriggerClientEvent("Client:Notify", playerId, "No character loaded", "error", 5000)
        return
    end
    
    local blips = {}
    local vehicleCount = 0
    
    -- Check persistent vehicles cache (already loaded from DB and JSON)
    local persistentVehicles = ig.vehicle.GetAllPersistentVehicles()
    
    for plate, vehicleData in pairs(persistentVehicles) do
        if vehicleData and vehicleData.coords then
            -- Check if character ID owns this vehicle
            if vehicleData.owner == characterId then
                vehicleCount = vehicleCount + 1
                table.insert(blips, {
                    plate = plate,
                    coords = vehicleData.coords,
                    model = vehicleData.model,
                    type = "persistent"
                })
            end
        end
    end
    
    -- Send blips to client
    if vehicleCount > 0 then
        TriggerClientEvent("Client:Vehicle:CreateLocateBlips", playerId, blips)
        TriggerClientEvent("Client:Notify", playerId, "Located " .. vehicleCount .. " vehicle(s)", "success", 5000)
    else
        TriggerClientEvent("Client:Notify", playerId, "No vehicles found", "info", 5000)
    end
end

-- ====================================================================================--
-- Command Handler
-- ====================================================================================--

RegisterCommand("locatevehicles", function(source, args, rawCommand)
    local src = tonumber(source)
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        TriggerClientEvent("Client:Notify", src, "Player data not found", "error", 5000)
        return
    end
    
    ig.vehicle.LocatePlayerVehicles(src, xPlayer.GetCharacter_ID())
end, false)

-- ====================================================================================--
-- Callback Handler (for client-side triggering)
-- ====================================================================================--

RegisterServerCallback({
    eventName = "Server:Vehicle:LocateVehicles",
    eventCallback = function(source)
        local src = tonumber(source)
        local xPlayer = ig.data.GetPlayer(src)
        
        if not xPlayer then
            return { success = false, error = "Player data not found" }
        end
        
        ig.vehicle.LocatePlayerVehicles(src, xPlayer.GetCharacter_ID())
        return { success = true }
    end
})
