# Discord Integration Implementation Summary

## Overview
This implementation adds an internal Discord integration module to the Ingenium framework, providing Discord role-based authentication and queue priority management without requiring external resources.

## Changes Made

### 1. New Files Created

#### `server/[Third Party]/_discord.lua`
- **Purpose**: Internal Discord integration module
- **Features**:
  - Discord ID extraction from player identifiers
  - Role checking via Discord API
  - Role caching (5-minute cache) to minimize API calls
  - Member role validation for whitelist
  - Priority role checking for queue system
  - Automatic cache cleanup

#### `_config/discord.lua` (Updated)
- **Added Configuration**:
  - `conf.discord.guild_id` - Discord server ID
  - `conf.discord.bot_token` - Discord bot authentication token
  - `conf.discord.member_role_enabled` - Enable/disable whitelist
  - `conf.discord.member_role` - Role ID for whitelist access
  - `conf.discord.priority_enabled` - Enable/disable priority queue
  - `conf.discord.priority_roles` - Array of priority roles with power levels

#### `_config/discord.example.lua`
- **Purpose**: Example configurations for different server setups
- **Contains**: 5 common configuration scenarios with detailed comments

#### `Documentation/Discord_Integration.md`
- **Purpose**: Comprehensive documentation for Discord integration
- **Sections**:
  - Overview and features
  - Configuration guide
  - API reference
  - Bot setup guide
  - Integration details
  - Troubleshooting
  - Security best practices
  - Performance considerations
  - Example configurations

### 2. Modified Files

#### `server/[Deferals]/_deferals.lua`
- **Changes**:
  - Replaced external `discordroles` resource with internal `ig.discord` module
  - Added Discord-based priority assignment during connection
  - Made Discord checks asynchronous with proper wait handling
  - Integrated priority roles with queue system

#### `fxmanifest.lua`
- **Changes**:
  - Removed `discordroles` from dependencies
  - Added explicit loading order for `_discord.lua` before queue system
  - Explicitly listed Third Party scripts to ensure correct load order

#### `Documentation/README.md`
- **Changes**:
  - Added link to Discord Integration documentation

## Key Features

### 1. Member Role Whitelist
- Restrict server access to users with specific Discord roles
- Configurable enable/disable toggle
- Clear error messages for non-whitelisted users

### 2. Priority Queue System
- Multiple priority tiers based on Discord roles
- Configurable priority power levels
- Highest role priority applies when user has multiple priority roles
- Seamless integration with existing queue system

### 3. Performance Optimizations
- Role data cached for 5 minutes per user
- Async Discord API calls to prevent server blocking
- Automatic cache cleanup to prevent memory leaks
- Minimal connection time impact (~100-500ms)

### 4. Security
- Bot token stored in config (never in code)
- Support for environment variable configuration
- Minimal bot permissions required
- Error handling for API failures

## API Functions

### `ig.discord.GetDiscordId(src)`
Get a player's Discord ID.

### `ig.discord.HasRole(src, roleId, callback)`
Check if a player has a specific Discord role.

### `ig.discord.HasAnyRole(src, roles, callback)`
Check if a player has any of the specified Discord roles.

### `ig.discord.HasMemberRole(src, callback)`
Check if a player has the configured member role (whitelist check).

### `ig.discord.GetPriority(src)`
Get a player's queue priority power based on their Discord roles.

## Configuration Examples

### Public Server with Priority
```lua
conf.discord.member_role_enabled = false
conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "123456", power = 50},
}
```

### Private Server with Whitelist and Priority
```lua
conf.discord.member_role_enabled = true
conf.discord.member_role = "789012"
conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "123456", power = 100},
    {id = "789012", power = 50},
}
```

## Integration Points

### Connection Flow
1. Player connects → `_deferals.lua`
2. Discord ID extracted from identifiers
3. Member role checked (if enabled)
4. Priority roles checked (if enabled)
5. Priority added to queue system
6. Player enters queue or is rejected

### Queue System Integration
- Uses existing `Queue.AddPriority()` function
- Compatible with existing priority sources (database, grace period)
- Priority values combine with other systems

## Testing Recommendations

1. **Member Role Testing**:
   - Test with whitelisted user
   - Test with non-whitelisted user
   - Test with invalid Discord ID
   - Test with Discord ID not in server

2. **Priority Testing**:
   - Test with single priority role
   - Test with multiple priority roles
   - Test priority ordering in queue
   - Test with no priority roles

3. **Error Handling**:
   - Test with invalid bot token
   - Test with invalid guild ID
   - Test with Discord API down
   - Test with network issues

4. **Performance Testing**:
   - Test cache effectiveness
   - Monitor API call frequency
   - Check connection time impact
   - Monitor memory usage

## Migration from discordroles

### Before
```lua
-- fxmanifest.lua
dependencies {
    "discordroles",
}

-- _deferals.lua
exports["discordroles"]:isRolePresent(src, conf.discord.role, function(hasRole, roles)
    -- check logic
end)
```

### After
```lua
-- fxmanifest.lua
dependencies {
    -- discordroles removed
}

-- _deferals.lua
ig.discord.HasMemberRole(src, function(hasMemberRole)
    -- check logic
end)
```

### Migration Steps
1. Update `_config/discord.lua` with bot token and guild ID
2. Configure member role and priority roles as needed
3. Remove `discordroles` resource from server
4. Restart server
5. No other changes needed - backward compatible

## Security Considerations

1. **Bot Token Security**:
   - Never commit tokens to version control
   - Use environment variables in production
   - Rotate tokens if compromised

2. **API Rate Limits**:
   - Caching reduces API calls
   - Discord has rate limits (50 requests per second)
   - Monitor API usage in production

3. **Permissions**:
   - Bot only needs "Server Members Intent"
   - Minimal Discord permissions required
   - No message reading or writing needed

## Future Enhancements

Potential improvements for future versions:
- Automatic role refresh on Discord role change
- Discord webhook integration for events
- Multi-guild support
- Role hierarchy checking
- Discord slash command integration
- Rich presence updates based on player state

## Support Resources

- [Discord Integration Documentation](Documentation/Discord_Integration.md)
- [Discord Developer Portal](https://discord.com/developers/applications)
- [Discord API Documentation](https://discord.com/developers/docs)
- [FiveM Forums](https://forum.cfx.re/)

## Credits

Implementation based on:
- Existing ConnectQueue system by Nick78111 (MIT License)
- FiveM Discord API integration patterns
- Ingenium framework architecture
