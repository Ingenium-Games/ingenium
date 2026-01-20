# ig.weapon.IsAllowedCategory

## Description

Checks if a weapon belongs to an allowed (initialized) category.

## Signature

```lua
function ig.weapon.IsAllowedCategory(weaponHash)
```

## Parameters

- **`weaponHash`**: number - The weapon hash identifier

## Returns

- **`boolean`** - `true` if the weapon is in an allowed category, `false` otherwise

## Example

```lua
-- Check if weapon is in an allowed category
local weaponHash = GetHashKey("WEAPON_PISTOL")
if ig.weapon.IsAllowedCategory(weaponHash) then
    print("Weapon is allowed")
else
    print("Weapon is not in an initialized category")
end
```

## Source

Defined in: `client/_weapon.lua`
