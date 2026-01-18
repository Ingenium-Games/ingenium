-- ====================================================================================--
-- APPEARANCE LIVE UPDATE NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes real-time appearance update messages FROM NUI TO CLIENT.
--
-- These callbacks handle live preview updates during appearance customization.
-- They bridge NUI's fetch() calls to the existing ig.appearance client functions.
--
-- NUI sends these messages from nui/src/stores/appearance.js:
--   - Client:Appearance:SetCameraView     => Change camera view
--   - Client:Appearance:UpdateModel       => Change ped model
--   - Client:Appearance:UpdateHeadBlend   => Update heritage/parents
--   - Client:Appearance:UpdateFaceFeature => Update face feature
--   - Client:Appearance:UpdateHeadOverlay => Update overlay (makeup, beard, etc)
--   - Client:Appearance:UpdateHair        => Update hair style/color
--   - Client:Appearance:UpdateEyeColor    => Update eye color
--   - Client:Appearance:UpdateComponent   => Update clothing component
--   - Client:Appearance:UpdateProp        => Update accessory/prop
--   - Client:Appearance:ApplyTattoo       => Apply tattoo
--   - Client:Appearance:ClearTattoos      => Clear all tattoos
--   - Client:Appearance:RotateCamera      => Rotate camera
--   - Client:Appearance:TurnAround        => Character spin animation
--   - Client:Appearance:Save              => Save appearance
--   - Client:Appearance:Cancel            => Cancel appearance customization
--
-- ====================================================================================--

-- Update model
RegisterNUICallback('Client:Appearance:UpdateModel', function(data, cb)
    local model = data[1]
    if not model then
        cb({ok = false, error = "Missing model"})
        return
    end
    
    ig.log.Trace("Appearance", "Update model: %s", model)
    
    -- Cleanup old cameras before model change
    TriggerEvent('Client:Appearance:CleanupCameras', {})
    
    ig.appearance.SetModel(model, function(newPed)
        -- Wait a frame for model to fully initialize
        Citizen.Wait(100)
        
        -- Recreate cameras for new ped
        TriggerEvent('Client:Appearance:InitializeCameras', {})
        
        cb({ok = true})
    end)
end)

-- Update head blend (heritage/parents)
RegisterNUICallback('Client:Appearance:UpdateHeadBlend', function(data, cb)
    local headBlend = data[1]
    if not headBlend then
        cb({ok = false, error = "Missing headBlend data"})
        return
    end
    
    ig.log.Trace("Appearance", "Update head blend")
    ig.appearance.SetHeadBlend(headBlend)
    cb({ok = true})
end)

-- Update face feature
RegisterNUICallback('Client:Appearance:UpdateFaceFeature', function(data, cb)
    local index = data[1]
    local value = data[2]
    
    if not index or not value then
        cb({ok = false, error = "Missing index or value"})
        return
    end
    
    ig.log.Trace("Appearance", "Update face feature %d: %s", index, value)
    ig.appearance.SetFaceFeature(index, value)
    cb({ok = true})
end)

-- Update head overlay
RegisterNUICallback('Client:Appearance:UpdateHeadOverlay', function(data, cb)
    local overlayId = data[1]
    local overlayData = data[2]
    
    if not overlayId or not overlayData then
        cb({ok = false, error = "Missing overlay data"})
        return
    end
    
    ig.log.Trace("Appearance", "Update head overlay %d", overlayId)
    ig.appearance.SetHeadOverlay(
        overlayId,
        overlayData.style,
        overlayData.opacity,
        overlayData.color,
        overlayData.secondColor
    )
    cb({ok = true})
end)

-- Update hair
RegisterNUICallback('Client:Appearance:UpdateHair', function(data, cb)
    local hair = data[1]
    
    if not hair then
        cb({ok = false, error = "Missing hair data"})
        return
    end
    
    ig.log.Trace("Appearance", "Update hair - style: %s, color: %s, highlight: %s", 
        hair.style or 0, hair.color or 0, hair.highlight or 0)
    
    ig.appearance.SetHair(hair.style, hair.color, hair.highlight)
    cb({ok = true})
end)

