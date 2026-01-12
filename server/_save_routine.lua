-- ====================================================================================--
-- Save dynamic JSON data periodically
-- ====================================================================================--

local function SaveDynamicData()
    if not ig._loading then  -- Don't save during startup
        local startTime = os.clock()
        
        -- Merge drops for persistence
        local dropsToSave = ig.drop.MergeDropsForSave()
        
        ig.json.Write('drops', dropsToSave)
        ig.json.Write('pickups', ig.picks or {})
        ig.json.Write('scenes', ig.scenes or {})
        ig.json.Write('notes', ig.notes or {})
        ig.json.Write('gsr', ig.gsrs or {})
        ig.json.Write('objects', ig.objects or {}) 

        local elapsed = (os.clock() - startTime) * 1000
        ig.log.Info('Autosave', 'Dynamic data saved to JSON (%.2fms)', elapsed)
    end
    
    SetTimeout(conf.objectsync, SaveDynamicData) -- 5 minutes
end

-- Start routine after resource is fully loaded
CreateThread(function()
    while ig._loading do
        Wait(1000)
    end
    
    Wait(5000) -- Initial delay
    ig.log.Info('Autosave', 'Starting dynamic data save routine (5 min intervals)')
    SaveDynamicData()
end)

-- Save on resource stop
AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        ig.log.Info('Shutdown', 'Saving all dynamic data...')
        
        -- Use helper function to merge drops
        local dropsToSave = ig.drop.MergeDropsForSave()
        
        ig.json.Write('drops', dropsToSave)
        ig.json.Write('pickups', ig.picks)
        ig.json.Write('scenes', ig.scenes)
        ig.json.Write('notes', ig.notes)
        ig.json.Write('gsr', ig.gsrs)
        ig.log.Info('Shutdown', 'All data saved successfully')
    end
end)

-- Manual save command for admins
RegisterCommand('savedata', function(source, args)
    if source == 0 or (ig.func and ig.func.IsAce and ig.func.IsAce(source)) then
        ig.log.Info('Manual Save', 'Saving dynamic data...')
        
        -- Use helper function to merge drops
        local dropsToSave = ig.drop.MergeDropsForSave()
        
        ig.json.Write('drops', dropsToSave)
        ig.json.Write('pickups', ig.picks)
        ig.json.Write('scenes', ig.scenes)
        ig.json.Write('notes', ig.notes)
        ig.json.Write('gsr', ig.gsrs)
        ig.log.Info('Manual Save', 'Complete')
        
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = {'[System]', 'Dynamic data saved to files'}
            })
        end
    end
end, true)
