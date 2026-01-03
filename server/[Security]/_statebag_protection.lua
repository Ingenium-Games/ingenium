-- ====================================================================================--
-- StateBag Write Protection
-- Prevents clients from modifying sensitive entity state data
-- ====================================================================================--

-- Whitelist of keys that clients are allowed to modify
local ALLOWED_CLIENT_KEYS = {
    ["Animation"] = true,
    ["IsSwimming"] = true,
    ["IsDiving"] = true,
    ["IsJumping"] = true,
    ["IsFalling"] = true,
    ["IsClimbing"] = true,
    ["IsRagdoll"] = true,
    -- Add other benign animation/state keys here
    ["IsSitting"] = true,
    ["IsCuffed"] = true,
    ["IsEscorted"] = true,
    ["Emote"] = true,
    ["FacialAnim"] = true,
    ["WalkStyle"] = true,
    ["IsInVehicle"] = true,
    ["VehicleSeat"] = true,
    ["IsTalking"] = true,
    ["VoiceRange"] = true,
    ["RadioChannel"] = true,
    ["RadioVolume"] = true,
    ["IsDead"] = true,
    ["IsUnconscious"] = true,
    ["IsInCombat"] = true,
    ["IsAiming"] = true,
    ["IsShooting"] = true,
    ["CurrentWeapon"] = true,
}

-- Blacklist of critical keys that must NEVER be modified by clients
-- This provides defense-in-depth in case of whitelist misconfiguration
local BLOCKED_CLIENT_KEYS = {
    ["Cash"] = true,
    ["Bank"] = true,
    ["Keys"] = true,
    ["Inventory"] = true,
    ["Health"] = true,
    ["Armour"] = true,
    ["Hunger"] = true,
    ["Thirst"] = true,
    ["Stress"] = true,
    ["Fuel"] = true,
    ["Owner"] = true,
    ["Job"] = true,
    ["Character_ID"] = true,
    ["License_ID"] = true,
    ["Ace"] = true,
    -- Add other sensitive keys here
}

-- Helper function to handle state bag changes
local function handleStateBagChange(bagName, key, value, reserved, replicated)
    -- Skip if this is a server-side change (reserved = true)
    if reserved then
        return
    end
    
    -- CRITICAL: Block explicitly blacklisted keys (defense-in-depth)
    if BLOCKED_CLIENT_KEYS[key] then
        local playerId = nil
        if bagName:match("^entity:") then
            local netId = tonumber(bagName:gsub('entity:', ''), 10)
            if netId then
                local entity = NetworkGetEntityFromNetworkId(netId)
                if DoesEntityExist(entity) then
                    playerId = NetworkGetEntityOwner(entity)
                end
            end
        elseif bagName:match("^player:") then
            playerId = tonumber(bagName:gsub('player:', ''), 10)
        end
        
        if playerId then
            print(("^1[SECURITY CRITICAL] Player %d attempted to modify BLOCKED key: %s^7"):format(playerId, key))
            TriggerEvent("txaLogger:SecurityAlert", {
                type = "statebag_blacklist_violation",
                severity = "critical",
                player = playerId,
                key = key,
                value = value,
                bagName = bagName,
                timestamp = os.time()
            })
            -- Consider dropping the player for critical violations
            -- DropPlayer(playerId, "Critical security violation detected")
        end
        return
    end
    
    -- Check if the key is in the whitelist
    if ALLOWED_CLIENT_KEYS[key] then
        return
    end
    
    -- Not whitelisted - log the exploit attempt
    if bagName:match("^entity:") then
        local netId = tonumber(bagName:gsub('entity:', ''), 10)
        if netId then
            local entity = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(entity) then
                local owner = NetworkGetEntityOwner(entity)
                print(("^1[SECURITY] Player %d attempted to modify protected state bag key: %s^7"):format(owner, key))
                
                -- Log the exploit attempt
                TriggerEvent("txaLogger:SecurityAlert", {
                    type = "statebag_exploit",
                    player = owner,
                    key = key,
                    value = value,
                    bagName = bagName,
                    timestamp = os.time()
                })
                
                -- Optionally: DropPlayer(owner, "StateBag exploit attempt detected")
            end
        end
    elseif bagName:match("^player:") then
        local playerId = tonumber(bagName:gsub('player:', ''), 10)
        if playerId then
            print(("^1[SECURITY] Player %d attempted to modify protected player state bag key: %s^7"):format(playerId, key))
            
            -- Log the exploit attempt
            TriggerEvent("txaLogger:SecurityAlert", {
                type = "statebag_exploit",
                player = playerId,
                key = key,
                value = value,
                bagName = bagName,
                timestamp = os.time()
            })
            
            -- Optionally: DropPlayer(playerId, "StateBag exploit attempt detected")
        end
    end
end

-- Register handlers for specific state bag patterns to improve performance
AddStateBagChangeHandler(nil, 'entity:', handleStateBagChange)
AddStateBagChangeHandler(nil, 'player:', handleStateBagChange)

print("^2[SECURITY] StateBag protection enabled^7")
