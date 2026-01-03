-- ====================================================================================--
-- Globals and Require/Replace
math.randomseed(GetNetworkTime())
ig = ig or {}
-- ====================================================================================--
ig.imagehost = conf.imagehost
ig.sec = conf.sec
ig.min = conf.min
ig.hour = conf.hour
ig.day = conf.day
ig.locale = conf.locale
-- _data.lua
ig._loaded = false
ig._character = nil
--
local ok, glm = pcall(require, "glm")
if ok and glm then
    ig = ig or {}
    ig.glm = glm
end
