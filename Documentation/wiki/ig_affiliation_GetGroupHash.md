# ig.affiliation.GetGroupHash

Retrieves the game hash for a relationship group by its name.

## Syntax

```lua
local hash = ig.affiliation.GetGroupHash(groupName)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `groupName` | string | Name of the group (uppercase) |

## Return Value

`number` - The group hash, or nil if the group doesn't exist

## Examples

### Get police group hash
```lua
local policeHash = ig.affiliation.GetGroupHash("POLICE")

if policeHash then
    print("Police hash: " .. policeHash)
else
    print("Police group not found")
end
```

### Use hash directly with FiveM natives
```lua
local groupHash = ig.affiliation.GetGroupHash("GANG_1")

if groupHash then
    -- Use hash with native functions
    AddRelationshipGroup(groupHash)
end
```

### Verify group before operations
```lua
local function SafeGetGroupHash(groupName)
    if not ig.affiliation.GroupExists(groupName) then
        print("Group does not exist: " .. groupName)
        return nil
    end
    return ig.affiliation.GetGroupHash(groupName)
end

local hash = SafeGetGroupHash("PLAYER")
```

## Notes

- Returns nil if group doesn't exist
- Hash is cached internally for performance
- Group names are case-sensitive (uppercase)
- Generally not needed for wrapper functions, but useful for direct FiveM native calls

## Related Functions

- [GroupExists](ig_affiliation_GroupExists.md) - Check if group exists
- [CreateGroup](ig_affiliation_CreateGroup.md) - Create new group
