-- ====================================================================================--

RegisterNUICallback("_character-select__join", function(data, cb)
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
        TriggerServerEvent("Server:Character:Join", data.ID)
        SetFollowPedCamViewMode(0)
        cb({
            message = "ok",
            data = nil
        })
    else
        -- Keep Focus, return error.
        cb({
            message = "error",
            data = "_character-select__join called with client already having a character"
        })
    end
end)

RegisterNUICallback("_character-select__delete", function(data, cb)
    if not data.ID then
        cb({
            message = "error",
            data = "__delete called with no data.ID passed"
        })
        return
    end
    -- Check if player is loaded as a character, otherwise dont disable nui, itll be in the character seleciton screen.
    if not ig.data.IsPlayerLoaded() then
        -- Remove Focus
        SetNuiFocus(false, false)
        TriggerServerEvent("Server:Character:Delete", data.ID)
        cb({
            message = "ok",
            data = nil
        })
    else
        -- Keep Focus, return error.
        cb({
            message = "error",
            data = "_character-select__delete called with client already having a character"
        })
    end

end)

RegisterNUICallback("_character-select__register", function(data, cb)
    -- Check if player is loaded as a character, otherwise dont disable nui, itll be in the character seleciton screen.
    if not ig.data.IsPlayerLoaded() then
        -- Remove Focus
        SetNuiFocus(false, false)
        SetFollowPedCamViewMode(0)
        
        -- Get appearance from our native system
        local appearance = ig.appearance.PendingAppearance or ig.appearance.GetAppearance()
        ig.appearance.PendingAppearance = nil -- Clear pending appearance
        
        TriggerServerEvent("Server:Character:Register", data.First_Name, data.Last_Name, appearance)
        cb({
            message = "ok",
            data = nil
        })
    else
        -- Keep Focus, return error.
        cb({
            message = "error",
            data = "_character-select__register called with client already having a character"
        })
    end
end)