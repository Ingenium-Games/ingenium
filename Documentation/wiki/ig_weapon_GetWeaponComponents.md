# ig.weapon.GetWeaponComponents

## Description

Retrieves the available components for a specific weapon by its hash.

## Signature

```lua
function ig.weapon.GetWeaponComponents(weaponHash)
```

## Parameters

- **`weaponHash`**: number - The weapon hash identifier

## Returns

- **`table|nil`** - Array of weapon component data, or `nil` if weapon has no components

## Example

```lua
-- Get components for a weapon
local weaponHash = GetHashKey("WEAPON_PISTOL")
local components = ig.weapon.GetWeaponComponents(weaponHash)
if components then
    for _, component in ipairs(components) do
        print("Component:", component.name)
    end
end
```

## Source

Defined in: `client/_weapon.lua`
