# ig.log.Warn(tag, fmt, ...)

**Parameters**: 
- `tag` (string) - Message tag/category
- `fmt` (string) - Format string
- `...` (any) - Format arguments

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [S C]

## Description

Log a warning-level message with tag and formatted text. Warning messages are displayed based on configured logging level.

## Usage

```lua
ig.log.Warn("CONFIG", "Using default value for: %s", configKey)
ig.log.Warn("VEHICLE", "Vehicle %d damaged beyond repair", vehicleId)
```

## Parameters

### tag (string)
Category/tag for the message (e.g., "CONFIG", "DEPRECATION", "PERFORMANCE")

### fmt (string)
Format string (supports standard Lua string.format patterns)

### ... (any)
Arguments to substitute in the format string

## Examples

```lua
-- Simple warning
ig.log.Warn("DEPRECATION", "Function deprecated, use NewFunction instead")

-- Warning with arguments
ig.log.Warn("PERFORMANCE", "Long operation took %dms", elapsedTime)

-- Warning with data context
ig.log.Warn("CONFIG", "Missing key '%s' in config section '%s'", key, section)
```

## See Also

- [ig.log.Error](ig_log_Error.md) - Error-level logging
- [ig.log.Info](ig_log_Info.md) - Info-level logging
- [ig.log.Debug](ig_log_Debug.md) - Debug-level logging
- [ig.log.Trace](ig_log_Trace.md) - Trace-level logging
- [ig.log.Log](ig_log_Log.md) - Generic logging function
