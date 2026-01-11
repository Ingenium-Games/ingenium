# ig.item.GetAbout

## Description

Retrieves and returns about data

## Signature

```lua
function ig.item.GetAbout(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get about data
local result = ig.item.GetAbout("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `client/_items.lua`
