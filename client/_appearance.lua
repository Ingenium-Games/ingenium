-- ====================================================================================--
-- Client-Side Appearance Module (ig.appearance initialized in client/_var.lua)
-- Handles all character appearance customization
-- ====================================================================================--

-- Local cache for appearance data
local currentAppearance = nil
local customizationActive = false

-- ====================================================================================--
-- INITIALIZATION
-- ====================================================================================--
-- Note: appearance_constants are loaded from JSON in client.lua and made read-only
-- No server callback needed - static reference data loaded client-side

---Get appearance constants (loaded from JSON in client.lua)
---@return table|nil Appearance constants or nil
function ig.appearance.GetConstants()
    -- Return the global appearance constants loaded from JSON in client.lua
    return ig.appearance_constants
end

-- ====================================================================================--
-- PED MODEL MANAGEMENT
-- ====================================================================================--

---Change ped model
---@param model string|number Ped model name or hash
---@param callback function|nil Optional callback when model is loaded
---@param freezePed boolean|nil Whether to freeze ped for customization (default: false for normal gameplay)
function ig.appearance.SetModel(model, callback, freezePed)
    local modelHash = type(model) == "string" and GetHashKey(model) or model
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(0)
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    SetPlayerModel(PlayerId(), modelHash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(modelHash)
    
    -- Get the new ped after model change
    ped = PlayerPedId()
    
    -- Restore position and heading (no axis, no offset, no collision, no ground placement)
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, heading)
    
    -- Only freeze/make invincible if explicitly requested (for customization UI)
    if freezePed then
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetPedCanRagdoll(ped, false)
    else
        -- Normal gameplay mode - ensure ped is mobile and visible
        SetEntityVisible(ped, true, false)
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        SetPedCanRagdoll(ped, true)
    end
    
    -- For animal models, set additional flags
    SetPedConfigFlag(ped, 32, false)  -- Can be stunned
    SetPedConfigFlag(ped, 281, true)  -- No writhe
    
    if callback then
        callback(ped)
    end
end

---Get current ped model
---@return string Ped model name
function ig.appearance.GetModel()
    local ped = PlayerPedId()
    local hash = GetEntityModel(ped)
    return GetHashKey(hash)
end

---Check if ped is freemode model
---@return boolean True if freemode model
function ig.appearance.IsFreemode()
    local ped = PlayerPedId()
    local hash = GetEntityModel(ped)
    return hash == GetHashKey('mp_m_freemode_01') or hash == GetHashKey('mp_f_freemode_01')
end

-- ====================================================================================--
-- HEAD BLEND (HERITAGE)
-- ====================================================================================--

---Set head blend data (parents/heritage)
---@param headBlend table Head blend data {shapeFirst, shapeSecond, skinFirst, skinSecond, shapeMix, skinMix, thirdMix}
function ig.appearance.SetHeadBlend(headBlend)
    if not ig.appearance.IsFreemode() then return end
    
    local ped = PlayerPedId()
    SetPedHeadBlendData(
        ped,
        headBlend.shapeFirst or 0,
        headBlend.shapeSecond or 0,
        0, -- third shape (unused)
        headBlend.skinFirst or 0,
        headBlend.skinSecond or 0,
        0, -- third skin (unused)
        headBlend.shapeMix or 0.5,
        headBlend.skinMix or 0.5,
        headBlend.thirdMix or 0.0,
        false
    )
end

---Get current head blend data
---@return table Head blend data
function ig.appearance.GetHeadBlend()
    if not ig.appearance.IsFreemode() then return nil end
    
    local ped = PlayerPedId()
    local success, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix = GetPedHeadBlendData(ped)
    
    if not success then
        return {
            shapeFirst = 0,
            shapeSecond = 0,
            skinFirst = 0,
            skinSecond = 0,
            shapeMix = 0.5,
            skinMix = 0.5,
            thirdMix = 0.0
        }
    end
    
    return {
        shapeFirst = shapeFirst or 0,
        shapeSecond = shapeSecond or 0,
        skinFirst = skinFirst or 0,
        skinSecond = skinSecond or 0,
        shapeMix = shapeMix or 0.5,
        skinMix = skinMix or 0.5,
        thirdMix = thirdMix or 0.0
    }
