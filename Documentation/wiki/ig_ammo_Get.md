# ig.ammo.Get

## Description

Retrieves the current ammunition counts for all ammo types. Returns a table containing ammo counts indexed by ammo type (9mm, 5.56mm, 7.62mm, 20g, .223, .308).

## Signature

```lua
function ig.ammo.Get()
```

## Parameters

*No parameters*

## Example

```lua
-- Get all ammo counts
local ammoData = ig.ammo.Get()
print("9mm ammo:", ammoData["9mm"])
print("5.56mm ammo:", ammoData["5.56mm"])
```

## Source

Defined in: `client/_ammo.lua`
