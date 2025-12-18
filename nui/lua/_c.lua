-- ====================================================================================--
RegisterNetEvent("Client:Nui:Message")
AddEventHandler("Client:Nui:Message", function(M, D, FOCUS)
    -- Send message
    SendNUIMessage(json.encode({
        message = M,
        data = D or {}
    }))
    -- 
    SetNuiFocus((FOCUS or true), (FOCUS or true))
end)
--
RegisterNUICallback("_c__close", function(data, cb)
    -- Check if player is loaded as a character, otherwise dont disable nui, itll be in the character seleciton screen.
    if ig.data.IsPlayerLoaded() then
        -- Remove Focus
        SetNuiFocus(false, false)
        cb({
            message = "ok",
            data = nil
        })
    else
        -- Keep Focus, return error.
        cb({
            message = "error",
            data = "__close called with no loaded character"
        })
    end
end)