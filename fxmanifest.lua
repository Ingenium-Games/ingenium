------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description "Ingenium Games - Core"
version "0.9.0"
------------------------------------------------------------------------------
lua54 "yes"
ui_page "nui/index.html"
------------------------------------------------------------------------------
shared_scripts {"_config/config.lua", "_config/**/*.lua", "shared/_c.lua"}
------------------------------------------------------------------------------
client_scripts {"client/_var.lua", "shared/[Tools]/*.lua", "shared/[Third Party]/*.lua", "client/_functions.lua",
                "client/**/*.lua"}
------------------------------------------------------------------------------
server_scripts {"@restfx/build/import.lua", "@oxmysql/lib/MySQL.lua", "server/_var.lua", "shared/[Tools]/*.lua",
                "shared/[Third Party]/*.lua", "server/_functions.lua", "server/_cron.lua", "server/[Doors]/_doors.lua",
                "server/**/*.lua"}
------------------------------------------------------------------------------
dependencies {"/onesync", "mysql-async", "discordroles", "ig.dump", "ox_lib"}
------------------------------------------------------------------------------
files {"data/*.json", "nui/index.html", "nui/index.css", "nui/index.js", "nui/img/*.png", "nui/libs/*.js",
       "theme/style.css"}
------------------------------------------------------------------------------
