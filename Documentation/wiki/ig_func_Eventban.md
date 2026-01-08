# ig.func.Eventban

## Description

[[local post = json.encode({

## Signature

```lua
function ig.func.Eventban(source, event)
```

## Parameters

- **`message`**: any
- **`footer`**: any
- **`source`**: any
- **`event`**: any

## Example

```lua
-- Example usage of ig.func.Eventban
local result = ig.func.Eventban(source, event)
```

## Important Notes

> ⚠️ **Security**: This function accesses player identifiers or can ban/kick players. Ensure proper permission checks.

## Related Functions

- [ig.func.Alert](ig_func_Alert.md)
- [ig.func.ClearInterval](ig_func_ClearInterval.md)
- [ig.func.CompareCoords](ig_func_CompareCoords.md)
- [ig.func.CreateObject](ig_func_CreateObject.md)
- [ig.func.CreatePed](ig_func_CreatePed.md)

## Source

Defined in: `server/_functions.lua`
