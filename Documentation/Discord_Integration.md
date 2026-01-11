# Discord Integration Guide

## Overview

Ingenium includes an **internal Discord integration module** that provides Discord role-based authentication and queue priority management. This eliminates the need for external Discord role-checking resources and gives you full control over how Discord roles are used in your server.

## Features

- **Member Role Whitelist**: Restrict server access to users with specific Discord roles
- **Priority Queue System**: Grant queue priority based on Discord roles with configurable power levels
- **Role Caching**: Efficient API usage with automatic role caching (5-minute cache)
- **Async Processing**: Non-blocking Discord API calls during player connection
- **Multiple Priority Tiers**: Support for multiple Discord roles with different priority levels

## Configuration

All Discord settings are configured in `_config/discord.lua`.

### Basic Setup

```lua
-- Discord Bot Configuration
conf.discord.guild_id = "YOUR_DISCORD_SERVER_ID"
conf.discord.bot_token = "YOUR_BOT_TOKEN"
```

**Important**: Keep your bot token secure! Never commit it to public repositories.

### Getting Your Discord IDs

1. **Guild ID (Server ID)**:
   - Enable Developer Mode in Discord (Settings > Advanced > Developer Mode)
   - Right-click your server icon and select "Copy ID"

2. **Role IDs**:
   - In Discord, go to Server Settings > Roles
   - Right-click any role and select "Copy ID"

