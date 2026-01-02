
local nospam = {}

-- Migrated to callback for security
RegisterServerCallback({
    eventName = "Feedback",
    eventCallback = function(source, message, url)
        local src = source
        local xPlayer = ig.data.GetPlayer(src)
        if not xPlayer then
            return { success = false, error = "Player not found" }
        end
        
        if not nospam[src] then
            nospam[src] = true
            ig.func.Discord(conf.url.feedback, 11216719, xPlayer.GetName(), message, ig.table.Dump(xPlayer.GetCoords()))
            return { success = true }
        else
            xPlayer.Notify("Please wait a while before trying to submit more feedback.")
            return { success = false, error = "Rate limited" }
        end
    end
})

Citizen.CreateThread(function()
    while (true) do
        nospam = {}
        Citizen.Wait(60000)
    end
end)