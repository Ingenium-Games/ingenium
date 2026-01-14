-- ====================================================================================--
-- NOTE: Generic `Client:Nui:Message` event removed. Internal code should use `ig.ui.Send(...)`.
-- External resources should call the exported `SendMessage` from the NUI resource.
-- Keep NUI close callback for frontend compatibility.
local function closeHandler(data, cb)
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
end

RegisterNUICallback("NUI:Client:Close", closeHandler)
 