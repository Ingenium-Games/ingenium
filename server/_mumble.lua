-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.mumble = {}
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
-- Reserve channles 20001 - 20064 for instances. (63 total)
-- default channle is 0.

local mumbleinstanceindex = 20000
local count = 1

function c.mumble.GenerateInstanceChannels()
    for i = 1, 64, 1 do
        MumbleCreateChannel(mumbleinstanceindex + count)
        count = count + 1
    end
end
