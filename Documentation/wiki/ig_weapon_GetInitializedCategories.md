# ig.weapon.GetInitializedCategories

## Description

Returns the list of weapon categories that have been initialized with the weapon system.

## Signature

```lua
function ig.weapon.GetInitializedCategories()
```

## Parameters

None

## Returns

- **`table`** - Array of initialized weapon category names

## Example

```lua
-- Get initialized categories
local categories = ig.weapon.GetInitializedCategories()
for _, category in ipairs(categories) do
    print("Initialized category:", category)
end
```

## Source

Defined in: `client/_weapon.lua`
