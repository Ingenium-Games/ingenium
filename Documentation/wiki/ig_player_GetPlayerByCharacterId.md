# ig.player.GetPlayerByCharacterId

## Description

Retrieves a player entity by their character ID (alternative naming convention).

## Signature

```lua
function ig.player.GetPlayerByCharacterId(id)
```

## Parameters

- **`id`**: number - The character ID to search for

## Returns

- **`table|false`** - The player entity table if found, `false` otherwise

## Example

```lua
-- Get player by character ID
local xPlayer = ig.player.GetPlayerByCharacterId(12345)
if xPlayer then
    print("Player source:", xPlayer.source)
end
```

## Notes

This function has the same behavior as `ig.player.GetPlayerByCharacterID` but uses camelCase naming.

## Source

Defined in: `server/[Objects]/_players.lua`
