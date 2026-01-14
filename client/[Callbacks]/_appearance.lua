-- ====================================================================================--
-- Appearance Customization NUI Callbacks
-- Handles communication between Vue UI and client-side appearance functions
-- ====================================================================================--

-- ====================================================================================--
-- APPEARANCE CUSTOMIZATION CALLBACKS
-- ====================================================================================--

---Open appearance customization UI
---@param config table|nil Configuration options
RegisterClientCallback({
    eventName = "Client:Appearance:Open",
    eventCallback = function(config)
        config = config or {}
        
        -- Store if this is character creation
        ig.appearance.IsCharacterCreation = config.isCharacterCreation or false
        
        -- Activate customization mode
        ig.appearance.SetCustomizationActive(true)
        
        -- Get current appearance
        local currentAppearance = ig.appearance.GetAppearance()
        
        -- Get appearance constants
        local constants = ig.appearance.GetConstants()
        
        -- Get ped data from server if needed
        local peds = nil
        if config.allowModelChange ~= false then
            peds = ig.callback.Await('ig:GameData:GetPeds')
        end
        
        -- Get tattoo data from server if tattoos enabled
        local tattoos = nil
        if config.allowTattoos ~= false then
            tattoos = ig.callback.Await('ig:GameData:GetTattoos')
        end
        
        -- Get pricing data from server if pricing enabled
        local pricing = nil
        if config.jobName then
            pricing = ig.callback.Await('Server:Appearance:GetPricing', config.jobName)
        end
        
        -- Send data to NUI
            ig.ui.Send("appearance:open", {
            appearance = currentAppearance,
            constants = constants,
            peds = peds,
            tattoos = tattoos,
            config = config,
            pricing = pricing
            }, true)
    end
})

---Close appearance customization UI
RegisterClientCallback({
    eventName = "Client:Appearance:Close",
    eventCallback = function()
        -- Deactivate customization mode
        ig.appearance.SetCustomizationActive(false)
        
        -- Close NUI
           ig.ui.Send("appearance:close", {}, false)
    end
})

---Update ped model
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateModel",
    eventCallback = function(model)
        ig.appearance.SetModel(model)
        return true
    end
})

---Update head blend (heritage)
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateHeadBlend",
    eventCallback = function(headBlend)
        ig.appearance.SetHeadBlend(headBlend)
        return true
    end
})

---Update single face feature
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateFaceFeature",
    eventCallback = function(index, value)
        ig.appearance.SetFaceFeature(index, value)
        return true
    end
})

---Update all face features
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateFaceFeatures",
    eventCallback = function(features)
        ig.appearance.SetFaceFeatures(features)
        return true
    end
})

---Update single head overlay
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateHeadOverlay",
    eventCallback = function(overlayId, data)
        ig.appearance.SetHeadOverlay(overlayId, data.style, data.opacity, data.color, data.secondColor)
        return true
    end
})

---Update all head overlays
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateHeadOverlays",
    eventCallback = function(overlays)
        ig.appearance.SetHeadOverlays(overlays)
        return true
    end
})

---Update hair
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateHair",
    eventCallback = function(hair)
        ig.appearance.SetHair(hair.style, hair.color, hair.highlight)
        return true
    end
})

---Update eye color
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateEyeColor",
    eventCallback = function(color)
        ig.appearance.SetEyeColor(color)
        return true
    end
})

---Update single component
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateComponent",
    eventCallback = function(componentId, drawable, texture)
        ig.appearance.SetComponent(componentId, drawable, texture)
        return true
    end
})

---Update all components
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateComponents",
    eventCallback = function(components)
        ig.appearance.SetComponents(components)
        return true
    end
})

---Update single prop
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateProp",
    eventCallback = function(propId, drawable, texture)
        ig.appearance.SetProp(propId, drawable, texture)
        return true
    end
})

---Update all props
RegisterClientCallback({
    eventName = "Client:Appearance:UpdateProps",
    eventCallback = function(props)
        ig.appearance.SetProps(props)
        return true
    end
})

---Apply tattoo
RegisterClientCallback({
    eventName = "Client:Appearance:ApplyTattoo",
    eventCallback = function(collection, hash)
        ig.appearance.ApplyTattoo(collection, hash)
        return true
    end
})

---Remove all tattoos
RegisterClientCallback({
    eventName = "Client:Appearance:ClearTattoos",
    eventCallback = function()
        ig.appearance.ClearTattoos()
        return true
    end
})

---Apply multiple tattoos
RegisterClientCallback({
    eventName = "Client:Appearance:ApplyTattoos",
    eventCallback = function(tattoos)
        ig.appearance.ApplyTattoos(tattoos)
        return true
    end
})

-- ====================================================================================--
-- CAMERA CONTROL CALLBACKS
-- ====================================================================================--

---Set camera view mode
RegisterClientCallback({
    eventName = "Client:Appearance:SetCameraView",
    eventCallback = function(mode)
        ig.appearance.SetCameraView(mode)
        return true
    end
})

---Rotate camera
RegisterClientCallback({
    eventName = "Client:Appearance:RotateCamera",
    eventCallback = function(degrees)
        ig.appearance.RotateCamera(degrees)
        return true
    end
})

---Turn ped around
RegisterClientCallback({
    eventName = "Client:Appearance:TurnAround",
    eventCallback = function(duration)
        ig.appearance.TurnAround(duration)
        return true
    end
})

-- ====================================================================================--
-- SAVE/LOAD CALLBACKS
-- ====================================================================================--

---Save appearance
RegisterClientCallback({
    eventName = "Client:Appearance:Save",
    eventCallback = function()
        local appearance = ig.appearance.GetAppearance()
        
        -- Check if this is character creation
        local isCharacterCreation = ig.appearance.IsCharacterCreation or false
        
        if isCharacterCreation then
            -- Store appearance temporarily for character registration
            ig.appearance.PendingAppearance = appearance
            
            -- Close customization
            ig.appearance.SetCustomizationActive(false)
            ig.ui.Send("appearance:close", {}, false)
            
            -- Trigger character registration NUI
            TriggerEvent("Client:Character:NewSpawn")
            ig.ui.Send("register", {}, true)
        else
            -- Send to server for validation and saving using callback
            TriggerServerCallback({
                eventName = "Server:Character:SaveAppearance",
                args = {appearance},
                callback = function(result)
                    if result and result.success then
                        ig.debug.Info("Appearance saved successfully")
                    else
                        ig.debug.Error("Failed to save appearance: " .. (result and result.error or "Unknown error"))
                        ig.ui.Send("notification", {
                            text = "Failed to save appearance: " .. (result and result.error or "Unknown error"),
                            colour = "red",
                            fade = 5000
                        }, false)
                    end
                end
            })
            
            -- Close customization
            ig.appearance.SetCustomizationActive(false)
                ig.ui.Send("appearance:close", {}, false)
        end
        
        return true
    end
})

---Cancel appearance changes
RegisterClientCallback({
    eventName = "Client:Appearance:Cancel",
    eventCallback = function()
        -- Restore previous appearance if stored
        -- For now, just close
        ig.appearance.SetCustomizationActive(false)
            ig.ui.Send("appearance:close", {}, false)
        
        return true
    end
})

---Get component variations for a component ID
RegisterClientCallback({
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
RegisterClientCallback({
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
RegisterClientCallback({
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
