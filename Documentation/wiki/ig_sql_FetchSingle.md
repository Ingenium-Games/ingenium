# ig.sql.FetchSingle

## Description

Performs fetchsingle operation

## Signature

```lua
function ig.sql.FetchSingle(query, parameters, callback)
```

## Parameters

- **`query`**: number
- **`parameters`**: number
- **`callback`**: function

## Example

```lua
-- Example usage
local result = ig.sql.FetchSingle(100, 100, function() end)
```

## Source

Defined in: `server/[SQL]/_handler.lua`
