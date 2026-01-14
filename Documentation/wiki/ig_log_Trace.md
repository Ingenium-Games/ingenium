# ig.log.Trace(tag, fmt, ...)

**Parameters**: 
- `tag` (string) - Message tag/category
- `fmt` (string) - Format string
- `...` (any) - Format arguments

**Returns**: `void`  
**Security**: ✅ Public  
**Side**: [S C]

## Description

Log a trace-level message with tag and formatted text. Trace messages are displayed based on configured logging level (equivalent to conf.debug_3) and provide the most detailed logging.

## Usage

```lua
ig.log.Trace("LOOP", "Iteration %d: processing %s", index, itemName)
ig.log.Trace("EXECUTION", "Function entered: %s", functionName)
```

## Parameters

### tag (string)
Category/tag for the message (e.g., "LOOP", "EXECUTION", "DETAIL")

### fmt (string)
Format string (supports standard Lua string.format patterns)

### ... (any)
Arguments to substitute in the format string

## Examples

```lua
-- Trace loop iterations
ig.log.Trace("LOOP", "Loop iteration %d of %d", i, count)

-- Trace function execution
ig.log.Trace("EXECUTION", "Entering function: %s, args: %d", funcName, argCount)

-- Trace detailed data flow
ig.log.Trace("DATA", "Value %.4f -> %.4f (delta: %.4f)", oldValue, newValue, delta)
```

## See Also

- [ig.log.Error](ig_log_Error.md) - Error-level logging
- [ig.log.Warn](ig_log_Warn.md) - Warn-level logging
- [ig.log.Info](ig_log_Info.md) - Info-level logging
- [ig.log.Debug](ig_log_Debug.md) - Debug-level logging
- [ig.log.Log](ig_log_Log.md) - Generic logging function
