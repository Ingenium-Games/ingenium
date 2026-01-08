# Ingenium VOIP System Guide

## Overview

The Ingenium VOIP system is a lightweight Voice Over IP solution built natively for the Ingenium framework. It leverages FiveM's built-in Mumble voice system and provides comprehensive features for proximity voice, radio communication, phone calls, web connections, and admin communication.

## Key Features

- **Proximity Voice**: Distance-based voice chat with configurable ranges (whisper, normal, shout)
- **Radio System**: Multi-channel radio communication with transmission controls
- **Call System**: Direct player-to-player phone calls
- **Connection System**: Web-based voice connections (browser calls, video chats)
- **Admin Call System**: Permission-gated admin-to-player communication
- **Grid-Based Optimization**: Efficient proximity detection using spatial grid system
- **PMA-Voice Compatibility**: Drop-in replacement for pma-voice with wrapper exports
- **Statebag Integration**: Full integration with Ingenium's statebag system
- **Permission System**: ACE-based permissions for sensitive features

## Architecture

### Statebag Keys

The VOIP system uses the following statebag keys for synchronization:

| Key | Type | Description | Client Writable |
|-----|------|-------------|-----------------|
| `InVoice` | boolean | Player is in proximity voice range | Yes |
| `InCall` | boolean | Player is in a phone call | Yes |
| `InConnection` | boolean | Player is in a web connection | Yes |
| `InAdminCall` | boolean | Player is receiving an admin call | No (Server only) |
| `VoiceMode` | number | Current voice mode index (1-3) | Yes |
| `VoiceDistance` | number | Current voice distance in meters | Yes |
| `RadioFrequency` | number | Current radio channel (0 = none) | Yes |
| `RadioTransmitting` | boolean | Player is transmitting on radio | Yes |
| `CallActive` | boolean | Call is currently active | Yes |
| `ConnectionActive` | boolean | Connection is currently active | Yes |
| `IsTalking` | boolean | Player is currently speaking | Yes |

### Voice Channels

The system uses separate Mumble channels for different voice types:

1. **Proximity** (Channel 1): Distance-based voice with volume falloff
2. **Radio** (Channel 2): Radio communication
3. **Call** (Channel 3): One-to-one phone calls
4. **Connection** (Channel 4): Web-based connections
5. **Admin** (Channel 5): Admin calls (highest priority)

## Configuration

All VOIP settings are configured in `_config/voip.lua`:

### Basic Settings

```lua
-- Enable/disable VOIP system
conf.voip.enabled = true

-- Default voice mode (1=Whisper, 2=Normal, 3=Shout)
conf.voip.defaultMode = 2

-- Key to cycle voice modes
conf.voip.rangeKey = "F6"
```

### Voice Modes

Voice modes define the distance ranges for proximity voice:

```lua
conf.voip.modes = {
    {
        name = "Whisper",
        distance = 3.0,  -- meters
        description = "Very close range"
    },
    {
        name = "Normal",
        distance = 8.0,
        description = "Normal conversation distance"
    },
    {
        name = "Shout",
        distance = 15.0,
        description = "Shouting distance"
    }
}
```

### System Features

```lua
-- Enable/disable specific features
conf.voip.radioEnabled = true
conf.voip.callEnabled = true
conf.voip.connectionEnabled = true
conf.voip.adminCallEnabled = true

-- Admin call permission
conf.voip.adminCallAce = "voip.admincall"
```

### Advanced Settings

```lua
-- Audio settings
conf.voip.audio3D = true           -- Directional audio
conf.voip.nativeAudio = true       -- GTA native audio (enables effects)
conf.voip.effectsEnabled = true    -- Voice effects (muffling, etc)
conf.voip.submixEnabled = true     -- Submix for radio effects

-- Environmental effects
conf.voip.vehicleMuffling = true   -- Muffle voice in vehicles
conf.voip.buildingMuffling = true  -- Muffle voice in buildings

-- Performance
conf.voip.useGrid = true           -- Use grid-based proximity
conf.voip.gridSize = 50.0          -- Grid cell size (meters)
conf.voip.updateRate = 500         -- Update interval (milliseconds)

-- Visual
conf.voip.showIndicator = true     -- Show talking indicator
conf.voip.indicatorPosition = "above_head"
```

