# ig.func.GetClosestPlayerPed

## Description

Retrieves and returns closestplayerped data

## Signature

```lua
function ig.func.GetClosestPlayerPed(position, maxRadius)
```

## Parameters

- **`position`**: number
- **`maxRadius`**: number

## Example

```lua
-- Get closestplayerped data
local result = ig.func.GetClosestPlayerPed(100, 100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/_functions.lua`
