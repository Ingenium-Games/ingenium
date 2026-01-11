-- ====================================================================================--
-- Screenshot System - Client Side
-- ====================================================================================--

ig.screenshot = ig.screenshot or {}

local screenshotInProgress = false

-- Take a screenshot and send to server for processing
function ig.screenshot.Take(reason, additionalData, callback)
    if screenshotInProgress then
        print("[IG Screenshot] Screenshot already in progress, please wait...")
        return false
    end
    
    if not conf.screenshot or not conf.screenshot.enabled then
        print("[IG Screenshot] Screenshot system is disabled")
        if callback then callback(false) end
        return false
    end
    
    -- Check if screenshot-basic resource is available
    if GetResourceState('screenshot-basic') ~= 'started' then
        print("[IG Screenshot] screenshot-basic resource not started")
        if callback then callback(false) end
        return false
    end
    
    screenshotInProgress = true
    
    -- Collect metadata if configured
    local metadata = {
        reason = reason or "manual",
        timestamp = os.time(),
    }
    
    if conf.screenshot.includeMetadata then
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        
        if conf.screenshot.includeMetadata.playerName then
            metadata.playerName = GetPlayerName(PlayerId())
        end
        
        if conf.screenshot.includeMetadata.coordinates then
            metadata.coordinates = {
                x = coords.x,
                y = coords.y,
                z = coords.z
            }
        end
        
        if conf.screenshot.includeMetadata.gameTime then
            metadata.gameTime = {
                hours = GetClockHours(),
                minutes = GetClockMinutes()
            }
        end
        
        if conf.screenshot.includeMetadata.vehicleInfo then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle ~= 0 then
                metadata.vehicle = {
                    model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)),
                    plate = GetVehicleNumberPlateText(vehicle)
                }
            end
        end
        
        if conf.screenshot.includeMetadata.nearbyPlayers then
            local players = {}
            for _, player in ipairs(GetActivePlayers()) do
                if player ~= PlayerId() then
                    local otherPed = GetPlayerPed(player)
                    local distance = #(coords - GetEntityCoords(otherPed))
                    if distance < 50.0 then
                        table.insert(players, {
                            name = GetPlayerName(player),
                            serverId = GetPlayerServerId(player),
                            distance = math.floor(distance)
                        })
                    end
                end
            end
            metadata.nearbyPlayers = players
        end
    end
    
    -- Merge additional data
    if additionalData then
        for k, v in pairs(additionalData) do
            metadata[k] = v
        end
    end
    
    -- Take screenshot using screenshot-basic
    exports['screenshot-basic']:requestScreenshotUpload(
        conf.screenshot.outputs.discord.webhook or "https://example.com/upload",
        'files[]',
        function(data)
            screenshotInProgress = false
            
            if data then
                print("[IG Screenshot] Screenshot captured successfully")
                
                -- Send to server for processing
                TriggerServerEvent('ig:screenshot:process', {
                    imageUrl = data,
                    metadata = metadata
                })
                
                if callback then callback(true, data) end
            else
                print("[IG Screenshot] Failed to capture screenshot")
                if callback then callback(false) end
            end
        end
    )
    
    return true
end

-- Automatically take screenshot on player report
RegisterNetEvent('ig:screenshot:takeOnReport')
AddEventHandler('ig:screenshot:takeOnReport', function(reportData)
    if conf.screenshot.autoScreenshot.onReport then
        ig.screenshot.Take('player_report', reportData)
    end
end)

-- Automatically take screenshot on error
RegisterNetEvent('ig:screenshot:takeOnError')
AddEventHandler('ig:screenshot:takeOnError', function(errorData)
    if conf.screenshot.autoScreenshot.onError then
        ig.screenshot.Take('client_error', errorData)
    end
end)

-- Automatically take screenshot on death
if conf.screenshot and conf.screenshot.autoScreenshot.onDeath then
    CreateThread(function()
        while true do
            Wait(1000)
            
            local ped = PlayerPedId()
            if IsEntityDead(ped) then
                ig.screenshot.Take('player_death', {
                    lastDamageType = GetPedCauseOfDeath(ped)
                })
                
                -- Wait until player is alive again
                while IsEntityDead(ped) do
                    Wait(1000)
                    ped = PlayerPedId()
                end
            end
        end
    end)
end

-- Export screenshot function
exports('TakeScreenshot', ig.screenshot.Take)

-- Command for manual screenshots (admin only)
RegisterCommand('screenshot', function(source, args, rawCommand)
    local ace = LocalPlayer.state.Ace
    if ace == 'admin' or ace == 'superadmin' or ace == 'developer' or ace == 'owner' then
        ig.screenshot.Take('manual_command', {
            command = rawCommand
        }, function(success, data)
            if success then
                TriggerEvent('Client:Notify', 'Screenshot captured successfully', 'green', 5000)
            else
                TriggerEvent('Client:Notify', 'Failed to capture screenshot', 'red', 5000)
            end
        end)
    else
        TriggerEvent('Client:Notify', 'You do not have permission to use this command', 'red', 5000)
    end
end, false)

print('[IG Screenshot] Screenshot system client loaded')
