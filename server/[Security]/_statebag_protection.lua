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

-- Global StateBag change handler to protect against client-side modifications
AddStateBagChangeHandler(nil, nil, function(bagName, key, value, reserved, replicated)
    -- Skip if this is a server-side change (reserved = true)
    if reserved then
        return
    end
    
    -- Check if this is an entity state bag
    if bagName:match("^entity:") then
        local netId = tonumber(bagName:gsub('entity:', ''), 10)
        if netId then
            local entity = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(entity) then
                local owner = NetworkGetEntityOwner(entity)
                
                -- Check if the key is in the whitelist
                if not ALLOWED_CLIENT_KEYS[key] then
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
                    -- For now, just log and warn
                end
            end
        end
    elseif bagName:match("^player:") then
        -- Handle player state bags similarly
        local playerId = tonumber(bagName:gsub('player:', ''), 10)
        if playerId then
            -- Check if the key is in the whitelist
            if not ALLOWED_CLIENT_KEYS[key] then
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
end)

print("^2[SECURITY] StateBag protection enabled^7")
