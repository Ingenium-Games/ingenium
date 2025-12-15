-- ====================================================================================--
-- Appearance Customization NUI Callbacks
-- Handles communication between Vue UI and client-side appearance functions
-- ====================================================================================--

-- ====================================================================================--
-- APPEARANCE CUSTOMIZATION CALLBACKS
-- ====================================================================================--

---Open appearance customization UI
---@param config table|nil Configuration options
RegisterServerCallback({
    eventName = "Client:Appearance:Open",
    eventCallback = function(config)
        config = config or {}
        
        -- Store if this is character creation
        c.appearance.IsCharacterCreation = config.isCharacterCreation or false
        
        -- Activate customization mode
        c.appearance.SetCustomizationActive(true)
        
        -- Get current appearance
        local currentAppearance = c.appearance.GetAppearance()
        
        -- Get appearance constants
        local constants = c.appearance.GetConstants()
        
        -- Get ped data from server if needed
        local peds = nil
        if config.allowModelChange ~= false then
            peds = c.callback.Await('ig:GameData:GetPeds')
        end
        
        -- Get tattoo data from server if tattoos enabled
        local tattoos = nil
        if config.allowTattoos ~= false then
            tattoos = c.callback.Await('ig:GameData:GetTattoos')
        end
        
        -- Send data to NUI
        TriggerEvent("Client:Nui:Message", "appearance:open", {
            appearance = currentAppearance,
            constants = constants,
            peds = peds,
            tattoos = tattoos,
            config = config
        })
    end
})

---Close appearance customization UI
RegisterServerCallback({
    eventName = "Client:Appearance:Close",
    eventCallback = function()
        -- Deactivate customization mode
        c.appearance.SetCustomizationActive(false)
        
        -- Close NUI
        TriggerEvent("Client:Nui:Message", "appearance:close", {})
    end
})

---Update ped model
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateModel",
    eventCallback = function(model)
        c.appearance.SetModel(model)
        return true
    end
})

---Update head blend (heritage)
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateHeadBlend",
    eventCallback = function(headBlend)
        c.appearance.SetHeadBlend(headBlend)
        return true
    end
})

---Update single face feature
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateFaceFeature",
    eventCallback = function(index, value)
        c.appearance.SetFaceFeature(index, value)
        return true
    end
})

---Update all face features
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateFaceFeatures",
    eventCallback = function(features)
        c.appearance.SetFaceFeatures(features)
        return true
    end
})

---Update single head overlay
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateHeadOverlay",
    eventCallback = function(overlayId, data)
        c.appearance.SetHeadOverlay(overlayId, data.style, data.opacity, data.color, data.secondColor)
        return true
    end
})

---Update all head overlays
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateHeadOverlays",
    eventCallback = function(overlays)
        c.appearance.SetHeadOverlays(overlays)
        return true
    end
})

---Update hair
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateHair",
    eventCallback = function(hair)
        c.appearance.SetHair(hair.style, hair.color, hair.highlight)
        return true
    end
})

---Update eye color
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateEyeColor",
    eventCallback = function(color)
        c.appearance.SetEyeColor(color)
        return true
    end
})

---Update single component
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateComponent",
    eventCallback = function(componentId, drawable, texture)
        c.appearance.SetComponent(componentId, drawable, texture)
        return true
    end
})

---Update all components
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateComponents",
    eventCallback = function(components)
        c.appearance.SetComponents(components)
        return true
    end
})

---Update single prop
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateProp",
    eventCallback = function(propId, drawable, texture)
        c.appearance.SetProp(propId, drawable, texture)
        return true
    end
})

---Update all props
RegisterServerCallback({
    eventName = "Client:Appearance:UpdateProps",
    eventCallback = function(props)
        c.appearance.SetProps(props)
        return true
    end
})

---Apply tattoo
RegisterServerCallback({
    eventName = "Client:Appearance:ApplyTattoo",
    eventCallback = function(collection, hash)
        c.appearance.ApplyTattoo(collection, hash)
        return true
    end
})

---Remove all tattoos
RegisterServerCallback({
    eventName = "Client:Appearance:ClearTattoos",
    eventCallback = function()
        c.appearance.ClearTattoos()
        return true
    end
})

