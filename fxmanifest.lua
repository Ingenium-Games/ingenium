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
--
ui_page "nui/dist/index.html"
------------------------------------------------------------------------------
shared_scripts {
    "_config/config.lua",
    "_config/**/*.lua",
    "shared/_ig.lua",
    "shared/[Tools]/*.lua",
    "shared/[Third Party]/*.lua",
    "shared/[Voice]/_voip.lua",
    "shared/_locale.lua",
    "shared/_protect.lua"
}
------------------------------------------------------------------------------
client_scripts {
    "@glm/init.lua",
    "client/_var.lua",
    "locale/*.lua",
    "shared/[Tools]/*.lua",
    "shared/[Third Party]/*.lua",
    "client/_callback.lua",
    "client/_functions.lua",
    "client/[Data]/_game_data_helpers.lua",
    -- PolyZone integration (must load before ig.zone wrapper)
    "client/[Zones]/PolyZone.lua",
    "client/[Zones]/BoxZone.lua",
    "client/[Zones]/CircleZone.lua",
    "client/[Zones]/EntityZone.lua",
    "client/[Zones]/ComboZone.lua",
    "client/[Zones]/_ig_zone.lua",
    -- Target system (must load after zones, requires glm)
    "client/[Target]/_var.lua",
    "client/[Target]/_lib.lua",
    "client/[Target]/_utils.lua",
    "client/[Target]/_api.lua",
    "client/[Target]/_defaults.lua",
    "client/[Target]/_main.lua",
    -- Development tools (requires target system)
    "client/[Dev]/_var.lua",
    "client/[Dev]/_debug.lua",
    "client/[Dev]/_ammunation.lua",
    "client/[Dev]/_doorcreator.lua",
    "client/[Dev]/_vehicleseats.lua",
    -- Garage system (requires target system and SQL)
    "client/[Garage]/_var.lua",
    "client/[Garage]/_client.lua",
    "client/[Garage]/_blips.lua",
    "client/[Garage]/_machine.lua",
    -- IPL management (must load after zones)
    "client/_ipls.lua",
    -- VOIP system (loads before other client scripts for early initialization)
    "client/[Voice]/_voip.lua",
    -- PMA-Voice compatibility wrapper (loads last for exports)
    "shared/[Voice]/_pma_wrapper.lua",
    -- Other client scripts
    "client/**/*.lua",
    "nui/lua/*.lua"
}
------------------------------------------------------------------------------
server_scripts {
    "@restfx/build/import.lua",
    "server/_var.lua",
    "locale/*.lua",
    "server/_functions.lua",
    "server/_cron.lua",
    "server/[Doors]/_doors.lua",
    "server/[Security]/*.lua",
    "server/[Validation]/*.lua",
    "server/[Tools]/_memory.lua",
    "server/[SQL]/_handler.lua",    
    "server/[SQL]/_bank.lua",
    "server/[SQL]/_character.lua",
    "server/[SQL]/_gen.lua",
    "server/[SQL]/_saves.lua",
    "server/[SQL]/_users.lua",
    "server/[SQL]/_vehicles.lua",
    -- Development tools (server-side commands)
    "server/[Dev]/_var.lua",
    "server/[Dev]/_commands.lua",
    -- Garage system (server-side logic and callbacks)
    "server/[Garage]/_var.lua",
    "server/[Garage]/_callbacks.lua",
    "server/[Garage]/_server.lua",
    -- VOIP system (loads before other server scripts)
    "server/[Voice]/_voip.lua",
    -- PMA-Voice compatibility wrapper (loads last for exports)
    "shared/[Voice]/_pma_wrapper.lua",
    "server/**/*.lua"
}
------------------------------------------------------------------------------
dependencies {
    "/onesync",
    "discordroles",
    "restfx",
    "freecam",
    "sit",
    "screenshot-basic",
    "glm"
}
------------------------------------------------------------------------------
files {
    "data/*.json",
    "nui/index.html",
    "nui/css/*.css",
    "nui/js/*.js",
    "nui/img/*.png",
    "nui/libs/*.js",
    "nui/inventory/dist/assets/*.css",
    "nui/inventory/dist/assets/*.js",
    "nui/dist/*.html",
    "nui/dist/assets/*.css",
    "nui/dist/assets/*.js"
}
------------------------------------------------------------------------------
