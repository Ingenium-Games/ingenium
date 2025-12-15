-- ====================================================================================--
-- Interaction System - Animations Configuration
-- Migrated from ig.interact/conf.anim.lua
-- ====================================================================================--

conf = conf or {}
conf.interact = conf.interact or {}
conf.interact.anim = {}

-- ====================================================================================--
-- Animation Definitions
-- ====================================================================================--

-- Animation dictionary and name mappings
conf.interact.anim.list = {
    -- Example animations
    -- {
    --     name = "handsup",
    --     dict = "missminuteman_1ig_2",
    --     anim = "handsup_base",
    --     flags = 49,
    -- }
}

-- Animation settings
conf.interact.anim.settings = {
    cancelOnMove = true,     -- Cancel animation when player moves
    cancelOnDamage = true,   -- Cancel animation when player takes damage
    upperBodyOnly = false,   -- Animation affects full body by default
}

-- Scenario animations (simpler than full animations)
conf.interact.anim.scenarios = {
    -- "WORLD_HUMAN_SMOKING",
    -- "WORLD_HUMAN_AA_COFFEE",
    -- Add scenarios during migration
}

c.func.Debug_1("Animations configuration loaded (placeholder)")