end

-- ====================================================================================--
-- FACE FEATURES
-- ====================================================================================--

---Set face feature
---@param index number Feature index (0-19)
---@param value number Feature value (-1.0 to 1.0)
function ig.appearance.SetFaceFeature(index, value)
    if not ig.appearance.IsFreemode() then return end
    
    local ped = PlayerPedId()
    SetPedFaceFeature(ped, index, value)
end

---Set all face features
---@param features table Table of features {[0]=value, [1]=value, ...}
function ig.appearance.SetFaceFeatures(features)
    if not ig.appearance.IsFreemode() then return end
    if type(features) ~= "table" then return end
    
    for i = 0, 19 do
        if features[tostring(i)] ~= nil then
            ig.appearance.SetFaceFeature(i, features[tostring(i)])
        elseif features[i] ~= nil then
            ig.appearance.SetFaceFeature(i, features[i])
        end
    end
end

---Get current face features
---@return table Face features
function ig.appearance.GetFaceFeatures()
    -- Note: Face features cannot be read from the game, must be tracked
    return currentAppearance and currentAppearance.faceFeatures or {}
end

-- ====================================================================================--
-- HEAD OVERLAYS (Makeup, Beards, etig.)
-- ====================================================================================--

---Set head overlay
---@param overlayId number Overlay ID (0-12)
---@param style number Style index
---@param opacity number Opacity (0.0-1.0)
---@param color number Color index
---@param secondColor number|nil Secondary color index (for certain overlays)
function ig.appearance.SetHeadOverlay(overlayId, style, opacity, color, secondColor)
    if not ig.appearance.IsFreemode() then return end
    
    local ped = PlayerPedId()
    SetPedHeadOverlay(ped, overlayId, style or 0, opacity or 1.0)
    
    -- Set overlay color if applicable
    if color then
        if overlayId == 1 or overlayId == 2 or overlayId == 10 then -- Facial hair, Eyebrows, Chest hair
            SetPedHeadOverlayColor(ped, overlayId, 1, color, secondColor or color)
        elseif overlayId == 4 or overlayId == 5 or overlayId == 8 then -- Makeup, Blush, Lipstick
            SetPedHeadOverlayColor(ped, overlayId, 2, color, secondColor or color)
        end
    end
end

---Set all head overlays
---@param overlays table Table of overlays {[0]={style, opacity, color}, ...}
function ig.appearance.SetHeadOverlays(overlays)
    if not ig.appearance.IsFreemode() then return end
    if type(overlays) ~= "table" then return end
    
    for i = 0, 12 do
        local overlay = overlays[tostring(i)] or overlays[i]
        if overlay then
            ig.appearance.SetHeadOverlay(
                i,
                overlay.style,
                overlay.opacity,
                overlay.color,
                overlay.secondColor
            )
        end
    end
end

-- ====================================================================================--
-- HAIR
-- ====================================================================================--

---Set hair style and color
---@param style number Hair style index
---@param color number Primary color
---@param highlight number Highlight color
function ig.appearance.SetHair(style, color, highlight)
    if not ig.appearance.IsFreemode() then return end
    
    local ped = PlayerPedId()
    SetPedComponentVariation(ped, 2, style or 0, 0, 0) -- Component 2 is hair
    SetPedHairColor(ped, color or 0, highlight or 0)
end

---Get current hair data
---@return table Hair data {style, color, highlight}
function ig.appearance.GetHair()
    local ped = PlayerPedId()
    return {
        style = GetPedDrawableVariation(ped, 2),
        color = GetPedHairColor(ped),
        highlight = GetPedHairHighlightColor(ped)
    }
end

-- ====================================================================================--
-- EYE COLOR
-- ====================================================================================--

---Set eye color
---@param color number Eye color index (0-31)
function ig.appearance.SetEyeColor(color)
    if not ig.appearance.IsFreemode() then return end
    
    local ped = PlayerPedId()
    SetPedEyeColor(ped, color or 0)
end

---Get current eye color
---@return number Eye color index
function ig.appearance.GetEyeColor()
    local ped = PlayerPedId()
    return GetPedEyeColor(ped)
end

