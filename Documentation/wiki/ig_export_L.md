# Export: _L(key, ...)

**Parameters**: 
- `key` (string) - Translation key
- `...` (any) - Variable arguments for string substitution

**Returns**: `string` - Translated text  
**Security**: ✅ Public  
**Side**: [S C]

## Description

Get localized strings from the framework's translation system.

## Usage

```lua
local greeting = exports["ingenium"]:_L("greeting.hello", playerName)
local errorMsg = exports["ingenium"]:_L("error.not_enough_funds")
```

## Parameters

### key (string)
Dot-notation key for the translation (e.g., "greeting.hello", "error.invalid")

### ... (any)
Optional arguments for string formatting/substitution

## Examples

```lua
-- Simple translation
local msg = exports["ingenium"]:_L("greeting.hello")
exports["ingenium"]:Notify(msg, "green", 3000)

-- Translation with argument substitution
local playerGreeting = exports["ingenium"]:_L("greeting.hello", "John")

-- Error messages
local error = exports["ingenium"]:_L("error.not_enough_funds")
exports["ingenium"]:Notify(error, "red", 3000)
```

## See Also

- [GetLocale](ig_export_GetLocale.md) - Get current locale
- [Notify](ig_export_Notify.md) - Send notification
