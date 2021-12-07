-- ====================================================================================--

-- Globals and Require/Replace
math = require('glm')
math.randomseed(GetNetworkTime())
--
c.Locale = conf.locale
c.Character = nil
c.CharacterLoaded = false