-- ====================================================================================--
-- Memory monitoring and cleanup utilities
-- ====================================================================================--

--- Memory monitoring command
RegisterCommand('memory', function(source, args)
    if source == 0 or (ig.func and ig.func.IsAce and ig.func.IsAce(source)) then
        local memBefore = collectgarbage('count')
        collectgarbage('collect')
        local memAfter = collectgarbage('count')
        
        ig.debug.Debug(('[Memory] Usage: %.2f MB (freed %.2f MB)'):format(
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
        
        ig.debug.Info(('[Active Entities] %d players, %d vehicles, %d NPCs, %d objects'):format(
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
        if npc and npc.Entity and not DoesEntityExist(npc.Entity) then
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
        ig.debug.Debug(('[Cleanup] Removed %d orphaned entities (V:%d N:%d O:%d)'):format(
            totalCleaned, cleaned.vehicles, cleaned.npcs, cleaned.objects
        ))
        collectgarbage('collect')
    end
    
    SetTimeout(60000, CleanupOrphanedEntities) -- Every minute
end

-- Start cleanup routine
CreateThread(function()
    Wait(60000) -- Wait 1 minute after startup
    ig.log.Info('Cleanup', 'Starting orphaned entity cleanup routine (60s intervals)')
    CleanupOrphanedEntities()
end)

RegisterCommand('sqlperf', function(source)
    local stats = ig.sql.GetStats()
    
    local report = string.format([[
=== SQL Performance Report ===
Total Queries: %d
Slow Queries: %d (%.2f%%)
Failed Queries: %d (%.2f%%)
Average Query Time: %.2fms
Total Execution Time: %.2fs

Connection Status: %s
Database: %s:%d/%s
Pool Size: %d connections

Thresholds:
  Good: < 50ms
  Warning: 50-100ms
  Critical: > 100ms
============================
    ]],
        stats.totalQueries,
        stats.slowQueries,
        (stats.slowQueries / stats.totalQueries) * 100,
        stats.failedQueries,
        (stats.failedQueries / stats.totalQueries) * 100,
        stats.averageTime,
        stats.totalTime / 1000,
        stats.isReady and "Ready" or "Not Ready",
        stats.config.host,
        stats.config.port,
        stats.config.database,
        stats.config.connectionLimit
    )
    
    print(report)
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"[SQL]", "Check server console for performance report"}
        })
    end
end, true)