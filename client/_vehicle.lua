-- ====================================================================================--
-- Vehicle client helper functions (ig.vehicle initialized in client/_var.lua)
-- ====================================================================================--

--- Get current vehicle player is in
---@return number vehicle entity
function ig.vehicle.GetCurrentVehicle()
    return ig.vehicles.currentVehicle
end

--- Get current seat player is in
---@return number seat index (-1 = driver)
function ig.vehicle.GetCurrentSeat()
    return ig.vehicles.currentSeat
end

--- Check if player is in a vehicle
---@return boolean
function ig.vehicle.IsInVehicle()
    return currentVehicle ~= 0
end

-- ====================================================================================--
-- Event Handlers
-- ====================================================================================--

--- Mark persistent vehicle as mission entity to prevent despawning
RegisterNetEvent("Client:Vehicle:SetMissionEntity")
AddEventHandler("Client:Vehicle:SetMissionEntity", function(netId)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if vehicle and DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        ig.log.Debug("Vehicle", "Marked vehicle " .. netId .. " as mission entity")
    end
end)

--- Capture vehicle condition and modifications for persistence
RegisterNetEvent("Client:Vehicle:CaptureCondition")
AddEventHandler("Client:Vehicle:CaptureCondition", function(plate, vehicleEntity)
    local vehicle = vehicleEntity
    
    -- If network ID was passed instead of entity, convert it
    if type(vehicleEntity) == "number" and vehicleEntity < 65536 then
        vehicle = NetworkGetEntityFromNetworkId(vehicleEntity)
    end
    
    if not vehicle or not DoesEntityExist(vehicle) then
        ig.log.Warn("Vehicle", "Cannot capture condition: vehicle doesn't exist")
        return
    end
    
    -- Capture colors
    local primaryColor, secondaryColor = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local customPrimaryColor = {GetVehicleCustomPrimaryColour(vehicle)}
    local customSecondaryColor = {GetVehicleCustomSecondaryColour(vehicle)}
    
    -- Capture modifications
    local mods = {}
    for i = 0, 49 do
        local modValue = GetVehicleMod(vehicle, i)
        if modValue ~= -1 then
            mods[i] = modValue
        end
    end
    
    -- Capture other properties
    local condition = {
        bodyHealth = GetVehicleBodyHealth(vehicle),
        engineHealth = GetVehicleEngineHealth(vehicle),
        tankHealth = GetVehiclePetrolTankHealth(vehicle),
        dirtLevel = GetVehicleDirtLevel(vehicle),
        windows = {},
        doors = {},
        tyres = {}
    }
    
    -- Capture window states
    for i = 0, 7 do
        condition.windows[i] = IsVehicleWindowIntact(vehicle, i)
    end
    
    -- Capture door states
    for i = 0, 5 do
        condition.doors[i] = IsVehicleDoorDamaged(vehicle, i)
    end
    
    -- Capture tyre states
    for i = 0, 7 do
        condition.tyres[i] = IsVehicleTyreBurst(vehicle, i, false)
    end
    
    local modifications = {
        primaryColor = primaryColor,
        secondaryColor = secondaryColor,
        pearlescentColor = pearlescentColor,
        wheelColor = wheelColor,
        customPrimaryColor = customPrimaryColor[1] and customPrimaryColor or nil,
        customSecondaryColor = customSecondaryColor[1] and customSecondaryColor or nil,
        mods = mods,
        windowTint = GetVehicleWindowTint(vehicle),
        neonEnabled = {
            IsVehicleNeonLightEnabled(vehicle, 0),
            IsVehicleNeonLightEnabled(vehicle, 1),
            IsVehicleNeonLightEnabled(vehicle, 2),
            IsVehicleNeonLightEnabled(vehicle, 3)
        },
        neonColor = {GetVehicleNeonLightsColour(vehicle)},
        extras = {}
    }
    
    -- Capture extras
    for i = 1, 14 do
        if DoesExtraExist(vehicle, i) then
            modifications.extras[i] = IsVehicleExtraTurnedOn(vehicle, i)
        end
    end
    
    -- Send back to server
    TriggerServerEvent("Server:Vehicle:StoreCondition", plate, condition, modifications)
end)

