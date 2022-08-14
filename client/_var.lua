-- ====================================================================================--
-- Globals and Require/Replace
math = require("glm")
math.randomseed(GetNetworkTime())
c = exports["ig.core"]:c()
-- ====================================================================================--
c.imagehost = conf.imagehost
c.sec = conf.sec
c.min = conf.min
c.hour = conf.hour
c.day = conf.day
c.Locale = conf.locale
--
c.Character = nil
c.CharacterLoaded = false
--