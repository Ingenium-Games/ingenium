-- ====================================================================================--
-- Discord Integration - Example Configuration
-- ====================================================================================--
-- This file shows example configurations for different server setups.
-- Copy the relevant section to your _config/discord.lua file.
-- ====================================================================================--

--[[
    EXAMPLE 1: Public Server with Priority for Supporters
    - No whitelist (anyone can join)
    - Supporters get priority in queue
]]--
conf.discord.guild_id = "YOUR_DISCORD_SERVER_ID"
conf.discord.bot_token = "YOUR_BOT_TOKEN_HERE"

-- Disable whitelist
conf.discord.member_role_enabled = false

-- Enable priority queue
conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "YOUR_SUPPORTER_ROLE_ID", power = 50},
}

--[[
    EXAMPLE 2: Private Server with Whitelist and Multiple Priority Tiers
    - Only members with specific role can join
    - Multiple priority tiers for different supporter levels
]]--
conf.discord.guild_id = "YOUR_DISCORD_SERVER_ID"
conf.discord.bot_token = "YOUR_BOT_TOKEN_HERE"

-- Enable whitelist
conf.discord.member_role_enabled = true
conf.discord.member_role = "YOUR_MEMBER_ROLE_ID"

-- Enable priority queue with multiple tiers
conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "YOUR_VIP_ROLE_ID", power = 100},      -- VIP gets highest priority
    {id = "YOUR_PREMIUM_ROLE_ID", power = 75},   -- Premium gets high priority
    {id = "YOUR_SUPPORTER_ROLE_ID", power = 50}, -- Supporter gets medium priority
    {id = "YOUR_MEMBER_PLUS_ROLE_ID", power = 25}, -- Member+ gets low priority
}

--[[
    EXAMPLE 3: Completely Disabled
    - No Discord integration
    - Anyone can join
    - No priority queue
]]--
conf.discord.member_role_enabled = false
conf.discord.priority_enabled = false

--[[
    EXAMPLE 4: Whitelist Only (No Priority)
    - Only members with specific role can join
    - No priority queue based on roles
]]--
conf.discord.guild_id = "YOUR_DISCORD_SERVER_ID"
conf.discord.bot_token = "YOUR_BOT_TOKEN_HERE"

-- Enable whitelist
conf.discord.member_role_enabled = true
conf.discord.member_role = "YOUR_MEMBER_ROLE_ID"

-- Disable priority queue
conf.discord.priority_enabled = false

--[[
    EXAMPLE 5: Priority Only (No Whitelist)
    - Anyone can join (no whitelist)
    - VIP members get priority in queue
]]--
conf.discord.guild_id = "YOUR_DISCORD_SERVER_ID"
conf.discord.bot_token = "YOUR_BOT_TOKEN_HERE"

-- Disable whitelist
conf.discord.member_role_enabled = false

-- Enable priority queue
conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "YOUR_VIP_ROLE_ID", power = 100},
}

-- ====================================================================================--
-- HOW TO GET YOUR DISCORD IDs
-- ====================================================================================--
--[[
    1. GUILD ID (Server ID):
       - Enable Developer Mode in Discord (Settings > Advanced > Developer Mode)
       - Right-click your server icon and select "Copy ID"
    
    2. ROLE IDs:
       - In Discord, go to Server Settings > Roles
       - Right-click any role and select "Copy ID"
    
    3. BOT TOKEN:
       - Go to https://discord.com/developers/applications
       - Create a new application or select an existing one
       - Go to the "Bot" section
       - Copy the bot token
       - IMPORTANT: Enable "Server Members Intent" in the Bot settings
    
    4. INVITE BOT TO SERVER:
       - In Developer Portal, go to OAuth2 > URL Generator
       - Select scopes: "bot"
       - Select bot permissions: "View Channels", "Read Messages/View Channels"
       - Copy the generated URL and open it in your browser
       - Select your Discord server and authorize
]]--

-- ====================================================================================--
-- SECURITY NOTES
-- ====================================================================================--
--[[
    1. NEVER commit your bot token to a public repository
    2. Keep your bot token secure - treat it like a password
    3. If your token is compromised, regenerate it immediately in Discord Developer Portal
    4. Consider using environment variables for production:
       conf.discord.bot_token = GetConvar("discord_bot_token", "")
       Then set in server.cfg: set discord_bot_token "YOUR_TOKEN_HERE"
]]--
