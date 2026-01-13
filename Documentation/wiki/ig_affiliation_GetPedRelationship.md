# ig.affiliation.GetPedRelationship

Queries the relationship level between two individual peds based on their group assignments.

## Syntax

```lua
local relationshipLevel = ig.affiliation.GetPedRelationship(ped1, ped2)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `ped1` | number | First ped entity handle |
| `ped2` | number | Second ped entity handle |

## Return Value

`number` - Relationship level (0-5), or -1 if peds don't exist or aren't in groups

## Relationship Levels

| Level | Meaning | Behavior |
|-------|---------|----------|
| 0 | Companion | Will help in combat, friendly |
| 1 | Respect | Professional, cooperative |
| 2 | Like | Positive, friendly attitude |
| 3 | Neutral | No particular feelings |
| 4 | Dislike | Negative attitude, avoidance |
| 5 | Hate | Actively hostile, attacks on sight |
| -1 | Error | Peds don't exist or aren't in groups |

## Examples

### Check relationship between two NPCs
```lua
local player = PlayerPedId()
local npc = GetNearbyPed()

local pedRelationship = ig.affiliation.GetPedRelationship(player, npc)

if pedRelationship == 5 then
    print("NPC is hostile!")
elseif pedRelationship == 0 then
    print("NPC is friendly!")
end
```

### Monitor ped interactions
```lua
function ShouldNpcsAttack(ped1, ped2)
    local rel = ig.affiliation.GetPedRelationship(ped1, ped2)
    return rel == 5 -- Return true if they hate each other
end
```

### Check player hostility toward nearby peds
```lua
local player = PlayerPedId()
local nearbyPeds = GetGamePool("CPed")

for _, ped in ipairs(nearbyPeds) do
    local rel = ig.affiliation.GetPedRelationship(player, ped)
    if rel == 5 then
        print("Hostile ped found!")
    end
end
```

## Notes

- Based on the groups both peds are assigned to
- Unidirectional (ped1 → ped2) by default
- Requires both peds to be in valid groups
- Returns -1 if either ped is invalid or not in a group

## Related Functions

- [SetPedGroup](ig_affiliation_SetPedGroup.md) - Assign ped to group
- [GetGroupRelationship](ig_affiliation_GetGroupRelationship.md) - Query group relationship
- [SetGroupRelationship](ig_affiliation_SetGroupRelationship.md) - Set group relationships
