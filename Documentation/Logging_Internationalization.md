# Logging & Internationalization

## Overview

Ingenium implements a **production-grade logging system** with queue-based batch writing and **lightweight i18n** supporting 5 languages with fallback chains. Both systems require no external dependencies.

## Logging System

### Log Levels

The logging system uses 5 verbosity levels in numeric hierarchy:

| Level | Number | Purpose |
|-------|--------|---------|
| **Error** | 1 | Critical issues requiring immediate attention |
| **Warn** | 2 | Warning messages about potential problems |
| **Info** | 3 | General information and status messages |
| **Debug** | 4 | Debugging details for development |
| **Trace** | 5 | Most verbose, detailed execution tracing |

### API Functions

Located in `shared/_log.lua`:

```lua
-- Primary logging functions
ig.log.Error(tag, fmt, ...)
ig.log.Warn(tag, fmt, ...)
ig.log.Info(tag, fmt, ...)
ig.log.Debug(tag, fmt, ...)
ig.log.Trace(tag, fmt, ...)

-- Generic with explicit level
ig.log.Log(levelOrName, tag, fmt, ...)
```

**Lowercase aliases** also available (`ig.log.error`, `ig.log.warn`, etc.)

### Usage Examples

```lua
-- Simple message
ig.log.Info("SERVER", "Resource started")

-- With formatting
ig.log.Error("SQL", "Query failed: %s", errorMsg)

-- Multiple arguments
ig.log.Debug("PLAYER", "Player %s spawned at %.2f, %.2f, %.2f", name, x, y, z)

-- Generic with level
ig.log.Log("warn", "SECURITY", "Rate limit exceeded")
ig.log.Log(2, "SECURITY", "Invalid attempt")  -- Numeric level
```

### Output Format

```
[YYYY-MM-DD HH:MM:SS] [LEVEL] [TAG] message
```

Example:
```
[2026-01-20 13:15:00] [INFO] [SERVER] Resource started
[2026-01-20 13:15:05] [ERROR] [SQL] Query failed: timeout
[2026-01-20 13:15:10] [DEBUG] [PLAYER] Player John spawned at 123.45, 678.90, 12.34
```

## File Logging System

### Architecture

Implemented in `server/[Tools]/_file_logging.lua` with **queue-based batch processing**:

**Key Features:**
- **Batch writing** - Groups entries before disk write (reduces I/O)
- **Per-level files** - Separate logs by severity
- **Async queue** - Non-blocking writes prevent server lag
- **Periodic flushing** - Background thread ensures data durability
- **Configurable** - Custom batch sizes, flush delays, file patterns

### Configuration

```lua
-- Create file logger
ig.fileLog.Create({
    logDirectory = "logs",
    filePattern = function(level)
        local date = os.date("%Y-%m-%d")
        return ("ingenium_%s_%s.log"):format(level, date)
    end,
    batchSize = 100,              -- Entries per batch
    flushDelay = 500,             -- Delay before processing (ms)
    periodicFlush = true,         -- Enable background flush
    periodicFlushInterval = 5000  -- Flush every 5 seconds
})
```

### File Structure

```
logs/
├── ingenium_error_2026-01-20.log
├── ingenium_warn_2026-01-20.log
├── ingenium_info_2026-01-20.log
├── ingenium_debug_2026-01-20.log
└── ingenium_trace_2026-01-20.log
```

### Log Entry Format

```
[2026-01-20 13:15:00] [INFO] [SERVER] Resource started successfully
[2026-01-20 13:15:05] [ERROR] [SQL] Connection timeout after 30s
[2026-01-20 13:15:10] [DEBUG] [VALIDATION] Item validation passed for slot 5
```

## Debug Configuration

### Global Settings

Configure in `_config/config.lua`:

