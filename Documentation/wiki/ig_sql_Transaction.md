# ig.sql.Transaction

## Description

Execute an UPDATE or DELETE query

## Signature

```lua
function ig.sql.Transaction(queries, callback)
```

## Parameters

- **`queries`**: any
- **`callback`**: function

## Example

```lua
-- Example usage
local result = ig.sql.Transaction(value, function() end)
```

## Source

Defined in: `server/[SQL]/_handler.lua`
