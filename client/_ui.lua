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
    ig.ui.Send("Client:NUI:MenuShow", data, true)
end

function ig.ui.HideMenu()
    ig.ui.Send("Client:NUI:MenuHide", {}, false)
end

function ig.ui.ShowInput(data)
    ig.ui.Send("Client:NUI:InputShow", data, true)
end

function ig.ui.HideInput()
    ig.ui.Send("Client:NUI:InputHide", {}, false)
end

function ig.ui.ShowContext(data)
    ig.ui.Send("Client:NUI:ContextShow", data, true)
end

function ig.ui.HideContext()
    ig.ui.Send("Client:NUI:ContextHide", {}, false)
end

function ig.ui.ShowHUD()
    ig.ui.Send("Client:NUI:HUDShow", {}, false)
end

function ig.ui.HideHUD()
    ig.ui.Send("Client:NUI:HUDHide", {}, false)
end

function ig.ui.UpdateHUD(data)
    ig.ui.Send("Client:NUI:HUDUpdate", data, false)
end

function ig.ui.Notify(text, colour, fade)
    ig.ui.Send("Client:NUI:Notification", { text = text, colour = colour, fade = fade }, false)
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