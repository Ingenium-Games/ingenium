# ig.ped.GetByGender

## Description

Get all ped data

## Signature

```lua
function ig.ped.GetByGender(gender)
```

## Parameters

- **`hash`**: number Ped hash
- **`name`**: string Ped model name (e.g., "mp_m_freemode_01")
- **`gender`**: string Gender ("male", "female", "unknown")

## Example

```lua
-- Example usage of ig.ped.GetByGender
local result = ig.ped.GetByGender()
```

## Related Functions

- [ig.ped.GetAll](ig_ped_GetAll.md)
- [ig.ped.GetByHash](ig_ped_GetByHash.md)
- [ig.ped.GetByName](ig_ped_GetByName.md)
- [ig.ped.GetByType](ig_ped_GetByType.md)
- [ig.ped.GetDisplayName](ig_ped_GetDisplayName.md)

## Source

Defined in: `server/[Data - No Save Needed]/_peds.lua`
