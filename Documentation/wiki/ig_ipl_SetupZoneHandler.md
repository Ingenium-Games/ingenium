# ig.ipl.SetupZoneHandler

## Description

Unload all IPLs in the configuration

## Signature

```lua
function ig.ipl.SetupZoneHandler(name, zoneConfig)
```

## Parameters

- **`name`**: string "The registered IPL configuration name
- **`zoneConfig`**: table "Zone configuration: {type, coords, radius/size, etc.}

## Example

```lua
-- Example usage of ig.ipl.SetupZoneHandler
ig.ipl.SetupZoneHandler(value)
```

## Related Functions

- [ig.ipl.Get](ig_ipl_Get.md)
- [ig.ipl.GetAll](ig_ipl_GetAll.md)
- [ig.ipl.IsLoaded](ig_ipl_IsLoaded.md)
- [ig.ipl.Load](ig_ipl_Load.md)
- [ig.ipl.LoadByName](ig_ipl_LoadByName.md)

## Source

Defined in: `client/_ipls.lua`
