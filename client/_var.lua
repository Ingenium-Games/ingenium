-- ====================================================================================--
-- Globals and Require/Replace
math.randomseed(GetNetworkTime())
c = c or exports["ig.core"]:c()
-- ====================================================================================--
ig.imagehost = conf.imagehost
ig.sec = conf.sec
ig.min = conf.min
ig.hour = conf.hour
ig.day = conf.day
ig.locale = conf.locale
--
function GetLocale()
    return ig.locale
end
exports("GetLocale", GetLocale)
--
-- _data.lua
ig._loaded = false
ig._character = nil
--
local ok, glm = pcall(require, "glm")
if ok and glm then
    c = c or {}
    ig.glm = glm
end
