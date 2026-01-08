# ig.ipl.Load

## Description

Configuration Loader

## Signature

```lua
function ig.ipl.Load(iplName)
```

## Parameters

- **`iplName`**: string "The IPL identifier to load

## Example

```lua
-- Example usage of ig.ipl.Load
local result = ig.ipl.Load(iplName)
```

## Important Notes

> ⚠️ **Security**: This function executes code dynamically. Never use with untrusted input.

## Related Functions

- [ig.ipl.Get](ig_ipl_Get.md)
- [ig.ipl.GetAll](ig_ipl_GetAll.md)
- [ig.ipl.IsLoaded](ig_ipl_IsLoaded.md)
- [ig.ipl.LoadByName](ig_ipl_LoadByName.md)
- [ig.ipl.LoadConfigurations](ig_ipl_LoadConfigurations.md)

## Source

Defined in: `client/_ipls.lua`
