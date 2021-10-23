-- ====================================================================================--
--  MIT License 2020 : Twiitchter
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

AddEventHandler('weaponDamageEvent', function()

end)

AddEventHandler('vehicleComponentControlEvent', function()

end)

AddEventHandler('respawnPlayerPedEvent', function()

end)

AddEventHandler('explosionEvent', function()
    CancelEvent()
    c.debug('Explosion has been Cancelled.')
end)

AddEventHandler('entityCreated', function(ent)
    local net = NetworkGetNetworkIdFromEntity(ent)
    local model = GetEntityModel(ent)
    local type = GetEntityType(ent)

    if DoesEntityExist(ent) then
        -- Object
        if type == 3 then
            if not conf.disable.objects[model] then
                if c.object.Find(net) then

                end                       
            else
                DeleteEntity(ent)
                c.debug('Object has been Deleted.')
            end
        --
        -- Vehicle
        elseif type == 2 then
            if not conf.disable.vehicles[model] then                        
                if not c.vehicle.Find(net) then
                    c.data.AddVehicle(net, c.class.CreateVehicle, net, false)
                end
            else
                DeleteEntity(ent)
                c.debug('Vehicle has been Deleted.')
            end
        --
        -- Ped
        elseif type == 1 then
            if not conf.disable.peds[model] then                        
                -- not a human player
                if not IsPedAPlayer(ent) then
                    if not c.npc.Find(net) then
                        c.class.CreateNpc(net)
                    end
                else
                -- is a player
                
                end
            else
                DeleteEntity(ent)
                c.debug('Ped has been Deleted.')
            end
        -- no other types // fin
        end
    end
end)

AddEventHandler('entityCreating', function(ent)
    local net = NetworkGetNetworkIdFromEntity(ent)
    local model = GetEntityModel(ent)
    local type = GetEntityType(ent)
    --
    -- Object
    if type == 3 then
        if conf.disable.objects[model] then
            CancelEvent()
            c.debug('Object prevented from Spawning.')
        end
    --
    -- Vehicle
    elseif type == 2 then            
        if conf.disable.vehicles[model] then
            CancelEvent()
            c.debug('Vehicle prevented from Spawning.')
        end
    --
    -- Ped
    elseif type == 1 then
        -- not a human player
        if not IsPedAPlayer(ent) then
            if conf.disable.peds[model] then
                CancelEvent()
                c.debug('Ped prevented from Spawning.')
            end
        else
        -- is a player
            
        end
    end
end)

AddEventHandler('entityRemoved', function(ent)
    local net = NetworkGetNetworkIdFromEntity(ent)
    local model = GetEntityModel(ent)
    local type = GetEntityType(ent)
    
    -- Object
    if type == 3 then

    -- Vehicle
    elseif type == 2 then            
        c.data.RemoveVehicle(net)
   -- Ped
    elseif type == 1 then
        -- not a human player
        if not IsPedAPlayer(ent) then
            c.npc.CleanOne(net)
        else
        -- is a player
            
        end
    end        
end)

AddEventHandler('playerEnteredScope', function()

end)

AddEventHandler('playerLeftScope', function()

end)
