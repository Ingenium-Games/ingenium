-- ====================================================================================--
if not conf then conf = {} end
conf.default = {}
-- ====================================================================================--

-- Accounts 
conf.default.accounts = {
    Bank = 500.00,
    Bitcoin = 0.00,
}

-- Default skills ever new character has.
conf.default.skills = {}

-- Default Job and Accounts for new jobs found in the DB.
conf.default.job = {
    Name = "none",
    Grade = 1
}
conf.default.jobaccounts = {
    Bank = 5000.00,
    Safe = 0.00
}

-- Defaults for modifier and statuses of characters
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
conf.default.selfdamage = 3


-- Enable Item Craft / Degarde
conf.default.itemcraft = true
conf.default.itemdegrade = false

-- City job tax rate on all payments
conf.default.tax = 10.00