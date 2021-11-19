-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
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
            c.data.Initilize(function()
                DisplayRadar(false)
                TriggerServerEvent('Server:PlayerConnecting')
                TriggerServerCallback({
                    eventName = 'GetItems',
                    eventCallback = function(data)
                        c.items = data
                    end
                })
                print(c.table.Dump(c.items))
            end)
            --
            return
        end
    end
end)

