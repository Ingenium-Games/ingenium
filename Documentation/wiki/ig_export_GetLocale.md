# Export: GetLocale()

**Returns**: `string` - Current locale code  
**Security**: ✅ Public  
**Side**: [S C]

## Description

Get the current server locale for internationalization.

## Usage

```lua
local locale = exports["ingenium"]:GetLocale()
print("Current locale: " .. locale)  -- e.g., "en", "es", "fr"
```

## Return Value

Returns the current locale code as a string:
- `"en"` - English
- `"es"` - Spanish
- `"fr"` - French
- `"de"` - German
- Other supported locales

## Examples

```lua
local locale = exports["ingenium"]:GetLocale()

if locale == "es" then
    exports["ingenium"]:Notify("¡Hola!", "green", 3000)
elseif locale == "en" then
    exports["ingenium"]:Notify("Hello!", "green", 3000)
end
```

## See Also

- [_L](ig_export_L.md) - Get translated string
- [GetIngenium](ig_export_GetIngenium.md) - Get framework object
