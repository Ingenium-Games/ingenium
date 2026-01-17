-- ====================================================================================--
-- APPEARANCE CAMERA NUI CALLBACKS
-- ====================================================================================--
-- Handles camera management for appearance customization
-- ====================================================================================--

-- Camera storage
local appearanceCameras = {
    face = nil,
    body = nil,
    legs = nil,
    full = nil,
    current = nil
}

local currentPed = nil
local baseCoords = nil
local baseHeading = nil
local originalCamActive = false

--- Creates all cameras around the ped for appearance customization
---@param ped number Entity ID of the ped
local function CreateAppearanceCameras(ped)
    if not DoesEntityExist(ped) then
        ig.log.Error("AppearanceCamera", "Cannot create cameras - ped does not exist")
        return false
    end
    
    -- Store ped reference
    currentPed = ped
    
    -- Get ped coordinates and heading
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    baseCoords = coords
    baseHeading = heading
    
    -- Camera distance from ped (1.0 unit as requested)
    local distance = 1.0
    local fov = 50.0
    
    -- Calculate camera positions in front of the ped based on heading
    local radians = math.rad(heading)
    local offsetX = math.sin(radians) * distance
    local offsetY = math.cos(radians) * distance
    
    -- Create cameras at different heights
    -- Face camera - eye level + slight up
    appearanceCameras.face = ig.camera.Basic(
        coords.x + offsetX,
        coords.y + offsetY,
        coords.z + 0.6,  -- Head height
        -10.0,  -- Slight downward angle
        0.0,
        heading - 180.0,  -- Face the ped
        fov,
        false,
        2
    )
    
    -- Body camera - chest level
    appearanceCameras.body = ig.camera.Basic(
        coords.x + offsetX,
        coords.y + offsetY,
        coords.z + 0.2,  -- Chest height
        0.0,  -- Level angle
        0.0,
        heading - 180.0,
        fov,
        false,
        2
    )
    
    -- Legs camera - lower body
    appearanceCameras.legs = ig.camera.Basic(
        coords.x + offsetX,
        coords.y + offsetY,
        coords.z - 0.5,  -- Lower body height
        10.0,  -- Slight upward angle
        0.0,
        heading - 180.0,
        fov,
        false,
        2
    )
    
    -- Full body camera - further back and higher for full view
    local fullDistance = 2.0
    local fullOffsetX = math.sin(radians) * fullDistance
    local fullOffsetY = math.cos(radians) * fullDistance
    
    appearanceCameras.full = ig.camera.Basic(
        coords.x + fullOffsetX,
        coords.y + fullOffsetY,
        coords.z + 0.5,  -- Mid-body height
        -5.0,  -- Slight downward angle
        0.0,
        heading - 180.0,
        fov * 1.2,  -- Wider FOV for full body
        false,
        2
    )
    
    ig.log.Info("AppearanceCamera", "Created cameras at base coords: %.2f, %.2f, %.2f (heading: %.2f)", 
        coords.x, coords.y, coords.z, heading)
    
    return true
end

--- Transitions to a specific camera view with smooth interpolation
---@param viewName string Camera view: "face", "body", "legs", "full"
local function TransitionToCamera(viewName)
    local targetCam = appearanceCameras[viewName]
    
    if not targetCam then
        ig.log.Error("AppearanceCamera", "Camera view '%s' does not exist", viewName)
        return
    end
    
    if appearanceCameras.current then
        -- Smooth transition from current to target camera
        SetCamActiveWithInterp(targetCam, appearanceCameras.current, 800, 1, 1)
        ig.log.Debug("AppearanceCamera", "Transitioning from current to %s camera", viewName)
    else
        -- First camera activation
        RenderScriptCams(true, false, 0, true, false)
        SetCamActive(targetCam, true)
        ig.log.Debug("AppearanceCamera", "Activated %s camera (first activation)", viewName)
    end
    
    appearanceCameras.current = targetCam
end

