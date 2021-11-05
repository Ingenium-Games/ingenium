-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.name = {} -- function level
c.names = {} -- names table to be imported from Names.json
--[[
NOTES.
    - The file loading also has country breakdowns, but really, up to you to make that
    - if you want to only load spefici county names.
]] --
math.randomseed(c.Seed)
-- ====================================================================================--
local gender = {["m"] = {},["f"] = {},["u"] = {}}

function c.name.Load()
    if c.json.Exists(conf.file.names) then
        local file = c.json.Read(conf.file.names)
        c.names = file
    end
end

function c.name.RandomMale()
    return c.names.m[math.random(1,#c.names.m)]
end

function c.name.RandomFemale()
    return c.names.f[math.random(1,#c.names.f)]
end

function c.name.RandomUnisex()
    return c.names.u[math.random(1,#c.names.u)]
end