# ig.inventory.HasItem

## Description

gets triggered via ig.nui to set the pulled current contents, then this can be used to confirm if items exist prior to menu activations.

## Signature

```lua
function ig.inventory.HasItem(name)
```

## Parameters

- **`name`**: string

## Example

```lua
-- Example usage
local result = ig.inventory.HasItem("name_example")
```

## Source

Defined in: `client/_inventory.lua`
