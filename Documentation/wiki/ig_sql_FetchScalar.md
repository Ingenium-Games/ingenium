# ig.sql.FetchScalar

## Description

Execute a SELECT query that returns a single row

## Signature

```lua
function ig.sql.FetchScalar(query, parameters, callback)
```

## Parameters

- **`query`**: number
- **`parameters`**: number
- **`callback`**: function

## Example

```lua
-- Example usage
local result = ig.sql.FetchScalar(100, 100, function() end)
```

## Source

Defined in: `server/[SQL]/_handler.lua`
