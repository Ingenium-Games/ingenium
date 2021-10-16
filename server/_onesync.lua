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
            for _, v in pairs(conf.disable.objects) do
                local diabled = v
                if (model == diabled) then
                    DeleteEntity(ent)
                    c.debug('Object has been Deleted.')
                end
            end
            if c.object.Find(net) then

            end
        --
        -- Vehicle
        elseif type == 2 then            
            -- Look for blacklisted vheicles and remove them
            for _, v in pairs(conf.disable.vehicles) do
                local diabled = v
                if (model == diabled) then
                    DeleteEntity(ent)
                    c.debug('Vehicle has been Deleted.')
                end
            end
            if not c.vehicle.Find(net) then
                c.class.UnownedVehicle(net, false)
            end
        --
        -- Ped
        elseif type == 1 then
            -- Look for blacklisted vheicles and remove them
            for _, v in pairs(conf.disable.peds) do
                local diabled = v
                if (model == diabled) then
                    DeleteEntity(ent)
                    c.debug('Ped has been Deleted.')
                end
            end
            
            -- not a human player
            if not IsPedAPlayer(ent) then
                if not c.npc.Find(net) then

                end
            else
            -- is a player
            
            end
        -- No entity
        else

        end
    end
    
end)

AddEventHandler('entityCreating', function(ent)
    local net = NetworkGetNetworkIdFromEntity(ent)
    local model = GetEntityModel(ent)
    local type = GetEntityType(ent)

    -- Object
    if type == 3 then

    -- Vehicle
    elseif type == 2 then            
        -- Look for blacklisted vheicles and remove them
        for _, v in pairs(conf.disable.vehicles) do
            local diabled = v
            if (model == diabled) then
                CancelEvent()
                c.debug('Vehicle prevented from Spawning.')
            end
        end

    -- Ped
    elseif type == 1 then
        -- not a human player
        if not IsPedAPlayer(ent) then
            for _, v in pairs(conf.disable.peds) do
                local diabled = v
                if (model == diabled) then
                    CancelEvent()
                    c.debug('Ped prevented from Spawning.')
                end
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
        if c.object.Find(net) then
            c.object.CleanOne(net)
        end
    -- Vehicle
    elseif type == 2 then            
        if c.vehicle.Find(net) then
            -- This is the inital remove, the loops CleanAll() functions are too ensure entities exist with data.
            c.vehicle.CleanOne(net)
        end
    -- Ped
    elseif type == 1 then
        -- not a human player
        if not IsPedAPlayer(ent) then
            if c.npc.Find(net) then
                -- This is the inital remove, the loops CleanAll() functions are too ensure entities exist with data.
                c.npc.CleanOne(net)
            end
        else
        -- is a player
            
        end
    end        
end)

AddEventHandler('playerEnteredScope', function()

end)

AddEventHandler('playerLeftScope', function()

end)
