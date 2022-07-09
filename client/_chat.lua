-- ====================================================================================--
c.chat = {}
c.chats = {}
-- ====================================================================================--
----
---@param group any "Check permissions and import the chat suggestions."
function c.chat.AddSuggestions()
    local ace = LocalPlayer.state.Ace
    if c.ace[ace] then
        c.ace[ace]()
        c.func.Debug_1("Added chat suggestions for group: "..ace.." and below.")
    else
        c.func.Debug_1("Unable to find chat suggestions for group: "..ace)
    end
end

function c.chat.SetPermissions()
    -- to remvoe permissions from cfg, to have them import via function to allow easier handling.
end

function c.chat.Msg(msg, colour, icon, subtitle, timestamp)
    local msg = msg
    local colour = colour or "#fff"
    local icon = icon or "fa-solid fa-angle-right"
    local subtitle = subtitle or ""
    local timestamp = timestamp or GetConvar("Time", "00:00")
    TriggerEvent('chat:addMessage', { templateId = 'core', multiline = false, args = { colour, icon, subtitle, timestamp, msg } })
end