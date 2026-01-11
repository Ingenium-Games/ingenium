-- ====================================================================================--
conf.discord = {}
-- ====================================================================================--
-- Discord Bot Configuration (for internal Discord API integration)
-- Guild ID - Your Discord server ID
conf.discord.guild_id = ""
-- Bot Token - Your Discord bot token (keep this secure!)
conf.discord.bot_token = ""

-- ====================================================================================--
-- Member Role Configuration (Whitelist)
-- ====================================================================================--
-- Enable member role checking for whitelist access
conf.discord.member_role_enabled = true
-- Discord role ID that allows access to the server (member/whitelist role)
conf.discord.member_role = "1147378938805506149"

-- ====================================================================================--
-- Legacy Configuration (for backwards compatibility with discordroles resource)
-- ====================================================================================--
-- This is the gated access to the server via the defferals, needing the specified role.
conf.discord.permissions = true
conf.discord.role = "1147378938805506149"

-- ====================================================================================--
-- Priority Queue Configuration
-- ====================================================================================--
-- Enable priority queue based on Discord roles
conf.discord.priority_enabled = true
-- Priority roles - array of role IDs with their priority power
-- Higher power = higher priority in queue
-- Example: {id = "role_id_here", power = 100}
conf.discord.priority_roles = {
    -- {id = "1234567890", power = 100},  -- VIP role
    -- {id = "0987654321", power = 50},   -- Supporter role
    -- {id = "1122334455", power = 25},   -- Member+ role
}

-- ====================================================================================--
-- Rich Presence Configuration
-- ====================================================================================--
-- Rich Pressence ID
conf.discord.id = "1147088071322509352"