--- Rotates the ped on its Z-axis
---@param direction string "left", "right", or "reset"
local function RotatePed(direction)
    if not currentPed or not DoesEntityExist(currentPed) then
        ig.log.Error("AppearanceCamera", "Cannot rotate - ped does not exist")
        return
    end
    
    local currentHeading = GetEntityHeading(currentPed)
    local newHeading = currentHeading
    
    if direction == "left" then
        newHeading = currentHeading + 45.0  -- Rotate 45 degrees left
    elseif direction == "right" then
        newHeading = currentHeading - 45.0  -- Rotate 45 degrees right
    elseif direction == "reset" then
        newHeading = baseHeading  -- Reset to original heading
    end
    
    -- Normalize heading (0-360)
    if newHeading < 0 then
        newHeading = newHeading + 360
    elseif newHeading >= 360 then
        newHeading = newHeading - 360
    end
    
    SetEntityHeading(currentPed, newHeading)
    ig.log.Debug("AppearanceCamera", "Rotated ped %s - heading: %.2f -> %.2f", direction, currentHeading, newHeading)
end

--- Cleans up all appearance cameras
local function CleanupAppearanceCameras()
    if appearanceCameras.face then
        ig.camera.CleanUp(appearanceCameras.face)
        appearanceCameras.face = nil
    end
    if appearanceCameras.body then
        ig.camera.CleanUp(appearanceCameras.body)
        appearanceCameras.body = nil
    end
    if appearanceCameras.legs then
        ig.camera.CleanUp(appearanceCameras.legs)
        appearanceCameras.legs = nil
    end
    if appearanceCameras.full then
        ig.camera.CleanUp(appearanceCameras.full)
        appearanceCameras.full = nil
    end
    
    appearanceCameras.current = nil
    
    -- Restore game camera
    RenderScriptCams(false, false, 0, true, false)
    
    currentPed = nil
    baseCoords = nil
    baseHeading = nil
    
    ig.log.Info("AppearanceCamera", "Cleaned up all appearance cameras")
end

-- ====================================================================================--
-- NUI CALLBACKS
-- ====================================================================================--

--- Initialize cameras when appearance menu opens
RegisterNUICallback("Client:Appearance:InitializeCameras", function(data, cb)
    ig.log.Info("AppearanceCamera", "Initializing cameras for appearance customization")
    
    local playerPed = PlayerPedId()
    
    -- Cleanup any existing cameras first
    CleanupAppearanceCameras()
    
    -- Create new cameras
    local success = CreateAppearanceCameras(playerPed)
    
    if success then
        -- Start with face camera
        TransitionToCamera("full")
    end
    
    cb({ success = success })
end)

--- Set camera view (face, body, legs, full)
RegisterNUICallback("Client:Appearance:SetCameraView", function(data, cb)
    ig.log.Debug("AppearanceCamera", "Received data: %s (type: %s)", json.encode(data), type(data))
    
    local view = data.view or data
    
    ig.log.Debug("AppearanceCamera", "Setting camera view to: %s (type: %s)", view, type(view))
    
    TransitionToCamera(view)
    
    cb({ success = true })
end)

--- Rotate ped (left, right, reset)
RegisterNUICallback("Client:Appearance:RotatePed", function(data, cb)
    ig.log.Debug("AppearanceCamera", "Received rotation data: %s (type: %s)", json.encode(data), type(data))
    
    local direction = data.direction or data
    
    ig.log.Debug("AppearanceCamera", "Rotating ped: %s (type: %s)", direction, type(direction))
    
    RotatePed(direction)
    
    cb({ success = true })
end)

--- Cleanup cameras when appearance menu closes
RegisterNUICallback("Client:Appearance:CleanupCameras", function(data, cb)
    ig.log.Info("AppearanceCamera", "Cleaning up appearance cameras")
    
    CleanupAppearanceCameras()
    
    cb({ success = true })
end)

-- ====================================================================================--
-- AUTO CLEANUP ON RESOURCE STOP
-- ====================================================================================--

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        CleanupAppearanceCameras()
    end
end)

ig.log.Info("NUI-Client", "Appearance camera callbacks registered")
