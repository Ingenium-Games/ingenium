# ig.item.GetRecipe

## Description

Retrieves and returns recipe data

## Signature

```lua
function ig.item.GetRecipe(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Get recipe data
local result = ig.item.GetRecipe("name_example")
if result then
    print("Retrieved:", result)
end
```

## Source

Defined in: `server/[Data - Save to File]/_items.lua`
