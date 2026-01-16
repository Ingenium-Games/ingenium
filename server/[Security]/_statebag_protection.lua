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
    -- VOIP statebag keys
    ["InVoice"] = true,
    ["InCall"] = true,
    ["InConnection"] = true,
    ["VoiceMode"] = true,
    ["VoiceDistance"] = true,
    ["RadioFrequency"] = true,
    ["RadioTransmitting"] = true,
    ["CallActive"] = true,
    ["ConnectionActive"] = true,
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
    ["InAdminCall"] = true, -- Only server can set admin call state
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
            ig.log.Error("SECURITY", "Player %d attempted to modify BLOCKED key: %s", playerId, key)
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
                ig.log.Warn("SECURITY", "Player %d attempted to modify protected state bag key: %s", owner, key)
                
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
            ig.log.Warn("SECURITY", "Player %d attempted to modify protected player state bag key: %s", playerId, key)
            
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

-- ====================================================================================--
-- Public API for external developers
-- ====================================================================================--

--- Add a key to the allowed client keys whitelist
---@param key string The state bag key to allow clients to modify
---@return boolean success True if the key was added successfully
function ig.security.AddAllowedStateBagKey(key)
    if type(key) ~= "string" or key == "" then
        ig.log.Warn("SECURITY", "AddAllowedStateBagKey: Invalid key provided")
        return false
    end
    
    if ALLOWED_CLIENT_KEYS[key] then
        ig.log.Warn("SECURITY", "Key '%s' is already in the allowed list", key)
        return false
    end
    
    ALLOWED_CLIENT_KEYS[key] = true
    ig.log.Info("SECURITY", "Added '%s' to allowed StateBag keys", key)
    return true
end

--- Remove a key from the allowed client keys whitelist
---@param key string The state bag key to remove from allowed list
---@return boolean success True if the key was removed successfully
function ig.security.RemoveAllowedStateBagKey(key)
    if type(key) ~= "string" or key == "" then
        ig.log.Warn("SECURITY", "RemoveAllowedStateBagKey: Invalid key provided")
        return false
    end
    
    if not ALLOWED_CLIENT_KEYS[key] then
        ig.log.Warn("SECURITY", "Key '%s' is not in the allowed list", key)
        return false
    end
    
    ALLOWED_CLIENT_KEYS[key] = nil
    ig.log.Info("SECURITY", "Removed '%s' from allowed StateBag keys", key)
    return true
end

--- Add a key to the blocked client keys blacklist
---@param key string The state bag key to block clients from modifying
---@return boolean success True if the key was added successfully
function ig.security.AddBlockedStateBagKey(key)
    if type(key) ~= "string" or key == "" then
        ig.log.Warn("SECURITY", "AddBlockedStateBagKey: Invalid key provided")
        return false
    end
    
    if BLOCKED_CLIENT_KEYS[key] then
        ig.log.Warn("SECURITY", "Key '%s' is already in the blocked list", key)
        return false
    end
    
    BLOCKED_CLIENT_KEYS[key] = true
    ig.log.Info("SECURITY", "Added '%s' to blocked StateBag keys", key)
    return true
end

--- Remove a key from the blocked client keys blacklist
---@param key string The state bag key to remove from blocked list
---@return boolean success True if the key was removed successfully
function ig.security.RemoveBlockedStateBagKey(key)
    if type(key) ~= "string" or key == "" then
        ig.log.Warn("SECURITY", "RemoveBlockedStateBagKey: Invalid key provided")
        return false
    end
    
    if not BLOCKED_CLIENT_KEYS[key] then
        ig.log.Warn("SECURITY", "Key '%s' is not in the blocked list", key)
        return false
    end
    
    BLOCKED_CLIENT_KEYS[key] = nil
    ig.log.Info("SECURITY", "Removed '%s' from blocked StateBag keys", key)
    return true
end

--- Get all allowed StateBag keys
---@return table allowedKeys Table of allowed keys (key = true format)
function ig.security.GetAllowedStateBagKeys()
    local keys = {}
    for key, _ in pairs(ALLOWED_CLIENT_KEYS) do
        keys[key] = true
    end
    return keys
end

--- Get all blocked StateBag keys
---@return table blockedKeys Table of blocked keys (key = true format)
function ig.security.GetBlockedStateBagKeys()
    local keys = {}
    for key, _ in pairs(BLOCKED_CLIENT_KEYS) do
        keys[key] = true
    end
    return keys
end

-- Register handlers for specific state bag patterns to improve performance
AddStateBagChangeHandler(nil, 'entity:', handleStateBagChange)
AddStateBagChangeHandler(nil, 'player:', handleStateBagChange)

ig.log.Info("SECURITY", "StateBag protection enabled")
