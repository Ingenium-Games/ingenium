# ig.weapon.GetDisplayName

## Description

Get weapon data by name

## Signature

```lua
function ig.weapon.GetDisplayName(hash)
```

## Parameters

- **`name`**: string Weapon name (e.g., "weapon_pistol")
- **`category`**: string Category (e.g., "Pistol", "Rifle", "Melee")
- **`hash`**: number Weapon hash

## Example

```lua
-- Example usage of ig.weapon.GetDisplayName
local result = ig.weapon.GetDisplayName()
```

## Related Functions

- [ig.weapon.ClearCache](ig_weapon_ClearCache.md)
- [ig.weapon.GetAll](ig_weapon_GetAll.md)
- [ig.weapon.GetByHash](ig_weapon_GetByHash.md)
- [ig.weapon.Get](ig_weapon_Get.md)
- [ig.weapon.GetComponents](ig_weapon_GetComponents.md)

## Source

Defined in: `server/[Data - No Save Needed]/_weapons.lua`
