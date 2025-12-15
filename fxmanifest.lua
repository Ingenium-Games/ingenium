------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description "Ingenium Games - Core"
version "0.9.0"
------------------------------------------------------------------------------
lua54 "yes"
-- New Vue 3 NUI system (comment out to use old system)
ui_page "nui/dist/index.html"
-- Old NUI system (uncomment to use old system)
-- ui_page "nui/index.html"
------------------------------------------------------------------------------
shared_scripts {"_config/config.lua", "_config/**/*.lua", "shared/_c.lua", "shared/_locale.lua"}
------------------------------------------------------------------------------
client_scripts {"client/_var.lua", "locale/*.lua", "shared/[Tools]/*.lua", "shared/[Third Party]/*.lua", "client/_functions.lua",
                "client/**/*.lua", "nui/lua/*.lua"}
------------------------------------------------------------------------------
server_scripts {"@restfx/build/import.lua", "@oxmysql/lib/MySQL.lua", "server/_var.lua", "locale/*.lua", "shared/[Tools]/*.lua",
                "shared/[Third Party]/*.lua", "server/_functions.lua", "server/_cron.lua", "server/[Doors]/_doors.lua",
                "server/[Security]/*.lua","server/[Validation]/*.lua", "server/[Data]/_loader.lua",
                "server/[Data]/_save_routine.lua", "server/[Tools]/_memory.lua", "server/**/*.lua"}
------------------------------------------------------------------------------
dependencies {"/onesync", "mysql-async", "discordroles", "ig.dump", "ox_lib"}
------------------------------------------------------------------------------
files {"data/*.json", "nui/index.html", "nui/css/*.css", "nui/js/*.js", "nui/img/*.png", "nui/libs/*.js",
       "nui/inventory/dist/assets/*.css", "nui/inventory/dist/assets/*.js"}
------------------------------------------------------------------------------
