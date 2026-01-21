# ig.data.GetPed

## Description

Retrieves an NPC (ped) entity by its network ID.

## Signature

```lua
function ig.data.GetPed(net)
```

## Parameters

- **`net`**: number - The network ID of the NPC

## Returns

- **`table|false`** - The NPC entity table if found, `false` otherwise

## Example

```lua
-- Get an NPC by network ID
local npc = ig.data.GetPed(netId)
if npc then
    print("NPC UUID:", npc.UUID)
end
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.npc.GetNpc` in `server/[Objects]/_npcs.lua`)
