-- ====================================================================================--

-- ====================================================================================--
local DataPacket = RegisterClientCallback({
    eventName = "DataPacket",
    eventCallback = function()
        local data = false
        if ig.data.GetLoadedStatus() then
            ig.func.IsBusy()
            Citizen.Wait(50)
            data = ig.data.Packet()
            Citizen.Wait(50)
            ig.func.NotBusy()
        end
        return data
    end
})