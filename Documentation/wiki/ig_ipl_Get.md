# ig.ipl.Get

## Description

Only load IPLs, don't trigger zone setup again

## Signature

```lua
function ig.ipl.Get(name)
```

## Parameters

- **`name`**: string "The registered IPL configuration name

## Example

```lua
-- Example usage of ig.ipl.Get
local result = ig.ipl.Get()
```

## Related Functions

- [ig.ipl.GetAll](ig_ipl_GetAll.md)
- [ig.ipl.IsLoaded](ig_ipl_IsLoaded.md)
- [ig.ipl.Load](ig_ipl_Load.md)
- [ig.ipl.LoadByName](ig_ipl_LoadByName.md)
- [ig.ipl.LoadConfigurations](ig_ipl_LoadConfigurations.md)

## Source

Defined in: `client/_ipls.lua`
