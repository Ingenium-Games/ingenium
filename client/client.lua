-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--[[
NOTES:
    -
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            --    
            c.data.Initilize(function()
                DisplayRadar(false)
                TriggerServerEvent('Server:PlayerConnecting')
            end)
            --
            return
        end
    end
end)

