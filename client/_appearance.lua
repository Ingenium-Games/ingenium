-- ====================================================================================--
-- Client-Side Appearance Module
-- Handles all character appearance customization
-- ====================================================================================--

c.appearance = c.appearance or {}

-- Local cache for appearance data
local currentAppearance = nil
local appearanceConstants = nil
local customizationActive = false

-- ====================================================================================--
-- INITIALIZATION
-- ====================================================================================--

---Initialize appearance system
---Loads appearance constants from server
function c.appearance.Initialize()
    if not appearanceConstants then
        appearanceConstants = c.callback.Await('ig:GameData:GetAppearanceConstants')
        if appearanceConstants then
            print('^2[Appearance] Constants loaded successfully^0')
        else
            print('^1[Appearance] Failed to load constants^0')
        end
    end
end

---Get appearance constants
---@return table|nil Appearance constants or nil
function c.appearance.GetConstants()
    if not appearanceConstants then
        c.appearance.Initialize()
    end
    return appearanceConstants
end

-- ====================================================================================--
-- PED MODEL MANAGEMENT
-- ====================================================================================--

---Change ped model
---@param model string|number Ped model name or hash
---@param callback function|nil Optional callback when model is loaded
function c.appearance.SetModel(model, callback)
    local modelHash = type(model) == "string" and GetHashKey(model) or model
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(0)
    end
    
    local ped = PlayerPedId()
    SetPlayerModel(PlayerId(), modelHash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(modelHash)
    
    if callback then
        callback(PlayerPedId())
    end
end

---Get current ped model
---@return string Ped model name
function c.appearance.GetModel()
    local ped = PlayerPedId()
    local hash = GetEntityModel(ped)
    return GetHashKey(hash)
end

---Check if ped is freemode model
---@return boolean True if freemode model
function c.appearance.IsFreemode()
    local ped = PlayerPedId()
    local hash = GetEntityModel(ped)
    return hash == GetHashKey('mp_m_freemode_01') or hash == GetHashKey('mp_f_freemode_01')
end

-- ====================================================================================--
-- HEAD BLEND (HERITAGE)
-- ====================================================================================--

---Set head blend data (parents/heritage)
---@param headBlend table Head blend data {shapeFirst, shapeSecond, skinFirst, skinSecond, shapeMix, skinMix, thirdMix}
function c.appearance.SetHeadBlend(headBlend)
    if not c.appearance.IsFreemode() then return end
    
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
function c.appearance.GetHeadBlend()
    if not c.appearance.IsFreemode() then return nil end
    
    local ped = PlayerPedId()
    local shapeFirst = GetPedHeadBlendFirstIndex(ped)
    local shapeSecond = GetPedHeadBlendSecondIndex(ped)
    local skinFirst = GetPedHeadBlendThirdIndex(ped)
    
    return {
        shapeFirst = shapeFirst,
        shapeSecond = shapeSecond,
        skinFirst = skinFirst,
        skinSecond = skinFirst, -- Note: Game doesn't distinguish skin indices
        shapeMix = 0.5, -- These can't be read from the game
        skinMix = 0.5,
        thirdMix = 0.0
    }
end

-- ====================================================================================--
-- FACE FEATURES
-- ====================================================================================--

---Set face feature
---@param index number Feature index (0-19)
---@param value number Feature value (-1.0 to 1.0)
function c.appearance.SetFaceFeature(index, value)
    if not c.appearance.IsFreemode() then return end
    
    local ped = PlayerPedId()
    SetPedFaceFeature(ped, index, value)
end

---Set all face features
---@param features table Table of features {[0]=value, [1]=value, ...}
function c.appearance.SetFaceFeatures(features)
    if not c.appearance.IsFreemode() then return end
    if type(features) ~= "table" then return end
    
    for i = 0, 19 do
        if features[tostring(i)] ~= nil then
            c.appearance.SetFaceFeature(i, features[tostring(i)])
        elseif features[i] ~= nil then
            c.appearance.SetFaceFeature(i, features[i])
        end
    end
end

---Get current face features
---@return table Face features
function c.appearance.GetFaceFeatures()
    -- Note: Face features cannot be read from the game, must be tracked
    return currentAppearance and currentAppearance.faceFeatures or {}
end

-- ====================================================================================--
-- HEAD OVERLAYS (Makeup, Beards, etc.)
-- ====================================================================================--

---Set head overlay
---@param overlayId number Overlay ID (0-12)
---@param style number Style index
---@param opacity number Opacity (0.0-1.0)
---@param color number Color index
---@param secondColor number|nil Secondary color index (for certain overlays)
function c.appearance.SetHeadOverlay(overlayId, style, opacity, color, secondColor)
    if not c.appearance.IsFreemode() then return end
    
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
function c.appearance.SetHeadOverlays(overlays)
    if not c.appearance.IsFreemode() then return end
    if type(overlays) ~= "table" then return end
    
    for i = 0, 12 do
        local overlay = overlays[tostring(i)] or overlays[i]
        if overlay then
            c.appearance.SetHeadOverlay(
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
function c.appearance.SetHair(style, color, highlight)
    if not c.appearance.IsFreemode() then return end
    
    local ped = PlayerPedId()
    SetPedComponentVariation(ped, 2, style or 0, 0, 0) -- Component 2 is hair
    SetPedHairColor(ped, color or 0, highlight or 0)
end

---Get current hair data
---@return table Hair data {style, color, highlight}
function c.appearance.GetHair()
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
function c.appearance.SetEyeColor(color)
    if not c.appearance.IsFreemode() then return end
    
    local ped = PlayerPedId()
    SetPedEyeColor(ped, color or 0)
end

---Get current eye color
---@return number Eye color index
function c.appearance.GetEyeColor()
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
function c.appearance.SetComponent(componentId, drawable, texture, palette)
    local ped = PlayerPedId()
    SetPedComponentVariation(ped, componentId, drawable or 0, texture or 0, palette or 0)
end

---Set all components
---@param components table Array of components {{component_id, drawable, texture}, ...}
function c.appearance.SetComponents(components)
    if type(components) ~= "table" then return end
    
    for _, comp in ipairs(components) do
        if comp.component_id or comp[1] then
            c.appearance.SetComponent(
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
function c.appearance.GetComponent(componentId)
    local ped = PlayerPedId()
    return {
        drawable = GetPedDrawableVariation(ped, componentId),
        texture = GetPedTextureVariation(ped, componentId),
        palette = GetPedPaletteVariation(ped, componentId)
    }
end

---Get all components
---@return table Array of all components
function c.appearance.GetComponents()
    local components = {}
    for i = 0, 11 do
        local comp = c.appearance.GetComponent(i)
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
function c.appearance.SetProp(propId, drawable, texture)
    local ped = PlayerPedId()
    if drawable == -1 then
        ClearPedProp(ped, propId)
    else
        SetPedPropIndex(ped, propId, drawable or 0, texture or 0, true)
    end
end

---Set all props
---@param props table Array of props {{prop_id, drawable, texture}, ...}
function c.appearance.SetProps(props)
    if type(props) ~= "table" then return end
    
    for _, prop in ipairs(props) do
        if prop.prop_id or prop[1] then
            c.appearance.SetProp(
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
function c.appearance.GetProp(propId)
    local ped = PlayerPedId()
    return {
        drawable = GetPedPropIndex(ped, propId),
        texture = GetPedPropTextureIndex(ped, propId)
    }
end

---Get all props
---@return table Array of all props
function c.appearance.GetProps()
    local props = {}
    local propIds = {0, 1, 2, 6, 7} -- Valid prop IDs
    for _, propId in ipairs(propIds) do
        local prop = c.appearance.GetProp(propId)
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
function c.appearance.ApplyTattoo(collection, hash)
    local ped = PlayerPedId()
    AddPedDecorationFromHashes(ped, GetHashKey(collection), GetHashKey(hash))
end

---Remove all tattoos
function c.appearance.ClearTattoos()
    local ped = PlayerPedId()
    ClearPedDecorations(ped)
end

---Apply multiple tattoos
---@param tattoos table Array of tattoos {{collection, hash}, ...}
function c.appearance.ApplyTattoos(tattoos)
    if type(tattoos) ~= "table" then return end
    
    c.appearance.ClearTattoos()
    for _, tattoo in ipairs(tattoos) do
        if tattoo.collection and tattoo.hash then
            c.appearance.ApplyTattoo(tattoo.collection, tattoo.hash)
        elseif tattoo[1] and tattoo[2] then
            c.appearance.ApplyTattoo(tattoo[1], tattoo[2])
        end
    end
end

-- ====================================================================================--
-- COMPLETE APPEARANCE MANAGEMENT
-- ====================================================================================--

---Set complete appearance
---@param appearance table Complete appearance data
function c.appearance.SetAppearance(appearance)
    if type(appearance) ~= "table" then return end
    
    -- Store current appearance
    currentAppearance = appearance
    
    -- Apply model if changed
    if appearance.model then
        local currentModel = GetEntityModel(PlayerPedId())
        local newModel = GetHashKey(appearance.model)
        if currentModel ~= newModel then
            c.appearance.SetModel(appearance.model, function()
                -- Apply rest of appearance after model change
                c.appearance.ApplyAppearanceData(appearance)
            end)
            return
        end
    end
    
    -- Apply appearance data
    c.appearance.ApplyAppearanceData(appearance)
end

---Apply appearance data (internal use)
---@param appearance table Appearance data
function c.appearance.ApplyAppearanceData(appearance)
    -- Head blend (heritage)
    if appearance.headBlend then
        c.appearance.SetHeadBlend(appearance.headBlend)
    end
    
    -- Face features
    if appearance.faceFeatures then
        c.appearance.SetFaceFeatures(appearance.faceFeatures)
    end
    
    -- Head overlays
    if appearance.headOverlays then
        c.appearance.SetHeadOverlays(appearance.headOverlays)
    end
    
    -- Hair
    if appearance.hair then
        c.appearance.SetHair(
            appearance.hair.style,
            appearance.hair.color,
            appearance.hair.highlight
        )
    end
    
    -- Eye color
    if appearance.eyeColor ~= nil then
        c.appearance.SetEyeColor(appearance.eyeColor)
    end
    
    -- Components (clothing)
    if appearance.components then
        c.appearance.SetComponents(appearance.components)
    end
    
    -- Props (accessories)
    if appearance.props then
        c.appearance.SetProps(appearance.props)
    end
    
    -- Tattoos
    if appearance.tattoos then
        c.appearance.ApplyTattoos(appearance.tattoos)
    end
end

---Get complete current appearance
---@return table Complete appearance data
function c.appearance.GetAppearance()
    local ped = PlayerPedId()
    local model = GetEntityModel(ped)
    
    local appearance = {
        model = GetHashKey(model),
        components = c.appearance.GetComponents(),
        props = c.appearance.GetProps(),
        hair = c.appearance.GetHair(),
        eyeColor = c.appearance.GetEyeColor()
    }
    
    -- Only include freemode-specific data if applicable
    if c.appearance.IsFreemode() then
        appearance.headBlend = c.appearance.GetHeadBlend()
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
function c.appearance.CreateCamera()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    -- Destroy existing camera if any
    c.appearance.DestroyCamera()
    
    -- Create new camera
    customizationCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    -- Set initial view to face
    c.appearance.SetCameraView("face")
    
    -- Render camera
    RenderScriptCams(true, true, 1000, true, true)
end

---Destroy customization camera
function c.appearance.DestroyCamera()
    if customizationCamera then
        RenderScriptCams(false, true, 1000, true, true)
        DestroyCam(customizationCamera, false)
        customizationCamera = nil
        cameraRotation = 0.0
    end
end

---Set camera view mode
---@param mode string Camera mode: "face", "body", "legs", "full"
function c.appearance.SetCameraView(mode)
    if not customizationCamera then return end
    if not CameraViews[mode] then return end
    
    customizationCameraMode = mode
    local view = CameraViews[mode]
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    -- Calculate camera position with rotation
    local rad = math.rad(heading + cameraRotation)
    local camPos = vector3(
        coords.x + (view.offset.y * math.sin(rad)),
        coords.y + (view.offset.y * math.cos(rad)),
        coords.z + view.offset.z
    )
    
    -- Set camera position and point at
    SetCamCoord(customizationCamera, camPos.x, camPos.y, camPos.z)
    PointCamAtCoord(customizationCamera, coords.x + view.pointAt.x, coords.y + view.pointAt.y, coords.z + view.pointAt.z)
    SetCamFov(customizationCamera, view.fov)
end

---Rotate camera around ped
---@param degrees number Degrees to rotate (positive = right, negative = left)
function c.appearance.RotateCamera(degrees)
    if not customizationCamera then return end
    
    cameraRotation = cameraRotation + degrees
    if cameraRotation >= 360 then cameraRotation = cameraRotation - 360 end
    if cameraRotation < 0 then cameraRotation = cameraRotation + 360 end
    
    -- Update camera position
    c.appearance.SetCameraView(customizationCameraMode)
end

---Make ped turn around (full 360 rotation)
---@param duration number Duration in milliseconds (default 2000)
function c.appearance.TurnAround(duration)
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
function c.appearance.GetCameraMode()
    return customizationCameraMode
end

-- ====================================================================================--
-- CUSTOMIZATION STATE
-- ====================================================================================--

---Set customization active state
---@param active boolean True if customization is active
function c.appearance.SetCustomizationActive(active)
    customizationActive = active
    
    if active then
        -- Freeze player
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, true)
        
        -- Create camera
        c.appearance.CreateCamera()
    else
        -- Unfreeze player
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        
        -- Destroy camera
        c.appearance.DestroyCamera()
    end
end

---Check if customization is active
---@return boolean True if customization is active
function c.appearance.IsCustomizationActive()
    return customizationActive
end

-- Initialize on resource start
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    c.appearance.Initialize()
end)

print('^2[Client] Appearance module loaded^0')
