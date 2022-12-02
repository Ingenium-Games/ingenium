-- ====================================================================================--
c.chat = {}
c.chats = {}
-- ====================================================================================--

--- func desc
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

--- func desc
function c.chat.SetPermissions()
    -- to remvoe permissions from cfg, to have them import via function to allow easier handling.
end