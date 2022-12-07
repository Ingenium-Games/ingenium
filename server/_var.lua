-- ====================================================================================--
-- Globals and Require/Replace
math = require("glm")
math.randomseed(GetGameTimer())
c = exports["ig.core"]:c()
-- ====================================================================================--
c.imagehost = conf.imagehost
c.sec = conf.sec
c.min = conf.min
c.hour = conf.hour
c.day = conf.day
c.locale = conf.locale
--
function GetLocale()
    return c.locale
end
exports("GetLocale", GetLocale)
--
-- _data.lua
c._running = false
c._loading = true