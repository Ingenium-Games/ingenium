-- ====================================================================================--
--  MIT License 2020 : Twiitchter
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
    if c.json.Exists("Names.json") then
        local file = c.json.Read("Names.json")
        c.names = file
    end
    --
    for _,v in pairs(c.names) do
        if v.gender == "male" then
            table.insert(gender.m, v.name)
        elseif v.gender == "female" then
            table.insert(gender.f, v.name)
        else
            table.insert(gender.u, v.name)
        end
    end
    c.debug(c.table.Dump(gender.u))
end

function c.name.RandomMale()
    return gender.m[math.random(1,#gender.m)]
end

function c.name.RandomFemale()
    return gender.m[math.random(1,#gender.f)]
end

function c.name.RandomUnisex()
    return gender.m[math.random(1,#gender.u)]
end