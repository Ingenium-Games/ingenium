-- ====================================================================================--
-- Save dynamic JSON data periodically
-- ====================================================================================--

local function SaveDynamicData()
    if not ig._loading then  -- Don't save during startup
        local startTime = os.clock()
        
        -- Merge drops for persistence
        local dropsToSave = ig.drop.MergeDropsForSave()
        
        ig.json.Write('Drops', dropsToSave)
        ig.json.Write('Pickups', ig.picks or {})
        ig.json.Write('Scenes', ig.scenes or {})
        ig.json.Write('Notes', ig.notes or {})
        ig.json.Write('GSR', ig.gsrs or {})
        ig.json.Write('Objects', ig.objects or {}) 

        local elapsed = (os.clock() - startTime) * 1000
        print(('^2[Autosave] Dynamic data saved to JSON (%.2fms)^7'):format(elapsed))
    end
end

-- Register autosave with cron to run every 5 minutes (12 jobs per hour, 288 total)
local autosaveRegistered = false
AddEventHandler("onServerResourceStart", function()
    if not autosaveRegistered then
        -- Register for every 5 minutes: :00, :05, :10, :15, :20, :25, :30, :35, :40, :45, :50, :55
        for hour = 0, 23 do
            for minute = 0, 59, 5 do
                ig.cron.RunAt(hour, minute, SaveDynamicData)
            end
        end
        autosaveRegistered = true
        print('^3[Autosave] Registered dynamic data save with cron (5 min intervals)^7')
    end
end)

-- Save on resource stop
AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        print('^3[Shutdown] Saving all dynamic data...^7')
        
        -- Use helper function to merge drops
        local dropsToSave = ig.drop.MergeDropsForSave()
        
        ig.json.Write('Drops', dropsToSave)
        ig.json.Write('Pickups', ig.picks)
        ig.json.Write('Scenes', ig.scenes)
        ig.json.Write('Notes', ig.notes)
        ig.json.Write('GSR', ig.gsrs)
        print('^2[Shutdown] All data saved successfully^7')
    end
end)

-- Manual save command for admins
RegisterCommand('savedata', function(source, args)
    if source == 0 or (ig.func and ig.func.IsAce and ig.func.IsAce(source)) then
        print('^3[Manual Save] Saving dynamic data...^7')
        
        -- Use helper function to merge drops
        local dropsToSave = ig.drop.MergeDropsForSave()
        
        ig.json.Write('Drops', dropsToSave)
        ig.json.Write('Pickups', ig.picks)
        ig.json.Write('Scenes', ig.scenes)
        ig.json.Write('Notes', ig.notes)
        ig.json.Write('GSR', ig.gsrs)
        print('^2[Manual Save] Complete^7')
        
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = {'[System]', 'Dynamic data saved to files'}
            })
        end
    end
end, true)
