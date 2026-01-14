# ig.log.Log(levelOrName, tag, fmt, ...)

**Parameters**: 
- `levelOrName` (number|string) - Log level (number 1-5 or level name string)
- `tag` (string) - Message tag/category
- `fmt` (string) - Format string
- `...` (any) - Format arguments

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [S C]

## Description

Generic logging function that accepts a level parameter. Can be called with either a numeric level (1-5) or a level name string ("error", "warn", "info", "debug", "trace").

## Usage

```lua
-- Using level names
ig.log.Log("error", "PLAYER", "Connection failed: %s", reason)
ig.log.Log("info", "INIT", "Server started on port %d", port)

-- Using numeric levels
ig.log.Log(1, "SYSTEM", "Critical system failure")
ig.log.Log(4, "DEBUG", "Processing item: %s", itemName)
```

## Parameters

### levelOrName (number|string)
Log level - either:
- **Number**: 1=error, 2=warn, 3=info, 4=debug, 5=trace
- **String**: "error", "warn", "info", "debug", "trace"

### tag (string)
Category/tag for the message

### fmt (string)
Format string (supports standard Lua string.format patterns)

### ... (any)
Arguments to substitute in the format string

## Examples

```lua
-- Dynamic level selection
local level = isDev and "debug" or "info"
ig.log.Log(level, "STARTUP", "Framework initializing")

-- Numeric level usage
local logLevel = 3  -- info
ig.log.Log(logLevel, "PLAYER", "Player count: %d", playerCount)

-- Level based on severity
if severity == "high" then
    ig.log.Log("error", "ALERT", "High severity issue: %s", description)
else
    ig.log.Log("warn", "ALERT", "Alert: %s", description)
end
```

## See Also

- [ig.log.Error](ig_log_Error.md) - Error-level logging
- [ig.log.Warn](ig_log_Warn.md) - Warn-level logging
- [ig.log.Info](ig_log_Info.md) - Info-level logging
- [ig.log.Debug](ig_log_Debug.md) - Debug-level logging
- [ig.log.Trace](ig_log_Trace.md) - Trace-level logging
