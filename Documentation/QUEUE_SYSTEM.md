# Queue System Documentation

## Overview

The Ingenium queue system provides a modern, feature-rich player connection management system with:

- **Adaptive Card UI** - Dynamic, visually appealing queue position updates
- **Multi-Source Priority** - Combines Discord roles, database supporter status, and temporary priorities
- **Admin Management** - Commands to manage queue, send alerts, and handle shutdowns gracefully
- **Extensible Connection Steps** - Add custom validation steps before player connection
- **Graceful Shutdown** - Properly handles server restarts without leaving players stuck

## License

The queue system is based on:
- **ConnectQueue by Nick78111** (MIT License) - Allows commercial use
- **fivem-deferralCards by mw-138** (GPL v3) - Allows commercial use

Both licenses allow for commercial use, modification, and distribution.

## Configuration

### Basic Configuration (`_queue_config_new.lua`)

```lua
-- Maximum players
QueueConf.MaxPlayers = GetConvarInt("sv_maxclients", 48)

-- Enable debug logging
QueueConf.Debug = true

-- Display queue count in server name
QueueConf.DisplayQueue = true

-- Require Steam to connect
QueueConf.RequireSteam = false

-- Whitelist mode (only priority players can join)
QueueConf.PriorityOnly = false
```

### Timeout Configuration

```lua
-- Queue timeout (seconds before removing inactive player)
QueueConf.QueueTimeout = 90

-- Connect timeout (seconds before removing from connecting list)
QueueConf.ConnectTimeout = 600

-- Update interval for queue cards (milliseconds)
QueueConf.UpdateInterval = 500
```

### Grace Period

The grace period gives recently disconnected players temporary priority to reconnect:

```lua
-- Enable grace period
QueueConf.GraceEnabled = true

-- Priority power during grace period
QueueConf.GracePower = 5

-- Grace period duration (seconds)
QueueConf.GraceTime = 300  -- 5 minutes
```

### Priority System

The queue system supports multiple priority sources:

#### 1. Static Priority List

Add specific identifiers to the priority list:

```lua
QueueConf.PriorityList = {
    ["license:abc123"] = 100,
    ["steam:110000103fd1bb1"] = 50,
    ["discord:123456789"] = 25,
}
```

#### 2. Database Supporter Priority

Players with `Supporter = 1` in the database automatically get priority:

```lua
-- Priority power for supporters
QueueConf.SupporterPriority = 10
```

To manage supporter status:

```lua
-- Server-side
ig.sql.user.SetSupporter(license_id, true, callback)  -- Make supporter
ig.sql.user.SetSupporter(license_id, false, callback) -- Remove supporter
ig.sql.user.GetSupporter(license_id, callback)        -- Check status
```

#### 3. Discord Role Priority

Configure Discord role priorities in `_config/discord.lua`:

```lua
conf.discord.priority_enabled = true
conf.discord.priority_roles = {
    {id = "1234567890", power = 100},  -- VIP role
    {id = "0987654321", power = 50},   -- Supporter role
    {id = "1122334455", power = 25},   -- Member+ role
}
```

**Priority Calculation**: The system uses the **highest** priority from all sources (static, supporter, Discord, temp).

## Admin Commands

All commands require admin or moderator permission in the database.

### View Queue

```bash
queue:list
```

Shows all players currently in queue with their position, priority, and wait time.

### Send Alert

```bash
queue:alert <message> [duration_seconds]
```

Send a message that displays on all queue cards. Duration defaults to 30 seconds.

Examples:
```bash
queue:alert Server restart in 5 minutes 300
queue:alert Thank you for waiting!
```

### Remove Player

```bash
queue:remove <player_id|position>
```

Remove a player from the queue by position number or identifier.

Examples:
```bash
queue:remove 1                    # Remove first player
queue:remove license:abc123       # Remove by license ID
```

### Graceful Shutdown

```bash
queue:shutdown [reason] [delay_seconds]
```

Initiates a graceful queue shutdown with a countdown. Default delay is 30 seconds.

Examples:
```bash
queue:shutdown "Server update" 60
queue:shutdown
```

### Help

```bash
queue:help
```

Shows all available queue commands.

## Connection Steps System

Add custom validation or information steps during player connection.

### Registering a Step

```lua
ig.queue.RegisterConnectionStep({
    id = "unique_step_id",
    title = "Step Title",
    description = "Step description shown to player",
    showInQueue = true,  -- Show in queue cards
    handler = function(src, callback)
        -- Your validation logic
        -- callback(true) to proceed
        -- callback(false, "error message") to reject
        
        -- Example: Check something
        if someCondition then
            callback(true)
        else
            callback(false, "You don't meet the requirements")
        end
    end
})
```

### Example: Terms of Service Acceptance

```lua
ig.queue.RegisterConnectionStep({
    id = "tos_acceptance",
    title = "Terms of Service",
    description = "By connecting, you agree to our Terms of Service",
    showInQueue = true,
    handler = function(src, callback)
        -- Always accept (just informational)
        callback(true)
    end
})
```

