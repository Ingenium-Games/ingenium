# ig.data.GetPlayers

## Description

Retrieves all player entities in the server.

## Signature

```lua
function ig.data.GetPlayers()
```

## Parameters

None

## Returns

- **`table`** - The complete `ig.pdex` table containing all player entities indexed by source ID

## Example

```lua
-- Get all players and count them
local players = ig.data.GetPlayers()
local count = 0
for source, xPlayer in pairs(players) do
    count = count + 1
    print("Player:", xPlayer.GetName())
end
print("Total players:", count)
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.player.GetPlayers` in `server/[Objects]/_players.lua`)