3. **Bot Token**:
   - Go to [Discord Developer Portal](https://discord.com/developers/applications)
   - Create a new application or select an existing one
   - Go to the "Bot" section
   - Copy the bot token
   - **Important**: Enable "Server Members Intent" in the Bot settings

### Member Role (Whitelist)

The member role acts as a whitelist - only users with this role can join the server.

```lua
-- Enable member role checking for whitelist access
conf.discord.member_role_enabled = true

-- Discord role ID that allows access to the server
conf.discord.member_role = "1147378938805506149"
```

To disable whitelist (allow anyone to join):
```lua
conf.discord.member_role_enabled = false
```

### Priority Queue Configuration

Priority roles give players higher positions in the connection queue. Each role has a "power" value - higher power = higher priority.

```lua
-- Enable priority queue based on Discord roles
conf.discord.priority_enabled = true

-- Priority roles with their power levels
conf.discord.priority_roles = {
    {id = "1234567890", power = 100},  -- VIP role (highest priority)
    {id = "0987654321", power = 50},   -- Supporter role (medium priority)
    {id = "1122334455", power = 25},   -- Member+ role (low priority)
}
```

**Priority System**:
- Players with multiple priority roles get the **highest** power level among their roles
- Higher power = earlier position in queue
- Players without priority roles join in the order they connected
- Priority combines with existing priority systems (database-based, grace periods, etc.)

To disable priority queue:
```lua
conf.discord.priority_enabled = false
```

## API Reference

The `ig.discord` module provides several functions for Discord integration.

### ig.discord.GetDiscordId(src)

Get a player's Discord ID.

**Parameters**:
- `src` (number): Player source ID

**Returns**:
- `string|nil`: Discord ID with prefix (e.g., "discord:123456789"), or nil if not found

**Example**:
```lua
local discordId = ig.discord.GetDiscordId(source)
if discordId then
    print("Player Discord ID: " .. discordId)
end
```

### ig.discord.HasRole(src, roleId, callback)

Check if a player has a specific Discord role.

**Parameters**:
- `src` (number): Player source ID
- `roleId` (string): Discord role ID to check
- `callback` (function): Callback with parameters `(hasRole, roles)`
  - `hasRole` (boolean): Whether the player has the role
  - `roles` (table): Array of all role IDs the player has

**Example**:
```lua
ig.discord.HasRole(source, "1147378938805506149", function(hasRole, roles)
    if hasRole then
        print("Player has the VIP role!")
    else
        print("Player does not have the VIP role")
    end
end)
```

### ig.discord.HasAnyRole(src, roles, callback)

Check if a player has any of the specified Discord roles.

**Parameters**:
- `src` (number): Player source ID
- `roles` (table): Array of role IDs to check
- `callback` (function): Callback with parameters `(hasAnyRole, matchedRoles)`
  - `hasAnyRole` (boolean): Whether the player has any of the roles
  - `matchedRoles` (table): Array of matched role IDs

**Example**:
```lua
local priorityRoles = {"123456", "789012", "345678"}
ig.discord.HasAnyRole(source, priorityRoles, function(hasAnyRole, matchedRoles)
    if hasAnyRole then
        print("Player has " .. #matchedRoles .. " priority role(s)")
    end
end)
```

### ig.discord.HasMemberRole(src, callback)

Check if a player has the configured member role (whitelist check).

**Parameters**:
- `src` (number): Player source ID
- `callback` (function): Callback with parameter `(hasMemberRole)`
  - `hasMemberRole` (boolean): Whether the player has the member role

**Example**:
```lua
ig.discord.HasMemberRole(source, function(hasMemberRole)
    if hasMemberRole then
        -- Allow player to join
        print("Player is whitelisted")
    else
        -- Kick player
        DropPlayer(source, "Not whitelisted")
    end
end)
```

### ig.discord.GetPriority(src)

Get a player's queue priority power based on their Discord roles. This is a synchronous function that uses cached role data.

**Parameters**:
- `src` (number): Player source ID

**Returns**:
- `number`: Priority power (0 if no priority roles)

**Example**:
```lua
local priority = ig.discord.GetPriority(source)
if priority > 0 then
    print("Player has priority level: " .. priority)
end
```

## Bot Setup Guide

### 1. Create Discord Bot

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Click "New Application"
3. Give it a name (e.g., "Your Server Bot")
4. Go to the "Bot" section
5. Click "Add Bot"
6. Under "Privileged Gateway Intents", enable:
   - **Server Members Intent** (required)
   - Presence Intent (optional)
   - Message Content Intent (optional)

### 2. Get Bot Token

1. In the Bot section, click "Reset Token"
2. Copy the token and save it securely
3. Add it to your `_config/discord.lua`:
   ```lua
   conf.discord.bot_token = "YOUR_TOKEN_HERE"
   ```

### 3. Invite Bot to Your Server

1. Go to the "OAuth2" > "URL Generator" section
2. Select scopes:
   - `bot`
3. Select bot permissions:
   - View Channels
   - Read Messages/View Channels
4. Copy the generated URL and open it in your browser
5. Select your Discord server and authorize

### 4. Verify Bot is Online

Your bot doesn't need to be actively running - the integration uses Discord's REST API directly. Just ensure:
- Bot token is valid
- Bot is in your server
- Server Members Intent is enabled

## Integration with Queue System

The Discord integration automatically integrates with the existing queue system (`_queue_config.lua`, `_queue_connect.lua`):

1. **Member Role Check**: Happens during player connection (in `_deferals.lua`)
   - Players without the member role are rejected before entering the queue
   
2. **Priority Assignment**: Happens during player connection
   - Discord roles are checked
   - Highest priority role power is assigned to the player
   - Player is placed in queue according to priority

3. **Queue Processing**: Normal queue processing continues
   - Players with higher priority move forward in queue
   - Discord priority combines with other priority sources (database, grace period, etc.)

## Troubleshooting

### Players Can't Join (Discord Check Fails)

**Check**:
1. Bot token is correct in config
2. Guild ID is correct
3. Bot is in your Discord server
4. Server Members Intent is enabled
5. Check server console for error messages

### Priority Not Working

**Check**:
1. `conf.discord.priority_enabled` is `true`
2. Role IDs in `conf.discord.priority_roles` are correct
3. Players actually have those roles in Discord
4. Check queue debug logs (`sv_debugqueue true`)

### Discord API Rate Limiting

The module includes automatic caching (5 minutes) to reduce API calls. If you're still hitting rate limits:

1. Increase cache timeout in `_discord.lua`:
   ```lua
   local cacheTimeout = 600 -- 10 minutes instead of 5
   ```

2. Reduce frequency of checks (only check during connection, which is the default)

## Security Best Practices

1. **Never commit bot tokens**: Add `.env` files to `.gitignore` if storing tokens there
2. **Restrict bot permissions**: Only give the bot necessary permissions in Discord
3. **Use environment variables**: For production, consider using `GetConvar()` to load bot tokens:
   ```lua
   conf.discord.bot_token = GetConvar("discord_bot_token", "")
   ```
4. **Monitor API usage**: Discord has rate limits - the caching system helps, but monitor your API usage
5. **Rotate tokens regularly**: If a token is compromised, regenerate it immediately

## Performance Considerations

- **Caching**: Role data is cached for 5 minutes per user, minimizing API calls
- **Async Operations**: All Discord API calls are asynchronous, preventing server blocking
- **Connection Impact**: Adds ~100-500ms to connection time (for API call)
- **Memory Usage**: Role cache grows with unique connected users (cleared after timeout)

## Migration from discordroles Resource

If you were previously using the `discordroles` external resource:

1. The internal module is now used by default
2. Remove `discordroles` from your server resources
3. Update your config with bot token and guild ID
4. Existing role IDs in config still work (backwards compatible)
5. No other changes needed - the integration is automatic

## Example Configurations

### Public Server (No Whitelist, Priority for Supporters)

```lua
conf.discord.guild_id = "123456789"
conf.discord.bot_token = "YOUR_TOKEN"

conf.discord.member_role_enabled = false -- No whitelist

conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "supporter_role_id", power = 50},
}
```

### Private Server (Whitelist + VIP Priority)

```lua
conf.discord.guild_id = "123456789"
conf.discord.bot_token = "YOUR_TOKEN"

conf.discord.member_role_enabled = true
conf.discord.member_role = "member_role_id" -- Whitelist

conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "vip_role_id", power = 100},
    {id = "premium_role_id", power = 75},
    {id = "supporter_role_id", power = 50},
}
```

### Completely Disabled

```lua
conf.discord.member_role_enabled = false
conf.discord.priority_enabled = false
```

## Related Documentation

- [Queue System Guide](./Queue_System.md) - Connection queue documentation
- [Security Guide](./Security_Guide.md) - General security best practices
- [Validation Architecture](./Validation_Architecture.md) - Input validation system