## Usage

### Client-Side

#### Voice Mode Control

```lua
-- Get current voice mode
local mode = exports['ingenium']:VoiceGetMode()

-- Set voice mode (1-3)
exports['ingenium']:VoiceSetMode(2)

-- Cycle to next mode
exports['ingenium']:VoiceNextMode()
```

#### Radio System

```lua
-- Join radio channel
exports['ingenium']:VoiceJoinRadio(100)

-- Leave radio channel
exports['ingenium']:VoiceLeaveRadio()

-- Start transmitting
exports['ingenium']:VoiceSetRadioTransmit(true)

-- Stop transmitting
exports['ingenium']:VoiceSetRadioTransmit(false)
```

#### Checking Talk State

```lua
-- Check if local player is talking
local isTalking = exports['ingenium']:VoiceIsTalking()
```

#### Events

Listen for VOIP events:

```lua
-- Voice mode changed
AddEventHandler("ingenium:voip:modeChanged", function(modeIndex, mode)
    print(("Voice mode changed to: %s (%.1fm)"):format(mode.name, mode.distance))
end)

-- Radio joined
AddEventHandler("ingenium:voip:radioJoined", function(channel)
    print(("Joined radio channel: %d"):format(channel))
end)

-- Radio left
AddEventHandler("ingenium:voip:radioLeft", function(channel)
    print(("Left radio channel: %d"):format(channel))
end)

-- Radio transmission state
AddEventHandler("ingenium:voip:radioTransmit", function(transmitting)
    print(("Radio transmitting: %s"):format(tostring(transmitting)))
end)

-- Call state changed
AddEventHandler("ingenium:voip:callStateChanged", function(inCall)
    print(("Call state: %s"):format(tostring(inCall)))
end)

-- Connection state changed
AddEventHandler("ingenium:voip:connectionStateChanged", function(inConnection)
    print(("Connection state: %s"):format(tostring(inConnection)))
end)

-- Admin call state changed
AddEventHandler("ingenium:voip:adminCallStateChanged", function(inAdminCall)
    print(("Admin call state: %s"):format(tostring(inAdminCall)))
end)

-- Talking state changed
AddEventHandler("ingenium:voip:talkingStateChanged", function(talking)
    print(("Talking: %s"):format(tostring(talking)))
end)
```

### Server-Side

#### Player Management

```lua
-- Initialize voice for a player (automatically done on connect)
exports['ingenium']:VoiceInitializePlayer(playerId)

-- Set player's voice mode
exports['ingenium']:VoiceSetMode(playerId, 2)
```

#### Radio Management

```lua
-- Make player join radio channel
local success = exports['ingenium']:VoiceJoinRadio(playerId, 100)

-- Make player leave radio channel
exports['ingenium']:VoiceLeaveRadio(playerId, 100)
```

#### Call Management

```lua
-- Start call between two players
local success = exports['ingenium']:VoiceStartCall(callerId, targetId)

-- End call for a player
exports['ingenium']:VoiceEndCall(playerId)
```

#### Connection Management

```lua
-- Start web connection for a player
local success = exports['ingenium']:VoiceStartConnection(playerId, "connection-id-123")

-- End connection for a player
exports['ingenium']:VoiceEndConnection(playerId)
```

#### Admin Call Management

```lua
-- Start admin call to a player (requires ACE permission)
local success = exports['ingenium']:VoiceStartAdminCall(adminId, targetId)

-- End admin call
exports['ingenium']:VoiceEndAdminCall(adminId, targetId)

-- End all admin calls from an admin
exports['ingenium']:VoiceEndAdminCall(adminId)
```

## PMA-Voice Compatibility

The Ingenium VOIP system includes a compatibility wrapper that provides drop-in replacement for pma-voice exports. Most resources built for pma-voice will work without modification.

### Manifest Configuration

Add to your `fxmanifest.lua`:

```lua
provide "pma-voice"
```

This is already included in Ingenium's manifest, so resources depending on pma-voice will automatically use Ingenium VOIP.

### Compatible Exports

