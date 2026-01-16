------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
lua54 "yes"
author "Twiitchter"
description "Ingenium"
version "1.0.0"
------------------------------------------------------------------------------
provide "polyzone"
provide "pma-voice"
provide "ig.target"

ui_page "nui/dist/index.html"
------------------------------------------------------------------------------
-- SHARED SCRIPTS (Available to both client and server)
-- Load order is critical: namespaces first, then utilities, then feature modules
shared_scripts {
    -- Core namespace and configuration (MUST be first)
    "_config/config.lua",
    "_config/defaults.lua",
    "_config/banking.lua",
    "_config/chat.lua",
    "_config/dev.lua",
    "_config/disable.lua",
    "_config/discord.lua",
    "_config/files.lua",
    "_config/forced_animations.lua",
    "_config/gamemode.lua",
    "_config/garage.lua",
    "_config/ipls.lua",
    "_config/jobs.lua",
    "_config/peds.lua",
    "_config/phones.lua",
    "_config/screenshot.lua",
    "_config/urls.lua",
    "_config/vehicles.lua",
    "_config/voip.lua",
    
    -- Shared namespace initialization (MUST be before all other shared code)
    "shared/_ig.lua",
    
    -- Core utilities (can be used by everything else)
    "shared/_log.lua",
    "shared/_locale.lua",
    "shared/_protect.lua",
    
    -- Third-party integrations
    "shared/[Third Party]/*.lua",
    
    -- Tools and debug utilities
    "shared/[Tools]/*.lua",
    
    -- Voice system
    "shared/[Voice]/*.lua",
    
    -- Localization
    "locale/*.lua",
}
------------------------------------------------------------------------------
-- CLIENT SCRIPTS (Client-side only, has access to GTA natives)
-- Load order: Initialize state before loading features
client_scripts {
    -- Variable initialization MUST be first
    "client/_var.lua",
    
    -- NUI Wrapper Functions (Client-to-NUI message senders)
    -- MUST load after _var.lua but before NUI callbacks
    "nui/lua/Client-NUI-Wrappers/_character.lua",
    "nui/lua/Client-NUI-Wrappers/_menu.lua",
    "nui/lua/Client-NUI-Wrappers/_input.lua",
    "nui/lua/Client-NUI-Wrappers/_context.lua",
    "nui/lua/Client-NUI-Wrappers/_chat.lua",
    "nui/lua/Client-NUI-Wrappers/_banking.lua",
    "nui/lua/Client-NUI-Wrappers/_inventory.lua",
    "nui/lua/Client-NUI-Wrappers/_garage.lua",
    "nui/lua/Client-NUI-Wrappers/_target.lua",
    "nui/lua/Client-NUI-Wrappers/_hud.lua",
    "nui/lua/Client-NUI-Wrappers/_notification.lua",
    
    -- Core system modules - load before dependent features
    "client/_data.lua",
    "client/_functions.lua",
    "client/_callback.lua",
    
    -- Character and appearance systems
    "client/_affiliation.lua",
    "client/_appearance.lua",
    
    -- Inventory and items
    "client/_inventory.lua",
    "client/_items.lua",
    "client/_status.lua",
    "client/_ammo.lua",
    "client/_weapon.lua",
    
    -- Visual systems
    "client/_blips.lua",
    "client/_markers.lua",
    "client/_cameras.lua",
    "client/_fx.lua",
    "client/_text.lua",
    "client/_ui.lua",
    
    -- World interaction
    "client/_doors.lua",
    "client/_objects.lua",
    "client/_ipls.lua",
    "client/_weather.lua",
    "client/_time.lua",
    
    -- Vehicle systems
    "client/_vehicle.lua",
    "client/_vehicle_persistence.lua",
    
    -- Character state
    "client/_death.lua",
    "client/_animations.lua",
    "client/_modifiers.lua",
    "client/_skills.lua",
    "client/_states.lua",
    "client/_tattoo.lua",
    
    -- Utilities
    "client/_drops.lua",
    "client/_chat.lua",
    "client/_commands.lua",
    "client/_discord.lua",
    "client/_persistance.lua",
    "client/_screenshot.lua",
    
    -- Feature modules (depend on core systems)
    "client/[Callbacks]/*.lua",
    
    -- NUI-Client Callback Handlers (NUI-to-Client message receivers)
    "nui/lua/NUI-Client/character-select.lua",
    "nui/lua/NUI-Client/_appearance.lua",
    "nui/lua/NUI-Client/_menu.lua",
    "nui/lua/NUI-Client/_input.lua",
    "nui/lua/NUI-Client/_context.lua",
    "nui/lua/NUI-Client/_chat.lua",
    "nui/lua/NUI-Client/_banking.lua",
    "nui/lua/NUI-Client/_inventory.lua",
    "nui/lua/NUI-Client/_garage.lua",
    "nui/lua/NUI-Client/_target.lua",
    "nui/lua/NUI-Client/_hud.lua",
    "nui/lua/NUI-Client/_notification.lua",
    
    "client/[Chat]/*.lua",
    "client/[Commands]/*.lua",
    "client/[Data]/*.lua",
    "client/[Dev]/*.lua",
    "client/[Drops]/*.lua",
    "client/[Events]/*.lua",
    "client/[Garage]/*.lua",
    "client/[Target]/*.lua",
    "client/[Threads]/*.lua",
    "client/[ToDo]/*.lua",
    "client/[Voice]/*.lua",
    
    -- Zone system (PolyZone must load first)
    "client/[Zones]/PolyZone.lua",
    "client/[Zones]/BoxZone.lua",
    "client/[Zones]/CircleZone.lua",
    "client/[Zones]/EntityZone.lua",
    "client/[Zones]/ComboZone.lua",
    "client/[Zones]/_zone.lua",
    "client/[Zones]/_zone_manager.lua",
    "client/[Zones]/_zone_test_example.lua",
    
    -- Main client entry point (MUST be last)
    "client/client.lua",
    
    -- NUI scripts
    "nui/lua/*.lua"
}
------------------------------------------------------------------------------
-- SERVER SCRIPTS (Server-side only)
-- Load order: State, database, validation, then features
server_scripts {
    -- Variable initialization MUST be first
    "server/_var.lua",
    
    -- Core system modules
    "server/_data.lua",
    "server/_functions.lua",
    "server/_events.lua",
    "server/_callback.lua",
    "server/_time.lua",
    "server/_cron.lua",
    
    -- Database and persistence (must be before features that use them)
    "server/[SQL]/*.lua",
    
    -- Character and account systems
    "server/_bank.lua",
    "server/_payroll.lua",
    "server/_persistance.lua",
    "server/_save_routine.lua",
    "server/_instance.lua",
    
    -- Security and validation (must be before handlers)
    "server/[Validation]/*.lua",
    "server/[Security]/*.lua",
    
    -- OneSync and synchronization
    "server/[Onesync]/*.lua",
    
    -- Vehicle systems
    "server/_vehicle_persistence.lua",
    
    -- Game systems
    "server/[Appearance]/*.lua",
    "server/[Commands]/*.lua",
    "server/[Data - No Save Needed]/*.lua",
    "server/[Data - Save to File]/*.lua",
    "server/[Deferals]/*.lua",
    "server/[Doors]/*.lua",
    "server/[Events]/*.lua",
    "server/[Garage]/*.lua",
    "server/[Objects]/*.lua",
    
    -- Integration and utilities
    "server/_chat.lua",
    "server/_commands.lua",
    "server/_screenshot.lua",
    "server/_tebex.lua",
    "server/[Third Party]/*.lua",
    "server/[Tools]/*.lua",
    "server/[Voice]/*.lua",
    
    -- Development tools
    "server/[Dev]/*.lua",
    
    -- API and advanced features
    "server/[API]/*.lua",
    
    -- Classes (dependency injection, patterns)
    "server/[Classes]/*.lua",
    
    -- Main server entry point (MUST be last)
    "server/server.lua",
}
------------------------------------------------------------------------------
dependencies {
    "/onesync",
    "freecam",
    "screenshot-basic",
}
------------------------------------------------------------------------------
files {
    "data/*.json",
    "nui/img/*.png",
    "nui/inventory/dist/assets/*.css",
    "nui/inventory/dist/assets/*.js",
    "nui/dist/*.html",
    "nui/dist/assets/*.css",
    "nui/dist/assets/*.js"
}
------------------------------------------------------------------------------
