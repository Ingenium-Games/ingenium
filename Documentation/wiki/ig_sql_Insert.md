# ig.sql.Insert

## Description

Execute a SELECT query that returns a single value

## Signature

```lua
function ig.sql.Insert(query, parameters, callback)
```

## Parameters

- **`query`**: number
- **`parameters`**: number
- **`callback`**: function

## Example

```lua
-- Example usage
local result = ig.sql.Insert(100, 100, function() end)
```

## Source

Defined in: `server/[SQL]/_handler.lua`
