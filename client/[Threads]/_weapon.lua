-- ====================================================================================--
-- Consolidated Weapon Thread
-- Optimized to reduce multiple per-frame threads into one efficient thread
-- ====================================================================================--

-- Consolidated weapon management thread
-- Handles ammo tracking, control disabling, and periodic updates in a single loop
Citizen.CreateThread(function()
    local lastAmmoSync = 0
    local AMMO_SYNC_INTERVAL = 2500 -- 2.5 seconds
    
    while true do
        local ped = PlayerPedId()
        local currentTime = GetGameTimer()
        
        -- Check if player is armed with a weapon (firearms or throwables)
        if IsPedArmed(ped, 4 | 2) then
            -- Disable pistol butting/melee while armed (must be per-frame)
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
            
            -- Handle shooting
            if IsPedShooting(ped) then
                if ig._weapon ~= nil and ig._ammotype ~= nil and ig._ammo[ig._ammotype] ~= nil then
                    ig._ammo[ig._ammotype] = ig._ammo[ig._ammotype] - 1
                end
                Wait(115) -- Brief wait after shot to avoid double-counting
            
            -- Handle reloading - immediate sync
            elseif IsPedReloading(ped) then
                if ig._weapon ~= nil and ig._ammotype ~= nil and ig._ammo[ig._ammotype] ~= nil then
                    TriggerServerCallback({
                        eventName = "UpdateAmmo",
                        args = {ig._ammotype, ig._ammo[ig._ammotype]}
                    })
                    lastAmmoSync = currentTime -- Reset sync timer
                    Wait(1250) -- Wait during reload animation
                end
            else
                -- Per-frame check when armed but not shooting/reloading
                Wait(0)
            end
            
            -- Periodic ammo sync (every 2.5 seconds) when not reloading/shooting
            if ig._weapon ~= nil and ig._ammotype ~= nil and ig._ammo[ig._ammotype] ~= nil and (currentTime - lastAmmoSync) >= AMMO_SYNC_INTERVAL then
                TriggerServerCallback({
                    eventName = "UpdateAmmo",
                    args = {ig._ammotype, ig._ammo[ig._ammotype]}
                })
                lastAmmoSync = currentTime
            end
        else
            -- Not armed, check less frequently
            Wait(100)
        end
    end
end)