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
                --
                DisplayRadar(false)
                --
                local items = TriggerServerCallback({eventName = "GetItems", args = {}})
                c.item.SetItems(items)
            end)
            --
            return
        end
    end
end)

