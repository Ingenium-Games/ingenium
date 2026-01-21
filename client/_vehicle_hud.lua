-- ====================================================================================--
-- Vehicle HUD System - Speed and Fuel Display
-- ====================================================================================--

local isInVehicle = false
local isDriverSeat = false
local isFirstPerson = false
local lastSpeed = 0
local lastFuel = 0

-- Cache natives for performance
local GetEntitySpeed = GetEntitySpeed
local GetVehicleFuelLevel = GetVehicleFuelLevel
local GetVehicleMaxSpeed = GetVehicleMaxSpeed
local IsPedInAnyVehicle = IsPedInAnyVehicle
local GetVehiclePedIsIn = GetVehiclePedIsIn
local GetPedInVehicleSeat = GetPedInVehicleSeat
local GetFollowPedCamViewMode = GetFollowPedCamViewMode

--- Convert speed from m/s to MPH or KPH
---@param speed number Speed in m/s
---@param useMph boolean Use MPH instead of KPH
---@return number
local function ConvertSpeed(speed, useMph)
    if useMph then
        return math.floor(speed * 2.236936) -- m/s to MPH
    else
        return math.floor(speed * 3.6) -- m/s to KPH
    end
end

--- Check if player is in first-person mode
---@return boolean
local function IsFirstPersonMode()
    return GetFollowPedCamViewMode() == 4
end

--- Update vehicle HUD visibility and data
local function UpdateVehicleHUD()
    local ped = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(ped, false)
    
    if inVehicle then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local driver = GetPedInVehicleSeat(vehicle, -1)
        local isDriver = driver == ped
        local firstPerson = IsFirstPersonMode()
        
        -- Show HUD only if in driver seat and NOT in first person
        local shouldShow = isDriver and not firstPerson
        
        if shouldShow then
            -- Get vehicle speed
            local speed = GetEntitySpeed(vehicle)
            local displaySpeed = ConvertSpeed(speed, true) -- Using MPH, can be made configurable
            
            -- Get fuel level (0-100)
            local fuel = GetVehicleFuelLevel(vehicle)
            
            -- Only send update if values changed significantly
            if math.abs(displaySpeed - lastSpeed) > 0 or math.abs(fuel - lastFuel) > 0.5 then
                SendNUIMessage({
                    event = 'vehicleHudUpdate',
                    data = {
                        visible = true,
                        speed = displaySpeed,
                        fuel = math.floor(fuel),
                        unit = 'MPH'
                    }
                })
                
                lastSpeed = displaySpeed
                lastFuel = fuel
            end
        else
            -- Hide HUD if conditions not met
            if isInVehicle and (not isDriver or firstPerson) then
                SendNUIMessage({
                    event = 'vehicleHudUpdate',
                    data = {
                        visible = false
                    }
                })
                isInVehicle = false
            end
        end
        
        isInVehicle = true
        isDriverSeat = isDriver
        isFirstPerson = firstPerson
    else
        -- Player exited vehicle, hide HUD
        if isInVehicle then
            SendNUIMessage({
                event = 'vehicleHudUpdate',
                data = {
                    visible = false
                }
            })
            isInVehicle = false
            isDriverSeat = false
            lastSpeed = 0
            lastFuel = 0
        end
    end
end

-- Main vehicle HUD thread
CreateThread(function()
    while true do
        UpdateVehicleHUD()
        Wait(100) -- Update every 100ms for smooth updates
    end
end)

-- ====================================================================================--
