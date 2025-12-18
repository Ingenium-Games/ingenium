-- ====================================================================================--
-- Memory monitoring and cleanup utilities
-- ====================================================================================--

--- Memory monitoring command
RegisterCommand('memory', function(source, args)
    if source == 0 or (ig.func and ig.funig.IsAce and ig.funig.IsAce(source)) then
        local memBefore = collectgarbage('count')
        collectgarbage('collect')
        local memAfter = collectgarbage('count')
        
        print(('^3[Memory] Usage: %.2f MB (freed %.2f MB)^7'):format(
            memAfter / 1024,
            (memBefore - memAfter) / 1024
        ))
        
        -- Count active objects
        local counts = {
            players = 0,
            vehicles = 0,
            npcs = 0,
            objects = 0
        }
        
        -- Count players
        for k,v in pairs(ig.pdex or {}) do 
            if v then counts.players = counts.players + 1 end 
        end
        
        -- Count vehicles
        for k,v in pairs(ig.vdex or {}) do 
            if v then counts.vehicles = counts.vehicles + 1 end 
        end
        
        -- Count NPCs
        for k,v in pairs(ig.ndex or {}) do 
            if v then counts.npcs = counts.npcs + 1 end 
        end
        
        -- Count objects
        for k,v in pairs(ig.odex or {}) do 
            if v then counts.objects = counts.objects + 1 end 
        end
        
        print(('^2[Active Entities] %d players, %d vehicles, %d NPCs, %d objects^7'):format(
            counts.players, counts.vehicles, counts.npcs, counts.objects
        ))
        
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = {'[Memory]', string.format('%.2f MB | Entities: %d total', 
                    memAfter / 1024, 
                    counts.players + counts.vehicles + counts.npcs + counts.objects
                )}
            })
        end
    end
end, true)

--- Periodic cleanup of orphaned entities
local function CleanupOrphanedEntities()
    local cleaned = {vehicles = 0, npcs = 0, objects = 0}
    
    -- Clean vehicles
    for net, veh in pairs(ig.vdex or {}) do
        if veh and veh.Entity and not DoesEntityExist(veh.Entity) then
            ig.vdex[net] = nil
            cleaned.vehicles = cleaned.vehicles + 1
        end
    end
    
    -- Clean NPCs
    for net, npc in pairs(ig.ndex or {}) do
        if npc and npig.Entity and not DoesEntityExist(npig.Entity) then
            ig.ndex[net] = nil
            cleaned.npcs = cleaned.npcs + 1
        end
    end
    
    -- Clean objects
    for uuid, obj in pairs(ig.odex or {}) do
        if obj and obj.Entity and not DoesEntityExist(obj.Entity) then
            ig.odex[uuid] = nil
            cleaned.objects = cleaned.objects + 1
        end
    end
    
    local totalCleaned = cleaned.vehicles + cleaned.npcs + cleaned.objects
    if totalCleaned > 0 then
        print(('^3[Cleanup] Removed %d orphaned entities (V:%d N:%d O:%d)^7'):format(
            totalCleaned, cleaned.vehicles, cleaned.npcs, cleaned.objects
        ))
        collectgarbage('collect')
    end
    
    SetTimeout(60000, CleanupOrphanedEntities) -- Every minute
end

-- Start cleanup routine
CreateThread(function()
    Wait(60000) -- Wait 1 minute after startup
    print('^3[Cleanup] Starting orphaned entity cleanup routine (60s intervals)^7')
    CleanupOrphanedEntities()
end)
