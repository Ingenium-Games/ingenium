# ig.sql.banking.AddTransaction

## Description

Logs a banking transaction to the banking_transactions table for audit and history purposes.

## Signature

```lua
function ig.sql.banking.AddTransaction(characterId, transaction)
```

## Parameters

- **`characterId`**: string - The Character_ID to log the transaction for
- **`transaction`**: table - Transaction data containing:
  - `type`: string - Transaction type (e.g., "Transfer Out", "Transfer In", "Withdrawal", "Deposit")
  - `description`: string - Transaction description
  - `amount`: number - Transaction amount (negative for debits, positive for credits)

## Returns

None

## Example

```lua
-- Log a transfer transaction
local xPlayer = ig.data.GetPlayer(source)
ig.sql.banking.AddTransaction(xPlayer.GetCharacter_ID(), {
    type = "Transfer Out",
    description = "To John Doe: Payment for services",
    amount = -500.00
})

-- Log a withdrawal
ig.sql.banking.AddTransaction(characterId, {
    type = "Withdrawal",
    description = "ATM Withdrawal",
    amount = -200.00
})

-- Log a deposit
ig.sql.banking.AddTransaction(characterId, {
    type = "Deposit",
    description = "ATM Deposit",
    amount = 1000.00
})

-- Log a transfer received
ig.sql.banking.AddTransaction(recipientId, {
    type = "Transfer In",
    description = "From Jane Smith: Rent payment",
    amount = 500.00
})
```

## Related Functions

- [ig.sql.banking.GetTransactions](ig_sql_banking_GetTransactions.md)
- [xPlayer.AddBank](xPlayer_AddBank.md)
- [xPlayer.RemoveBank](xPlayer_RemoveBank.md)

## Notes

- Date is automatically set to current timestamp (NOW())
- Amount should be negative for debits (withdrawals, outgoing transfers)
- Amount should be positive for credits (deposits, incoming transfers)
- All banking operations should log transactions for audit trail
- Transactions are stored permanently for historical records

## Source

Defined in: `server/[SQL]/_banking.lua`