---Apply multiple tattoos
RegisterServerCallback({
    eventName = "Client:Appearance:ApplyTattoos",
    eventCallback = function(tattoos)
        c.appearance.ApplyTattoos(tattoos)
        return true
    end
})

-- ====================================================================================--
-- CAMERA CONTROL CALLBACKS
-- ====================================================================================--

---Set camera view mode
RegisterServerCallback({
    eventName = "Client:Appearance:SetCameraView",
    eventCallback = function(mode)
        c.appearance.SetCameraView(mode)
        return true
    end
})

---Rotate camera
RegisterServerCallback({
    eventName = "Client:Appearance:RotateCamera",
    eventCallback = function(degrees)
        c.appearance.RotateCamera(degrees)
        return true
    end
})

---Turn ped around
RegisterServerCallback({
    eventName = "Client:Appearance:TurnAround",
    eventCallback = function(duration)
        c.appearance.TurnAround(duration)
        return true
    end
})

-- ====================================================================================--
-- SAVE/LOAD CALLBACKS
-- ====================================================================================--

---Save appearance
RegisterServerCallback({
    eventName = "Client:Appearance:Save",
    eventCallback = function()
        local appearance = c.appearance.GetAppearance()
        
        -- Check if this is character creation
        local isCharacterCreation = c.appearance.IsCharacterCreation or false
        
        if isCharacterCreation then
            -- Store appearance temporarily for character registration
            c.appearance.PendingAppearance = appearance
            
            -- Close customization
            c.appearance.SetCustomizationActive(false)
            TriggerEvent("Client:Nui:Message", "appearance:close", {})
            
            -- Trigger character registration NUI
            TriggerEvent("Client:Character:NewSpawn")
            TriggerEvent("Client:Nui:Message", "register")
        else
            -- Send to server for validation and saving
            TriggerServerEvent("Server:Character:SaveAppearance", appearance)
            
            -- Close customization
            c.appearance.SetCustomizationActive(false)
            TriggerEvent("Client:Nui:Message", "appearance:close", {})
        end
        
        return true
    end
})

---Cancel appearance changes
RegisterServerCallback({
    eventName = "Client:Appearance:Cancel",
    eventCallback = function()
        -- Restore previous appearance if stored
        -- For now, just close
        c.appearance.SetCustomizationActive(false)
        TriggerEvent("Client:Nui:Message", "appearance:close", {})
        
        return true
    end
})

---Get component variations for a component ID
RegisterServerCallback({
    eventName = "Client:Appearance:GetComponentVariations",
    eventCallback = function(componentId)
        local ped = PlayerPedId()
        local numDrawables = GetNumberOfPedDrawableVariations(ped, componentId)
        local variations = {}
        
        for i = 0, numDrawables - 1 do
            local numTextures = GetNumberOfPedTextureVariations(ped, componentId, i)
            table.insert(variations, {
                drawable = i,
                textures = numTextures
            })
        end
        
        return variations
    end
})

---Get prop variations for a prop ID
RegisterServerCallback({
    eventName = "Client:Appearance:GetPropVariations",
    eventCallback = function(propId)
        local ped = PlayerPedId()
        local numDrawables = GetNumberOfPedPropDrawableVariations(ped, propId)
        local variations = {}
        
        for i = -1, numDrawables - 1 do
            if i == -1 then
                table.insert(variations, {
                    drawable = -1,
                    textures = 0,
                    label = "None"
                })
            else
                local numTextures = GetNumberOfPedPropTextureVariations(ped, propId, i)
                table.insert(variations, {
                    drawable = i,
                    textures = numTextures
                })
            end
        end
        
        return variations
    end
})

---Get hair variations
RegisterServerCallback({
    eventName = "Client:Appearance:GetHairVariations",
    eventCallback = function()
        local ped = PlayerPedId()
        local numDrawables = GetNumberOfPedDrawableVariations(ped, 2) -- Component 2 is hair
        local variations = {}
        
        for i = 0, numDrawables - 1 do
            table.insert(variations, {
                style = i
            })
        end
        
        return variations
    end
})

print('^2[Client] Appearance NUI callbacks loaded^0')
