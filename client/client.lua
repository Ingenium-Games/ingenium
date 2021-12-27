-- ====================================================================================--

--[[
NOTES:
    -
]] --

-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            --    
            TriggerServerEvent("Server:Queue:ConfirmedPlayer")
            c.data.Initilize(function()
                --
                DisplayRadar(false)
                --
                local items = TriggerServerCallback({eventName = "GetItems", args = {}})
                c.item.SetItems(items)
                --
                local jobs = TriggerServerCallback({eventName = "GetJobs", args = {}})
                c.jobs.SetJobs(jobs)
                --
            end)
            --
            return
        end
    end
end)

