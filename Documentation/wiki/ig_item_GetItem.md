# ig.item.GetItem

## Description

To create json creator on web tool to enable users to create items.

## Signature

```lua
function ig.item.GetItem(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get item data
local result = ig.item.GetItem("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_items.lua`
