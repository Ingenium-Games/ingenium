-- ====================================================================================--
-- ig.zone - Ingenium Zone Management Wrapper (ig.zone initialized in client/_var.lua)
-- Wraps PolyZone functionality for internal Ingenium use
-- 
-- This provides a unified interface for all zone operations within Ingenium
-- and enables future export for PolyZone compatibility with external resources
-- ====================================================================================--

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
-- Note: Zone functionality is exported via the top-level ig table export
-- External resources can access zones via exports.ingenium:GetIngenium().zone
-- ====================================================================================--
