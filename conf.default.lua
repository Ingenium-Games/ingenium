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

conf.default.cash = 25.00
conf.default.bank = 500.00
conf.default.accounts = {
    Cash = conf.default.cash,
    Bank = conf.default.bank
}
conf.default.modifiers = {
    Hunger = 1,
    Thirst = 1,
    Stress = 1
}
conf.default.stats = {
    Hunger = 100, -- Min 0 Max 100
    Thirst = 100, -- Min 0 Max 100
    Stress = 0 -- Min 0 Max 100
}
-- jobs
conf.default.job = {
    Name = "none",
    Grade = 1
}
conf.default.jobaccounts = {
    Bank = 5000.00,
    Safe = 0.00
}
-- items
conf.default.itemcraft = true
conf.default.itemdegrade = false
-- tax 
conf.default.tax = 10
-- 
conf.default.skills = {
    -- General Repair
    Mechanics = 0,
    -- Moulds and Building
    Engineering = 0,
    -- Weaponry
    Gunsmithy = 0,
    -- Electrical goods
    Electronics = 0,
    -- Knowledge of plants
    Botany = 0,
    -- Built by Labour
    Physique = 0
}
