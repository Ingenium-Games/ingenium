-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
math = require('glm')
c.Seed = math.ceil(GetGameTimer() * math.pi) * 2
c.Locale = conf.locale

c.Character = nil
c.CharacterLoaded = false