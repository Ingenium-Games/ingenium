# ig.affiliation.SetGroupRelationship

Sets a bidirectional relationship between two groups. This affects how both groups feel about each other.

## Syntax

```lua
local success = ig.affiliation.SetGroupRelationship(group1, group2, relationship)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `group1` | string | Name of the first relationship group |
| `group2` | string | Name of the second relationship group |
| `relationship` | number | Relationship level (0-5) |

## Return Value

`boolean` - True if relationship was set successfully, false otherwise

## Relationship Levels

| Level | Meaning | Behavior |
|-------|---------|----------|
| 0 | Companion | Will help in combat, friendly interactions |
| 1 | Respect | Professional, cooperative interactions |
| 2 | Like | Positive, friendly attitude |
| 3 | Neutral | No particular feelings (default) |
| 4 | Dislike | Negative attitude, avoidance |
| 5 | Hate | Actively hostile, will attack on sight |

## Examples

### Make two gangs allies
```lua
ig.affiliation.SetGroupRelationship("GANG_1", "GANG_2", 0)
-- Now GANG_1 and GANG_2 are companions to each other
```

### Make two gangs enemies
```lua
ig.affiliation.SetGroupRelationship("GANG_1", "GANG_2", 5)
-- Both groups will attack each other on sight
```

### Make player faction friendly with police
```lua
ig.affiliation.SetGroupRelationship("PLAYER", "POLICE", 2)
-- Player and police will be friendly toward each other
```

## Notes

- Groups must exist before calling this function
- The relationship is **bidirectional** - both groups get the same feeling
- Use [SetGroupRelationshipDirectional](ig_affiliation_SetGroupRelationshipDirectional.md) for one-way relationships
- Valid relationship range is 0-5

## Related Functions

- [SetGroupRelationshipDirectional](ig_affiliation_SetGroupRelationshipDirectional.md) - One-way relationships
- [GetGroupRelationship](ig_affiliation_GetGroupRelationship.md) - Query relationship
- [ClearGroupRelationship](ig_affiliation_ClearGroupRelationship.md) - Reset relationship
