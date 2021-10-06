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
    local type = GetEntityType(ent)
    local model = GetEntityModel(ent)
    
    if DoesEntityExist(ent) then
        -- Object
        if type == 3 then

        -- Vehicle
        elseif type == 2 then            
            -- Look for blacklisted vheicles and remove them
            for _, v in pairs(conf.disable.vehicles) do
                local diabled = v
                if (model == diabled) then
                    DeleteEntity(ent)
                    c.debug('Entity has been Deleted.')
                end
            end
            
        
        -- Ped
        elseif type == 1 then
            -- Look for blacklisted vheicles and remove them
            for _, v in pairs(conf.disable.peds) do
                local diabled = v
                if (model == diabled) then
                    DeleteEntity(ent)
                    c.debug('Entity has been Deleted.')
                end
            end


        -- No entity
        else

        end
    end
    
end)

AddEventHandler('entityCreating', function(ent)
    local model = GetEntityModel(ent)
    for _, v in pairs(conf.disable.vehicles) do
        local diabled = v
        if (model == diabled) then
            CancelEvent()
            c.debug('Entity prevented from Spawning.')
        end
    end
end)

AddEventHandler('entityRemoved', function(ent)
    
end)

AddEventHandler('playerEnteredScope', function()

end)

AddEventHandler('playerLeftScope', function()

end)
