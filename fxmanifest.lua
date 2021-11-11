------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description "Ingenium Games - Core"
version "0.8.0"
------------------------------------------------------------------------------
lua54 "yes"
loadscreen "https://www.ingenium.games/"
loadscreen_cursor "yes"
------------------------------------------------------------------------------
shared_scripts {"conf.lua", "conf.default.lua", "conf.vehicles.lua", "conf.disable.lua", "conf.file.lua", "conf.peds.lua", "shared/_c.lua"}
------------------------------------------------------------------------------
client_scripts {"client/_var.lua", "shared/[Tools]/*.lua", "shared/[Credits]/*.lua", "shared/[Data]/_meta.lua", "shared/[Data]/*.lua", "client/_functions.lua", "client/**/*.lua"}
------------------------------------------------------------------------------
server_scripts {"@mysql-async/lib/MySQL.lua", "server/_var.lua", "shared/[Tools]/*.lua", "shared/[Credits]/*.lua", "shared/[Data]/_meta.lua", "shared/[Data]/*.lua", "server/_functions.lua", "server/**/*.lua"}
------------------------------------------------------------------------------
exports {"c", "RegisterClientCallback", "UnregisterClientCallback", "TriggerClientCallback", "TriggerServerCallback"}
------------------------------------------------------------------------------
server_exports {"c", "RegisterServerCallback", "UnregisterServerCallback", "TriggerClientCallback", "TriggerServerCallback"}
------------------------------------------------------------------------------
dependencies {"/onesync","mysql-async","discordroles"}
------------------------------------------------------------------------------
files {"data/Peds.json","data/Names.json", "data/Jobs.json", "data/Drops.json", "data/GSR.json", "data/Items.json", "data/Notes.json", "data/Pickups.json"}