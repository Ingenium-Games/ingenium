# ig.affiliation.ClearGroupRelationship

Resets the relationship between two groups to neutral (level 3).

## Syntax

```lua
local success = ig.affiliation.ClearGroupRelationship(group1, group2)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `group1` | string | Name of the first relationship group |
| `group2` | string | Name of the second relationship group |

## Return Value

`boolean` - True if relationship was cleared successfully, false otherwise

## Examples

### Reset gang relationship
```lua
-- Clear the hostile relationship
ig.affiliation.ClearGroupRelationship("GANG_1", "GANG_2")
-- Both groups are now neutral to each other
```

### Wipe all relationships for a group
```lua
local allGroups = ig.affiliation.GetGroups()
for groupName, _ in pairs(allGroups) do
    ig.affiliation.ClearGroupRelationship("PLAYER", groupName)
end
```

## Notes

- This sets the relationship to neutral (level 3) for both groups
- Works bidirectionally (affects both directions)
- Useful for resetting hostile relationships or starting fresh

## Related Functions

- [SetGroupRelationship](ig_affiliation_SetGroupRelationship.md) - Set bidirectional relationships
- [SetGroupRelationshipDirectional](ig_affiliation_SetGroupRelationshipDirectional.md) - Set one-way relationships
- [GetGroupRelationship](ig_affiliation_GetGroupRelationship.md) - Query relationship
