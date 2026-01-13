-- ====================================================================================--
-- Consolidated RP Features Thread
-- Optimized thread structure replacing multiple per-frame threads from ig.base
-- Migrated and consolidated from ig.base/client/[RP]/_threads.lua
-- ====================================================================================--

-- Only load if in RP mode
if conf.gamemode ~= "RP" then
    return
end

local modeSettings = ig.game.GetGameModeSettings("RP")

-- ====================================================================================--
-- One-Time Setup Thread
-- Runs once on resource start for initial configuration
-- ====================================================================================--

Citizen.CreateThread(function()
    -- Disable trains if configured
    if modeSettings.disableTrains then
        SwitchTrainTrack(0, false)
        SwitchTrainTrack(3, false)
        SetRandomTrains(false)
        ig.log.Info("RPFeatures", "Trains disabled")
    end
    
    -- Disable police dispatch if configured
    if modeSettings.disableDispatch then
        for i = 1, 15 do
            EnableDispatchService(i, false)
        end
        ig.log.Info("RPFeatures", "Dispatch services disabled")
    end
    
    -- Set audio flags for RP experience
    SetAudioFlag("PoliceScannerDisabled", true)
    SetAudioFlag("DisableFlightMusic", true)
    
    ig.log.Info("RPFeatures", "One-time setup complete")
end)

-- ====================================================================================--
-- Per-Frame Necessities Thread
-- Only items that MUST run every frame (minimal to reduce overhead)
-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Wait(0) -- Per-frame
        
        -- Hide default HUD elements if configured
        if modeSettings.hideHud then
            -- Hide HUD components
            HideHudComponentThisFrame(1)  -- Wanted Stars
            HideHudComponentThisFrame(2)  -- Weapon Icon
            HideHudComponentThisFrame(3)  -- Cash
            HideHudComponentThisFrame(4)  -- MP Cash
            HideHudComponentThisFrame(6)  -- Vehicle Name
            HideHudComponentThisFrame(7)  -- Area Name
            HideHudComponentThisFrame(8)  -- Vehicle Class
            HideHudComponentThisFrame(9)  -- Street Name
            HideHudComponentThisFrame(13) -- Cash Change
            HideHudComponentThisFrame(17) -- Save Game
            HideHudComponentThisFrame(20) -- Weapon Stats
            
            -- Hide radar (can be toggled by player separately)
            -- DisplayRadar(false)
        end
    end
end)

-- ====================================================================================--
-- Consolidated Timed Operations Thread
-- Uses GetGameTimer() for precise timing without multiple threads
-- ====================================================================================--

Citizen.CreateThread(function()
    local lastIdleCameraCheck = 0
    local lastNPCWeaponCheck = 0
    
    -- Timer intervals from config (in milliseconds)
    local IDLE_CAMERA_INTERVAL = conf.rp.idleCameraInterval
    local NPC_WEAPON_INTERVAL = conf.rp.npcWeaponInterval
    
    -- Cache pickup hashes outside loop to avoid table recreation
    local weaponPickupHashes = {
        `PICKUP_WEAPON_PISTOL`,
        `PICKUP_WEAPON_COMBATPISTOL`,
        `PICKUP_WEAPON_PUMPSHOTGUN`,
        `PICKUP_WEAPON_CARBINERIFLE`,
        `PICKUP_WEAPON_ASSAULTRIFLE`,
        `PICKUP_WEAPON_SMG`,
    }
    
    while true do
        local currentTime = GetGameTimer()
        
        -- Idle camera disable check (every 5 seconds)
        if modeSettings.disableIdleCamera and (currentTime - lastIdleCameraCheck) >= IDLE_CAMERA_INTERVAL then
            InvalidateIdleCam()
            InvalidateVehicleIdleCam()
            lastIdleCameraCheck = currentTime
        end
        
        -- NPC weapon drop disable check (every 2.5 seconds)
        if modeSettings.disableNPCWeaponDrops and (currentTime - lastNPCWeaponCheck) >= NPC_WEAPON_INTERVAL then
            local ped = PlayerPedId()
            -- Disable weapon drops from NPCs
            SetPedDropsWeaponsWhenDead(ped, false)
            
            -- Remove nearby dropped weapons (within 50 units)
            local playerCoords = GetEntityCoords(ped)
            
            for _, pickupHash in ipairs(weaponPickupHashes) do
                local pickup = GetClosestPickupOfType(pickupHash, playerCoords.x, playerCoords.y, playerCoords.z, 50.0)
                if pickup and DoesPickupExist(pickup) then
                    RemovePickup(pickup)
                end
            end
            
            lastNPCWeaponCheck = currentTime
        end
        
        -- Wait based on shortest interval to check
        Wait(math.min(IDLE_CAMERA_INTERVAL, NPC_WEAPON_INTERVAL))
    end
end)

-- ====================================================================================--
-- Player State Monitoring Thread
-- Monitors important player states for RP features
-- Runs every second for efficiency
-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Wait(1000) -- Check every second
        
        local ped = PlayerPedId()
        
        -- Update death state
        local isDead = IsEntityDead(ped) or IsPedDeadOrDying(ped, true)
        if LocalPlayer.state.IsDead ~= isDead then
            LocalPlayer.state:set("IsDead", isDead, false)
        end
        
        -- Update frozen state
        local isFrozen = IsPedStill(ped) and GetEntitySpeed(ped) == 0.0
        if LocalPlayer.state.IsFrozen ~= isFrozen then
            -- Only update if changed
            -- This is a basic check, more sophisticated freezing should use FreezeEntityPosition
        end
        
        -- Update cuffed state (if applicable - this would be set by arrest/cuff scripts)
        -- LocalPlayer.state.IsCuffed is managed by other systems
        
        -- Additional RP state checks can be added here
    end
end)