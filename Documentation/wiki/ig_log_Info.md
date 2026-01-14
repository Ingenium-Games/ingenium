# ig.log.Info(tag, fmt, ...)

**Parameters**: 
- `tag` (string) - Message tag/category
- `fmt` (string) - Format string
- `...` (any) - Format arguments

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [S C]

## Description

Log an info-level message with tag and formatted text. Info messages are displayed based on configured logging level (equivalent to conf.debug_1).

## Usage

```lua
ig.log.Info("PLAYER", "Player connected: %s", playerName)
ig.log.Info("INIT", "Resource initialized successfully")
```

## Parameters

### tag (string)
Category/tag for the message (e.g., "PLAYER", "INIT", "RESOURCE")

### fmt (string)
Format string (supports standard Lua string.format patterns)

### ... (any)
Arguments to substitute in the format string

## Examples

```lua
-- Simple info message
ig.log.Info("INIT", "Starting server initialization")

-- Info with player data
ig.log.Info("PLAYER", "Player %d (%s) joined (characters: %d)", playerId, playerName, characterCount)

-- Info with status
ig.log.Info("RESOURCE", "Loaded %d vehicles from config", vehicleCount)
```

## See Also

- [ig.log.Error](ig_log_Error.md) - Error-level logging
- [ig.log.Warn](ig_log_Warn.md) - Warn-level logging
- [ig.log.Debug](ig_log_Debug.md) - Debug-level logging
- [ig.log.Trace](ig_log_Trace.md) - Trace-level logging
- [ig.log.Log](ig_log_Log.md) - Generic logging function
