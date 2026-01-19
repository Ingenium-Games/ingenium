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
    feet = nil,
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
    local rightOffset = 1.0  -- Distance to the right side
    
    -- Calculate right offset (perpendicular to heading)
    local rightRadians = math.rad(heading - 90.0)  -- 90 degrees to the right
    local rightX = math.sin(rightRadians) * rightOffset
    local rightY = math.cos(rightRadians) * rightOffset
    
    -- Create cameras at different heights
    -- All cameras use the full camera distance (away from ped) with adjusted FOV and height
    -- Face camera - far back, tight FOV, head level
    local faceRadians = math.rad(heading + 135.0)
    local faceDistance = 2.0
    local faceOffsetX = math.sin(faceRadians) * faceDistance
    local faceOffsetY = math.cos(faceRadians) * faceDistance
    
    appearanceCameras.face = ig.camera.Basic(
        coords.x + faceOffsetX,
        coords.y + faceOffsetY,
        coords.z + 0.7,  -- Head level
        0.0,
        0.0,
        heading - 180.0,
        35.0,  -- Tighter FOV to zoom on face
        false,
        2
    )
    ig.camera.PointAtEntity(appearanceCameras.face, ped, 0.0, 0.0, 0.65, true)  -- Point at head
    
    -- Body camera - far back, moderate FOV, chest level
    local bodyRadians = math.rad(heading + 135.0)
    local bodyDistance = 2.0
    local bodyOffsetX = math.sin(bodyRadians) * bodyDistance
    local bodyOffsetY = math.cos(bodyRadians) * bodyDistance
    
    appearanceCameras.body = ig.camera.Basic(
        coords.x + bodyOffsetX,
        coords.y + bodyOffsetY,
        coords.z + 0.4,  -- Chest level
        0.0,
        0.0,
        heading - 180.0,
        45.0,  -- Moderate FOV for torso
        false,
        2
    )
    ig.camera.PointAtEntity(appearanceCameras.body, ped, 0.0, 0.0, 0.3, true)  -- Point at chest
    
    -- Legs camera - far back, moderate FOV, knee level
    local legsRadians = math.rad(heading + 135.0)
    local legsDistance = 2.0
    local legsOffsetX = math.sin(legsRadians) * legsDistance
    local legsOffsetY = math.cos(legsRadians) * legsDistance
    
    appearanceCameras.legs = ig.camera.Basic(
        coords.x + legsOffsetX,
        coords.y + legsOffsetY,
        coords.z - 0.2,  -- Knee level
        0.0,
        0.0,
        heading - 180.0,
        50.0,  -- Moderate FOV for legs
        false,
        2
    )
    ig.camera.PointAtEntity(appearanceCameras.legs, ped, 0.0, 0.0, -0.3, true)  -- Point at knees
    
    -- Feet camera - far back, tight FOV, foot level
    local feetRadians = math.rad(heading + 135.0)
    local feetDistance = 2.0
    local feetOffsetX = math.sin(feetRadians) * feetDistance
    local feetOffsetY = math.cos(feetRadians) * feetDistance
    
    appearanceCameras.feet = ig.camera.Basic(
        coords.x + feetOffsetX,
        coords.y + feetOffsetY,
        coords.z - 0.7,  -- Foot level (lowered by 0.2)
        0.0,
        0.0,
        heading - 180.0,
        40.0,  -- Tight FOV to zoom on feet
        false,
        2
    )
    ig.camera.PointAtEntity(appearanceCameras.feet, ped, 0.0, 0.0, -0.7, true)  -- Point at feet
    
    -- Full body camera - directly behind for centered full view
    local fullDistance = 2.5
    local fullRadians = math.rad(heading + 180.0)  -- Directly behind ped
    local fullOffsetX = math.sin(fullRadians) * fullDistance
    local fullOffsetY = math.cos(fullRadians) * fullDistance
    
    appearanceCameras.full = ig.camera.Basic(
        coords.x + fullOffsetX,
        coords.y + fullOffsetY,
        coords.z + 0.5,  -- Mid-body height
        0.0,  -- Level angle
        0.0,
        heading - 180.0,  -- Face the ped
        fov * 1.2,  -- Wider FOV for full body
        false,
        2
    )
    ig.camera.PointAtEntity(appearanceCameras.full, ped, 0.0, 0.0, 0.0, true)  -- Point at center of ped
    
    -- Set all cameras to inactive initially (best practice)
    SetCamActive(appearanceCameras.face, false)
    SetCamActive(appearanceCameras.body, false)
    SetCamActive(appearanceCameras.legs, false)
    SetCamActive(appearanceCameras.feet, false)
    SetCamActive(appearanceCameras.full, false)
    
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
    
    if appearanceCameras.current and appearanceCameras.current ~= targetCam then
        -- Smooth transition from current to target camera (800ms)
        SetCamActiveWithInterp(targetCam, appearanceCameras.current, 800, 1, 1)
        ig.log.Debug("AppearanceCamera", "Transitioning from current to %s camera", viewName)
        appearanceCameras.current = targetCam
    elseif not appearanceCameras.current then
        -- First camera activation (shouldn't happen since we initialize with full)
        SetCamActive(targetCam, true)
        appearanceCameras.current = targetCam
        ig.log.Debug("AppearanceCamera", "Activated %s camera (first activation)", viewName)
    else
        ig.log.Debug("AppearanceCamera", "Camera %s already active", viewName)
    end
end

--- Rotates the ped on its Z-axis
---@param direction string "left", "right", or "reset"
local function RotatePed(direction)
    -- Refresh current ped reference in case it changed during character selection
    local playerPed = PlayerPedId()
    
    if not DoesEntityExist(playerPed) then
        ig.log.Error("AppearanceCamera", "Cannot rotate - ped does not exist")
        return
    end
    
    -- Update stored reference
    currentPed = playerPed
    
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
    -- Deactivate all cameras before destroying
    if appearanceCameras.face then
        SetCamActive(appearanceCameras.face, false)
        ig.camera.CleanUp(appearanceCameras.face)
        appearanceCameras.face = nil
    end
    if appearanceCameras.body then
        SetCamActive(appearanceCameras.body, false)
        ig.camera.CleanUp(appearanceCameras.body)
        appearanceCameras.body = nil
    end
    if appearanceCameras.legs then
        SetCamActive(appearanceCameras.legs, false)
        ig.camera.CleanUp(appearanceCameras.legs)
        appearanceCameras.legs = nil
    end
    if appearanceCameras.feet then
        SetCamActive(appearanceCameras.feet, false)
        ig.camera.CleanUp(appearanceCameras.feet)
        appearanceCameras.feet = nil
    end
    if appearanceCameras.full then
        SetCamActive(appearanceCameras.full, false)
        ig.camera.CleanUp(appearanceCameras.full)
        appearanceCameras.full = nil
    end
    
    appearanceCameras.current = nil
    
    -- Stop rendering script cameras with smooth 1000ms transition
    RenderScriptCams(false, true, 1000, false, false)
    
    -- Clear streaming focus (reset to player ped)
    ClearFocus()
    
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
    
    -- Cleanup any existing cameras first
    CleanupAppearanceCameras()
    
    -- Wait for ped model to fully load after character selection or model change
    Citizen.Wait(250)
    
    local playerPed = PlayerPedId()
    
    -- Verify ped exists before creating cameras
    if not DoesEntityExist(playerPed) then
        ig.log.Error("AppearanceCamera", "Player ped does not exist yet, retrying...")
        Citizen.Wait(500)
        playerPed = PlayerPedId()
    end
    
    -- Create new cameras
    local success = CreateAppearanceCameras(playerPed)
    
    if success then
        -- Set streaming focus to the ped location for proper loading
        local coords = GetEntityCoords(playerPed)
        SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
        
        -- Activate only the full camera (others are already set to false in CreateAppearanceCameras)
        Citizen.Wait(100)
        SetCamActive(appearanceCameras.full, true)
        appearanceCameras.current = appearanceCameras.full
        
        -- Now render script cameras with smooth 1000ms transition
        RenderScriptCams(true, true, 1000, false, false)
        
        ig.log.Info("AppearanceCamera", "Initialized with full camera view")
    else
        ig.log.Error("AppearanceCamera", "Failed to create cameras")
    end
    
    cb({ success = success })
end)

