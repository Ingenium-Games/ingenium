-- ====================================================================================--
-- Chat System Integration with Vue NUI
-- ====================================================================================--

local chatVisible = false
local chatInputActive = false

-- Register NUI callbacks
RegisterNUICallback('chatSubmit', function(data, cb)
    chatVisible = false
    chatInputActive = false
    SetNuiFocus(false, false)
    
    local message = data.message
    if message and #message > 0 then
        -- Send message to server for logging
        TriggerServerEvent('ig:chat:serverMessage', message)
        
        -- Handle chat message or command
        if string.sub(message, 1, 1) == '/' then
            -- This is a command - execute it locally
            ExecuteCommand(string.sub(message, 2))
        else
            -- Regular message is handled by server (it will broadcast)
            -- No need to do anything else here
        end
    end
    
    cb('ok')
end)

RegisterNUICallback('chatClose', function(data, cb)
    chatVisible = false
    chatInputActive = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Function to add a message to chat
function AddChatMessage(author, message, color)
    SendNUIMessage({
        message = 'chat:addMessage',
        data = {
            author = author,
            text = message,
            color = color or {255, 255, 255}
        }
    })
end

-- Function to show chat input
function ShowChatInput()
    if not chatInputActive then
        chatVisible = true
        chatInputActive = true
        SendNUIMessage({
            message = 'chat:show',
            data = {}
        })
        SetNuiFocus(true, true)
    end
end

-- Function to hide chat
function HideChat()
    if chatInputActive then
        chatVisible = false
        chatInputActive = false
        SendNUIMessage({
            message = 'chat:hide',
            data = {}
        })
        SetNuiFocus(false, false)
    end
end

-- Function to clear chat messages
function ClearChat()
    SendNUIMessage({
        message = 'chat:clear',
        data = {}
    })
end

-- Function to set chat suggestions (commands)
function SetChatSuggestions(suggestions)
    SendNUIMessage({
        message = 'chat:setSuggestions',
        data = {
            suggestions = suggestions
        }
    })
end

-- Export functions
exports('AddChatMessage', AddChatMessage)
exports('ShowChatInput', ShowChatInput)
exports('HideChat', HideChat)
exports('ClearChat', ClearChat)
exports('SetChatSuggestions', SetChatSuggestions)

-- Register keybind for chat
RegisterCommand('+chat', function()
    ShowChatInput()
end, false)

RegisterCommand('-chat', function()
    -- Do nothing on key release
end, false)

RegisterKeyMapping('+chat', 'Open Chat', 'keyboard', 'T')

-- Listen for chat messages from server
-- Handles both new format (table) and legacy format (separate params)
RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(author, message, args)
    -- Handle both new format and legacy format
    if type(author) == 'table' then
        -- New format: author is actually the message object
        AddChatMessage(
            author.args and author.args[1] or author.author or 'System',
            author.args and author.args[2] or author.message or author.text or '',
            author.color or {255, 255, 255}
        )
    else
        -- Legacy format: separate parameters
        AddChatMessage(author, message, args or {255, 255, 255})
    end
end)

-- Integrate with ig.chat suggestions
if ig and ig.chat then
    -- Hook into chat suggestion system
    local oldAddSuggestions = ig.chat.AddSuggestions
    ig.chat.AddSuggestions = function()
        if oldAddSuggestions then
            oldAddSuggestions()
        end
        
        -- Get suggestions from the ace system and send to NUI
        -- This would need to be populated based on available commands
        local suggestions = {}
        
        -- Add common commands as suggestions
        table.insert(suggestions, {name = '/help', help = 'Show available commands'})
        table.insert(suggestions, {name = '/switch', help = _L('switch')})
        
        if LocalPlayer.state.Ace then
            local ace = LocalPlayer.state.Ace
            
            -- Add suggestions based on ace level
            if ace == 'mod' or ace == 'admin' or ace == 'superadmin' or ace == 'developer' or ace == 'owner' then
                table.insert(suggestions, {name = '/revive', help = _L('revive')})
                table.insert(suggestions, {name = '/heal', help = _L('heal')})
            end
            
            if ace == 'admin' or ace == 'superadmin' or ace == 'developer' or ace == 'owner' then
                table.insert(suggestions, {name = '/car', help = _L('car')})
                table.insert(suggestions, {name = '/kick', help = _L('kick')})
                table.insert(suggestions, {name = '/freeze', help = _L('freeze')})
            end
            
            if ace == 'developer' or ace == 'owner' then
                table.insert(suggestions, {name = '/noclip', help = _L('noclip')})
                table.insert(suggestions, {name = '/cam', help = _L('cam')})
            end
        end
        
        SetChatSuggestions(suggestions)
    end
end

-- Sync with default chat resource if it exists
CreateThread(function()
    Wait(1000) -- Wait for resources to load
    
    -- Disable default chat UI but keep functionality
    if GetResourceState('chat') == 'started' then
        exports.chat:addMessage = function(message)
            AddChatMessage(
                message.args and message.args[1] or message.author or 'System',
                message.args and message.args[2] or message.message or message.text or '',
                message.color or {255, 255, 255}
            )
        end
    end
end)

print('[IG Chat] Vue-based chat system loaded')
