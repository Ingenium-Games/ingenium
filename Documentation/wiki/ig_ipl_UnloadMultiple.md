# ig.ipl.UnloadMultiple

## Description

Check if an IPL is currently loaded

## Signature

```lua
function ig.ipl.UnloadMultiple(iplNames)
```

## Parameters

- **`iplName`**: string "The IPL identifier to check
- **`iplNames`**: table "Array of IPL identifiers
- **`iplNames`**: table "Array of IPL identifiers

## Example

```lua
-- Example usage of ig.ipl.UnloadMultiple
local result = ig.ipl.UnloadMultiple(iplNames)
```

## Important Notes

> ⚠️ **Security**: This function executes code dynamically. Never use with untrusted input.

## Related Functions

- [ig.ipl.Get](ig_ipl_Get.md)
- [ig.ipl.GetAll](ig_ipl_GetAll.md)
- [ig.ipl.IsLoaded](ig_ipl_IsLoaded.md)
- [ig.ipl.Load](ig_ipl_Load.md)
- [ig.ipl.LoadByName](ig_ipl_LoadByName.md)

## Source

Defined in: `client/_ipls.lua`
