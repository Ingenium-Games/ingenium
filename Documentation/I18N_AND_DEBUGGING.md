# Internationalization (i18n) and Debugging Guide

## Table of Contents
- [Internationalization (i18n)](#internationalization-i18n)
- [Enhanced Debugging System](#enhanced-debugging-system)
- [Error Handling](#error-handling)
- [Server-Side Logging](#server-side-logging)

---

## Internationalization (i18n)

### Overview
Ingenium now supports multiple languages through a locale system. Users can change their preferred language by setting `conf.locale` in the configuration file.

### Supported Languages
- `en` - English (default)
- `fr` - French (Français)
- `es` - Spanish (Español)
- `de` - German (Deutsch)
- `pt` - Portuguese (Português)

### Configuration
Set the locale in `_config/config.lua`:
```lua
conf.locale = "en"  -- Change to "fr", "es", "de", or "pt"
```

### Using Translations in Code
Use the `_()` function to translate text:
```lua
local text = _("switch")  -- Returns translated text for current locale
```

Use the `_L()` function for uppercase first character:
```lua
local text = _L("switch")  -- Returns translated text with first character uppercase
```

### Fallback System
If a translation is missing:
1. The system will attempt to use the English translation
2. If no English translation exists, it will return the key itself

This ensures the system never shows error messages for missing translations.

### Adding New Locales
To add a new locale:

1. Create a new file in the `locale/` directory (e.g., `locale/it.lua` for Italian)
2. Follow this format:
```lua
Locales["it"] = {
    ["switch"] = "Usa per cambiare personaggio(i).",
    ["setjob"] = "Permesso(i) moderatore richiesto(i).",
    -- Add more translations...
}
```
3. The file will be automatically loaded by the manifest

### Adding New Translation Keys
To add new translation keys to all locales:

1. Add the key to `locale/en.lua` first (this is the fallback)
2. Add the same key to all other locale files with appropriate translations
3. Use the key in your code with `_("your_key")`

---

## Enhanced Debugging System

### Overview
The new debugging system provides detailed error tracking with resource name, file path, line numbers, function names, and stack traces.

### Debug Levels
The system supports 5 debug levels in order of severity:

| Level | Name | Config Flag | Purpose |
|-------|------|-------------|---------|
| 1 | ERROR | `conf.error` | Critical errors that should always be logged |
| 2 | WARN | N/A | Warnings about potential issues |
| 3 | INFO | `conf.debug_1` | Top-level function tracking (formerly Debug_1) |
| 4 | DEBUG | `conf.debug_2` | State and class generation (formerly Debug_2) |
| 5 | TRACE | `conf.debug_3` | Detailed alterations and events (formerly Debug_3) |

### Configuration
Set debug levels in `_config/config.lua`:
```lua
conf.error = true     -- Always show errors
conf.debug_1 = true   -- Show INFO level messages
conf.debug_2 = false  -- Hide DEBUG level messages
conf.debug_3 = true   -- Show TRACE level messages
```


### Function Wrapping
You can wrap functions to automatically catch and log errors:

```lua
-- Wrap a function with error handling
local safeFunction = ig.debug.Wrap(function(param1, param2)
    -- Your code here
    if param1 == nil then
        error("param1 cannot be nil")
    end
    return param1 + param2
end, "MyFunctionName")

-- Call the wrapped function
local result = safeFunction(5, 10)
-- If an error occurs, it will be logged with full context
```

### Custom Error Handlers
You can use the error handler directly with xpcall:
```lua
local success, result = xpcall(function()
    -- Your code that might error
    return someRiskyOperation()
end, ig.debug.ErrorHandler)

if not success then
    print("Operation failed:", result)
end
```

---

## Server-Side Logging

### Overview
On the server side, ERROR and WARN level messages are automatically written to log files in addition to console output.

### Log File Location
Log files are created in the `logs/` directory:
- `logs/ingenium_error_YYYY-MM-DD.log` - Error logs
- `logs/ingenium_warn_YYYY-MM-DD.log` - Warning logs

Each day gets its own log file.

### Log File Format
Log entries include timestamps and full context:
```
[2026-01-08 10:30:45] [ERROR] [ingenium] /path/to/file.lua:42 in MyFunction() - Error message
```

### Manual Logging to File
You can manually log to a file using the export:
```lua
-- Server-side only
exports['ingenium']:LogToFile("Custom message", "ERROR")
```

### Log File Management
- Log files are automatically rotated daily
- Old log files are kept for historical reference
- The `logs/` directory is excluded from git (see `.gitignore`)
- Log writing is batched for performance (writes every 5 seconds)

### Viewing Logs
On Windows Server:
```batch
type logs\ingenium_error_2026-01-08.log
```

On Linux:
```bash
cat logs/ingenium_error_2026-01-08.log
tail -f logs/ingenium_error_2026-01-08.log  # Live monitoring
```

---

## Best Practices

### When to Use Each Log Level

**ERROR** - Use for:
- Database connection failures
- Critical resource failures
- Data corruption
- Security violations

**WARN** - Use for:
- Deprecated function usage
- Configuration issues that have fallbacks
- Resource intensive operations
- Potential security concerns

**INFO** - Use for:
- Player connections/disconnections
- Important state changes
- Resource initialization
- Successful major operations

**DEBUG** - Use for:
- Function entry/exit
- Variable state changes
- Loop iterations (when needed)
- Class/object creation

**TRACE** - Use for:
- Detailed execution flow
- Event triggers and handlers
- Data transformation steps
- Performance timing points

### Performance Considerations
- Debug messages are only processed if their level is enabled
- File logging is batched to minimize I/O overhead
- Use appropriate log levels to avoid console spam
- Disable DEBUG and TRACE levels in production

### Locale Best Practices
- Always provide English translations first (fallback)
- Keep translations concise
- Use placeholders for dynamic content: `_("message", playerName)`
- Test with multiple locales before release

---

## Examples

### Example 1: Function with Error Handling
```lua
function ProcessPlayerData(playerId, data)
    ig.debug.Info("Processing player data for: " .. playerId)
    
    if not data then
        ig.debug.Error("No data provided for player: " .. playerId)
        return false
    end
    
    ig.debug.Debug("Data validation passed")
    
    -- Process data...
    local success = DoSomethingWithData(data)
    
    if not success then
        ig.debug.Warn("Failed to process data for player: " .. playerId)
        return false
    end
    
    ig.debug.Info("Successfully processed data for player: " .. playerId)
    return true
end
```

### Example 2: Wrapped Function with Locale Support
```lua
local SafePlayerConnect = ig.debug.Wrap(function(source)
    local playerName = GetPlayerName(source)
    local message = _("player_connected", playerName)
    
    ig.debug.Info(message)
    
    -- Your connection logic here
    InitializePlayer(source)
    
    return true
end, "PlayerConnect")

-- Use it in an event
RegisterNetEvent("playerConnecting", function()
    SafePlayerConnect(source)
end)
```

### Example 3: Multi-Level Debug Tracking
```lua
function ComplexOperation(input)
    ig.debug.Info("Starting complex operation")
    
    local step1 = ig.debug.Wrap(function()
        ig.debug.Debug("Executing step 1")
        -- Step 1 logic
        return processStep1(input)
    end, "ComplexOperation_Step1")
    
    local step2 = ig.debug.Wrap(function()
        ig.debug.Debug("Executing step 2")
        -- Step 2 logic
        return processStep2(step1())
    end, "ComplexOperation_Step2")
    
    local result = step2()
    ig.debug.Info("Complex operation completed")
    
    return result
end
```

---

## Troubleshooting

### Locale not working
1. Check that `conf.locale` is set correctly in `_config/config.lua`
2. Verify the locale file exists in `locale/` directory
3. Check console for any errors during resource start
4. Ensure the locale file has the correct format

### Debug messages not showing
1. Check debug flags in `_config/config.lua`
2. Verify the message level matches enabled flags
3. Ensure `shared/[Tools]/_debug.lua` is loaded (check manifest)

### Log files not created
1. Verify the resource has write permissions
2. Check that you're on the server side (client can't write files)
3. Look for error messages in console
4. Ensure `server/[Tools]/_logging.lua` is loaded

---

## Support

For issues, questions, or contributions related to i18n and debugging:
- Check the [main README](../README.md)
- Review [CONTRIBUTING.md](../CONTRIBUTING.md)
- Open an issue on GitHub

---

*Last updated: 2026-01-08*
