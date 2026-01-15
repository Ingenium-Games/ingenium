-- ====================================================================================--

RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    if not data.ID then
        -- Keep Focus, return error.
        cb({
            message = "error",
            data = "__join called with no data.ID passed"
        })
        return
    end
    -- Check if player is loaded as a character, otherwise dont disable nui, itll be in the character seleciton screen.
    if not ig.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        -- Use secure callback instead of direct event
        TriggerServerCallback({
            eventName = "Server:Character:Join",
            args = {data.ID},
            callback = function(result)
                if result and result.success then
                    SetFollowPedCamViewMode(0)
                else
                    ig.log.Error("CHARSELECT", "Failed to join character: %s", (result and result.error or "Unknown error"))
                end
            end
        })
        cb({
            message = "ok",
            data = nil
        })
    else
        -- Keep Focus, return error.
        cb({
            message = "error",
            data = "NUI:Client:CharacterPlay called with client already having a character"
        })
    end
end)

RegisterNUICallback("NUI:Client:CharacterDelete", function(data, cb)
    if not data.ID then
        cb({
            message = "error",
            data = "NUI:Client:CharacterDelete called with no data.ID passed"
        })
        return
    end
    -- Check if player is loaded as a character, otherwise dont disable nui, itll be in the character seleciton screen.
    if not ig.data.IsPlayerLoaded() then
        -- Remove Focus
        SetNuiFocus(false, false)
        -- Use secure callback instead of direct event
        TriggerServerCallback({
            eventName = "Server:Character:Delete",
            args = {data.ID},
            callback = function(result)
                if result and not result.success then
                    ig.log.Error("CHARSELECT", "Failed to delete character: %s", (result.error or "Unknown error"))
                end
            end
        })
        cb({
            message = "ok",
            data = nil
        })
    else
        -- Keep Focus, return error.
        cb({
            message = "error",
            data = "NUI:Client:CharacterDelete called with client already having a character"
        })
    end

end)

RegisterNUICallback("NUI:Client:CharacterCreate", function(data, cb)
    -- Check if player is loaded as a character, otherwise dont disable nui, itll be in the character seleciton screen.
    if not ig.data.IsPlayerLoaded() then
        -- Remove Focus
        SetNuiFocus(false, false)
        SetFollowPedCamViewMode(0)
        
        -- Get appearance from our native system
        local appearance = ig.appearance.PendingAppearance or ig.appearance.GetAppearance()
        ig.appearance.PendingAppearance = nil -- Clear pending appearance
        
        -- Use secure callback instead of direct event
        TriggerServerCallback({
            eventName = "Server:Character:Register",
            args = {data.First_Name, data.Last_Name, appearance},
            callback = function(result)
                if result and result.success then
                    ig.log.Info("CHARSELECT", "Character registered successfully with ID: %s", (result.character_id or "unknown"))
                else
                    ig.log.Error("CHARSELECT", "Failed to register character: %s", (result and result.error or "Unknown error"))
                end
            end
        })
        cb({
            message = "ok",
            data = nil
        })
    else
        -- Keep Focus, return error.
        cb({
            message = "error",
            data = "NUI:Client:CharacterCreate called with client already having a character"
        })
    end
end)