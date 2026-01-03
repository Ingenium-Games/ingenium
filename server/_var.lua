-- ====================================================================================--
-- Globals and Require/Replace
math.randomseed(GetGameTimer())
ig = ig or {}
-- ====================================================================================--
ig.imagehost = conf.imagehost
ig.sec = conf.sec
ig.min = conf.min
ig.hour = conf.hour
ig.day = conf.day
ig.locale = conf.locale
-- _data.lua
ig._running = false
ig._loading = true
ig._dataloaded = false
--
local ok, glm = pcall(require, "glm")
if ok and glm then
    ig = ig or {}
    ig.glm = glm
end
