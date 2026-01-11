# ig.pick.Create

## Description

Creates a new pickup object in the world at specified coordinates. Pickups are collectible items that players can interact with. Returns the pickup instance.

## Signature

```lua
function ig.pick.Create(coords, model, event, data)
```

## Parameters

- **`coords`**: any
- **`model`**: any
- **`event`**: any
- **`data`**: table

## Example

```lua
-- Create pickup at location
local coords = vector3(100.0, 200.0, 30.0)
local pickup = ig.pick.Create({
    coords = coords,
    model = "prop_cs_box_01",
    item = "lockpick",
    amount = 1
})
```

## Source

Defined in: `server/[Data - Save to File]/_pickups.lua`
