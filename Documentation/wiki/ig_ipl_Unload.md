# ig.ipl.Unload

## Description

====================================================================================--

## Signature

```lua
function ig.ipl.Unload(iplName)
```

## Parameters

- **`iplName`**: string "The IPL identifier to load
- **`iplName`**: string "The IPL identifier to unload

## Example

```lua
-- Example usage of ig.ipl.Unload
local result = ig.ipl.Unload(iplName)
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