```lua
conf.log = {
    enabled = true,           -- Enable console output
    level = "trace",          -- Default threshold (string or number)
    writeToFile = true,       -- Enable file logging
    
    -- Per-level overrides
    levels = {
        error = true,         -- Always log errors
        warn = false,         -- Suppress warnings
        info = false,         -- Suppress info
        debug = true,         -- Enable debug logs
        trace = false         -- Suppress trace
    }
}
```

### Level Logic

**Threshold-based filtering:**
```lua
-- If level = "info", logs info, warn, and error (not debug/trace)
conf.log.level = "info"
```

**Per-level override:**
```lua
-- Individual levels override threshold
conf.log.levels.debug = true  -- Enable debug even if threshold is "info"
```

**File logging respects both:**
- Global `writeToFile` toggle
- Per-level settings
- Console respects `enabled` flag and per-level settings

### Development vs Production

**Development:**
```lua
conf.log = {
    enabled = true,
    level = "trace",
    writeToFile = true,
    levels = {
        error = true,
        warn = true,
        info = true,
        debug = true,
        trace = true
    }
}
```

**Production:**
```lua
conf.log = {
    enabled = true,
    level = "warn",
    writeToFile = true,
    levels = {
        error = true,
        warn = true,
        info = false,
        debug = false,
        trace = false
    }
}
```

## Internationalization (i18n)

### Architecture

- **Translation tables:** `locale/` directory (en.lua, es.lua, fr.lua, de.lua, pt.lua)
- **Helper functions:** `shared/_locale.lua`
- **Configuration:** `conf.locale = "en"` in `_config/config.lua`

### Translation API

```lua
-- Basic translation
_("key")

-- With string.format arguments
_("welcome_message", playerName)

-- Capitalize first character
_L("menu_title")
```

**Global Access:** All functions are globally accessible and exported.

### Supported Languages

| Code | Language | Status |
|------|----------|--------|
| `en` | English | Complete |
| `es` | Spanish | Complete |
| `fr` | French | Complete |
| `de` | German | Complete |
| `pt` | Portuguese | Complete |

### Fallback Chain

```
Requested Locale → English → Key Name
```

Example:
```lua
-- conf.locale = "fr"
_("missing_key")  -- Returns key from "en" if not found in "fr"
_("not_in_any")   -- Returns "not_in_any" if not found anywhere
```

### Translation File Structure

```lua
-- locale/en.lua
Locales["en"] = {
    ["switch"] = "Use to change your character(s).",
    ["defer_welcome"] = "Welcome %s",
    ["menu_title"] = "vehicle menu",
    ["insufficient_funds"] = "Insufficient funds",
    ["player_joined"] = "%s has joined the server",
    ["error_occurred"] = "An error occurred: %s"
}
```

### Usage Examples

```lua
-- Simple translation
local message = _("welcome_message")

-- With formatting
local greeting = _("defer_welcome", playerName)

-- Capitalized
local title = _L("menu_title")  -- "Vehicle menu"

-- In notifications
xPlayer.Notify(_("insufficient_funds"))

-- In menus
local menu = {
    title = _L("vehicle_menu"),
    items = {
        {label = _("lock_doors"), action = "lock"},
        {label = _("unlock_doors"), action = "unlock"}
    }
}
```

### Adding New Translations

1. Add key to `locale/en.lua`:
```lua
Locales["en"]["new_key"] = "New message with %s placeholder"
```

2. Add to other language files:
```lua
Locales["es"]["new_key"] = "Nuevo mensaje con %s marcador"
Locales["fr"]["new_key"] = "Nouveau message avec %s espace réservé"
```

3. Use in code:
```lua
local msg = _("new_key", value)
```

### Configuration

Set default locale in `_config/config.lua`:

```lua
conf.locale = "en"  -- Options: en, es, fr, de, pt
```

## Error Tracking & Reporting

### Validation Errors

Validation system logs detailed error information:

