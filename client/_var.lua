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
c.locale = conf.locale
--
-- _data.lua
c._loaded = false
c._character = nil
