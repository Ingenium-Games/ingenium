# ig.target.AddBoxZone

## Description

Creates a box-shaped interactive zone for the targeting system. Players can interact when looking at the zone. Supports multiple interaction options.

## Signature

```lua
function ig.target.AddBoxZone(data)
```

## Parameters

- **`data`**: table
- **`data`**: table

## Example

```lua
-- Example 1: Create an interactive box zone
ig.target.AddBoxZone({
    name = "bank_counter",
    coords = vector3(150.0, -1040.0, 29.37),
    size = vector3(2.0, 1.0, 1.0),
    heading = 340.0,
    debugPoly = false,
    options = {
        {
            type = "client",
            event = "bank:openMenu",
            icon = "fas fa-dollar-sign",
            label = "Access Bank",
            canInteract = function(entity, distance, data)
                return distance < 2.5
            end
        }
    }
})

-- Example 2: Box zone with multiple options
ig.target.AddBoxZone({
    name = "shop_register",
    coords = vector3(25.0, -1347.0, 29.5),
    size = vector3(1.5, 1.5, 1.5),
    heading = 270.0,
    options = {
        {
            event = "shop:buy",
            icon = "fas fa-shopping-cart",
            label = "Buy Items"
        },
        {
            event = "shop:sell",
            icon = "fas fa-hand-holding-usd",
            label = "Sell Items"
        }
    }
})
```

## Important Notes

> 📋 **Parameter**: `data` - Optional data payload for customization

## Related Functions

- [ig.target.AddEntity](ig_target_AddEntity.md)
- [ig.target.AddEntityZone](ig_target_AddEntityZone.md)
- [ig.target.AddGlobalObject](ig_target_AddGlobalObject.md)
- [ig.target.AddGlobalPed](ig_target_AddGlobalPed.md)
- [ig.target.AddGlobalPlayer](ig_target_AddGlobalPlayer.md)

## Source

Defined in: `client/[Target]/_api.lua`
