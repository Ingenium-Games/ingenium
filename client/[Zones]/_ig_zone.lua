-- ====================================================================================--
-- ig.zone - Ingenium Zone Management Wrapper
-- Wraps PolyZone functionality for internal Ingenium use
-- 
-- This provides a unified interface for all zone operations within Ingenium
-- and enables future export for PolyZone compatibility with external resources
-- ====================================================================================--

-- Initialize the ig.zone namespace
ig.zone = {}

-- Map zone types to their respective classes
-- These reference the PolyZone classes loaded from client/[Zones]/ files
ig.zone.Poly = PolyZone
ig.zone.Box = BoxZone
ig.zone.Circle = CircleZone
ig.zone.Entity = EntityZone
ig.zone.Combo = ComboZone

-- Helper functions for quick access
ig.zone.GetPlayerPosition = PolyZone.getPlayerPosition
ig.zone.GetPlayerHeadPosition = PolyZone.getPlayerHeadPosition
ig.zone.EnsureMetatable = PolyZone.ensureMetatable

-- ====================================================================================--
-- Export the zone namespace for external resource compatibility (future use)
-- This will allow other resources to use Ingenium's PolyZone implementation
-- ====================================================================================--
exports("GetZone", function()
	return ig.zone
end)

-- ====================================================================================--
