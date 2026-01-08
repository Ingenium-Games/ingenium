# ig.GetLocalPlayer

## Description

Takes local information from the `user` SQL table and sets it for the client.

## Signature

```lua
function ig.GetLocalPlayer()
```

## Parameters

- **`bool`**: boolean "Set loaded status to true or false.

## Example

```lua
-- Example usage of ig.GetLocalPlayer
local result = ig.GetLocalPlayer()
```

## Related Functions

- [ig.modkit.ClearCache](ig_modkit_ClearCache.md)
- [ig.modkit.GetAll](ig_modkit_GetAll.md)
- [ig.modkit.GetForVehicle](ig_modkit_GetForVehicle.md)
- [ig.tattoo.ClearCache](ig_tattoo_ClearCache.md)
- [ig.tattoo.GetAll](ig_tattoo_GetAll.md)

## Source

Defined in: `client/_data.lua`
