# ig.weapon.GetAll

## Description

Returns all weapon data from the server's weapon registry. This includes all available weapons with their properties such as hash, name, label, category, ammo type, and other metadata. Returns the original unprotected data for network transmission.

## Signature

```lua
function ig.weapon.GetAll()
```

## Parameters

None

## Returns

- **`table`** - Table containing all weapons data indexed by weapon hash

## Example

```lua
-- Get all weapons
local weapons = ig.weapon.GetAll()
for hash, weapon in pairs(weapons) do
    print(string.format("%s - %s (%s)", weapon.name, weapon.label, weapon.category))
end

-- Count weapons by category
local categoryCounts = {}
for _, weapon in pairs(weapons) do
    categoryCounts[weapon.category] = (categoryCounts[weapon.category] or 0) + 1
end
for category, count in pairs(categoryCounts) do
    print(string.format("%s: %d weapons", category, count))
end
```

## Related Functions

- [ig.weapon.GetByHash](ig_weapon_GetByHash.md) - Get specific weapon by hash
- [ig.weapon.GetByName](ig_weapon_GetByName.md) - Get weapon by name
- [ig.weapon.GetByCategory](ig_weapon_GetByCategory.md) - Get weapons by category
- [ig.weapon.GetDisplayName](ig_weapon_GetDisplayName.md) - Get weapon display name
- [ig.weapon.IsMelee](ig_weapon_IsMelee.md) - Check if weapon is melee

## Source

Defined in: `server/[Data - No Save Needed]/_weapons.lua`
