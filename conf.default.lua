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

conf.default.cash = 125.00
conf.default.bank = 2500.00
conf.default.accounts = {["Cash"] = conf.default.cash, ["Bank"] = conf.default.bank}
conf.default.modifiers = {["Hunger"] = 1, ["Thirst"] = 1, ["Stress"] = 1}
-- jobs
conf.default.job = {["Name"] = "cop", ["Grade"] = 1}
conf.default.jobaccounts = {["Bank"] = 25000.00, ["Safe"] = 0.00}
-- items
conf.default.itemcraft = true
conf.default.itemdegrade = false
-- tax 
conf.default.tax = 10
--
conf.default.skills = {}