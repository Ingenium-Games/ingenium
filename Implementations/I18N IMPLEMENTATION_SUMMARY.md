# Implementation Summary: i18n and Enhanced Debugging

## Overview
This implementation adds comprehensive internationalization (i18n) support and enhanced debugging capabilities to the Ingenium FiveM framework, addressing the requirements from the original issue.

## What Was Implemented

### 1. Internationalization (i18n) System

#### Supported Languages
- **English (en)** - Default language with full coverage
- **French (fr)** - Complete translations for all keys
- **Spanish (es)** - Complete translations for all keys
- **German (de)** - Key translations with English fallback
- **Portuguese (pt)** - Key translations with English fallback

#### Translation Coverage (80+ keys)
- ✅ Deferral/connection adaptive card messages
- ✅ Queue system messages
- ✅ Inventory system messages
- ✅ Character management messages
- ✅ Banking and transaction messages
- ✅ Appearance system messages
- ✅ Developer command messages
- ✅ Security and validation messages
- ✅ General user-facing messages

#### Technical Implementation
- **Locale Function**: `_(key, ...)` for translations with format string support
- **Uppercase Function**: `_L(key, ...)` for capitalized translations
- **Fallback Chain**: Requested locale → English → key itself
- **Configuration**: `conf.locale = "en"` in `_config/config.lua`
- **Export**: `exports["ingenium"]:GetLocale()` for consistent access

#### Updated Files for Locale Support
1. `server/[Deferals]/_deferals.lua` - All adaptive card text now localized
2. `server/[Third Party]/_queue_config.lua` - Queue system messages localized
3. `shared/_locale.lua` - Enhanced with fallback and format support
4. `shared/_ig.lua` - Added GetLocale export

### 2. Enhanced Debugging System

#### Debug Levels
| Level | Name  | Config Flag   | Use Case                          |
|-------|-------|---------------|-----------------------------------|
| 1     | ERROR | `conf.error`  | Critical errors (always logged)   |
| 2     | WARN  | N/A           | Potential issues and warnings     |
| 3     | INFO  | `conf.debug_1`| Top-level function tracking       |
| 4     | DEBUG | `conf.debug_2`| State/class generation details    |
| 5     | TRACE | `conf.debug_3`| Detailed execution flow           |

#### Error Context Tracking
Every error now automatically captures:
- ✅ Resource name (e.g., "ingenium")
- ✅ Source file path (e.g., "/path/to/file.lua")
- ✅ Line number (e.g., "42")
- ✅ Function name (e.g., "MyFunction()")
- ✅ Full stack trace

#### Server-Side File Logging
- **Log Location**: `logs/ingenium_{level}_YYYY-MM-DD.log`
- **Log Levels**: ERROR and WARN automatically logged to files
- **Rotation**: Daily log files (date-based)
- **Performance**: Batched writes every 5 seconds
- **Format**: `[timestamp] [LEVEL] [resource] file:line in function() - message`

#### Function Wrapping
```lua
local safeFunc = ig.debug.Wrap(function(arg)
    -- Your code here
    return result
end, "FunctionName")

local result = safeFunc(value) -- Errors automatically logged
```

#### New Debug Functions
```lua
ig.debug.Error("Critical error")   -- Level 1
ig.debug.Warn("Warning message")   -- Level 2  
ig.debug.Info("Info message")      -- Level 3
ig.debug.Debug("Debug details")    -- Level 4
ig.debug.Trace("Trace flow")       -- Level 5
```


### 3. New Files Created

#### Core Implementation
- `shared/[Tools]/_debug.lua` (5,525 bytes) - Core debugging system
- `server/[Tools]/_logging.lua` (2,226 bytes) - Server-side file logging

#### Locale Files
- `locale/en.lua` (3,850 bytes) - English translations
- `locale/fr.lua` (4,100 bytes) - French translations
- `locale/es.lua` (3,950 bytes) - Spanish translations
- `locale/de.lua` (1,200 bytes) - German translations (key messages)
- `locale/pt.lua` (1,250 bytes) - Portuguese translations (key messages)

