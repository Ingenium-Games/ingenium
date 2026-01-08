# ig.security.CheckTransactionRateLimit

## Description

Rate Limiting

## Signature

```lua
function ig.security.CheckTransactionRateLimit(player, transactionType)
```

## Parameters

- **`playerId`**: number Player source ID
- **`transactionType`**: string Type of transaction
- **`player`**: table Player object
- **`transactionType`**: string Type of transaction

## Example

```lua
-- Example usage of ig.security.CheckTransactionRateLimit
local result = ig.security.CheckTransactionRateLimit(player, transactionType)
```

## Related Functions

- [ig.security.CheckRateLimit](ig_security_CheckRateLimit.md)
- [ig.security.DetectSuspiciousActivity](ig_security_DetectSuspiciousActivity.md)
- [ig.security.LogPlayerTransaction](ig_security_LogPlayerTransaction.md)
- [ig.security.LogTransaction](ig_security_LogTransaction.md)

## Source

Defined in: `server/[Security]/_transaction_security.lua`
