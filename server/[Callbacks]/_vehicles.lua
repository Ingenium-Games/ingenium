-- ====================================================================================--
local EnsureVehicle = RegisterServerCallback({
    eventName = "EnsureVehicle",
    eventCallback = function(source, net)
        local ent = NetworkGetEntityFromNetworkId(net)
        local net = NetworkGetNetworkIdFromEntity(ent)
        local model = GetEntityModel(ent)
        local type = GetEntityType(ent)
        --
        if type == 2 then
            if DoesEntityExist(ent) then
                c.data.AddVehicle(net, c.class.Vehicle, net)
            end
        end
        --
        return true
    end
})