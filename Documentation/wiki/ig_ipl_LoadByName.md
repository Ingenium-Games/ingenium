# ig.ipl.LoadByName

## Description

Register an IPL configuration with optional zone triggers

## Signature

```lua
function ig.ipl.LoadByName(name)
```

## Parameters

- **`config`**: table "IPL configuration: {name, ipls, zone, autoload}
- **`name`**: string "The registered IPL configuration name

## Example

```lua
-- Example usage of ig.ipl.LoadByName
local result = ig.ipl.LoadByName(name)
```

## Important Notes

> ⚠️ **Security**: This function executes code dynamically. Never use with untrusted input.

## Related Functions

- [ig.ipl.Get](ig_ipl_Get.md)
- [ig.ipl.GetAll](ig_ipl_GetAll.md)
- [ig.ipl.IsLoaded](ig_ipl_IsLoaded.md)
- [ig.ipl.Load](ig_ipl_Load.md)
- [ig.ipl.LoadConfigurations](ig_ipl_LoadConfigurations.md)

## Source

Defined in: `client/_ipls.lua`
