# ig.table.MatchKey

## Description

Searches a table for entries matching a specific key and returns matching elements. Useful for filtering table data by key name.

## Signature

```lua
function ig.table.MatchKey(t, k)
```

## Parameters

- **`t`**: table
- **`k`**: any

## Example

```lua
-- Find all entries with specific key
local data = {
    {name = "John", age = 30},
    {name = "Jane", age = 25},
    {title = "Admin"}
}
local withAge = ig.table.MatchKey(data, "age")
-- Returns entries that have "age" key
```

## Source

Defined in: `shared/[Tools]/_table.lua`