### Example: Age Verification

```lua
ig.queue.RegisterConnectionStep({
    id = "age_verification",
    title = "Age Verification",
    description = "Checking your age...",
    showInQueue = false,
    handler = function(src, callback)
        local licenseId = GetLicenseId(src)
        
        -- Check database for age verification
        local verified = ig.sql.FetchScalar(
            "SELECT `AgeVerified` FROM `users` WHERE `License_ID` = ?",
            {licenseId}
        )
        
        if verified and tonumber(verified) == 1 then
            callback(true)
        else
            callback(false, "Age verification required. Visit our website.")
        end
    end
})
```

## Adaptive Cards

The queue system automatically generates adaptive cards for:

1. **Queue Position Card** - Shows position, wait time, server messages
2. **Connecting Card** - Shows connection progress through steps

Cards are automatically updated every 500ms (configurable) while player is in queue.

### Card Features

- Real-time position updates
- Queue time tracker
- Estimated wait time
- Admin alerts/messages
- Connection step information
- Server branding

## API Reference

### Exports

#### Get Queue Size

```lua
local size = ig.queue.GetQueueSize()
```

#### Get Queue List

```lua
local list = ig.queue.GetQueueList()
-- Returns array of:
-- {
--   position = 1,
--   name = "PlayerName",
--   priority = 10,
--   queueTime = 120,  -- seconds
--   ids = {...}
-- }
```

#### Remove Player

```lua
local removed = ig.queue.RemovePlayer(ids)
```

#### Send Alert

```lua
ig.queue.SendAlert("Your message", 30)  -- 30 second duration
```

#### Initiate Shutdown

```lua
ig.queue.InitiateShutdown("Reason", 30)  -- 30 second delay
```

#### Register Connection Step

```lua
ig.queue.RegisterConnectionStep(stepConfig)
```

## Server ConVars

Configure via server.cfg:

```cfg
# Maximum players
set sv_maxclients 48

# Enable queue debug logging
set sv_debugqueue "true"

# Display queue count in server name
set sv_displayqueue "true"
```

## Database Schema

The queue system uses the existing `users` table:

```sql
-- Supporter field
ALTER TABLE `users` ADD COLUMN `Supporter` TINYINT(1) NOT NULL DEFAULT 0;
```

This field should already exist in your database.

## Troubleshooting

### Players stuck in queue

1. Check server capacity: `queue:list`
2. Check for errors in server console
3. Restart queue resource if needed

### Priority not working

1. Verify Discord bot token and guild ID in `_config/discord.lua`
2. Check role IDs are correct (right-click role in Discord > Copy ID)
3. Check database Supporter field: `SELECT Supporter FROM users WHERE License_ID = 'license:...'`
4. Enable debug mode to see priority calculations

### Adaptive cards not showing

1. Ensure FiveM client is up to date
2. Check for JavaScript errors in F8 console (client-side)
3. Verify `_adaptivecards.lua` is loading before queue system

## Migration from Old Queue

The new queue system is designed to be backwards compatible. The old queue files remain but are superseded by the new system:

- `_queue_config.lua` → `_queue_config_new.lua`
- `_queue_connect.lua` → `_queue_system.lua`
- Added: `_queue_commands.lua`

Old exports and functions still work through compatibility layer.

## Performance

The queue system is designed to be lightweight:

- Efficient player tracking with minimal overhead
- Cached Discord role lookups (5 minute cache)
- Optimized adaptive card updates
- Automatic cleanup of expired data
- No significant performance impact on server

## Support

For issues or questions:
1. Check server console for error messages
2. Enable debug mode: `set sv_debugqueue "true"`
3. Review this documentation
4. Contact server developers

## Refactoring and Framework Integration

The queue system has been refactored to leverage existing framework functions:

### Framework Functions Used

1. **`ig.func.identifiers(source)`** - Retrieves all player identifiers (steam, fivem, license, discord, ip)
2. **`ig.func.identifier(source)`** - Retrieves primary identifier (license)
3. **`ig.func.Debug_1(msg)`** - Debug logging with framework's debug system
4. **`ig.sql.FetchScalar(query, params)`** - Database scalar queries

### Identifier Handling

Instead of separate functions for each identifier type, the system uses a unified table-based approach:

```lua
local identifiers = GetPlayerIdentifiers(src)
-- Returns:
-- {
--   steam = "steam:...",
--   fivem = "fivem:...",
--   license = "license:...",
--   discord = "discord:...",
--   ip = "ip:...",
--   array = function() -- Returns array format for compatibility
-- }

-- Access identifiers
if identifiers.steam then
    -- Player has Steam
end

-- Get all identifiers as array
local idArray = identifiers.array()
```

This eliminates code duplication and provides a consistent interface for identifier access throughout the queue system.

## Credits

- **ConnectQueue** by Nick78111 - Original queue system
- **fivem-deferralCards** by mw-138 - Adaptive cards implementation
- **Ingenium Games** - Enhanced implementation and features
