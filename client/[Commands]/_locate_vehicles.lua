--[[
    Locate Vehicles Client
    
    Handles GPS blips for located vehicles
    Creates blips that auto-remove after 1 minute
]]

-- ====================================================================================--
-- Client-Side Blip Management
-- ====================================================================================--

ig.vehicle = ig.vehicle or {}
ig.vehicle.locateBlips = {}  -- Track active blips for cleanup

---Create GPS blips for located vehicles
---@param blips table Array of vehicle blip data
RegisterNetEvent("Client:Vehicle:CreateLocateBlips", function(blips)
    -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= GetCurrentResourceName() then
        CancelEvent()
        return
    end
    
    if not blips or #blips == 0 then
        return
    end
    
    -- Clear any existing locate blips
    ig.vehicle.ClearLocateBlips()
    
    local blipDuration = 60000  -- 1 minute in milliseconds
    local startTime = GetGameTimer()
    
    for _, vehicleData in ipairs(blips) do
        if vehicleData.coords then
            -- Create blip
            local blip = AddBlipForCoord(vehicleData.coords.x, vehicleData.coords.y, vehicleData.coords.z)
            
            -- Set blip properties
            SetBlipRoute(blip, true)  -- Enable GPS route
            SetBlipAsShortRange(blip, false)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Vehicle: " .. vehicleData.plate)
            EndTextCommandSetBlipName(blip)
            
            -- Set blip color (light blue for vehicles with keys)
            SetBlipColour(blip, 3)
            
            -- Set blip icon (car)
            SetBlipSprite(blip, 227)
            
            -- Scale
            SetBlipScale(blip, 0.8)
            
            -- Store blip data
            table.insert(ig.vehicle.locateBlips, {
                blip = blip,
                plate = vehicleData.plate,
                createdAt = startTime,
                duration = blipDuration
            })
        end
    end
    
    -- Create cleanup thread
    if #ig.vehicle.locateBlips > 0 then
        TriggerEvent("Client:Notify", "GPS Routes Active - " .. #ig.vehicle.locateBlips .. " vehicle(s) marked for 1 minute", "success", 5000)
        
        CreateThread(function()
            while #ig.vehicle.locateBlips > 0 do
                Wait(100)
                
                local currentTime = GetGameTimer()
                local toRemove = {}
                
                for i, blipData in ipairs(ig.vehicle.locateBlips) do
                    local elapsed = currentTime - blipData.createdAt
                    
                    -- Remove blip if duration expired
                    if elapsed >= blipData.duration then
                        RemoveBlip(blipData.blip)
                        table.insert(toRemove, i)
                    end
                end
                
                -- Remove expired blips from table (reverse order to maintain indices)
                for i = #toRemove, 1, -1 do
                    table.remove(ig.vehicle.locateBlips, toRemove[i])
                end
                
                -- Exit thread if no more blips
                if #ig.vehicle.locateBlips == 0 then
                    TriggerEvent("Client:Notify", "GPS Routes Expired", "info", 3000)
                    break
                end
            end
        end)
    end
end)

---Clear all locate blips
function ig.vehicle.ClearLocateBlips()
    for _, blipData in ipairs(ig.vehicle.locateBlips) do
        RemoveBlip(blipData.blip)
    end
    ig.vehicle.locateBlips = {}
end

-- ====================================================================================--
-- Client-Side Command
-- ====================================================================================--

RegisterCommand("locatevehicles", function(source, args, rawCommand)
    ig.callback.Async("Server:Vehicle:LocateVehicles", function(result)
        if result and result.success then
            -- Blips will be created by Client:Vehicle:CreateLocateBlips event
        else
            TriggerEvent("Client:Notify", result and result.error or "Failed to locate vehicles", "error", 5000)
        end
    end)
end, false)

-- ====================================================================================--
-- Cleanup on resource stop
-- ====================================================================================--

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        ig.vehicle.ClearLocateBlips()
    end
end)
