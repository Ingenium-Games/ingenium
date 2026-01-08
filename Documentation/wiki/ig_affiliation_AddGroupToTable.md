# ig.affiliation.AddGroupToTable

## Description

Returns Groups after merging the default and Newly created groups.

## Signature

```lua
function ig.affiliation.AddGroupToTable(name, grouphash, relations)
```

## Parameters

- **`.`**: any
- **`name`**: string "Name of group : "NAME
- **`grouphash`**: string "Hash number of the group, typically starts with: "0x
- **`relations`**: table "Table of relations to iterate over : {['Companion'] = {}, ['Respect'] = {}, ['Like'] = {}, ['Nutral'] = {}, ['Dislike'] = {}, ['Hate'] = {}}

## Example

```lua
-- Example usage of ig.affiliation.AddGroupToTable
ig.affiliation.AddGroupToTable(item)
```

## Related Functions

- [ig.affiliation.CreateGroup](ig_affiliation_CreateGroup.md)
- [ig.affiliation.GetGroups](ig_affiliation_GetGroups.md)

## Source

Defined in: `client/_affiliation.lua`
