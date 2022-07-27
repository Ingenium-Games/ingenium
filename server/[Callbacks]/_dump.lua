-- ====================================================================================--

local GetDump = RegisterServerCallback({
    eventName = "GetDump",
    eventCallback = function(source, dump)
        if dump == "peds" then
            return exports["ig.dump"]:GetPeds()
        elseif dump == "tattoos" then
            return exports["ig.dump"]:GetTattoos()
        elseif dump == "zones" then
            return exports["ig.dump"]:GetZones()
        elseif dump == "weapons" then
            return exports["ig.dump"]:GetWeapons()
        elseif dump == "vehicles" then
            return exports["ig.dump"]:GetVehicles()
        elseif dump == "vehiclemodkits" then
            return exports["ig.dump"]:GetVehicleModKits()
        elseif dump == "cctvs" then
            return exports["ig.dump"]:GetCCTV()
        end
    end
})
