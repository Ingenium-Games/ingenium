# ig.table.Dump

## Description

Converts a Lua table to a readable string representation for debugging. Handles nested tables and various data types. Useful for logging and debugging complex data structures.

## Signature

```lua
function ig.table.Dump(table, nb)
```

## Parameters

- **`table`**: string
- **`nb`**: number

## Example

```lua
-- Example 1: Debug print a table
local playerData = {
    name = "John",
    age = 25,
    job = {title = "Police", grade = 3}
}
print(ig.table.Dump(playerData))

-- Example 2: Dump with custom indentation
local config = {setting1 = true, setting2 = false}
print(ig.table.Dump(config, 2))  -- 2 spaces indent

-- Example 3: Dump complex nested structure
local vehicle = {
    model = "adder",
    modifications = {
        engine = 4,
        transmission = 3,
        colors = {primary = 1, secondary = 2}
    }
}
print(ig.table.Dump(vehicle))
```

## Source

Defined in: `shared/[Tools]/_table.lua`
