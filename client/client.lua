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
                c.items = TriggerServerCallback({
                    eventName = 'GetItems',
                    eventCallback = function(data)
                        return data
                    end
                })
                print(c.table.Dump(c.items))
            end)
            --
            return
        end
    end
end)

