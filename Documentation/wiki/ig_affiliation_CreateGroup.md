# ig.affiliation.CreateGroup

## Description

Returns Groups after merging the default and Newly created groups.

## Signature

```lua
function ig.affiliation.CreateGroup(str, relations)
```

## Parameters

- **`.`**: any
- **`name`**: string "Name of group : "NAME
- **`grouphash`**: string "Hash number of the group, typically starts with: "0x
- **`relations`**: table "Table of relations to iterate over : {['Companion'] = {}, ['Respect'] = {}, ['Like'] = {}, ['Nutral'] = {}, ['Dislike'] = {}, ['Hate'] = {}}
- **`str`**: string "Can be lower case, will convert to UPPERCASE
- **`relations`**: table "Table of relations to iterate over : {['Companion'] = {}, ['Respect'] = {}, ['Like'] = {}, ['Nutral'] = {}, ['Dislike'] = {}, ['Hate'] = {}}

## Example

```lua
-- Example usage of ig.affiliation.CreateGroup
local entity = ig.affiliation.CreateGroup(params)
```

## Related Functions

- [ig.affiliation.AddGroupToTable](ig_affiliation_AddGroupToTable.md)
- [ig.affiliation.GetGroups](ig_affiliation_GetGroups.md)

## Source

Defined in: `client/_affiliation.lua`
