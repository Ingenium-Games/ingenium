# ig.item.GetMeta

## Description

Retrieves and returns meta data

## Signature

```lua
function ig.item.GetMeta(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get meta data
local result = ig.item.GetMeta("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_items.lua`
