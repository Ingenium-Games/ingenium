-- ====================================================================================--
-- Server-Side Forced Animation Callbacks
-- Handles authentication and validation for forced animations
-- These animations are triggered by game mechanics (e.g., being aimed at)
-- Data-driven approach using weapons.json categories
-- ====================================================================================--

-- Cooldown tracking
local animationCooldowns = {}

-- Weapon category cache (built from ig.weapons on resource start)
local ALLOWED_WEAPON_CATEGORIES = {
    ["GROUP_UNARMED"] = true,
    ["GROUP_MELEE"] = true,
}

local unarmedWeapons = {}

-- Initialize allowed weapons from weapon data
Citizen.CreateThread(function()
    if not ig.weapons then
        ig.log.Error("ForcedAnimations", "Weapon data not loaded!")
        return
    end
    
    local count = 0
    for hashStr, weaponInfo in pairs(ig.weapons) do
        local category = weaponInfo.Category
        if category and ALLOWED_WEAPON_CATEGORIES[category] then
            local hash = tonumber(weaponInfo.Hash) or tonumber(hashStr)
            if hash then
                unarmedWeapons[hash] = true
                count = count + 1
            end
        end
    end
    
    ig.log.Info("ForcedAnimations", "Initialized %d allowed weapons for forced animations", count)
end)

-- Helper: Check cooldown
local function IsOnCooldown(playerId, animationType)
    local key = playerId .. "_" .. animationType
    local lastTrigger = animationCooldowns[key] or 0
    local currentTime = os.time()
    
    if currentTime - lastTrigger < conf.forcedAnimations.cooldown then
        return true
    end
    
    animationCooldowns[key] = currentTime
    return false
end

-- Helper: Validate distance between players
local function ValidateDistance(sourceId, targetId, maxDistance)
    local sourcePed = GetPlayerPed(sourceId)
    local targetPed = GetPlayerPed(targetId)
    
    if not sourcePed or not targetPed or sourcePed == 0 or targetPed == 0 then
        return false
    end
    
    local sourceCoords = GetEntityCoords(sourcePed)
    local targetCoords = GetEntityCoords(targetPed)
    local distance = #(sourceCoords - targetCoords)
    
    return distance <= maxDistance
end

-- Helper: Check if player has permission
local function HasPermission(playerId, action)
    local xPlayer = ig.data.GetPlayer(playerId)
    if not xPlayer then return false end
    
    local job = xPlayer.GetJob()
    if job and conf.forcedAnimations.authorizedJobs[job.name] then
        return true
    end
    
    return false
end

-- Helper: Check if weapon is allowed (unarmed/melee) using data-driven approach
local function IsWeaponAllowed(weaponHash)
    return unarmedWeapons[weaponHash] == true
end

-- Helper: Log forced animation
local function LogForcedAnimation(sourceId, targetId, animationType, allowed)
    if not conf.forcedAnimations.enableLogging then return end
    
    local xPlayer = ig.data.GetPlayer(sourceId)
    local xTarget = ig.data.GetPlayer(targetId)
    
    local message = string.format(
        "[FORCED ANIM] %s (%s) %s force %s on %s (%s)",
        xPlayer and xPlayer.GetName() or "Unknown",
        sourceId,
        allowed and "ALLOWED" or "DENIED",
        animationType,
        xTarget and xTarget.GetName() or "Unknown",
        targetId
    )
    
    print(message)
    
    -- Discord webhook (if configured)
    if conf.forcedAnimations.discordWebhook then
        -- Implement discord webhook here if needed
    end
end

--- Force Arms Crossed animation on target player
--- @param source number Source player requesting the animation
--- @param targetId number Target player to apply animation to
--- @param shouldPlay boolean Whether to play or stop the animation
RegisterServerCallback({
    eventName = "ForceAnimation:ArmsCrossed",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        -- Check cooldown
        if IsOnCooldown(source, "ArmsCrossed") then
            return false
        end
        
        -- Validate distance
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "ArmsCrossed", false)
            return false
        end
        
        -- Log action
        LogForcedAnimation(source, targetId, "ArmsCrossed", true)
        
        -- Trigger client callback on target player
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:ArmsCrossed",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force Hands Up animation on target player
--- @param source number Source player requesting the animation
--- @param targetId number Target player to apply animation to
--- @param shouldPlay boolean Whether to play or stop the animation
RegisterServerCallback({
    eventName = "ForceAnimation:HandsUp",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        -- Check cooldown (only when starting animation)
        if shouldPlay and IsOnCooldown(source, "HandsUp") then
            return false
        end
        
        -- Validate distance
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "HandsUp", false)
            return false
        end
        
        -- Check if target is unarmed (if required) - data-driven approach
        if conf.forcedAnimations.requireUnarmedForHandsUp and shouldPlay then
            local targetPed = GetPlayerPed(targetId)
            local weapon = GetSelectedPedWeapon(targetPed)
            
            if not IsWeaponAllowed(weapon) then
                LogForcedAnimation(source, targetId, "HandsUp", false)
                return false
            end
        end
        
        -- Log action
        LogForcedAnimation(source, targetId, "HandsUp", true)
        
        -- Trigger client callback on target player
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:HandsUp",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force Hold Arm animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:HoldArm",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "HoldArm") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "HoldArm", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "HoldArm", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:HoldArm",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force Mugging animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:Mugging",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "Mugging") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "Mugging", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "Mugging", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:Mugging",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force PickUp animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:PickUp",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "PickUp") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "PickUp", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "PickUp", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:PickUp",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force Escorting animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:Escorting",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "Escorting") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "Escorting", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "Escorting", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:Escorting",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force Escorted animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:Escorted",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "Escorted") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "Escorted", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "Escorted", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:Escorted",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force Nod animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:Nod",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "Nod") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "Nod", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "Nod", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:Nod",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force Lockpick animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:Lockpick",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "Lockpick") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "Lockpick", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "Lockpick", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:Lockpick",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force Repair animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:Repair",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "Repair") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "Repair", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "Repair", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:Repair",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force PhoneCall animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:PhoneCall",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "PhoneCall") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "PhoneCall", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "PhoneCall", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:PhoneCall",
            args = {shouldPlay}
        })
        
        return true
    end
})

--- Force FacePalm animation on target player
RegisterServerCallback({
    eventName = "ForceAnimation:FacePalm",
    eventCallback = function(source, targetId, shouldPlay)
        if not targetId or type(targetId) ~= "number" then
            return false
        end
        
        local xPlayer = ig.data.GetPlayer(source)
        local xTarget = ig.data.GetPlayer(targetId)
        
        if not xPlayer or not xTarget then
            return false
        end
        
        if shouldPlay and IsOnCooldown(source, "FacePalm") then
            return false
        end
        
        if not ValidateDistance(source, targetId, conf.forcedAnimations.maxDistance) then
            LogForcedAnimation(source, targetId, "FacePalm", false)
            return false
        end
        
        LogForcedAnimation(source, targetId, "FacePalm", true)
        
        TriggerClientCallback({
            source = targetId,
            eventName = "Client:Animation:FacePalm",
            args = {shouldPlay}
        })
        
        return true
    end
})
