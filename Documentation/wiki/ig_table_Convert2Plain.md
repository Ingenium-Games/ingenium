# ig.table.Convert2Plain

## Description

Recursively converts tables to plain serializable form by removing metatables and converting nested structures.

## Signature

```lua
function ig.table.Convert2Plain(tbl)
```

## Parameters

- **`tbl`**: table - The table to convert

## Returns

- **`table`** - A plain table without metatables

## Example

```lua
-- Convert a table with metatables to plain form
local complexTable = setmetatable({a = 1, b = 2}, {__index = {}})
local plainTable = ig.table.Convert2Plain(complexTable)
-- plainTable can now be safely serialized with JSON
```

## Source

Defined in: `shared/[Tools]/_table.lua`