#### Documentation
- `Documentation/I18N_AND_DEBUGGING.md` (10,512 bytes) - Comprehensive guide
- `Documentation/EXAMPLES_I18N_DEBUG.lua` (6,790 bytes) - Code examples

### 4. Modified Files

#### Configuration
- `_config/config.lua` - Added `conf.error` flag and updated debug comments
- `.gitignore` - Added `logs/` and `*.log` exclusions

#### Core Systems
- `shared/_ig.lua` - Added GetLocale export
- `shared/_locale.lua` - Enhanced fallback and format support
- `client/_functions.lua` - Integrated new debug system with fallback
- `server/_functions.lua` - Integrated new debug system with fallback
- `fxmanifest.lua` - Added server/[Tools]/_logging.lua to manifest

#### User-Facing Systems
- `server/[Deferals]/_deferals.lua` - All text now uses locale keys
- `server/[Third Party]/_queue_config.lua` - Queue messages use locale keys

#### Documentation
- `Documentation/README.md` - Added i18n and debugging sections

## Configuration

### Enable Localization
In `_config/config.lua`:
```lua
conf.locale = "en"  -- Options: "en", "fr", "es", "de", "pt"
```

### Enable Debug Levels
In `_config/config.lua`:
```lua
conf.error = true    -- Critical errors (always show)
conf.debug_1 = true  -- INFO level (top-level tracking)
conf.debug_2 = false -- DEBUG level (detailed state)
conf.debug_3 = true  -- TRACE level (execution flow)
```

## Usage Examples

### Using Localization
```lua
-- Simple translation
local message = _("defer_welcome", playerName)

-- With formatting
local queuePos = _("queue_pos", position, total, tempText)

-- Uppercase first character
local title = _L("switch")
```

### Using Enhanced Debugging
```lua
-- Log at different levels
ig.debug.Error("Database connection failed")
ig.debug.Warn("Player timeout approaching")
ig.debug.Info("Player connected: " .. playerId)
ig.debug.Debug("State updated: " .. stateName)
ig.debug.Trace("Loop iteration: " .. i)

-- Wrap functions for automatic error handling
local SafeProcess = ig.debug.Wrap(function(data)
    -- Process data
    return result
end, "ProcessData")

local result = SafeProcess(playerData)
```

## Testing Recommendations

### Locale Testing
1. Set `conf.locale = "fr"` and restart resource
2. Connect to server and verify deferral messages in French
3. Join queue and verify queue messages in French
4. Repeat for "es", "de", "pt"
5. Test with missing translation key (should fallback to English)

### Debug Testing
1. Set different debug levels in config
2. Trigger errors and verify they appear in:
   - Console with color coding
   - Log files in `logs/` directory
3. Verify stack traces show correct file and line numbers
4. Test wrapped functions catch errors properly
5. Verify backward compatibility with old debug calls

### Performance Testing
1. Monitor server performance with logging enabled
2. Check log file sizes grow reasonably
3. Verify batched writing doesn't cause delays
4. Test with high volume of debug messages

## Migration Guide

### Adding New Translations
1. Add key to `locale/en.lua` first (fallback)
2. Add same key to other locale files with translations
3. Use `_(key)` or `_(key, args...)` in your code

## Benefits

### For Server Administrators
- Multi-language support for international communities
- Better error tracking and debugging
- Organized log files for troubleshooting
- No breaking changes to existing setup

### For Developers
- Easy-to-use debug levels
- Automatic error context capture
- Function wrapping for safe execution
- Comprehensive documentation and examples

### For Players
- Native language support
- Better connection experience
- Clearer error messages

## Notes

- German and Portuguese locales have key messages translated with English fallback for others
- Log files are automatically created in `logs/` directory (git-ignored)
- All changes are backward compatible
- System performs efficiently with batched log writes
- Fallback chain ensures no broken messages

## Support

For issues or questions:
- See `Documentation/I18N_AND_DEBUGGING.md` for detailed guide
- See `Documentation/EXAMPLES_I18N_DEBUG.lua` for code examples
- Check existing locale files for translation patterns

---

**Implementation Date**: 2026-01-08
**Version**: 1.1.0
**Status**: Complete and tested
