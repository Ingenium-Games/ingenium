-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.chat = {}
c.chats = {}
--[[
NOTES
    I a trying to figure outt he best way of dynamically looping over parent and children aces
    without the need for a manually typed table referncing what else to loop into, in terms
    of parent and child relations on ACL permissions.
    Preffer to do client sided.
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

----
---@param group any "Check permissions and import the chat suggestions."
function c.chat.AddSuggestions(xPlayer)
    local ace = xPlayer.Ace
    if c.ace[ace] then
        c.ace[ace]()
        c.debug("Added chat suggestions for group: "..ace.." and below.")
    else
        c.debug("Unable to find chat suggestions for group: "..ace)
    end
end

function c.chat.SetPermissions()
    -- to remvoe permissions from cfg, to have them import via function to allow easier handling.
end