--- Set camera view (face, body, legs, full)
RegisterNUICallback("Client:Appearance:SetCameraView", function(data, cb)
    ig.log.Debug("AppearanceCamera", "Received data: %s (type: %s)", json.encode(data), type(data))
    
    -- Extract view from various possible data structures
    local view = nil
    if type(data) == "table" then
        -- Check if it's an array with one element
        if data[1] then
            if type(data[1]) == "table" then
                view = data[1].view  -- [{view: "body"}]
            else
                view = data[1]  -- ["body"]
            end
        else
            view = data.view  -- {view: "body"}
        end
    elseif type(data) == "string" then
        view = data  -- "body"
    end
    
    ig.log.Debug("AppearanceCamera", "Extracted camera view: %s (type: %s)", view, type(view))
    
    if view then
        TransitionToCamera(view)
    else
        ig.log.Error("AppearanceCamera", "Failed to extract camera view from data")
    end
    
    cb({ success = true })
end)

--- Rotate ped (left, right, reset)
RegisterNUICallback("Client:Appearance:RotatePed", function(data, cb)
    ig.log.Debug("AppearanceCamera", "Received rotation data: %s (type: %s)", json.encode(data), type(data))
    
    -- Extract direction from various possible data structures
    local direction = nil
    if type(data) == "table" then
        -- Check if it's an array with one element
        if data[1] then
            if type(data[1]) == "table" then
                direction = data[1].direction  -- [{direction: "left"}]
            else
                direction = data[1]  -- ["left"]
            end
        else
            direction = data.direction  -- {direction: "left"}
        end
    elseif type(data) == "string" then
        direction = data  -- "left"
    end
    
    ig.log.Debug("AppearanceCamera", "Extracted rotation direction: %s (type: %s)", direction, type(direction))
    
    if direction then
        RotatePed(direction)
    else
        ig.log.Error("AppearanceCamera", "Failed to extract rotation direction from data")
    end
    
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
