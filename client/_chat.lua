-- ====================================================================================--
ig.chat = {}
ig.chats = {}
-- ====================================================================================--

--- func desc
---@param group any "Check permissions and import the chat suggestions."
function ig.chat.AddSuggestions()
    local ace = LocalPlayer.state.Ace
    if ig.ace[ace] then
        ig.ace[ace]()
        ig.funig.Debug_1("Added chat suggestions for group: "..ace.." and below.")
    else
        ig.funig.Debug_1("Unable to find chat suggestions for group: "..ace)
    end
end

--- func desc
function ig.chat.SetPermissions()
    -- to remvoe permissions from cfg, to have them import via function to allow easier handling.
end