--- Apply vehicle modifications (colors, mods, extras) from persistence data
RegisterNetEvent("Client:Vehicle:ApplyModifications")
AddEventHandler("Client:Vehicle:ApplyModifications", function(netId, modifications)
    local vehicle = NetworkGetNetworkIdFromEntity(netId)
    
    if not vehicle or not DoesEntityExist(vehicle) or not modifications then
        return
    end
    
    -- Apply colors
    if modifications.customPrimaryColor and modifications.customPrimaryColor[1] then
        SetVehicleCustomPrimaryColour(vehicle, table.unpack(modifications.customPrimaryColor))
    elseif modifications.primaryColor then
        SetVehicleColours(vehicle, modifications.primaryColor, modifications.secondaryColor or 0)
    end
    
    if modifications.customSecondaryColor and modifications.customSecondaryColor[1] then
        SetVehicleCustomSecondaryColour(vehicle, table.unpack(modifications.customSecondaryColor))
    end
    
    if modifications.pearlescentColor or modifications.wheelColor then
        SetVehicleExtraColours(vehicle, modifications.pearlescentColor or 0, modifications.wheelColor or 0)
    end
    
    -- Apply mods
    if modifications.mods then
        for modIndex, modValue in pairs(modifications.mods) do
            SetVehicleMod(vehicle, tonumber(modIndex), modValue, false)
        end
    end
    
    -- Apply window tint
    if modifications.windowTint then
        SetVehicleWindowTint(vehicle, modifications.windowTint)
    end
    
    -- Apply neon
    if modifications.neonEnabled then
        for i = 0, 3 do
            SetVehicleNeonLightEnabled(vehicle, i, modifications.neonEnabled[i + 1] or false)
        end
    end
    
    if modifications.neonColor and modifications.neonColor[1] then
        SetVehicleNeonLightsColour(vehicle, table.unpack(modifications.neonColor))
    end
    
    -- Apply extras
    if modifications.extras then
        for extraId, enabled in pairs(modifications.extras) do
            if DoesExtraExist(vehicle, tonumber(extraId)) then
                SetVehicleExtra(vehicle, tonumber(extraId), not enabled)
            end
        end
    end
end)

--- Apply vehicle condition (damage, dirt, etc) from persistence data
RegisterNetEvent("Client:Vehicle:ApplyCondition")
AddEventHandler("Client:Vehicle:ApplyCondition", function(netId, condition)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    
    if not vehicle or not DoesEntityExist(vehicle) or not condition then
        return
    end
    
    -- Apply health values
    if condition.bodyHealth then
        SetVehicleBodyHealth(vehicle, condition.bodyHealth + 0.0)
    end
    
    if condition.engineHealth then
        SetVehicleEngineHealth(vehicle, condition.engineHealth + 0.0)
    end
    
    if condition.tankHealth then
        SetVehiclePetrolTankHealth(vehicle, condition.tankHealth + 0.0)
    end
    
    -- Apply dirt level
    if condition.dirtLevel then
        SetVehicleDirtLevel(vehicle, condition.dirtLevel + 0.0)
    end
    
    -- Apply window damage
    if condition.windows then
        for windowIndex, isIntact in pairs(condition.windows) do
            if not isIntact then
                SmashVehicleWindow(vehicle, tonumber(windowIndex))
            end
        end
    end
    
    -- Apply door damage
    if condition.doors then
        for doorIndex, isDamaged in pairs(condition.doors) do
            if isDamaged then
                SetVehicleDoorBroken(vehicle, tonumber(doorIndex), true)
            end
        end
    end
    
    -- Apply tyre damage
    if condition.tyres then
        for tyreIndex, isBurst in pairs(condition.tyres) do
            if isBurst then
                SetVehicleTyreBurst(vehicle, tonumber(tyreIndex), true, 1000.0)
            end
        end
    end
end)