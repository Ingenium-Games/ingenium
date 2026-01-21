# ig.weapon.HasWeaponComponents

## Description

Checks if a weapon has any available components.

## Signature

```lua
function ig.weapon.HasWeaponComponents(weaponHash)
```

## Parameters

- **`weaponHash`**: number - The weapon hash identifier

## Returns

- **`boolean`** - `true` if the weapon has components, `false` otherwise

## Example

```lua
-- Check if weapon has components
local weaponHash = GetHashKey("WEAPON_PISTOL")
if ig.weapon.HasWeaponComponents(weaponHash) then
    print("This weapon can be customized with components")
end
```

## Source

Defined in: `client/_weapon.lua`
