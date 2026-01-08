# ig.security.LogTransaction

## Description

====================================================================================--

## Signature

```lua
function ig.security.LogTransaction(player, transactionType, amount, reason)
```

## Parameters

- **`player`**: table Player object
- **`transactionType`**: string Type of transaction (e.g., "add_cash", "remove_cash", "set_bank")
- **`amount`**: number Transaction amount
- **`reason`**: string Reason for transaction

## Example

```lua
-- Example usage of ig.security.LogTransaction
local result = ig.security.LogTransaction(player, transactionType, amount, reason)
```

## Related Functions

- [ig.security.CheckRateLimit](ig_security_CheckRateLimit.md)
- [ig.security.CheckTransactionRateLimit](ig_security_CheckTransactionRateLimit.md)
- [ig.security.DetectSuspiciousActivity](ig_security_DetectSuspiciousActivity.md)
- [ig.security.LogPlayerTransaction](ig_security_LogPlayerTransaction.md)

## Source

Defined in: `server/[Security]/_transaction_security.lua`
