-- ====================================================================================--
-- Interaction System - Peds Configuration
-- Migrated from ig.interact/conf.peds.lua
-- ====================================================================================--

conf = conf or {}
conf.interact = conf.interact or {}
conf.interact.peds = {}

-- ====================================================================================--
-- Interaction Ped Locations and Settings
-- ====================================================================================--

-- Example interaction ped configuration structure
-- To be populated during full ig.interact migration
conf.interact.peds.locations = {
    -- Example:
    -- {
    --     coords = vector3(x, y, z),
    --     heading = 0.0,
    --     model = `a_m_y_business_01`,
    --     scenario = "WORLD_HUMAN_CLIPBOARD",
    --     interaction = "job_menu",
    -- }
}

-- Ped interaction settings
conf.interact.peds.settings = {
    interactRadius = 2.5,    -- Radius to show interaction prompt
    renderDistance = 50.0,   -- Distance to render peds
    freezePeds = true,       -- Freeze interaction peds
    invincible = true,       -- Make peds invincible
}

c.func.Debug_1("Peds configuration loaded (placeholder)")
