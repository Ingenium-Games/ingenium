# ig.tattoo.GetByCollection

## Description

Get all tattoo data

## Signature

```lua
function ig.tattoo.GetByCollection(collection)
```

## Parameters

- **`hash`**: number Tattoo hash
- **`zone`**: string Zone name (e.g., "ZONE_HEAD", "ZONE_TORSO")
- **`collection`**: string Collection hash

## Example

```lua
-- Example usage of ig.tattoo.GetByCollection
local result = ig.tattoo.GetByCollection()
```

## Related Functions

- [ig.tattoo.ClearCache](ig_tattoo_ClearCache.md)
- [ig.tattoo.GetAll](ig_tattoo_GetAll.md)
- [ig.tattoo.GetByZone](ig_tattoo_GetByZone.md)
- [ig.tattoo.GetAll](ig_tattoo_GetAll.md)
- [ig.tattoo.GetByHash](ig_tattoo_GetByHash.md)

## Source

Defined in: `server/[Data - No Save Needed]/_tattoo.lua`