-- ====================================================================================--
-- COMPONENTS (Clothing)
-- ====================================================================================--

---Set component variation
---@param componentId number Component ID (0-11)
---@param drawable number Drawable index
---@param texture number Texture index
---@param palette number Palette index (default 0)
function ig.appearance.SetComponent(componentId, drawable, texture, palette)
    local ped = PlayerPedId()
    SetPedComponentVariation(ped, componentId, drawable or 0, texture or 0, palette or 0)
end

---Set all components
---@param components table Array of components {{component_id, drawable, texture}, ...}
function ig.appearance.SetComponents(components)
    if type(components) ~= "table" then return end
    
    for _, comp in ipairs(components) do
        if comp.component_id or comp[1] then
            ig.appearance.SetComponent(
                comp.component_id or comp[1],
                comp.drawable or comp[2],
                comp.texture or comp[3],
                comp.palette or 0
            )
        end
    end
end

---Get current component variation
---@param componentId number Component ID
---@return table Component data {drawable, texture, palette}
function ig.appearance.GetComponent(componentId)
    local ped = PlayerPedId()
    return {
        drawable = GetPedDrawableVariation(ped, componentId),
        texture = GetPedTextureVariation(ped, componentId),
        palette = GetPedPaletteVariation(ped, componentId)
    }
end

---Get all components
---@return table Array of all components
function ig.appearance.GetComponents()
    local components = {}
    for i = 0, 11 do
        local comp = ig.appearance.GetComponent(i)
        table.insert(components, {
            component_id = i,
            drawable = comp.drawable,
            texture = comp.texture,
            palette = comp.palette
        })
    end
    return components
end

-- ====================================================================================--
-- PROPS (Accessories)
-- ====================================================================================--

---Set prop variation
---@param propId number Prop ID (0, 1, 2, 6, 7)
---@param drawable number Drawable index (-1 to remove)
---@param texture number Texture index
function ig.appearance.SetProp(propId, drawable, texture)
    local ped = PlayerPedId()
    if drawable == -1 then
        ClearPedProp(ped, propId)
    else
        SetPedPropIndex(ped, propId, drawable or 0, texture or 0, true)
    end
end

---Set all props
---@param props table Array of props {{prop_id, drawable, texture}, ...}
function ig.appearance.SetProps(props)
    if type(props) ~= "table" then return end
    
    for _, prop in ipairs(props) do
        if prop.prop_id or prop[1] then
            ig.appearance.SetProp(
                prop.prop_id or prop[1],
                prop.drawable or prop[2],
                prop.texture or prop[3]
            )
        end
    end
end

---Get current prop variation
---@param propId number Prop ID
---@return table Prop data {drawable, texture}
function ig.appearance.GetProp(propId)
    local ped = PlayerPedId()
    return {
        drawable = GetPedPropIndex(ped, propId),
        texture = GetPedPropTextureIndex(ped, propId)
    }
end

---Get all props
---@return table Array of all props
function ig.appearance.GetProps()
    local props = {}
    local propIds = {0, 1, 2, 6, 7} -- Valid prop IDs
    for _, propId in ipairs(propIds) do
        local prop = ig.appearance.GetProp(propId)
        table.insert(props, {
            prop_id = propId,
            drawable = prop.drawable,
            texture = prop.texture
        })
    end
    return props
end

-- ====================================================================================--
-- TATTOOS
-- ====================================================================================--

---Apply tattoo
---@param collection string Collection hash
---@param hash string Tattoo hash
function ig.appearance.ApplyTattoo(collection, hash)
    local ped = PlayerPedId()
    AddPedDecorationFromHashes(ped, GetHashKey(collection), GetHashKey(hash))
end

---Remove all tattoos
function ig.appearance.ClearTattoos()
    local ped = PlayerPedId()
    ClearPedDecorations(ped)
end

---Apply multiple tattoos
---@param tattoos table Array of tattoos {{collection, hash}, ...}
function ig.appearance.ApplyTattoos(tattoos)
    if type(tattoos) ~= "table" then return end
    
    ig.appearance.ClearTattoos()
    for _, tattoo in ipairs(tattoos) do
        if tattoo.collection and tattoo.hash then
            ig.appearance.ApplyTattoo(tattoo.collection, tattoo.hash)
        elseif tattoo[1] and tattoo[2] then
            ig.appearance.ApplyTattoo(tattoo[1], tattoo[2])
        end
    end
