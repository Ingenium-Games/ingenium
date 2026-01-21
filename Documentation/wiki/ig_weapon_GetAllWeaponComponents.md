# ig.weapon.GetAllWeaponComponents

## Description

Retrieves all weapon components data for all initialized weapon categories.

## Signature

```lua
function ig.weapon.GetAllWeaponComponents()
```

## Parameters

None

## Returns

- **`table`** - A table containing all weapon components indexed by weapon hash

## Example

```lua
-- Get all weapon components
local allComponents = ig.weapon.GetAllWeaponComponents()
for weaponHash, components in pairs(allComponents) do
    print("Weapon hash:", weaponHash, "Components:", #components)
end
```

## Source

Defined in: `client/_weapon.lua`