#### Client-Side

```lua
-- Set radio channel
exports['pma-voice']:setRadioChannel(100)

-- Set call channel
exports['pma-voice']:setCallChannel(targetServerId)

-- Toggle voice range
exports['pma-voice']:toggleVoiceRange()

-- Set radio talking
exports['pma-voice']:setRadioTalking(true)

-- Check if talking
local talking = exports['pma-voice']:isTalking()
```

#### Server-Side

```lua
-- Set player radio channel
exports['pma-voice']:setPlayerRadioChannel(playerId, 100)

-- Set player call
exports['pma-voice']:setPlayerCallChannel(playerId, targetId)

-- Set player voice mode
exports['pma-voice']:setPlayerVoiceMode(playerId, 2)

-- Get players in proximity
local nearby = exports['pma-voice']:getPlayersInProximity(playerId, 10.0)
```

## Permission System

### Admin Call Permission

The admin call feature requires ACE permission. Configure in `server.cfg`:

```cfg
# Grant admin call permission to a specific user
add_ace identifier.license:ABC123 voip.admincall allow

# Grant to an admin group
add_ace group.admin voip.admincall allow
```

### Security

The InAdminCall statebag is protected from client modification. Only the server can set this state, and it requires the admin to have the proper ACE permission.

## Performance Optimization

### Grid System

The grid system divides the world into cells for efficient proximity detection. Instead of checking distance to all players, the system only checks players in nearby grid cells.

- **Grid Size**: Configurable via `conf.voip.gridSize` (default: 50 meters)
- **Update Rate**: Configurable via `conf.voip.updateRate` (default: 500ms)

### Routing Bucket Isolation

When enabled, players in different routing buckets cannot hear each other, even if in proximity. This is useful for instanced areas or separate dimensions.

```lua
conf.voip.routingBucketIsolation = true
```

## Troubleshooting

### No Voice

1. Verify FiveM voice is enabled in server settings
2. Check that OneSync is enabled (required by Ingenium)
3. Verify `conf.voip.enabled = true` in config
4. Check console for VOIP initialization messages

### Muffled Voice

1. Check vehicle/building muffling settings in config
2. Verify players are in the same routing bucket
3. Check for obstacles between players if building muffling is enabled

### Radio Not Working

1. Verify `conf.voip.radioEnabled = true`
2. Check radio channel is within valid range (1-999 by default)
3. Ensure both players are on the same channel
4. Check radio transmitting state is set correctly

### Admin Call Not Working

1. Verify admin has ACE permission: `voip.admincall`
2. Check `conf.voip.adminCallEnabled = true`
3. Verify target player is online

## API Reference

### Shared Functions

```lua
-- Get voice mode by index
ig.voip.GetVoiceMode(modeIndex) -> VoiceMode|nil

-- Get total voice mode count
ig.voip.GetVoiceModeCount() -> number

-- Get next voice mode index
ig.voip.GetNextVoiceMode(currentIndex) -> number

-- Get previous voice mode index
ig.voip.GetPreviousVoiceMode(currentIndex) -> number

-- Check if radio channel is valid
ig.voip.IsValidRadioChannel(channel) -> boolean

-- Calculate distance between positions
ig.voip.GetDistance(x1, y1, z1, x2, y2, z2) -> number

-- Get grid cell from position
ig.voip.GetGridCell(x, y) -> gridX, gridY

-- Get surrounding grid cells
ig.voip.GetSurroundingGridCells(gridX, gridY) -> table

-- Debug logging
ig.voip.Debug(message)
```

### Client Functions

```lua
-- Initialize Mumble
ig.voip.client.InitializeMumble()

-- Set voice mode
ig.voip.client.SetVoiceMode(modeIndex)

-- Cycle voice modes
ig.voip.client.NextVoiceMode()
ig.voip.client.PreviousVoiceMode()

-- Get voice mode
ig.voip.client.GetVoiceMode() -> number

-- Radio control
ig.voip.client.JoinRadioChannel(channel)
ig.voip.client.LeaveRadioChannel()
ig.voip.client.SetRadioTransmitting(transmitting)

-- Check talking
ig.voip.client.IsTalking() -> boolean
```

