# ig.voip.server.GetPlayersInProximity

## Description

Retrieves and returns playersinproximity data

## Signature

```lua
function ig.voip.server.GetPlayersInProximity(playerId, distance)
```

## Parameters

- **`playerId`**: any
- **`distance`**: any

## Example

```lua
-- Get playersinproximity data
local result = ig.voip.server.GetPlayersInProximity(value, value)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Voice]/_voip.lua`
