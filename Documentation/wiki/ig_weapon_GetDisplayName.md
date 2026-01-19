# ig.weapon.GetDisplayName

## Description

Returns the human-readable display name (label) for a weapon based on its hash. This is useful for UI displays where you need to show the weapon's name to players. Returns "Unknown" if the weapon hash is not found in the registry.

## Signature

```lua
function ig.weapon.GetDisplayName(hash)
```

## Parameters

- **`hash`**: number - The weapon hash

## Returns

- **`string`** - Weapon display name (label) or "Unknown" if not found

## Example

```lua
-- Get display name for a weapon
local weaponHash = GetHashKey("weapon_pistol")
local displayName = ig.weapon.GetDisplayName(weaponHash)
print("Weapon Display Name:", displayName)  -- Output: "Pistol"

-- Use in notification
local currentWeapon = GetSelectedPedWeapon(PlayerPedId())
local weaponName = ig.weapon.GetDisplayName(currentWeapon)
ig.func.Notify(string.format("Current weapon: %s", weaponName), "info", 3000)

-- Safe lookup with fallback
local hash = GetHashKey("unknown_weapon")
local name = ig.weapon.GetDisplayName(hash)  -- Returns "Unknown"

-- Display weapon categories
local weapons = ig.weapon.GetAll()
for hash, weapon in pairs(weapons) do
    local displayName = ig.weapon.GetDisplayName(tonumber(hash))
    print(string.format("%s: %s", displayName, weapon.category))
end
```

## Related Functions

- [ig.weapon.GetAll](ig_weapon_GetAll.md) - Get all weapons
- [ig.weapon.GetByHash](ig_weapon_GetByHash.md) - Get weapon data by hash
- [ig.weapon.GetByName](ig_weapon_GetByName.md) - Get weapon by name
- [ig.vehicle.GetDisplayName](ig_vehicle_GetDisplayName.md) - Get vehicle display name

## Source

Defined in: `server/[Data - No Save Needed]/_weapons.lua`