### Server Functions

```lua
-- Player management
ig.voip.server.InitializePlayer(playerId)
ig.voip.server.CleanupPlayer(playerId)

-- Voice mode
ig.voip.server.SetVoiceMode(playerId, modeIndex)
ig.voip.server.GetVoiceMode(playerId) -> number|nil

-- Radio
ig.voip.server.JoinRadioChannel(playerId, channel) -> boolean
ig.voip.server.LeaveRadioChannel(playerId, channel)
ig.voip.server.SetRadioTransmitting(playerId, transmitting)

-- Calls
ig.voip.server.StartCall(callerId, targetId) -> boolean
ig.voip.server.EndCall(playerId)

-- Connections
ig.voip.server.StartConnection(playerId, connectionId) -> boolean
ig.voip.server.EndConnection(playerId)

-- Admin calls
ig.voip.server.StartAdminCall(adminId, targetId) -> boolean
ig.voip.server.EndAdminCall(adminId, targetId)

-- Grid
ig.voip.server.UpdateGrid(playerId, x, y)
ig.voip.server.RemoveFromGrid(playerId)
ig.voip.server.GetPlayersInProximity(playerId, distance) -> table
```

## Integration Examples

### Phone System Integration

```lua
-- Client-side: Start call when phone connects
RegisterNetEvent("phone:callStarted", function(targetPhoneNumber, targetServerId)
    TriggerServerEvent("ingenium:voip:startCall", targetServerId)
end)

-- Client-side: End call when phone hangs up
RegisterNetEvent("phone:callEnded", function()
    TriggerServerEvent("ingenium:voip:endCall")
end)

-- Server-side: Handle call request
RegisterNetEvent("ingenium:voip:startCall", function(targetId)
    local src = source
    exports['ingenium']:VoiceStartCall(src, targetId)
end)

RegisterNetEvent("ingenium:voip:endCall", function()
    local src = source
    exports['ingenium']:VoiceEndCall(src)
end)
```

### Radio Item Integration

```lua
-- Client-side: Use radio item
RegisterNetEvent("inventory:useItem:radio", function(item)
    local channel = item.metadata.channel or 0
    
    if channel > 0 then
        exports['ingenium']:VoiceJoinRadio(channel)
        -- Show radio UI
    else
        exports['ingenium']:VoiceLeaveRadio()
    end
end)

-- Client-side: Radio PTT (Push to Talk)
RegisterCommand("+radioTransmit", function()
    exports['ingenium']:VoiceSetRadioTransmit(true)
end, false)

RegisterCommand("-radioTransmit", function()
    exports['ingenium']:VoiceSetRadioTransmit(false)
end, false)

RegisterKeyMapping("+radioTransmit", "Radio Transmit", "keyboard", "LMENU")
```

### Admin Tools Integration

```lua
-- Server-side: Admin command to call player
RegisterCommand("admincall", function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    
    if not targetId then
        print("Usage: /admincall [playerid]")
        return
    end
    
    local success = exports['ingenium']:VoiceStartAdminCall(source, targetId)
    
    if success then
        print(("Admin call started to player %d"):format(targetId))
    else
        print("Failed to start admin call (check permissions)")
    end
end, false)

RegisterCommand("endadmincall", function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    exports['ingenium']:VoiceEndAdminCall(source, targetId)
    print("Admin call ended")
end, false)
```

## Best Practices

1. **Use Events**: Listen for VOIP events to update your UI rather than polling state
2. **Server Authority**: Let the server manage call/radio state for security
3. **ACE Permissions**: Always check permissions for sensitive operations
4. **Performance**: Use the grid system for large servers (default enabled)
5. **Routing Buckets**: Enable bucket isolation for instanced content
6. **Testing**: Test voice in various scenarios (vehicles, buildings, different distances)

## Support

For issues or questions:
- Check the [Ingenium Documentation](../README.md)
- Review the [Contributing Guidelines](../CONTRIBUTING.md)
- Report bugs via GitHub Issues

---

**Version**: 1.0.0  
**Compatible with**: Ingenium Framework 1.0.0+  
**FiveM Build**: Recommended 2802 or higher
