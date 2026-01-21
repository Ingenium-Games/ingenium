# ig.table.Count

## Description

Counts the number of keys in a table or the number of occurrences of a specific value.

## Signature

```lua
function ig.table.Count(t, value)
```

## Parameters

- **`t`**: table - The table to count
- **`value`**: any (optional) - If provided, counts occurrences of this value; otherwise counts all keys

## Returns

- **`number`** - The count of keys or value occurrences

## Example

```lua
-- Count keys in a table
local t = {a = 1, b = 2, c = 3}
local keyCount = ig.table.Count(t)  -- Returns 3

-- Count occurrences of a value
local t2 = {1, 2, 2, 3, 2}
local valueCount = ig.table.Count(t2, 2)  -- Returns 3
```

## Source

Defined in: `shared/[Tools]/_table.lua`
