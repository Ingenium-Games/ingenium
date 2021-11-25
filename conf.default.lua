-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
conf.default = {}
--[[
NOTES
	-
	-
	-
]] --
-- ====================================================================================--
-- character

conf.default.health = 175
conf.default.armour = 100

conf.default.cash = 125
conf.default.bank = 2500
conf.default.accounts = {["Cash"] = conf.default.cash, ["Bank"] = conf.default.bank}
conf.default.modifiers = {["Hunger"] = 1, ["Thirst"] = 1, ["Stress"] = 1}
-- jobs
conf.default.job = {["Name"] = "none", ["Grade"] = 1}
conf.default.jobaccounts = {["Bank"] = 25000, ["Safe"] = 0}
-- items
conf.default.itemcraft = true
conf.default.itemdegrade = false
