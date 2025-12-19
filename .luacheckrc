-- Luacheck configuration for ingenium
std = "lua53"

globals = {
  "Citizen", "RegisterNetEvent", "AddEventHandler", "TriggerEvent", "TriggerServerEvent",
  "TriggerClientEvent", "exports", "conf", "c", "vec3", "GetPlayerPed", "GetPlayers",
  "GetEntityCoords", "GetHashKey", "CreateThread", "Wait", "PerformHttpRequest", "json",
  "BeginTextCommandBusyspinnerOn", "EndTextCommandBusyspinnerOn", "BusyspinnerOff", "PreloadBusyspinner",
  "DoScreenFadeOut", "DoScreenFadeIn", "IsScreenFadedOut", "IsScreenFadedIn", "IsScreenFadingIn", "IsScreenFadingOut",
}

-- Ignore generated natives stubs and large generated files
exclude_files = {
  "client/fivem_natives.lua",
  "fivem_natives_all.lua",
  "client/fivem_natives_client.lua",
  "server/fivem_natives_server.lua",
}

# allow long lines in generated or data files
max_line_length = 120