-- Update eye color
RegisterNUICallback('Client:Appearance:UpdateEyeColor', function(data, cb)
    local color = data[1]
    
    if not color then
        cb({ok = false, error = "Missing eye color"})
        return
    end
    
    ig.log.Trace("Appearance", "Update eye color: %d", color)
    ig.appearance.SetEyeColor(color)
    cb({ok = true})
end)

-- Update component
RegisterNUICallback('Client:Appearance:UpdateComponent', function(data, cb)
    local componentId = data[1]
    local drawable = data[2]
    local texture = data[3]
    
    if not componentId then
        cb({ok = false, error = "Missing component data"})
        return
    end
    
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then
        cb({ok = false, error = "Ped does not exist"})
        return
    end
    
    -- Validate drawable and texture exist before setting
    local maxDrawable = GetNumberOfPedDrawableVariations(ped, componentId)
    local maxTexture = GetNumberOfPedTextureVariations(ped, componentId, drawable)
    
    if drawable >= maxDrawable then
        ig.log.Warn("Appearance", "Invalid drawable %d for component %d (max: %d)", drawable, componentId, maxDrawable - 1)
        cb({ok = false, error = "Invalid drawable"})
        return
    end
    
    if texture >= maxTexture then
        ig.log.Warn("Appearance", "Invalid texture %d for component %d drawable %d (max: %d)", texture, componentId, drawable, maxTexture - 1)
        cb({ok = false, error = "Invalid texture"})
        return
    end
    
    ig.log.Trace("Appearance", "Update component %d: drawable=%s, texture=%s", 
        componentId, drawable or 0, texture or 0)
    
    ig.appearance.SetComponent(componentId, drawable, texture)
    cb({ok = true})
end)

-- Get available component variations
RegisterNUICallback('Client:Appearance:GetComponentVariations', function(data, cb)
    local componentId = data[1]
    
    if not componentId then
        cb({ok = false, error = "Missing component ID"})
        return
    end
    
    local ped = PlayerPedId()
    if not DoesEntityExist(ped) then
        cb({ok = false, error = "Ped does not exist"})
        return
    end
    
    local drawableCount = GetNumberOfPedDrawableVariations(ped, componentId)
    local currentDrawable = GetPedDrawableVariation(ped, componentId)
    local textureCount = GetNumberOfPedTextureVariations(ped, componentId, currentDrawable)
    
    ig.log.Trace("Appearance", "Component %d variations: drawables=%d, textures=%d", 
        componentId, drawableCount, textureCount)
    
    cb({
        ok = true,
        drawableCount = drawableCount,
        textureCount = textureCount,
        currentDrawable = currentDrawable,
        currentTexture = GetPedTextureVariation(ped, componentId)
    })
end)

