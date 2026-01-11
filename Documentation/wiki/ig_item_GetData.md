# ig.item.GetData

## Description

Retrieves and returns data data

## Signature

```lua
function ig.item.GetData(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get data data
local result = ig.item.GetData("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_items.lua`
