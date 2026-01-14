-- ====================================================================================--
ig.name = {} -- function level
ig.names = {} -- names table to be imported from Names.json
-- ====================================================================================--

local gender = {["m"] = {},["f"] = {},["u"] = {}}

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