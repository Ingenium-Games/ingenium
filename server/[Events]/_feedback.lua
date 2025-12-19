
local nospam = {}

RegisterNetEvent("Feedback", function(message, url)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    if not nospam[src] then
        nospam[src] = true
        ig.func.Discord(conf.url.feedback, 11216719, xPlayer.GetName(), message, ig.table.Dump(xPlayer.GetCoords()))
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