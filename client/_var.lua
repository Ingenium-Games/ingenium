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
-- _data.lua
c._loaded = false
c._character = nil
--
-- _weapons.lua
c._weapon = nil
c._weaponname = nil
c._components = nil
--
-- _ammo.lua
c._ammo = {["9mm"]=0,["5.56mm"]=0,["7.62mm"]=0,["20g"]=0,[".223"]=0,[".308"]=0}
