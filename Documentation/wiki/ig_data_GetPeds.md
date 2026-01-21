# ig.data.GetPeds

## Description

Retrieves all NPC (ped) entities in the server.

## Signature

```lua
function ig.data.GetPeds()
```

## Parameters

None

## Returns

- **`table`** - The complete `ig.pdex` table containing all NPC entities indexed by network ID

## Example

```lua
-- Get all NPCs and iterate through them
local npcs = ig.data.GetPeds()
for netId, npc in pairs(npcs) do
    print("NPC:", npc.UUID)
end
```

## Source

Defined in: `server/_data.lua` (delegates to `ig.npc.GetNpcs` in `server/[Objects]/_npcs.lua`)
