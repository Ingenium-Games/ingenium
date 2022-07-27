-- ====================================================================================--
--[[
NOTES.
    - Updated to PMC callbacks v2, with alerations to ensure it works?
]] --
-- ====================================================================================--
local DataPacket = RegisterClientCallback({
    eventName = "DataPacket",
    eventCallback = function()
        local data = false
        if c.data.GetLoadedStatus() then
            c.func.IsBusy()
            Citizen.Wait(500)
            data = c.data.Packet()
            Citizen.Wait(500)
            c.func.NotBusy()
        end
        return data
    end
})