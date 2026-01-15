-- ====================================================================================--
--[[
NOTES.
    - These are the events within the OneSync Server events found at :
    - https://docs.fivem.net/docs/scripting-reference/events/server-events/


GetEntityType( entity )
0 = no entity
1 = ped
2 = vehicle
3 = object
]] --

-- ====================================================================================--

AddEventHandler("weaponDamageEvent", function()

end)

AddEventHandler("vehicleComponentControlEvent", function()

end)

AddEventHandler("respawnPlayerPedEvent", function()

end)

AddEventHandler("explosionEvent", function()
    --CancelEvent()
    --ig.func.Debug_1("Explosion has been Cancelled.")
end)

AddEventHandler("entityCreated", function(ent)
    local net = NetworkGetNetworkIdFromEntity(ent)
    local model = GetEntityModel(ent)
    local type = GetEntityType(ent)

    if DoesEntityExist(ent) then
        -- Object
        if type == 3 then
            if not conf.disable.objects[model] then
                ig.object.AddObject(net, ig.class.BlankObject, net)                      
            else
                DeleteEntity(ent)
                ig.func.Debug_1("Object has been Deleted.")
            end
        --
        -- Vehicle
        elseif type == 2 then
            if not conf.disable.vehicles[model] then                        
                ig.vehicle.AddVehicle(net, ig.class.Vehicle, net, false)
            else
                DeleteEntity(ent)
                ig.func.Debug_1("Vehicle has been Deleted.")
            end
        --
        -- Ped
        elseif type == 1 then
            if not conf.disable.peds[model] then                        
                -- not a human player
                if not IsPedAPlayer(ent) then
                    ig.npc.AddNpc(net, ig.class.Npc, net)
                else
                -- is a player

                end
            else
                DeleteEntity(ent)
                ig.func.Debug_1("Ped has been Deleted.")
            end
        -- no other types // fin
        end
    end
end)

AddEventHandler("entityCreating", function(ent)
    local net = NetworkGetNetworkIdFromEntity(ent)
    local model = GetEntityModel(ent)
    local type = GetEntityType(ent)
    --
    -- Object
    if type == 3 then
        if conf.disable.objects[model] then
            ig.func.Debug_1("Object prevented from Spawning.")
            CancelEvent()
        end
    --
    -- Vehicle
    elseif type == 2 then            
        if conf.disable.vehicles[model] then
            ig.func.Debug_1("Vehicle prevented from Spawning.")
            CancelEvent()
        end
    --
    -- Ped
    elseif type == 1 then
        -- not a human player
        if not IsPedAPlayer(ent) then
            if conf.disable.peds[model] then
                ig.func.Debug_1("Ped prevented from Spawning.")
                CancelEvent()
            end
        else
        -- is a player
            
        end
    end
end)

AddEventHandler("entityRemoved", function(ent)
    local net = NetworkGetNetworkIdFromEntity(ent)
    local model = GetEntityModel(ent)
    local type = GetEntityType(ent)
    
    -- Object
    if type == 3 then
        ig.object.RemoveObject(net)
    -- Vehicle
    elseif type == 2 then            
        ig.vehicle.RemoveVehicle(net)
   -- Ped
    elseif type == 1 then
        -- not a human player
        if not IsPedAPlayer(ent) then
            ig.npc.RemoveNpc(net)
        else
        -- is a player
            
        end
    end        
end)

AddEventHandler("playerEnteredScope", function()

end)

AddEventHandler("playerLeftScope", function()

end)
