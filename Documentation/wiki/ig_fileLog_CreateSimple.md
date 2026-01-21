# ig.fileLog.CreateSimple

## Description

Creates a simple file-based logger with default configuration.

## Signature

```lua
function ig.fileLog.CreateSimple(logDirectory, filename, options)
```

## Parameters

- **`logDirectory`**: string - Base directory for log files
- **`filename`**: string - Log filename
- **`options`**: table (optional) - Optional configuration overrides (same as `ig.fileLog.Create` config)

## Returns

- **`table`** - Simple logger instance with `Log()`, `Flush()`, and `Close()` methods

## Example

```lua
-- Create a simple logger
local logger = ig.fileLog.CreateSimple("logs", "game.log")

-- Log messages
logger.Log("Player joined the server")
logger.Log("Vehicle spawned")
```

## Source

Defined in: `server/[Tools]/_file_logging.lua`
