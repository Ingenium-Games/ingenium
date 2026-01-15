-- ====================================================================================--
-- Shared Namespace Initialization
-- Centralizes all table declarations for shared code
-- ====================================================================================--
ig = {}

-- Utility and Helper Functions
ig.check = {}      -- Validation and checking functions
ig.game = {}       -- Game mode utilities
ig.json = {}       -- JSON parsing utilities
ig.rng = {}        -- Random number generation
ig.math = {}       -- Math utilities (wrapper for shared math functions)
ig.util = {}       -- General utilities
ig.table = {}      -- Table manipulation utilities
ig.file = {}       -- File operations
ig.func = {}       -- Generic functions (shared across all contexts)

-- ====================================================================================--
-- Logging and Debugging
-- ====================================================================================--
ig.log = {}                                   -- Logging functions
ig.log.error = nil                            -- Error logging alias
ig.log.warn = nil                             -- Warning logging alias
ig.log.info = nil                             -- Info logging alias
ig.log.debug = nil                            -- Debug logging alias
ig.log.trace = nil                            -- Trace logging alias
ig.log.log = nil                              -- Generic log alias

ig.debug = {}                                 -- Debug utilities
ig.debug.levels = {}                          -- Debug level definitions
ig.debug.colors = {}                          -- Debug color definitions

ig.func.Alert = nil                           -- Alert function alias

-- ====================================================================================--
-- Voice Communication
-- ====================================================================================--
ig.voip = {}                                  -- Voice system
ig.voip.VoiceModes = {}                       -- Voice mode definitions
ig.voip.StateType = {}                        -- Voice state types

-- ====================================================================================--
-- GLM (Math Library) Integration - Global Setup
-- ====================================================================================--
-- GLM is a FiveM provided resource that extends math capabilities
-- Loading it on shared side makes it available globally to all contexts
ig._glm_loaded = false
local ok, glm = pcall(require, "glm")
if ok and glm then
    ig.glm = glm
    -- Set GLM as the global math library
    -- This allows all code to use math.* functions with GLM enhancements
    _G.math = glm
	-- DECLARE AFTER ITS MOUNTED
	ig._glm_loaded = true
else
    -- Fallback: if GLM fails to load, math remains Lua standard library
    -- This ensures compatibility if GLM resource is not available
    ig._glm_loaded = false
end

-- ====================================================================================--
-- Core Export
exports("GetIngenium", function()
	return ig
end)
-- ====================================================================================--
-- Locale Export
exports("GetLocale", function()
	return conf.locale
end)
-- ====================================================================================--