end

-- ====================================================================================--
-- COMPLETE APPEARANCE MANAGEMENT
-- ====================================================================================--

---Set complete appearance
---@param appearance table Complete appearance data
function ig.appearance.SetAppearance(appearance)
    if type(appearance) ~= "table" then return end
    
    -- Store current appearance
    currentAppearance = appearance
    
    -- Apply model if changed
    if appearance.model then
        local currentModel = GetEntityModel(PlayerPedId())
        local newModel = GetHashKey(appearance.model)
        if currentModel ~= newModel then
            ig.appearance.SetModel(appearance.model, function()
                -- Apply rest of appearance after model change
                ig.appearance.ApplyAppearanceData(appearance)
            end)
            return
        end
    end
    
    -- Apply appearance data
    ig.appearance.ApplyAppearanceData(appearance)
end

---Apply appearance data (internal use)
---@param appearance table Appearance data
function ig.appearance.ApplyAppearanceData(appearance)
    -- Head blend (heritage)
    if appearance.headBlend then
        ig.appearance.SetHeadBlend(appearance.headBlend)
    end
    
    -- Face features (skip if empty array)
    if appearance.faceFeatures and type(appearance.faceFeatures) == "table" and next(appearance.faceFeatures) then
        ig.appearance.SetFaceFeatures(appearance.faceFeatures)
    end
    
    -- Head overlays (skip if empty array)
    if appearance.headOverlays and type(appearance.headOverlays) == "table" and next(appearance.headOverlays) then
        ig.appearance.SetHeadOverlays(appearance.headOverlays)
    end
    
    -- Hair
    if appearance.hair then
        ig.appearance.SetHair(
            appearance.hair.style or 0,
            appearance.hair.color or 0,
            appearance.hair.highlight or 0
        )
    end
    
    -- Eye color
    if appearance.eyeColor ~= nil then
        ig.appearance.SetEyeColor(appearance.eyeColor)
    end
    
    -- Components (clothing) - skip if empty array
    if appearance.components and type(appearance.components) == "table" and next(appearance.components) then
        ig.appearance.SetComponents(appearance.components)
    end
    
    -- Props (accessories) - skip if empty array
    if appearance.props and type(appearance.props) == "table" and next(appearance.props) then
        ig.appearance.SetProps(appearance.props)
    end
    
    -- Tattoos
    if appearance.tattoos and type(appearance.tattoos) == "table" and next(appearance.tattoos) then
        ig.appearance.ApplyTattoos(appearance.tattoos)
    end
end

---Get complete current appearance
---@return table Complete appearance data
function ig.appearance.GetAppearance()
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    
    local appearance = {
        model = GetHashKey(model),
        components = ig.appearance.GetComponents(),
        props = ig.appearance.GetProps(),
        hair = ig.appearance.GetHair(),
        eyeColor = ig.appearance.GetEyeColor()
    }
    
    -- Only include freemode-specific data if applicable
    if ig.appearance.IsFreemode() then
        appearance.headBlend = ig.appearance.GetHeadBlend()
        appearance.faceFeatures = currentAppearance and currentAppearance.faceFeatures or {}
        appearance.headOverlays = currentAppearance and currentAppearance.headOverlays or {}
    end
    
    -- Include tattoos if any were applied
    if currentAppearance and currentAppearance.tattoos then
        appearance.tattoos = currentAppearance.tattoos
    end
    
    return appearance
end

-- ====================================================================================--
-- CAMERA MANAGEMENT
-- ====================================================================================--

local customizationCamera = nil
local customizationCameraMode = "face"
local cameraRotation = 0.0

---Camera positions and FOV for different views
local CameraViews = {
    face = { offset = vector3(0.0, 0.65, 0.65), fov = 40.0, pointAt = vector3(0.0, 0.0, 0.65) },
    body = { offset = vector3(0.0, 2.0, 0.2), fov = 50.0, pointAt = vector3(0.0, 0.0, 0.0) },
    legs = { offset = vector3(0.0, 2.0, -0.8), fov = 50.0, pointAt = vector3(0.0, 0.0, -0.8) },
    full = { offset = vector3(0.0, 3.0, 0.0), fov = 60.0, pointAt = vector3(0.0, 0.0, 0.0) }
}

