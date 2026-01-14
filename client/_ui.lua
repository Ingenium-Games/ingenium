-- ====================================================================================--
-- ig.ui - Global UI helper for Vue NUI
-- Provides a single internal API for sending NUI messages and handling UI actions
-- ====================================================================================--

ig.ui = {}

-- Send a raw NUI message (internal use). `focus` defaults to false when omitted.
---@param message string
---@param data table|nil
---@param focus boolean|nil
function ig.ui.Send(message, data, focus)
    local payload = {
        message = message,
        data = data or {}
    }
    -- Use table form (consistent with other UI code)
    SendNUIMessage(payload)

    if focus ~= nil then
        SetNuiFocus( (focus and true) or false, (focus and true) or false )
    end
end

-- Convenience wrappers for common messages
function ig.ui.ShowMenu(data)
    ig.ui.Send("menu:show", data, true)
end

function ig.ui.HideMenu()
    ig.ui.Send("menu:hide", {}, false)
end

function ig.ui.ShowInput(data)
    ig.ui.Send("input:show", data, true)
end

function ig.ui.HideInput()
    ig.ui.Send("input:hide", {}, false)
end

function ig.ui.ShowContext(data)
    ig.ui.Send("context:show", data, true)
end

function ig.ui.HideContext()
    ig.ui.Send("context:hide", {}, false)
end

function ig.ui.ShowHUD()
    ig.ui.Send("hud:show", {}, false)
end

function ig.ui.HideHUD()
    ig.ui.Send("hud:hide", {}, false)
end

function ig.ui.UpdateHUD(data)
    ig.ui.Send("hud:update", data, false)
end

function ig.ui.Notify(text, colour, fade)
    ig.ui.Send("notification", { text = text, colour = colour, fade = fade }, false)
end

-- Allow server to force open UI via client callback. Server should check ACE before calling.
RegisterClientCallback({
    eventName = "Client:UI:ForceOpen",
    eventCallback = function(message, data)
        -- message: string - NUI message to send (e.g. "appearance:open")
        -- data: table - payload
        if type(message) ~= "string" then return false end
        ig.ui.Send(message, data, true)
        return true
    end
})