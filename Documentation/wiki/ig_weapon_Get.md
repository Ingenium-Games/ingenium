# ig.weapon.Get

## Description

Retrieves and returns the weapon data table containing all loaded weapon information

## Signature

```lua
function ig.weapon.Get()
```

## Parameters

*No parameters*

## Example

```lua
-- Get weapon data table
local weapons = ig.weapon.Get()
for weaponHash, weaponData in pairs(weapons) do
    print("Weapon:", weaponHash, weaponData.name)
end
```

## Source

Defined in: `client/_weapon.lua`
