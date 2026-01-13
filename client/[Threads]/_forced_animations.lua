-- ====================================================================================--
-- Forced Animation Detection Thread
-- Monitors game state and triggers forced animations via server callbacks
-- Example: Forces hands up when an unarmed player is aimed at
-- Data-driven approach using weapons.json categories
-- ====================================================================================--

-- Configuration
local FORCED_ANIM_CONFIG = {
    handsUpDistance = 15.0,          -- Maximum distance to detect aiming
    handsUpCheckInterval = 500,      -- Check every 500ms
    requireUnarmed = true,           -- Target must be unarmed
    requireLineOfSight = true,       -- Target must see the aimer
}

-- State tracking
local isBeingAimedAt = false
local aimerPlayerId = nil
local lastForcedAnimCheck = 0

-- Weapon category tables (populated from server data)
local UNARMED_WEAPONS = {}
local ALLOWED_WEAPON_CATEGORIES = {
    ["GROUP_UNARMED"] = true,
    ["GROUP_MELEE"] = true,
}

-- Initialization flag
local weaponDataInitialized = false
local initializationAttempted = false

-- Helper: Initialize weapon categories from server data
local function InitializeWeaponCategories()
    if weaponDataInitialized or initializationAttempted then
        return weaponDataInitialized
    end
    
    initializationAttempted = true
    
    ig.weapon.GetAll(function(weaponsData)
        if not weaponsData then
            ig.log.Error("ForcedAnimations", "Failed to load weapon data from server")
            return
        end
        
        -- Build table of allowed weapons based on categories
        UNARMED_WEAPONS = {}
        local count = 0
        
        for hashStr, weaponInfo in pairs(weaponsData) do
            local category = weaponInfo.Category
            if category and ALLOWED_WEAPON_CATEGORIES[category] then
                local hash = tonumber(weaponInfo.Hash) or tonumber(hashStr)
                if hash then
                    UNARMED_WEAPONS[hash] = true
                    count = count + 1
                end
            end
        end
        
        weaponDataInitialized = true
        ig.log.Info("ForcedAnimations", "Initialized %d allowed weapons for forced animations", count)
    end)
    
    return weaponDataInitialized
end

-- Helper: Check if local player is unarmed (data-driven)
local function IsLocalPlayerUnarmed()
    if not weaponDataInitialized then
        return false
    end
    
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    
    return UNARMED_WEAPONS[weapon] == true
end

-- Helper: Check if target has line of sight to source
local function HasLineOfSight(sourcePed, targetPed)
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetCoords = GetEntityCoords(targetPed)
    
    -- Use raycast to check for obstacles
    local rayHandle = StartShapeTestRay(
        sourceCoords.x, sourceCoords.y, sourceCoords.z,
        targetCoords.x, targetCoords.y, targetCoords.z,
        -1, -- All entities
        sourcePed,
        7 -- Flags
    )
    
    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
    
    -- If no hit or hit the target ped, line of sight is clear
    return not hit or entityHit == targetPed
end

-- Helper: Check if a player is aiming at local player
local function CheckIfBeingAimedAt()
    local localPed = PlayerPedId()
    local localCoords = GetEntityCoords(localPed)
    local localPlayer = PlayerId()
    
    -- Don't check if already performing an animation
    local currentAnimState = LocalPlayer.state.Animation
    if currentAnimState and currentAnimState ~= false then
        return false, nil
    end
    
    -- Check if local player is unarmed
    if FORCED_ANIM_CONFIG.requireUnarmed and not IsLocalPlayerUnarmed() then
        return false, nil
    end
    
    -- Check all nearby players
    local players = GetActivePlayers()
    
    for _, player in ipairs(players) do
        if player ~= localPlayer then
            local ped = GetPlayerPed(player)
            
            if ped and DoesEntityExist(ped) then
                local pedCoords = GetEntityCoords(ped)
                local distance = #(localCoords - pedCoords)
                
                -- Check if within range
                if distance <= FORCED_ANIM_CONFIG.handsUpDistance then
                    -- Check if player is aiming
                    if IsPlayerFreeAiming(player) then
                        -- Get aiming target
                        local isAimingAtEntity, targetEntity = GetEntityPlayerIsFreeAimingAt(player)
                        
                        if isAimingAtEntity and targetEntity == localPed then
                            -- Check line of sight if required
                            if FORCED_ANIM_CONFIG.requireLineOfSight then
                                if not HasLineOfSight(localPed, ped) then
                                    goto continue
                                end
                            end
                            
                            -- Player is aiming at us!
                            return true, GetPlayerServerId(player)
                        end
                    end
                end
            end
            
            ::continue::
        end
    end
    
    return false, nil
end

-- Main thread for forced animation detection
Citizen.CreateThread(function()
    -- Wait for player to be loaded before initializing
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(100)
    end
    
    -- Wait a bit more for data systems to be ready
    Citizen.Wait(2000)
    
    -- Initialize weapon categories from server
    InitializeWeaponCategories()
    
    -- Wait for weapon data to be initialized
    while not weaponDataInitialized do
        ig.log.Info("ForcedAnimations", "Waiting for weapon data initialization...")
        Citizen.Wait(1000)
    end
    
    ig.log.Info("ForcedAnimations", "Forced animation detection thread started")
    
    -- Main loop
    while true do
        local sleep = FORCED_ANIM_CONFIG.handsUpCheckInterval
        local currentTime = GetGameTimer()
        
        -- Only check at interval
        if currentTime - lastForcedAnimCheck >= FORCED_ANIM_CONFIG.handsUpCheckInterval then
            lastForcedAnimCheck = currentTime
            
            local beingAimedAt, aimerServerId = CheckIfBeingAimedAt()
            
            -- State changed: now being aimed at
            if beingAimedAt and not isBeingAimedAt then
                isBeingAimedAt = true
                aimerPlayerId = aimerServerId
                
                -- Trigger server callback to force hands up
                local localServerId = GetPlayerServerId(PlayerId())
                TriggerServerCallback({
                    eventName = "ForceAnimation:HandsUp",
                    args = {localServerId, true},
                    callback = function(success)
                        if not success then
                            -- Server rejected, reset state
                            isBeingAimedAt = false
                            aimerPlayerId = nil
                        end
                    end
                })
                
            -- State changed: no longer being aimed at
            elseif not beingAimedAt and isBeingAimedAt then
                isBeingAimedAt = false
                
                -- Stop hands up animation
                local localServerId = GetPlayerServerId(PlayerId())
                TriggerServerCallback({
                    eventName = "ForceAnimation:HandsUp",
                    args = {localServerId, false}
                })
                
                aimerPlayerId = nil
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Export configuration for external modification
exports("GetForcedAnimConfig", function()
    return FORCED_ANIM_CONFIG
end)

exports("SetForcedAnimConfig", function(key, value)
    if FORCED_ANIM_CONFIG[key] ~= nil then
        FORCED_ANIM_CONFIG[key] = value
        return true
    end
    return false
end)

-- Export weapon category data (for debugging)
exports("GetAllowedWeapons", function()
    return UNARMED_WEAPONS
end)

exports("IsWeaponDataInitialized", function()
    return weaponDataInitialized
end)

