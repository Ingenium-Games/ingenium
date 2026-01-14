-- ====================================================================================--
ig.name = {} -- function level
ig.names = {} -- names table to be imported from Names.json
-- ====================================================================================--

local gender = {["m"] = {},["f"] = {},["u"] = {}}

--- func desc
---@wiki:ignore 
---@param . any
function ig.name.Load()
    if ig.json.Exists(conf.file.names) then
        local file = ig.json.Read(conf.file.names)
        ig.names = file
    end
end

--- func desc
function ig.name.RandomMale()
    return ig.names.m[math.random(1,#ig.names.m)]
end

--- func desc
function ig.name.RandomFemale()
    return ig.names.f[math.random(1,#ig.names.f)]
end

--- func desc
function ig.name.RandomUnisex()
    return ig.names.u[math.random(1,#ig.names.u)]
end