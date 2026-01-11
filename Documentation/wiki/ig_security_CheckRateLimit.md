# ig.security.CheckRateLimit

## Description

Checks and returns whether checkratelimit condition is met

## Signature

```lua
function ig.security.CheckRateLimit(playerId, transactionType)
```

## Parameters

- **`playerId`**: string
- **`transactionType`**: any

## Example

```lua
-- Example usage
local result = ig.security.CheckRateLimit("id_12345", value)
```

## Source

Defined in: `server/[Security]/_transaction_security.lua`
