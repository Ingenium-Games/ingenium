# ig.player.GetPlayerByCharacterID

## Description

Retrieves a player entity by their character ID.

## Signature

```lua
function ig.player.GetPlayerByCharacterID(characterId)
```

## Parameters

- **`characterId`**: number - The character ID to search for

## Returns

- **`table|false`** - The player entity table if found, `false` otherwise

## Example

```lua
-- Get player by character ID
local xPlayer = ig.player.GetPlayerByCharacterID(12345)
if xPlayer then
    print("Player name:", xPlayer.GetName())
end
```

## Source

Defined in: `server/[Objects]/_players.lua`
