# ig.ui.UpdateHUD

## Description

Updates the HUD (Heads-Up Display) with new data.

## Signature

```lua
function ig.ui.UpdateHUD(data)
```

## Parameters

- **`data`**: table - HUD data object containing values to update (health, armor, hunger, thirst, etc.)

## Returns

None

## Example

```lua
-- Update HUD values
ig.ui.UpdateHUD({
    health = 100,
    armor = 50,
    hunger = 75,
    thirst = 80
})
```

## Source

Defined in: `client/_ui.lua`
