# ig.func.GetPedsInArea

## Description

Returns All Peds (including Players) within the designated radius.

## Signature

```lua
function ig.func.GetPedsInArea(ords, radius, minimal)
```

## Parameters

- **`ords`**: table "Generally a {x,y,z} or vec3
- **`radius`**: number "Radius to return objects within
- **`minimal`**: boolean "Return just the found objects or their model and coords as well?

## Example

```lua
-- Example usage of ig.func.GetPedsInArea
local result = ig.func.GetPedsInArea()
```

## Important Notes

> 📋 **Parameter**: `minimal` - When set to `true`, returns simplified data structure

## Related Functions

- [ig.func.Alert](ig_func_Alert.md)
- [ig.func.ClearInterval](ig_func_ClearInterval.md)
- [ig.func.CompareCoords](ig_func_CompareCoords.md)
- [ig.func.CreateObject](ig_func_CreateObject.md)
- [ig.func.CreatePed](ig_func_CreatePed.md)

## Source

Defined in: `client/_functions.lua`
