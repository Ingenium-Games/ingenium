
RegisterNetEvent("Feedback", function(message)
    local src = source
    local xPlayer = c.data.GetData(src)
    c.func.Discord(conf.url.feedback, 'fff', xPlayer.GetName(), message, '')
end)