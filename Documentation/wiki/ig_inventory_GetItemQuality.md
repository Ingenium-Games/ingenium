# ig.inventory.GetItemQuality

## Description

Retrieves and returns itemquality data

## Signature

```lua
function ig.inventory.GetItemQuality(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get itemquality data
local result = ig.inventory.GetItemQuality("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_inventory.lua`
