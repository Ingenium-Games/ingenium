-- ====================================================================================--
-- Forced Animation Configuration
-- Server-side configuration for forced animation mechanics
-- Data-driven: Uses weapons.json categories instead of hardcoded weapon hashes
-- ====================================================================================--
conf.forcedAnimations = {}

-- Maximum distance for forced animations
conf.forcedAnimations.maxDistance = 15.0

-- Cooldown between forced animation triggers (in seconds)
conf.forcedAnimations.cooldown = 2.0

-- Require target to be unarmed for hands up (checks GROUP_UNARMED and GROUP_MELEE from weapons.json)
conf.forcedAnimations.requireUnarmedForHandsUp = true

-- Require line of sight for forced animations
conf.forcedAnimations.requireLineOfSight = true

-- Job-based permission mode:
-- nil = disabled (anyone can force animations)
-- "requireJob" = only players with authorized jobs can force animations
-- "noJobPermission" = only players WITHOUT authorized jobs can force animations
conf.forcedAnimations.jobPermissionMode = nil

-- Job-based permissions (jobs that are authorized or unauthorized based on jobPermissionMode)
conf.forcedAnimations.authorizedJobs = {
    ["police"] = true,
    ["sheriff"] = true,
    ["ambulance"] = true,
    ["fib"] = true,
}

-- Allow players to force animations on others when aiming
conf.forcedAnimations.enableAimingMechanic = true

-- Weapon categories that are considered "unarmed" for forced animations
-- These map to the "Category" field in weapons.json
-- The system automatically builds a table of all weapons in these categories
conf.forcedAnimations.allowedWeaponCategories = {
    "GROUP_UNARMED",    -- Unarmed/fists
    "GROUP_MELEE",      -- Melee weapons (knives, bats, etc.)
}

-- Logging
conf.forcedAnimations.enableLogging = true

-- Discord webhook for logging (optional)
conf.forcedAnimations.discordWebhook = nil