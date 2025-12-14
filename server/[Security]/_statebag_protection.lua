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
}

-- Helper function to handle state bag changes
local function handleStateBagChange(bagName, key, value, reserved, replicated)
    -- Skip if this is a server-side change (reserved = true)
    if reserved then
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
