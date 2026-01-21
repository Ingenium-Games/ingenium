# ig.fileLog.Create

## Description

Creates a file-based logging system with batch processing, automatic directory creation, and rotation capabilities.

## Signature

```lua
function ig.fileLog.Create(config)
```

## Parameters

- **`config`**: table - Configuration object with the following fields:
  - **`logDirectory`**: string - Base directory for log files
  - **`filePattern`**: string - Pattern for log file naming (supports date placeholders)
  - **`batchSize`**: number (optional) - Number of logs to batch before writing (default: 10)
  - **`flushDelay`**: number (optional) - Delay in milliseconds before flushing batch (default: 5000)
  - **`maxLogSize`**: number (optional) - Maximum log file size before rotation
  - **`enableRotation`**: boolean (optional) - Enable automatic log rotation

## Returns

- **`table`** - Logger instance with methods:
  - `Log(message)` - Adds message to queue
  - `Flush()` - Forces immediate write
  - `Close()` - Closes logger and flushes remaining logs

## Example

```lua
-- Create a custom logger
local logger = ig.fileLog.Create({
    logDirectory = "logs/custom",
    filePattern = "custom_%Y%m%d.log",
    batchSize = 20,
    flushDelay = 10000
})

-- Log messages
logger.Log("This is a log message")
logger.Log("Another log entry")

-- Force flush
logger.Flush()
```

## Source

Defined in: `server/[Tools]/_file_logging.lua`
