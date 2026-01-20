-- ====================================================================================--
-- Chat management (ig.chat, ig.chats initialized in client/_var.lua)
-- ====================================================================================--

--- func desc
---@param group any "Check permissions and import the chat suggestions."
function ig.chat.AddSuggestions()
    local ace = LocalPlayer.state.Ace
    if not ace then
        ig.log.Warn("Chat", "Ace permission not yet synced from server, skipping chat suggestions")
        return
    end
    if ig.ace[ace] then
        ig.ace[ace]()
        ig.log.Info("Chat", "Added chat suggestions for group: "..ace.." and below")
    else
        ig.log.Warn("Chat", "Unable to find chat suggestions for group: "..ace)
    end
end

--- func desc
function ig.chat.SetPermissions()
    -- to remvoe permissions from cfg, to have them import via function to allow easier handling.
end

-- Receive chat messages from server and display in NUI
RegisterNetEvent('Client:NUI:ChatAddMessage')
AddEventHandler('Client:NUI:ChatAddMessage', function(messageData)
    if not messageData then return end
    
    -- Send message to NUI for display
    SendNUIMessage({
        message = 'Client:NUI:ChatAddMessage',
        data = {
            author = messageData.author or 'System',
            text = messageData.text or messageData.message or '',
            color = messageData.color or {255, 255, 255}
        }
    })
end)

-- Open chat with keybind (T key by default)
RegisterCommand('+openchat', function()
    -- Show chat input
    SendNUIMessage({
        message = 'Client:NUI:ChatShow'
    })
    SetNuiFocus(true, false)  -- Focus for typing, but no cursor
end, false)

RegisterCommand('-openchat', function()
    -- Do nothing on key release
end, false)

-- Register the keybind (T key)
RegisterKeyMapping('+openchat', 'Open Chat', 'keyboard', 'T')