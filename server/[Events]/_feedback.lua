
local nospam = {}

RegisterNetEvent("Feedback", function(message, url)
    local src = source
    local xPlayer = c.data.GetPlayer(src)
    if not nospam[src] then
        nospam[src] = true
        c.func.Discord(conf.url.feedback, 11216719, xPlayer.GetName(), message, c.table.Dump(xPlayer.GetCoords()))
        -- c.func.Discorse(message, url, xPlayer.GetName(), xPlayer.GetCoords())
    else
        xPlayer.Notify("Please wait a while before trying to submit more feedback.")
    end
end)

Citizen.CreateThread(function()
    while (true) do
        nospam = {}
        Citizen.Wait(60000)
    end
end)