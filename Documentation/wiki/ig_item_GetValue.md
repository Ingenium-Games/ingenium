# ig.item.GetValue

## Description

Retrieves and returns value data

## Signature

```lua
function ig.item.GetValue(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get value data
local result = ig.item.GetValue("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_items.lua`
