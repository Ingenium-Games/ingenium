# ig.affiliation.SetGroupRelationshipDirectional

Sets a one-way relationship from one group to another. Only the source group's feelings toward the target are affected.

## Syntax

```lua
local success = ig.affiliation.SetGroupRelationshipDirectional(sourceGroup, targetGroup, relationship)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `sourceGroup` | string | The group that will have the feeling |
| `targetGroup` | string | The group that will be felt toward |
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

### Police fear criminals, but criminals don't fear police
```lua
ig.affiliation.SetGroupRelationshipDirectional("POLICE", "GANG_1", 4)
-- Police dislike (avoid) Gang_1, but Gang_1 doesn't necessarily dislike police
```

### Player respects authority, authority is neutral about player
```lua
ig.affiliation.SetGroupRelationshipDirectional("PLAYER", "POLICE", 1)
-- Player respects police, but police have no particular feelings
```

### Create asymmetric power dynamic
```lua
-- Citizens fear gangsters
ig.affiliation.SetGroupRelationshipDirectional("CIVMALE", "GANG_1", 5)

-- But gangsters don't fear citizens
ig.affiliation.SetGroupRelationshipDirectional("GANG_1", "CIVMALE", 3)
```

## Notes

- Relationship is **one-way only** - reverse relationship unaffected
- Call twice to set both directions:
  ```lua
  ig.affiliation.SetGroupRelationshipDirectional("GANG_1", "GANG_2", 5)
  ig.affiliation.SetGroupRelationshipDirectional("GANG_2", "GANG_1", 5)
  ```

## Related Functions

- [SetGroupRelationship](ig_affiliation_SetGroupRelationship.md) - Bidirectional relationships
- [GetGroupRelationship](ig_affiliation_GetGroupRelationship.md) - Query relationship
- [ClearGroupRelationship](ig_affiliation_ClearGroupRelationship.md) - Reset relationship
