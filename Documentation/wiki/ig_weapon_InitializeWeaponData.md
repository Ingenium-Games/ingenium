# ig.weapon.InitializeWeaponData

## Description

Initializes the weapon system with weapon data, loading weapon components and categories.

## Signature

```lua
function ig.weapon.InitializeWeaponData(weaponsData)
```

## Parameters

- **`weaponsData`**: table|nil (optional) - Weapon data object. If not provided, fetches from server

## Returns

None

## Behavior

- Loads weapon component data
- Initializes weapon categories
- Sets up weapon hash mappings

## Example

```lua
-- Initialize weapon system with custom data
ig.weapon.InitializeWeaponData(customWeaponData)

-- Initialize with server data
ig.weapon.InitializeWeaponData()
```

## Source

Defined in: `client/_weapon.lua`
