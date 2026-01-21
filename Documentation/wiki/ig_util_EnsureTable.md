# ig.util.EnsureTable

## Description

Normalizes input to table form. If the value is already a table, returns it; otherwise, wraps it in a table or returns an empty table.

## Signature

```lua
function ig.util.EnsureTable(value)
```

## Parameters

- **`value`**: any - The value to normalize

## Returns

- **`table`** - The value as a table

## Example

```lua
-- Ensure various inputs become tables
local t1 = ig.util.EnsureTable({a = 1})  -- Returns {a = 1}
local t2 = ig.util.EnsureTable("hello")  -- Returns {"hello"}
local t3 = ig.util.EnsureTable(nil)      -- Returns {}
```

## Source

Defined in: `shared/[Tools]/_util.lua`