---Create customization camera
function ig.appearance.CreateCamera()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    -- Destroy existing camera if any
    ig.appearance.DestroyCamera()
    
    -- Create new camera
    customizationCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    -- Set initial view to face
    ig.appearance.SetCameraView("face")
    
    -- Render camera
    RenderScriptCams(true, true, 1000, true, true)
end

---Destroy customization camera
function ig.appearance.DestroyCamera()
    if customizationCamera then
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(customizationCamera, false)
        customizationCamera = nil
        cameraRotation = 0.0
    end
end

---Set camera view mode
---@param mode string Camera mode: "face", "body", "legs", "full"
function ig.appearance.SetCameraView(mode)
    if not customizationCamera then return end
    if not CameraViews[mode] then return end
    
    customizationCameraMode = mode
    local view = CameraViews[mode]
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    -- Rotate the offset vector based on heading + cameraRotation
    -- The offset.y is the primary distance from the ped (forward/backward)
    -- The offset.x is the side offset (left/right)
    -- The offset.z is the height offset
    local totalHeading = heading + cameraRotation
    local rad = math.rad(totalHeading)
    
    -- Calculate rotated X and Y offset based on heading
    local rotatedOffsetX = (view.offset.x * math.cos(rad)) - (view.offset.y * math.sin(rad))
    local rotatedOffsetY = (view.offset.x * math.sin(rad)) + (view.offset.y * math.cos(rad))
    
    -- Position camera at rotated offset + Z height
    local camPos = vector3(
        coords.x + rotatedOffsetX,
        coords.y + rotatedOffsetY,
        coords.z + view.offset.z
    )
    
    -- Set camera position and point at
    SetCamCoord(customizationCamera, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(customizationCamera, coords.x + view.pointAt.x, coords.y + view.pointAt.y, coords.z + view.pointAt.z)
    SetCamFov(customizationCamera, view.fov)
end

---Rotate camera around ped
---@param degrees number Degrees to rotate (positive = right, negative = left)
function ig.appearance.RotateCamera(degrees)
    if not customizationCamera then return end
    
    cameraRotation = cameraRotation + degrees
    if cameraRotation >= 360 then cameraRotation = cameraRotation - 360 end
    if cameraRotation < 0 then cameraRotation = cameraRotation + 360 end
    
    -- Update camera position
    ig.appearance.SetCameraView(customizationCameraMode)
end

---Make ped turn around (full 360 rotation)
---@param duration number Duration in milliseconds (default 2000)
function ig.appearance.TurnAround(duration)
    local ped = PlayerPedId()
    local startHeading = GetEntityHeading(ped)
    local targetHeading = startHeading + 360.0
    local elapsed = 0
    local step = duration or 2000
    
    Citizen.CreateThread(function()
        while elapsed < step do
            local progress = elapsed / step
            local currentHeading = startHeading + (360.0 * progress)
            SetEntityHeading(ped, currentHeading % 360.0)
            
            Citizen.Wait(10)
            elapsed = elapsed + 10
        end
        SetEntityHeading(ped, startHeading)
    end)
end

---Get current camera mode
---@return string Current camera mode
function ig.appearance.GetCameraMode()
    return customizationCameraMode
end

-- ====================================================================================--
-- CUSTOMIZATION STATE
-- ====================================================================================--

---Set customization active state
---@param active boolean True if customization is active
function ig.appearance.SetCustomizationActive(active)
    customizationActive = active
    
    if active then
        -- Freeze player
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)
        
        -- Create camera
        ig.appearance.CreateCamera()
    else
        -- Unfreeze player
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        
        -- Destroy camera
        ig.appearance.DestroyCamera()
    end
end

---Check if customization is active
---@return boolean True if customization is active
function ig.appearance.IsCustomizationActive()
    return customizationActive
end

-- Note: appearance constants are loaded from JSON in client.lua at startup
-- No initialization callback needed - static reference data loaded client-side

ig.log.Info("CLIENT", "Appearance module loaded")
