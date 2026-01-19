# ig.weapon.GetByHash

## Description

Retrieves weapon data for a specific weapon hash. Each weapon in the game has a unique hash that identifies it. This function looks up and returns the complete weapon data including name, label, category, ammo type, and other properties.

## Signature

```lua
function ig.weapon.GetByHash(hash)
```

## Parameters

- **`hash`**: number - The weapon hash to look up

## Returns

- **`table|nil`** - Weapon data table if found, nil otherwise

## Example

```lua
-- Get weapon data by hash
local weaponHash = GetHashKey("weapon_pistol")
local weapon = ig.weapon.GetByHash(weaponHash)

if weapon then
    print("Weapon Name:", weapon.name)
    print("Display Name:", weapon.label)
    print("Category:", weapon.category)
    print("Ammo Type:", weapon.ammotype)
else
    print("Weapon not found")
end

-- Check if weapon exists before using
local hash = GetHashKey("weapon_combatpistol")
local weaponData = ig.weapon.GetByHash(hash)
if weaponData then
    print(string.format("Found: %s (%s)", weaponData.label, weaponData.category))
end
```

## Related Functions

- [ig.weapon.GetAll](ig_weapon_GetAll.md) - Get all weapons
- [ig.weapon.GetByName](ig_weapon_GetByName.md) - Get weapon by name
- [ig.weapon.GetDisplayName](ig_weapon_GetDisplayName.md) - Get weapon display name
- [ig.weapon.GetByCategory](ig_weapon_GetByCategory.md) - Get weapons by category
- [ig.weapon.IsMelee](ig_weapon_IsMelee.md) - Check if weapon is melee

## Source

Defined in: `server/[Data - No Save Needed]/_weapons.lua`
