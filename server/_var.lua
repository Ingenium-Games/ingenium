-- ====================================================================================--
-- Globals and Require/Replace
math.randomseed(GetGameTimer())
c = c or {}
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
ig._running = false
ig._loading = true
--
local ok, glm = pcall(require, "glm")
if ok and glm then
    c = c or {}
    ig.glm = glm
end
