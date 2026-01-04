------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description "Ingenium"
version "1.0.0"
------------------------------------------------------------------------------
provide "polyzone"
--
ui_page "nui/dist/index.html"
------------------------------------------------------------------------------
shared_scripts {
    "_config/config.lua",
    "_config/**/*.lua",
    "shared/_ig.lua",
    "shared/[Tools]/*.lua",
    "shared/[Third Party]/*.lua",
    "shared/_locale.lua",
    "shared/_protect.lua"
}
------------------------------------------------------------------------------
client_scripts {
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
    -- IPL management (must load after zones)
    "client/_ipls.lua",
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
    "server/**/*.lua"
}
------------------------------------------------------------------------------
dependencies {
    "/onesync",
    "discordroles",
    "restfx",
    "freecam",
    "sit",
    "screenshot-basic"
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
