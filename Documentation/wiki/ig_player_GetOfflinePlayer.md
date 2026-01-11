# ig.player.GetOfflinePlayer

## Description

Retrieves and returns offlineplayer data

## Signature

```lua
function ig.player.GetOfflinePlayer(character_id)
```

## Parameters

- **`character_id`**: number

## Example

```lua
-- Get offlineplayer data
local result = ig.player.GetOfflinePlayer(123)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_players.lua`
