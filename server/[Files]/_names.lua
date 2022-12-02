-- ====================================================================================--
c.name = {} -- function level
c.names = {} -- names table to be imported from Names.json
-- ====================================================================================--

local gender = {["m"] = {},["f"] = {},["u"] = {}}

--- func desc
---@param . any
function c.name.Load()
    if c.json.Exists(conf.file.names) then
        local file = c.json.Read(conf.file.names)
        c.names = file
    end
end

--- func desc
function c.name.RandomMale()
    return c.names.m[math.random(1,#c.names.m)]
end

--- func desc
function c.name.RandomFemale()
    return c.names.f[math.random(1,#c.names.f)]
end

--- func desc
function c.name.RandomUnisex()
    return c.names.u[math.random(1,#c.names.u)]
end