```lua
-- From server/[Validation]/_validator.lua
ig.log.Error("VALIDATION", "Slot %d: Invalid item: %s", idx, itemName)
ig.log.Error("VALIDATION", "Item duplication detected for: %s", itemName)
ig.log.Info("VALIDATION", "Inventory validation passed")
```

### Security Violations

```lua
-- StateBag protection
ig.log.Warn("SECURITY", "Unauthorized StateBag write: %s by %s", key, source)

-- Rate limiting
ig.log.Warn("SECURITY", "Rate limit exceeded by source %d", source)

-- Exploit detection
ig.log.Error("SECURITY", "Item injection attempt by source %d", source)
```

### Transaction Logging

Integrated with security module:

```lua
ig.security.LogPlayerTransaction(
    source,
    'cash_add',
    100,
    'Job payment',
    beforeCash,
    beforeBank
)
```

Logs include:
- Timestamp
- Player source
- Transaction type
- Amount
- Reason
- Before/after balances

### Log Analysis

**Console monitoring:**
```bash
# Watch logs in real-time
tail -f logs/ingenium_error_2026-01-20.log

# Filter by tag
grep "\[SQL\]" logs/ingenium_error_2026-01-20.log

# Count errors
grep -c "\[ERROR\]" logs/ingenium_error_2026-01-20.log
```

## Best Practices

### Logging

1. **Use appropriate levels** - Error for problems, Info for status
2. **Include context** - Tag, player source, item names
3. **Format clearly** - Use string.format for readability
4. **Avoid spam** - Don't log every iteration
5. **Log security events** - Track violations and exploits
6. **Use file logging** - Keep historical records
7. **Rotate logs** - Clean old files periodically
8. **Tag consistently** - Use uppercase tags (SERVER, SQL, PLAYER)

### Internationalization

1. **Use translation keys** - Never hardcode user-facing text
2. **Provide placeholders** - Use %s, %d for dynamic values
3. **Keep keys semantic** - Name by purpose, not content
4. **Update all languages** - Don't leave partial translations
5. **Test fallbacks** - Verify English fallback works
6. **Capitalize appropriately** - Use _L() for titles
7. **Context matters** - Same word may need different translations
8. **Check formatting** - Ensure placeholders align across languages

### Performance

1. **Batch file writes** - Don't write every log immediately
2. **Use periodic flush** - Background thread reduces lag
3. **Filter by level** - Disable verbose logs in production
4. **Monitor file size** - Implement log rotation
5. **Async operations** - Never block server for I/O

## Configuration Reference

### Complete Logging Config

```lua
conf.log = {
    -- Console output
    enabled = true,
    
    -- Threshold (logs at/above this level)
    level = "info",  -- or 1-5 numeric
    
    -- File logging
    writeToFile = true,
    
    -- Per-level overrides
    levels = {
        error = true,
        warn = true,
        info = true,
        debug = false,
        trace = false
    }
}

-- File logger settings
conf.fileLog = {
    logDirectory = "logs",
    batchSize = 100,
    flushDelay = 500,
    periodicFlush = true,
    periodicFlushInterval = 5000
}
```

### Complete i18n Config

```lua
conf.locale = "en"  -- Default language

-- Available locales
conf.availableLocales = {
    "en", "es", "fr", "de", "pt"
}
```

## Debugging Commands

### Console Commands

```lua
-- Change log level at runtime
setr log_level "debug"

-- Toggle file logging
setr log_writeToFile "false"

-- View current settings
print(json.encode(conf.log, {indent = true}))
```

### In-Game Commands

```lua
-- /debuglevel [level]
RegisterCommand('debuglevel', function(source, args)
    if IsPlayerAceAllowed(source, 'command.debuglevel') then
        conf.log.level = args[1] or "info"
        print(('Log level set to: %s'):format(conf.log.level))
    end
end, true)
```

## Related Documentation

- [Validation & Security](Validation_Security.md) - Security logging patterns
- [SQL System](SQL_System.md) - Database query logging
- [Callback System](Callback_System.md) - Event logging
