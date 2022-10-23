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
shared_scripts {"conf.lua", "conf.default.lua", "conf.vehicles.lua", "conf.disable.lua", "conf.file.lua", "conf.peds.lua", "conf.phone.lua", "shared/_c.lua"}
------------------------------------------------------------------------------
client_scripts {"client/_var.lua", "shared/[Tools]/*.lua", "shared/[Third Party]/*.lua", "client/_functions.lua", "client/**/*.lua"}
------------------------------------------------------------------------------
server_scripts {"@restfx/build/import.lua", "@mysql-async/lib/MySQL.lua", "server/_var.lua", "shared/[Tools]/*.lua", "shared/[Third Party]/*.lua", "server/_functions.lua", "server/**/*.lua"}
------------------------------------------------------------------------------
dependencies {"/onesync", "mysql-async", "discordroles", "ig.dump"}
------------------------------------------------------------------------------
files {"data/*.json", "nui/index.html", "nui/index.css", "nui/index.js", "nui/img/*.png", "nui/libs/*.js", "theme/style.css"}
------------------------------------------------------------------------------
chat_theme "core" {
    styleSheet = "theme/style.css",
    msgTemplates = {
        core = '<div id="notification" class="noisy"><div id="color-box" style="background-color: {1};" class="noisy"></div><div id="info"><div id="top-info"><div id="left-info"><h1 id="title"><i class="{2}"></i></h1><h2 id="sub-title">{3}</h2></div><h2 id="time">{4}</h2></div><div id="bottom-info"><br><p id="text">{0}</p></div></div>'
    }
}