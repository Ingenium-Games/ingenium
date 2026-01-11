# ig.npc.GetNpc

## Description

Retrieves and returns npc data

## Signature

```lua
function ig.npc.GetNpc(net)
```

## Parameters

- **`net`**: number

## Example

```lua
-- Get npc data
local result = ig.npc.GetNpc(100)
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Objects]/_npcs.lua`
