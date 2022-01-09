------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description "Ingenium Games - Core"
version "0.9.0"
------------------------------------------------------------------------------
lua54 "yes"
ui_page "nui/index.html"
loadscreen "https://www.ingenium.games/"
loadscreen_cursor "yes"
loadscreen_manual_shutdown 'yes'
------------------------------------------------------------------------------
shared_scripts {"conf.lua", "conf.default.lua", "conf.vehicles.lua", "conf.disable.lua", "conf.file.lua", "conf.peds.lua", "shared/_c.lua"}
------------------------------------------------------------------------------
client_scripts {"client/_var.lua", "shared/[Tools]/*.lua", "shared/[Credits]/*.lua", "shared/[Data]/_meta.lua", "shared/[Data]/*.lua", "client/_functions.lua", "client/**/*.lua"}
------------------------------------------------------------------------------
server_scripts {"@mysql-async/lib/MySQL.lua", "server/_var.lua", "shared/[Tools]/*.lua", "shared/[Credits]/*.lua", "shared/[Data]/_meta.lua", "shared/[Data]/*.lua", "server/_functions.lua", "server/**/*.lua"}
------------------------------------------------------------------------------
dependencies {"/onesync", "mysql-async", "discordroles", "ig.dump"}
------------------------------------------------------------------------------
files {"data/*.json", "nui/index.html", "nui/index.css", "nui/index.js", "nui/img/*.png", "nui/libs/*.js"}