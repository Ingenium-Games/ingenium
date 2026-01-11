# ig.affiliation.GetGroups

## Description

Returns Groups after merging the default and Newly created groups.

## Signature

```lua
function ig.affiliation.GetGroups()
```

## Parameters

*No parameters*

## Example

```lua
-- Get groups data
local result = ig.affiliation.GetGroups()
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_affiliation.lua`
