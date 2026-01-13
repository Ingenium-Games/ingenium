# ig.affiliation.ConfigureGroupRelationships

Sets multiple relationships for a group at once, either bidirectionally or directionally.

## Syntax

```lua
local success = ig.affiliation.ConfigureGroupRelationships(sourceGroup, relationships, bidirectional)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `sourceGroup` | string | The source group |
| `relationships` | table | Table of {groupName = relationshipLevel} |
| `bidirectional` | boolean | If true, relationships are mutual; if false, one-way |

## Return Value

`boolean` - True if all relationships were configured successfully, false otherwise

## Relationship Levels

| Level | Meaning |
|-------|---------|
| 0 | Companion |
| 1 | Respect |
| 2 | Like |
| 3 | Neutral |
| 4 | Dislike |
| 5 | Hate |

## Examples

### Set up player relationships (bidirectional)
```lua
local playerRelationships = {
    ["POLICE"] = 1,           -- Respect
    ["GANG_1"] = 4,           -- Dislike
    ["GANG_2"] = 5,           -- Hate
    ["MEDIC"] = 2,            -- Like
    ["SECURITY_GUARD"] = 1,   -- Respect
    ["DEALER"] = 4            -- Dislike
}

ig.affiliation.ConfigureGroupRelationships("PLAYER", playerRelationships, true)
```

### Set up gang territory (one-way)
```lua
local gangRelationships = {
    ["PLAYER"] = 5,           -- Hate intruders
    ["POLICE"] = 5,           -- Hate cops
    ["OTHER_GANG"] = 5,       -- Hate rivals
    ["GANG_1"] = 0             -- Companions with own gang
}

ig.affiliation.ConfigureGroupRelationships("GANG_1", gangRelationships, false)
```

### Initialize all group relationships
```lua
local function InitializeRelationships()
    -- Police vs criminals
    ig.affiliation.ConfigureGroupRelationships("POLICE", {
        ["GANG_1"] = 5,
        ["GANG_2"] = 5,
        ["DEALER"] = 5,
        ["MEDIC"] = 1,
        ["CIVMALE"] = 3,
        ["CIVFEMALE"] = 3
    }, true)
    
    -- Gang vs others
    ig.affiliation.ConfigureGroupRelationships("GANG_1", {
        ["POLICE"] = 5,
        ["GANG_2"] = 4,
        ["GANG_1"] = 0
    }, true)
end

InitializeRelationships()
```

## Notes

- **Bidirectional=true:** Sets relationship both ways (efficient for mutual feelings)
- **Bidirectional=false:** Sets one-way relationships only
- More efficient than calling SetGroupRelationship multiple times
- All groups in the table must exist

## Related Functions

- [SetGroupRelationship](ig_affiliation_SetGroupRelationship.md) - Set single bidirectional relationship
- [SetGroupRelationshipDirectional](ig_affiliation_SetGroupRelationshipDirectional.md) - Set single one-way relationship
- [GetGroupRelationship](ig_affiliation_GetGroupRelationship.md) - Query relationship
