# ig.affiliation.GetGroupRelationship

Queries the relationship level between two groups. Returns the numeric value indicating how one group feels about another.

## Syntax

```lua
local relationshipLevel = ig.affiliation.GetGroupRelationship(sourceGroup, targetGroup)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `sourceGroup` | string | The group doing the feeling |
| `targetGroup` | string | The group being felt toward |

## Return Value

`number` - Relationship level (0-5), or -1 if groups don't exist

## Relationship Levels

| Level | Meaning | Behavior |
|-------|---------|----------|
| 0 | Companion | Will help in combat, friendly |
| 1 | Respect | Professional, cooperative |
| 2 | Like | Positive, friendly attitude |
| 3 | Neutral | No particular feelings |
| 4 | Dislike | Negative attitude, avoidance |
| 5 | Hate | Actively hostile, attacks on sight |
| -1 | Error | Groups don't exist |

## Examples

### Check if groups are hostile
```lua
local relationshipLevel = ig.affiliation.GetGroupRelationship("POLICE", "GANG_1")

if relationshipLevel == 5 then
    print("Police hate Gang_1!")
elseif relationshipLevel == 0 then
    print("Police and Gang_1 are allies!")
else
    print("Relationship level: " .. relationshipLevel)
end
```

### Check player relationship with authority
```lua
local playerPoliceRel = ig.affiliation.GetGroupRelationship("PLAYER", "POLICE")

if playerPoliceRel >= 4 then
    print("You are wanted by police!")
elseif playerPoliceRel <= 1 then
    print("Police respect you")
else
    print("Police are neutral about you")
end
```

### Dynamic dialogue based on relationships
```lua
local function GetDialogueForGroup(targetGroup)
    local rel = ig.affiliation.GetGroupRelationship("PLAYER", targetGroup)
    
    if rel == 5 then
        return "I'm coming for you!"
    elseif rel == 0 or rel == 1 then
        return "Good to see you, friend!"
    elseif rel == 2 then
        return "Hey there"
    elseif rel == 3 then
        return "..."
    else -- 4
        return "Get out of my sight!"
    end
end
```

## Directional Behavior

The relationship is **directional** - it depends on which group is querying which:

```lua
-- These can return different values:
local aToB = ig.affiliation.GetGroupRelationship("GANG_1", "GANG_2") -- How Gang_1 feels
local bToA = ig.affiliation.GetGroupRelationship("GANG_2", "GANG_1") -- How Gang_2 feels
```

## Error Handling

```lua
local rel = ig.affiliation.GetGroupRelationship("UNKNOWN_GROUP", "ANOTHER_UNKNOWN")

if rel == -1 then
    print("One or both groups don't exist!")
elseif rel >= 0 and rel <= 5 then
    print("Valid relationship: " .. rel)
end
```

## Related Functions

- [SetGroupRelationship](ig_affiliation_SetGroupRelationship.md) - Set bidirectional relationships
- [SetGroupRelationshipDirectional](ig_affiliation_SetGroupRelationshipDirectional.md) - Set one-way relationships
- [GetPedRelationship](ig_affiliation_GetPedRelationship.md) - Query ped relationship
