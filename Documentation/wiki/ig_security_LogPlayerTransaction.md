# ig.security.LogPlayerTransaction

## Description

Update cooldown

## Signature

```lua
function ig.security.LogPlayerTransaction(player, transactionType, amount, reason)
```

## Parameters

- **`player`**: table Player object
- **`transactionType`**: string Type of transaction
- **`player`**: table Player object
- **`transactionType`**: string Type of transaction
- **`amount`**: number Transaction amount
- **`reason`**: string Reason for transaction

## Example

```lua
-- Example usage of ig.security.LogPlayerTransaction
local result = ig.security.LogPlayerTransaction(player, transactionType, amount, reason)
```

## Related Functions

- [ig.security.CheckRateLimit](ig_security_CheckRateLimit.md)
- [ig.security.CheckTransactionRateLimit](ig_security_CheckTransactionRateLimit.md)
- [ig.security.DetectSuspiciousActivity](ig_security_DetectSuspiciousActivity.md)
- [ig.security.LogTransaction](ig_security_LogTransaction.md)

## Source

Defined in: `server/[Security]/_transaction_security.lua`
