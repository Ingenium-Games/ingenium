# ig.player.GetPlayer

## Description

Retrieves and returns player data

## Signature

```lua
function ig.player.GetPlayer(source)
```

## Parameters

- **`source`**: number

## Example

```lua
-- Get player data
local result = ig.player.GetPlayer(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_players.lua`
