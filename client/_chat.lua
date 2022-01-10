-- ====================================================================================--
c.chat = {}
c.chats = {}
-- ====================================================================================--
----
---@param group any "Check permissions and import the chat suggestions."
function c.chat.AddSuggestions(xPlayer)
    local ace = xPlayer.Ace
    if c.ace[ace] then
        c.ace[ace]()
        c.debug_1("Added chat suggestions for group: "..ace.." and below.")
    else
        c.debug_1("Unable to find chat suggestions for group: "..ace)
    end
end

function c.chat.SetPermissions()
    -- to remvoe permissions from cfg, to have them import via function to allow easier handling.
end