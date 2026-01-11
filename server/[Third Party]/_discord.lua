--[[
Internal Discord Integration Module
Provides Discord role checking for whitelist and queue priority
]]--

ig.discord = {}

-- Cache for Discord role data to reduce API calls
local roleCache = {}
local cacheTimeout = 300 -- 5 minutes in seconds
local maxCacheSize = 500 -- Maximum number of cached users
local cacheCount = 0 -- Track cache size efficiently

---@param discordId string The Discord ID (e.g., "discord:123456789")
---@return string|nil The Discord ID without prefix, or nil if invalid
local function ExtractDiscordId(discordId)
    if not discordId then return nil end
    if string.match(discordId, "discord:") then
        return string.gsub(discordId, "discord:", "")
    end
    return discordId
end

---@param src number The player source ID
---@return string|nil The Discord ID, or nil if not found
function ig.discord.GetDiscordId(src)
    local identifiers = GetPlayerIdentifiers(src)
    for _, id in ipairs(identifiers) do
        if string.match(id, "discord:") then
            return id
        end
    end
    return nil
end

---@param src number The player source ID
---@param roleId string The Discord role ID to check
---@param callback function Callback function with parameters (hasRole, roles)
function ig.discord.HasRole(src, roleId, callback)
    if not src or not roleId then
        if callback then callback(false, {}) end
        return
    end

    local discordId = ig.discord.GetDiscordId(src)
    if not discordId then
        if callback then callback(false, {}) end
        return
    end

    local cleanDiscordId = ExtractDiscordId(discordId)
    
    -- Check cache first
    local cached = roleCache[cleanDiscordId]
    if cached and os.time() - cached.timestamp < cacheTimeout then
        local hasRole = false
        for _, role in ipairs(cached.roles) do
            if role == roleId then
                hasRole = true
                break
            end
        end
        if callback then callback(hasRole, cached.roles) end
        return
    end

    -- Make Discord API request
    local guildId = conf.discord.guild_id
    if not guildId then
        print("^1[ERROR] Discord guild ID not configured^7")
        if callback then callback(false, {}) end
        return
    end

    local botToken = conf.discord.bot_token
    if not botToken then
        print("^1[ERROR] Discord bot token not configured^7")
        if callback then callback(false, {}) end
        return
    end

    local apiUrl = string.format("https://discord.com/api/v10/guilds/%s/members/%s", guildId, cleanDiscordId)
    
    PerformHttpRequest(apiUrl, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.roles then
                -- Check cache size and remove oldest entry if needed
                if cacheCount >= maxCacheSize then
                    -- Find and remove oldest entry
                    local oldestId = nil
                    local oldestTime = os.time()
                    for id, cached in pairs(roleCache) do
                        if cached.timestamp < oldestTime then
                            oldestTime = cached.timestamp
                            oldestId = id
                        end
                    end
                    if oldestId then
                        roleCache[oldestId] = nil
                        cacheCount = cacheCount - 1
                    end
                end
                
                -- Cache the roles
                if not roleCache[cleanDiscordId] then
                    cacheCount = cacheCount + 1
                end
                roleCache[cleanDiscordId] = {
                    roles = data.roles,
                    timestamp = os.time()
                }
                
                local hasRole = false
                for _, role in ipairs(data.roles) do
                    if role == roleId then
                        hasRole = true
                        break
                    end
                end
                
                if callback then callback(hasRole, data.roles) end
            else
                if callback then callback(false, {}) end
            end
        else
            print("^1[ERROR] Discord API request failed with status " .. tostring(statusCode) .. "^7")
            if callback then callback(false, {}) end
        end
    end, "GET", "", {
        ["Authorization"] = "Bot " .. botToken,
        ["Content-Type"] = "application/json"
    })
end

---@param src number The player source ID
---@param roles table Array of role IDs to check
---@param callback function Callback function with parameters (hasAnyRole, matchedRoles)
function ig.discord.HasAnyRole(src, roles, callback)
    if not src or not roles or #roles == 0 then
        if callback then callback(false, {}) end
        return
    end

    ig.discord.HasRole(src, roles[1], function(hasRole, userRoles)
        local matchedRoles = {}
        for _, roleId in ipairs(roles) do
            for _, userRole in ipairs(userRoles) do
                if userRole == roleId then
                    table.insert(matchedRoles, roleId)
                    break
                end
            end
        end
        
        local hasAnyRole = #matchedRoles > 0
        if callback then callback(hasAnyRole, matchedRoles) end
    end)
end

---@param src number The player source ID
---@return number The priority power based on Discord roles, or 0 if no priority
function ig.discord.GetPriority(src)
    if not conf.discord.priority_enabled then
        return 0
    end

    local discordId = ig.discord.GetDiscordId(src)
    if not discordId then
        return 0
    end

    -- Check cache for synchronous return
    local cleanDiscordId = ExtractDiscordId(discordId)
    local cached = roleCache[cleanDiscordId]
    if not cached or os.time() - cached.timestamp >= cacheTimeout then
        return 0 -- Return 0 if no cache, async check will happen in deferral
    end

    -- Check priority roles
    local highestPriority = 0
    if conf.discord.priority_roles then
        for _, priorityRole in ipairs(conf.discord.priority_roles) do
            for _, userRole in ipairs(cached.roles) do
                if userRole == priorityRole.id then
                    if priorityRole.power > highestPriority then
                        highestPriority = priorityRole.power
                    end
                end
            end
        end
    end

    return highestPriority
end

---@param src number The player source ID
---@param callback function Callback function with parameter (hasMemberRole)
function ig.discord.HasMemberRole(src, callback)
    if not conf.discord.member_role_enabled then
        if callback then callback(true) end -- If not enabled, allow by default
        return
    end

    local memberRole = conf.discord.member_role
    if not memberRole then
        print("^1[ERROR] Discord member role not configured but member_role_enabled is true^7")
        if callback then callback(false) end
        return
    end

    ig.discord.HasRole(src, memberRole, function(hasRole, roles)
        if callback then callback(hasRole) end
    end)
end

-- Clear role cache periodically
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Every minute
        local currentTime = os.time()
        local removed = 0
        for discordId, data in pairs(roleCache) do
            if currentTime - data.timestamp >= cacheTimeout then
                roleCache[discordId] = nil
                removed = removed + 1
            end
        end
        if removed > 0 then
            cacheCount = cacheCount - removed
        end
    end
end)

ig.func.Debug_1("^2[Discord] Internal Discord module loaded^7")
