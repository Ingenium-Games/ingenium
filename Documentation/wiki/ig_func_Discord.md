# ig.func.Discord

## Description

Returns Steam, FiveM, License, Discord and IP identifiers in that order. Strings

## Signature

```lua
function ig.func.Discord(url, color, name, message, footer)
```

## Parameters

- **`source`**: number "license: etig...
- **`url`**: any
- **`color`**: any
- **`name`**: any
- **`message`**: any
- **`footer`**: any

## Example

```lua
-- Example usage of ig.func.Discord
local result = ig.func.Discord(url, color, name, message, footer)
```

## Important Notes

> ⚠️ **Security**: This function makes network requests. Be cautious with sensitive data and validate URLs.

## Related Functions

- [ig.func.Alert](ig_func_Alert.md)
- [ig.func.ClearInterval](ig_func_ClearInterval.md)
- [ig.func.CompareCoords](ig_func_CompareCoords.md)
- [ig.func.CreateObject](ig_func_CreateObject.md)
- [ig.func.CreatePed](ig_func_CreatePed.md)

## Source

Defined in: `server/_functions.lua`
