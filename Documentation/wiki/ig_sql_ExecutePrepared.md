# ig.sql.ExecutePrepared

## Description

Execute multiple queries as a batch (without transaction)

## Signature

```lua
function ig.sql.ExecutePrepared(queryId, parameters, callback)
```

## Parameters

- **`queryId`**: any
- **`parameters`**: any
- **`callback`**: function

## Example

```lua
-- Example usage
local result = ig.sql.ExecutePrepared(value, value, function() end)
```

## Source

Defined in: `server/[SQL]/_handler.lua`
