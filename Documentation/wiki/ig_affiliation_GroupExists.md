# ig.affiliation.GroupExists

Checks whether a relationship group exists in the system.

## Syntax

```lua
local exists = ig.affiliation.GroupExists(groupName)
```

## Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `groupName` | string | Name of the group to check (uppercase) |

## Return Value

`boolean` - True if the group exists, false otherwise

## Examples

### Check if police group exists
```lua
if ig.affiliation.GroupExists("POLICE") then
    print("Police group exists")
end
```

### Validate group before assigning ped
```lua
local groupName = "GANG_1"

if ig.affiliation.GroupExists(groupName) then
    ig.affiliation.SetPedGroup(PlayerPedId(), groupName)
else
    print("Group does not exist: " .. groupName)
end
```

### Filter available groups
```lua
local desiredGroups = {"POLICE", "MEDIC", "CUSTOM_GROUP", "UNKNOWN"}
local availableGroups = {}

for _, groupName in ipairs(desiredGroups) do
    if ig.affiliation.GroupExists(groupName) then
        table.insert(availableGroups, groupName)
    end
end

print("Available groups: " .. table.concat(availableGroups, ", "))
```

## Notes

- Group names are case-sensitive (uppercase)
- Useful for validation before using a group
- Returns false for non-existent groups

## Related Functions

- [CreateGroup](ig_affiliation_CreateGroup.md) - Create new group
- [GetGroupHash](ig_affiliation_GetGroupHash.md) - Get group hash
- [SetPedGroup](ig_affiliation_SetPedGroup.md) - Assign ped to group
