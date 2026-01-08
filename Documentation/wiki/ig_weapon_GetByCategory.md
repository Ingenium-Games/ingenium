# ig.weapon.GetByCategory

## Description

Get weapon data by hash

## Signature

```lua
function ig.weapon.GetByCategory(category)
```

## Parameters

- **`hash`**: number Weapon hash
- **`name`**: string Weapon name (e.g., "weapon_pistol")
- **`category`**: string Category (e.g., "Pistol", "Rifle", "Melee")

## Example

```lua
-- Example usage of ig.weapon.GetByCategory
local result = ig.weapon.GetByCategory()
```

## Related Functions

- [ig.weapon.ClearCache](ig_weapon_ClearCache.md)
- [ig.weapon.GetAll](ig_weapon_GetAll.md)
- [ig.weapon.GetByHash](ig_weapon_GetByHash.md)
- [ig.weapon.GetDisplayName](ig_weapon_GetDisplayName.md)
- [ig.weapon.Get](ig_weapon_Get.md)

## Source

Defined in: `server/[Data - No Save Needed]/_weapons.lua`
