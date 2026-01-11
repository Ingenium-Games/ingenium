# ig.sql.Batch

## Description

Execute an UPDATE or DELETE query

## Signature

```lua
function ig.sql.Batch(queries, callback)
```

## Parameters

- **`queries`**: any
- **`callback`**: function

## Example

```lua
-- Example usage
local result = ig.sql.Batch(value, function() end)
```

## Source

Defined in: `server/[SQL]/_handler.lua`
