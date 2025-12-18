------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description "Ingenium"
version "0.9.0"
------------------------------------------------------------------------------
lua54 "yes"
-- New Vue 3 NUI system (comment out to use old system)
ui_page "nui/dist/index.html"
-- Old NUI system (uncomment to use old system)
-- ui_page "nui/index.html"
------------------------------------------------------------------------------
shared_scripts {"_config/config.lua", "_config/**/*.lua", "shared/_ig.lua",    "shared/[Tools]/*.lua",    "shared/[Third Party]/*.lua", "shared/_locale.lua"}
------------------------------------------------------------------------------
client_scripts {"client/_var.lua", "locale/*.lua", "shared/[Tools]/*.lua", "shared/[Third Party]/*.lua", "client/_functions.lua",
                "client/[Data]/_game_data_helpers.lua", "client/**/*.lua", "nui/lua/*.lua"}
------------------------------------------------------------------------------
-- SQL Handler (must load before other server scripts)
server_scripts {
    "@restfx/build/import.lua",
    "server/_var.lua",
    "locale/*.lua",
    "server/[SQL]/_pool.js",
    "server/[SQL]/_query.js", 
    "server/[SQL]/_transaction.js",
    "server/[SQL]/_handler.lua",
    "server/[SQL]/_compatibility.lua",
    "server/_functions.lua",
    "server/_cron.lua",
    "server/[Doors]/_doors.lua",
    "server/[Security]/*.lua",
    "server/[Validation]/*.lua",
    "server/[Data]/_loader.lua",
    "server/[Data]/_game_data_helpers.lua",
    "server/[Data]/_ped_helpers.lua",
    "server/[Data]/_save_routine.lua",
    "server/[Tools]/_memory.lua",
    "server/[SQL]/_bank.lua",
    "server/[SQL]/_character.lua",
    "server/[SQL]/_gen.lua",
    "server/[SQL]/_jobs.lua",
    "server/[SQL]/_objects.lua",
    "server/[SQL]/_saves.lua",
    "server/[SQL]/_users.lua",
    "server/[SQL]/_vehicles.lua",
    "server/**/*.lua"
}
------------------------------------------------------------------------------
dependencies {"/onesync", "discordroles", "restfx"}
------------------------------------------------------------------------------
files {"data/*.json", "nui/index.html", "nui/css/*.css", "nui/js/*.js", "nui/img/*.png", "nui/libs/*.js",
       "nui/inventory/dist/assets/*.css", "nui/inventory/dist/assets/*.js", "nui/dist/*.html", "nui/dist/assets/*.css", "nui/dist/assets/*.js"}
------------------------------------------------------------------------------
