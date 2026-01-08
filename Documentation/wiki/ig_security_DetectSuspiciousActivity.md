# ig.security.DetectSuspiciousActivity

## Description

Wrapper: Log a transaction with player object

## Signature

```lua
function ig.security.DetectSuspiciousActivity(player, actionType, amount)
```

## Parameters

- **`player`**: table Player object
- **`transactionType`**: string Type of transaction
- **`amount`**: number Transaction amount
- **`reason`**: string Reason for transaction
- **`player`**: table Player object
- **`actionType`**: string Type of action
- **`amount`**: number Transaction amount

## Example

```lua
-- Example usage of ig.security.DetectSuspiciousActivity
local result = ig.security.DetectSuspiciousActivity(player, actionType, amount)
```

## Related Functions

- [ig.security.CheckRateLimit](ig_security_CheckRateLimit.md)
- [ig.security.CheckTransactionRateLimit](ig_security_CheckTransactionRateLimit.md)
- [ig.security.LogPlayerTransaction](ig_security_LogPlayerTransaction.md)
- [ig.security.LogTransaction](ig_security_LogTransaction.md)

## Source

Defined in: `server/[Security]/_transaction_security.lua`
