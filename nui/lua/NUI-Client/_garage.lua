-- ====================================================================================--
-- GARAGE NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for garage/vehicle management.
--
-- NUI sends these messages:
--   - NUI:Client:GarageClose        => Garage menu was closed
--   - NUI:Client:GarageSelectVehicle => Player selected vehicle to spawn/manage
--   - NUI:Client:GarageDeleteVehicle => Player requested vehicle deletion
--   - NUI:Client:GarageTuneVehicle   => Player opened vehicle customization
--
-- ====================================================================================--

-- Player closes garage menu
-- Sent from: nui/src/components/Garage.vue
RegisterNUICallback('NUI:Client:GarageClose', function(data, cb)
    ig.log.Trace("Garage", "Garage menu closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for garage cleanup
    TriggerEvent("Client:Garage:Close")
    
    cb({ok = true})
end)

-- Player selects vehicle from garage
-- Sent from: nui/src/components/Garage.vue with vehicle data
RegisterNUICallback('NUI:Client:GarageSelectVehicle', function(data, cb)
    if not data or not data.vehicleId then
        ig.log.Error("Garage", "NUI:Client:GarageSelectVehicle: missing vehicle data")
        cb({ok = false, error = "Missing vehicle data"})
        return
    end
    
    ig.log.Trace("Garage", "Vehicle selected: " .. data.vehicleId)
    
    -- Send vehicle selection to server
    TriggerServerEvent("Server:Garage:SelectVehicle", data.vehicleId)
    
    cb({ok = true})
end)

-- Player requests vehicle deletion
-- Sent from: nui/src/components/Garage.vue with vehicle data
RegisterNUICallback('NUI:Client:GarageDeleteVehicle', function(data, cb)
    if not data or not data.vehicleId then
        ig.log.Error("Garage", "NUI:Client:GarageDeleteVehicle: missing vehicle data")
        cb({ok = false, error = "Missing vehicle data"})
        return
    end
    
    ig.log.Trace("Garage", "Vehicle deletion requested: " .. data.vehicleId)
    
    -- Send deletion request to server
    TriggerServerEvent("Server:Garage:DeleteVehicle", data.vehicleId)
    
    cb({ok = true})
end)

-- Player opens vehicle customization/tuning menu
-- Sent from: nui/src/components/Garage.vue with vehicle data
RegisterNUICallback('NUI:Client:GarageTuneVehicle', function(data, cb)
    if not data or not data.vehicleId then
        ig.log.Error("Garage", "NUI:Client:GarageTuneVehicle: missing vehicle data")
        cb({ok = false, error = "Missing vehicle data"})
        return
    end
    
    ig.log.Trace("Garage", "Vehicle tune requested: " .. data.vehicleId)
    
    -- Trigger tuning interface
    TriggerEvent("Client:Garage:TuneVehicle", data.vehicleId)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Garage callbacks registered")
