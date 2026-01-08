-- ====================================================================================--
-- Development Tools Configuration
-- ====================================================================================--

if not conf then conf = {} end
if not conf.dev then conf.dev = {} end

-- Version check URL for development tools
conf.dev.version_check_url = "https://raw.githubusercontent.com/Ingenium-Games/ig.dev/main/version.txt"

-- Enable/disable development tools (set to false in production)
conf.dev.enabled = true

-- Debug visualization settings
conf.dev.debug = {
    draw_text_3d = true,  -- Enable 3D text debug drawing
    show_vehicles = false,  -- Show vehicle debug info
    show_objects = false,   -- Show object debug info
}

-- Door creator settings
conf.dev.door_creator = {
    enabled = true,
    raycast_distance = 10.0,
}

-- Vehicle seats interaction settings
conf.dev.vehicle_seats = {
    enabled = true,
}

-- Ammunation locations (for development reference)
conf.dev.ammunation_locations = {
    -- Will be populated from _ammunation.lua
}

-- ====================================================================================--
