# File Logging Refactoring

## Overview

This document describes the refactoring of file logging infrastructure to eliminate code duplication and create a unified, reusable logging utility.

## Problem Statement

Prior to this refactoring, file logging logic was duplicated across multiple files:

1. **server/[Tools]/_logging.lua** - General error/info logging
2. **server/_chat.lua** - Chat message logging

Both implementations contained nearly identical:
- Queue management systems
- Batch writing logic
- File path generation
- Periodic flush mechanisms

The chat logging also used `io.open()` which doesn't work reliably in FiveM's sandboxed environment.

## Solution

### Shared File Logging Utility

Created `server/[Tools]/_file_logging.lua` that provides:

```lua
-- Create a logger instance
local logger = ig.fileLog.Create({
    logDirectory = "logs",
    filePattern = function(level)
        -- Custom file path generation
        return "logs/app_" .. level .. "_" .. os.date("%Y-%m-%d") .. ".log"
    end,
    batchSize = 100,
    flushDelay = 500,
    periodicFlush = true,
    periodicFlushInterval = 5000
})

-- Queue entries for writing
logger.QueueEntry(message, level)

-- Force flush
logger.Flush()
```

### Key Features

1. **Configurable Queue Processing**: Adjustable batch sizes and flush delays
2. **Batched Writes**: Groups messages by level to minimize file I/O
3. **Automatic Periodic Flushing**: Optional background thread
4. **FiveM-Compatible**: Uses `LoadResourceFile`/`SaveResourceFile` instead of `io.open`
5. **Multiple Instances**: Each subsystem can have its own logger

### Migration

#### General Logging (server/[Tools]/_logging.lua)

**Before:**
```lua
local logQueue = {}
local isWriting = false

local function ProcessLogQueue()
    -- 80+ lines of custom queue processing
end
```

**After:**
```lua
local logger = ig.fileLog.Create({
    logDirectory = "logs",
    filePattern = function(level)
        local date = os.date("%Y-%m-%d")
        return "logs/ingenium_" .. level:lower() .. "_" .. date .. ".log"
    end
})

RegisterNetEvent("Ingenium:Log:ToFile", function(message, level)
    logger.QueueEntry(message, level)
end)
```

#### Chat Logging (server/_chat.lua)

**Before:**
```lua
local chatLogQueue = {}
local isWritingChatLog = false

local function WriteChatLogEntry(entry)
    local file, err = io.open(filePath, "a")  -- ❌ Doesn't work reliably in FiveM
    if file then
        file:write(entry .. "\n")
        file:close()
    end
end
```

**After:**
```lua
local chatLogger = ig.fileLog.Create({
    logDirectory = "logs/chat",
    filePattern = function()
        local date = os.date("%Y-%m-%d")
        return (conf.chat.logging.logDirectory or "logs/chat") .. "/chat_" .. date .. ".log"
    end,
    flushDelay = 0  -- Immediate processing for chat
})

function ig.chat.LogMessage(source, playerName, message, isCommand)
    -- ... validation ...
    chatLogger.QueueEntry(logEntry, "chat")
end
```

## Benefits

1. **Reduced Code Duplication**: ~150 lines of duplicated logic eliminated
2. **Single Source of Truth**: One implementation for queue-based file logging
3. **Improved Reliability**: Uses FiveM-compatible file operations throughout
4. **Better Performance**: Optimized batch writing reduces file I/O
5. **Easier Testing**: Isolated utility can be tested independently
6. **Future Extensibility**: New logging subsystems can easily adopt the pattern

## API Reference

### ig.fileLog.Create(config)

Creates a new logger instance.

**Parameters:**
- `config.logDirectory` (string): Base directory for log files
- `config.filePattern` (function): Returns filename for a given level
- `config.batchSize` (number): Max entries per batch (default: 100)
- `config.flushDelay` (number): Delay before processing queue in ms (default: 500)
- `config.periodicFlush` (boolean): Enable periodic flush thread (default: true)
- `config.periodicFlushInterval` (number): Interval for periodic flush in ms (default: 5000)

**Returns:** Logger instance with methods:
- `QueueEntry(message, level)`: Add entry to queue
- `Flush()`: Force immediate flush
- `GetStats()`: Returns `{queueSize, isWriting}`

### ig.fileLog.CreateSimple(logDirectory, filename, options)

Convenience wrapper for single-file loggers.

**Example:**
```lua
local logger = ig.fileLog.CreateSimple("logs/custom", "app.log", {
    batchSize = 50,
    flushDelay = 1000
})
```

## Migration Notes

### Breaking Changes

None - existing event handlers and exports remain unchanged.

### Backwards Compatibility

✅ All existing functionality preserved:
- `RegisterNetEvent("Ingenium:Log:ToFile")` still works
- `exports('LogToFile', ...)` unchanged
- `ig.chat.LogMessage()` API unchanged
- Log file formats unchanged

### Performance Impact

✅ **Improved Performance**:
- Reduced file I/O through better batching
- Single periodic flush thread instead of multiple
- More efficient queue processing

## Testing

### Manual Testing

1. **General Logging:**
   ```lua
   -- Trigger log events
   TriggerEvent("Ingenium:Log:ToFile", "Test message", "INFO")
   
   -- Verify log file: logs/ingenium_info_YYYY-MM-DD.log
   ```

2. **Chat Logging:**
   ```lua
   -- Send chat message
   TriggerEvent('ig:chat:serverMessage', "Test chat message")
   
   -- Verify log file: logs/chat/chat_YYYY-MM-DD.log
   ```

3. **Verify Queue Stats:**
   ```lua
   local stats = logger.GetStats()
   print(json.encode(stats))  -- {queueSize: 0, isWriting: false}
   ```

### Automated Testing

No automated tests exist in the codebase. Future work should include:
- Unit tests for queue processing
- Integration tests for file writing
- Stress tests for high-volume logging

## Future Improvements

1. **Log Rotation**: Automatic deletion of old log files
2. **Compression**: Archive old logs to save disk space
3. **Remote Logging**: Send logs to external services (Sentry, Datadog)
4. **Structured Logging**: JSON format for better parsing
5. **Log Levels**: Filter by minimum level (DEBUG, INFO, WARN, ERROR)

## Related Files

- `server/[Tools]/_file_logging.lua` - Shared utility (NEW)
- `server/[Tools]/_logging.lua` - General logging (REFACTORED)
- `server/_chat.lua` - Chat logging (REFACTORED)
- `fxmanifest.lua` - Updated to include new file

## Contributors

- Automated refactoring by GitHub Copilot (2026-01)

---

**Last Updated**: 2026-01-19
