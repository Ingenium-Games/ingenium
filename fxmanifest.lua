------------------------------------------------------------------------------
fx_version "cerulean"
game "gta5"
author "Twiitchter"
description 'c = exports["ig.core"]:c()'
version "0.7.2"
------------------------------------------------------------------------------
ui_page "nui/ig.core.html"
loadscreen "https://www.ingenium.games/"
loadscreen_cursor 'yes'
------------------------------------------------------------------------------
-- shared
shared_scripts {"conf.lua", "conf.default.lua", "conf.vehicles.lua", "conf.disable.lua", "conf.file.lua",
                "conf.peds.lua", "shared/_c.lua"}
------------------------------------------------------------------------------
-- client
client_scripts {"client/_var.lua", "shared/[Tools]/*.lua", "shared/[Credits]/*.lua", "shared/[Data]/_meta.lua",
                "shared/[Data]/*.lua", "client/_functions.lua", "client/**/*.lua"}
------------------------------------------------------------------------------
-- server
server_scripts {"@mysql-async/lib/MySQL.lua", "server/_var.lua", "shared/[Tools]/*.lua", "shared/[Credits]/*.lua",
                "shared/[Data]/_meta.lua", "shared/[Data]/*.lua", "server/_functions.lua", "server/**/*.lua"}
------------------------------------------------------------------------------
-- client exports
exports {"c", 'RegisterClientCallback', 'UnregisterClientCallback', 'TriggerClientCallback', 'TriggerServerCallback'}
------------------------------------------------------------------------------
-- server exports
server_exports {"c", 'RegisterServerCallback', 'UnregisterServerCallback', 'TriggerClientCallback',
                'TriggerServerCallback'}
------------------------------------------------------------------------------
-- required resources
dependencies {"mysql-async", "discordroles"}
------------------------------------------------------------------------------
-- files
files {"nui/ig.core.js", "nui/ig.core.css", "nui/ig.core.html", "nui/img/*.png", "nui/img/*.jpg",
       "nui/jquery-3.5.1.min.js", "nui/jquery.mask.min.js", "nui/jquery.validate.min.js", "data/Peds.json",
       "data/Names.json", "data/Jobs.json", "data/Drops.json", "data/GSR.json", "data/Items.json", "data/Notes.json",
       "data/Pickups.json"}