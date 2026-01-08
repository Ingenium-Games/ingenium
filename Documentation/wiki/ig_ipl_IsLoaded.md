# ig.ipl.IsLoaded

## Description

Load an IPL by name

## Signature

```lua
function ig.ipl.IsLoaded(iplName)
```

## Parameters

- **`iplName`**: string "The IPL identifier to load
- **`iplName`**: string "The IPL identifier to unload
- **`iplName`**: string "The IPL identifier to check

## Example

```lua
-- Example usage of ig.ipl.IsLoaded
local result = ig.ipl.IsLoaded(iplName)
```

## Important Notes

> ⚠️ **Security**: This function executes code dynamically. Never use with untrusted input.

## Related Functions

- [ig.ipl.Get](ig_ipl_Get.md)
- [ig.ipl.GetAll](ig_ipl_GetAll.md)
- [ig.ipl.Load](ig_ipl_Load.md)
- [ig.ipl.LoadByName](ig_ipl_LoadByName.md)
- [ig.ipl.LoadConfigurations](ig_ipl_LoadConfigurations.md)

## Source

Defined in: `client/_ipls.lua`
