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
    -- Output options for door configurations
    output = {
        console = true,        -- Print to console
        file = true,           -- Save to file
        location = "local",    -- "local" or "server" - where to save files
        file_path = "door_configs/",  -- Relative path for saved configurations
    },
}

-- Vehicle seats interaction settings
conf.dev.vehicle_seats = {
    enabled = true,
}

-- Ammunation locations (for development reference)
conf.dev.ammunation_locations = {
    -- Will be populated from _ammunation.lua
}

-- Global development output settings
-- These apply to all dev commands and tools
conf.dev.output = {
    -- Console output settings
    console = {
        enabled = true,
        use_colors = true,  -- Use colored output
        verbose = false,    -- Show detailed debug information
    },
    
    -- File output settings
    file = {
        enabled = true,
        location = "local",  -- "local" = client-side files, "server" = server-side files
        base_path = "dev_output/",  -- Base directory for all dev output files
        timestamp = true,   -- Include timestamp in filenames
        format = "lua",     -- "lua", "json", or "txt"
    },
    
    -- Collaboration settings
    collaboration = {
        share_output = false,  -- Allow output to be shared with other developers
        export_format = "json",  -- Format for shared exports: "json" or "lua"
        include_metadata = true,  -- Include creator, timestamp, etc.
    },
}

-- Command-specific output overrides
-- Individual commands can override global settings
conf.dev.commands = {
    door_creator = {
        output = {
            console = true,
            file = true,
            location = "local",
        },
    },
    debug_draw = {
        output = {
            console = true,
            file = false,
        },
    },
}

-- ====================================================================================--
