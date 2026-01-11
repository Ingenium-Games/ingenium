# ig.item.GetWeaponAmmoType

## Description

Retrieves and returns weaponammotype data

## Signature

```lua
function ig.item.GetWeaponAmmoType(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get weaponammotype data
local result = ig.item.GetWeaponAmmoType("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_items.lua`
