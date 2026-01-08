# ig.ped.GetByType

## Description

Get ped data by name

## Signature

```lua
function ig.ped.GetByType(pedType)
```

## Parameters

- **`name`**: string Ped model name (e.g., "mp_m_freemode_01")
- **`gender`**: string Gender ("male", "female", "unknown")
- **`pedType`**: string Type ("freemode", "story", "ambient", "animal")

## Example

```lua
-- Example usage of ig.ped.GetByType
local result = ig.ped.GetByType()
```

## Related Functions

- [ig.ped.GetAll](ig_ped_GetAll.md)
- [ig.ped.GetByGender](ig_ped_GetByGender.md)
- [ig.ped.GetByHash](ig_ped_GetByHash.md)
- [ig.ped.GetByName](ig_ped_GetByName.md)
- [ig.ped.GetDisplayName](ig_ped_GetDisplayName.md)

## Source

Defined in: `server/[Data - No Save Needed]/_peds.lua`
