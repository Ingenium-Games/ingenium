# ig.ipl.UnloadByName

## Description

Load all IPLs in the configuration

## Signature

```lua
function ig.ipl.UnloadByName(name)
```

## Parameters

- **`name`**: string "The registered IPL configuration name
- **`name`**: string "The registered IPL configuration name

## Example

```lua
-- Example usage of ig.ipl.UnloadByName
local result = ig.ipl.UnloadByName(name)
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
