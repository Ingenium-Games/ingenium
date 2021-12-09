-- ====================================================================================--

function core_Queue(src, name, data, d)
    local src = src
    Citizen.Wait(0)
    d.update("Adding "..name..", to queue system and applying priotity if enabled")
    Citizen.Wait(1000)
    if data.Priority then
        Queue.AddPriority(tostring(data.IP_Address), 10)
    end
    d.done()
end