-- Get all available components and props for current ped
RegisterNUICallback('Client:Appearance:GetAvailableCustomization', function(data, cb)
    local ped = PlayerPedId()
    
    if not DoesEntityExist(ped) then
        cb({ok = false, error = "Ped does not exist"})
        return
    end
    
    local model = GetEntityModel(ped)
    local isFreemode = ig.appearance.IsFreemode()
    
    -- Build components list with actual drawable counts
    local components = {}
    for i = 0, 11 do  -- Standard component IDs (0-11)
        -- Skip component 0 (face/head) - this is for face structure, not clothing
        -- Skip component 2 (hair) - has its own dedicated tab
        -- Face items like sunglasses are props (prop 1 = glasses)
        if i ~= 0 and i ~= 2 then
            local drawableCount = GetNumberOfPedDrawableVariations(ped, i)
            if drawableCount > 0 then
                table.insert(components, {
                    id = i,
                    name = GetComponentName(i),
                    drawableCount = drawableCount
                })
            end
        end
    end
    
    -- Build props list with actual drawable counts
    local props = {}
    for i = 0, 9 do  -- Standard prop IDs (0-9)
        local drawableCount = GetNumberOfPedPropDrawableVariations(ped, i)
        if drawableCount > 0 then
            table.insert(props, {
                id = i,
                name = GetPropName(i),
                drawableCount = drawableCount
            })
        end
    end
    
    ig.log.Info("Appearance", "Available customization - Components: %d, Props: %d, Freemode: %s", 
        #components, #props, tostring(isFreemode))
    
    cb({
        ok = true,
        isFreemode = isFreemode,
        components = components,
        props = props,
        model = model
    })
end)

-- Helper function to get component name
function GetComponentName(componentId)
    local names = {
        [0] = "Face",
        [1] = "Mask",
        [2] = "Hair",
        [3] = "Torso",
        [4] = "Legs",
        [5] = "Bags",
        [6] = "Shoes",
        [7] = "Accessories",
        [8] = "Undershirt",
        [9] = "Body Armor",
        [10] = "Decals",
        [11] = "Tops"
    }
    return names[componentId] or "Component " .. componentId
end

-- Helper function to get prop name
function GetPropName(propId)
    local names = {
        [0] = "Hats",
        [1] = "Glasses",
        [2] = "Ears",
        [6] = "Watches",
        [7] = "Bracelets"
    }
    return names[propId] or "Prop " .. propId
end

-- Update prop
RegisterNUICallback('Client:Appearance:UpdateProp', function(data, cb)
    local propId = data[1]
    local drawable = data[2]
    local texture = data[3]
    
    if not propId then
        cb({ok = false, error = "Missing prop data"})
        return
    end
    
    ig.log.Trace("Appearance", "Update prop %d: drawable=%s, texture=%s", 
        propId, drawable or 0, texture or 0)
    
    ig.appearance.SetProp(propId, drawable, texture)
    cb({ok = true})
end)

-- Apply tattoo
RegisterNUICallback('Client:Appearance:ApplyTattoo', function(data, cb)
    local collection = data[1]
    local hash = data[2]
    
    if not collection or not hash then
        cb({ok = false, error = "Missing tattoo data"})
        return
    end
    
    ig.log.Trace("Appearance", "Apply tattoo: %s / %s", collection, hash)
    ig.appearance.ApplyTattoo(collection, hash)  -- Fixed: was AddTattoo, should be ApplyTattoo
    cb({ok = true})
end)

-- Clear tattoos
RegisterNUICallback('Client:Appearance:ClearTattoos', function(data, cb)
    ig.log.Trace("Appearance", "Clear all tattoos")
    ig.appearance.ClearTattoos()
    cb({ok = true})
end)

-- Rotate camera
RegisterNUICallback('Client:Appearance:RotateCamera', function(data, cb)
    local degrees = data[1] or 0
    ig.log.Trace("Appearance", "Rotate camera: %d degrees", degrees)
    
    -- TODO: Implement camera rotation
    -- ig.appearance.RotateCamera(degrees)
    
    cb({ok = true})
end)

-- Turn around animation
RegisterNUICallback('Client:Appearance:TurnAround', function(data, cb)
    local duration = data[1] or 2000
    ig.log.Trace("Appearance", "Turn around animation: %dms", duration)
    
    -- TODO: Implement turn around animation
    -- ig.appearance.TurnAround(duration)
    
    cb({ok = true})
end)

-- Save appearance
RegisterNUICallback('Client:Appearance:Save', function(data, cb)
    ig.log.Trace("Appearance", "Save appearance")
    
    -- Get current appearance from game
    local appearance = ig.appearance.GetAppearance()
    
    cb({ok = true, appearance = appearance})
end)

-- Cancel appearance customization
RegisterNUICallback('Client:Appearance:Cancel', function(data, cb)
    ig.log.Trace("Appearance", "Cancel appearance customization")
    
    -- Close NUI
    SetNuiFocus(false, false)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Appearance live update callbacks registered")
