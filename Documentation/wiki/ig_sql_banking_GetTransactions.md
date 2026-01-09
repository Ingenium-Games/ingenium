# ig.sql.banking.GetTransactions

## Description

Retrieves transaction history for a character from the banking_transactions table.

## Signature

```lua
function ig.sql.banking.GetTransactions(characterId, limit)
```

## Parameters

- **`characterId`**: string - The Character_ID to get transactions for
- **`limit`**: number (optional) - Maximum number of transactions to retrieve (default: 50)

## Returns

- **`table`**: Array of transaction objects, each containing:
  - `type`: string - Transaction type (e.g., "Transfer In", "Transfer Out", "Withdrawal", "Deposit")
  - `description`: string - Transaction description
  - `amount`: number - Transaction amount (negative for debits, positive for credits)
  - `date`: string - Transaction timestamp (YYYY-MM-DD HH:MM:SS)

## Example

```lua
-- Get last 50 transactions for a character
local xPlayer = ig.data.GetPlayer(source)
local transactions = ig.sql.banking.GetTransactions(xPlayer.GetCharacter_ID(), 50)

for i, transaction in ipairs(transactions) do
    print(string.format("%s: %s - $%.2f", 
        transaction.date, 
        transaction.type, 
        transaction.amount))
end

-- Get last 10 transactions
local recentTransactions = ig.sql.banking.GetTransactions(characterId, 10)

-- Send transactions to NUI
TriggerClientEvent("banking:openMenu", source, {
    characterName = xPlayer.GetFull_Name(),
    transactions = transactions
})
```

## Related Functions

- [ig.sql.banking.AddTransaction](ig_sql_banking_AddTransaction.md)
- [xPlayer.GetBank](xPlayer_GetBank.md)

## Notes

- Transactions are ordered by date descending (most recent first)
- Returns empty table if no transactions found
- Default limit is 50 to prevent excessive data transfer
- Useful for displaying transaction history in banking UI

## Source

Defined in: `server/[SQL]/_banking.lua`
