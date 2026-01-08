-- ====================================================================================--
-- ig.target - Integrated targeting system
-- ====================================================================================--

-- Initialize target namespace
ig.target = {}

-- Global variables for targeting system
MaxTargetDistance = 7.0
Debug = false

-- Cache for entity lookups (initialized by main.lua)
cache = cache or {}

-- Zones table (initialized by lib.lua)
Zones = {}

-- ====================================================================================--
