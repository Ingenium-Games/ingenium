-- ====================================================================================--
-- Interaction System - Bins Configuration
-- Migrated from ig.interact/conf.bins.lua
-- ====================================================================================--

conf = conf or {}
conf.interact = conf.interact or {}
conf.interact.bins = {}

-- ====================================================================================--
-- Bin Locations and Settings
-- ====================================================================================--

-- Example bin configuration structure
-- To be populated during full ig.interact migration
conf.interact.bins.locations = {
    -- Example:
    -- {
    --     coords = vector3(x, y, z),
    --     model = `prop_bin_01a`,
    --     items = {"trash", "recyclable"},
    -- }
}

-- Bin interaction settings
conf.interact.bins.settings = {
    searchRadius = 2.0,      -- Radius to detect bin interaction
    searchCooldown = 5000,   -- Cooldown between searches (ms)
    lootChance = 0.3,        -- 30% chance to find items
}

-- Possible loot items from bins
conf.interact.bins.loot = {
    -- {item = "water_bottle", chance = 0.1, min = 1, max = 1},
    -- {item = "burger", chance = 0.05, min = 1, max = 1},
    -- Add items during migration
}

c.func.Debug_1("Bins configuration loaded (placeholder)")
