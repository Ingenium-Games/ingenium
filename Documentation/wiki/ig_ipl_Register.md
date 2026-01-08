# ig.ipl.Register

## Description

Unload multiple IPLs at once

## Signature

```lua
function ig.ipl.Register(config)
```

## Parameters

- **`iplNames`**: table "Array of IPL identifiers
- **`config`**: table "IPL configuration: {name, ipls, zone, autoload}

## Example

```lua
-- Example usage of ig.ipl.Register
ig.ipl.Register("eventName", function(data)
    -- Handle event
end)
```

## Related Functions

- [ig.ipl.Get](ig_ipl_Get.md)
- [ig.ipl.GetAll](ig_ipl_GetAll.md)
- [ig.ipl.IsLoaded](ig_ipl_IsLoaded.md)
- [ig.ipl.Load](ig_ipl_Load.md)
- [ig.ipl.LoadByName](ig_ipl_LoadByName.md)

## Source

Defined in: `client/_ipls.lua`
