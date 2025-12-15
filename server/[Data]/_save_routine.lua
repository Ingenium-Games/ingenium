-- ====================================================================================--
-- Save dynamic JSON data periodically
-- ====================================================================================--

local function SaveDynamicData()
    if not c._loading then  -- Don't save during startup
        local startTime = os.clock()
        
        c.json.Write('Drops', c.drops)
        c.json.Write('Pickups', c.picks)
        c.json.Write('Scenes', c.scenes)
        c.json.Write('Notes', c.notes)
        c.json.Write('GSR', c.gsrs)
        
        local elapsed = (os.clock() - startTime) * 1000
        print(('^2[Autosave] Dynamic data saved to JSON (%.2fms)^7'):format(elapsed))
    end
    
    SetTimeout(300000, SaveDynamicData) -- 5 minutes
end

-- Start routine after resource is fully loaded
CreateThread(function()
    while c._loading do
        Wait(1000)
    end
    
    Wait(5000) -- Initial delay
    print('^3[Autosave] Starting dynamic data save routine (5 min intervals)^7')
    SaveDynamicData()
end)

-- Save on resource stop
AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        print('^3[Shutdown] Saving all dynamic data...^7')
        c.json.Write('Drops', c.drops)
        c.json.Write('Pickups', c.picks)
        c.json.Write('Scenes', c.scenes)
        c.json.Write('Notes', c.notes)
        c.json.Write('GSR', c.gsrs)
        print('^2[Shutdown] All data saved successfully^7')
    end
end)

-- Manual save command for admins
RegisterCommand('savedata', function(source, args)
    if source == 0 or (c.func and c.func.IsAce and c.func.IsAce(source)) then
        print('^3[Manual Save] Saving dynamic data...^7')
        c.json.Write('Drops', c.drops)
        c.json.Write('Pickups', c.picks)
        c.json.Write('Scenes', c.scenes)
        c.json.Write('Notes', c.notes)
        c.json.Write('GSR', c.gsrs)
        print('^2[Manual Save] Complete^7')
        
        if source > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                args = {'[System]', 'Dynamic data saved to files'}
            })
        end
    end
end, true)
