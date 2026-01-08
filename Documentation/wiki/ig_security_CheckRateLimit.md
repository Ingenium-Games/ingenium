# ig.security.CheckRateLimit

## Description

Validate critical fields

## Signature

```lua
function ig.security.CheckRateLimit(playerId, transactionType)
```

## Parameters

- **`playerId`**: number Player source ID
- **`transactionType`**: string Type of transaction

## Example

```lua
-- Example usage of ig.security.CheckRateLimit
local result = ig.security.CheckRateLimit(playerId, transactionType)
```

## Related Functions

- [ig.security.CheckTransactionRateLimit](ig_security_CheckTransactionRateLimit.md)
- [ig.security.DetectSuspiciousActivity](ig_security_DetectSuspiciousActivity.md)
- [ig.security.LogPlayerTransaction](ig_security_LogPlayerTransaction.md)
- [ig.security.LogTransaction](ig_security_LogTransaction.md)

## Source

Defined in: `server/[Security]/_transaction_security.lua`
