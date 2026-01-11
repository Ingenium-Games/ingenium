# ig.affiliation.CreateGroup

## Description

Returns Groups after merging the default and Newly created groups.

## Signature

```lua
function ig.affiliation.CreateGroup(str, relations)
```

## Parameters

- **`str`**: string
- **`relations`**: any

## Example

```lua
-- Create new group
local created = ig.affiliation.CreateGroup("str", value)
if created then
    print("Created successfully")
end
```

## Source

Defined in: `client/_affiliation.lua`
