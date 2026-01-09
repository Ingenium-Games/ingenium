# Banking System Implementation Guide

## Overview

This implementation integrates the ig.bank banking system into the Ingenium framework, following all Ingenium wiki guides and code standards. The system provides a complete banking solution with NUI interface, ATM/Bank interactions, player transfers, favorites management, and withdrawal/deposit functionality.

## Components

### 1. Banking NUI (Vue 3 Component)

**Location**: `nui/src/components/BankingMenu.vue`

- Modern Vue 3 single-file component following Ingenium's one-window style
- Fully integrated with Pinia state management (`nui/src/stores/banking.js`)
- Responsive design with Tailwind CSS
- Features:
  - Account overview with balance and IBAN display
  - Transaction history with real-time updates
  - Money transfer interface with IBAN lookup
  - Withdrawal and deposit forms
  - Favorites management system

### 2. ATM/Bank Object Interaction

**Location**: `client/[Callbacks]/_banking.lua`

- Global object targets for ATM props:
  - `prop_atm_01`
  - `prop_atm_02`
  - `prop_atm_03`
  - `prop_fleeca_atm`
- Box zone targets for major bank locations:
  - All Fleeca Banks across Los Santos
  - Blaine County Savings
  - Additional bank locations

### 3. Server-Side Callbacks

**Location**: `server/[Callbacks]/_banking.lua`

Registered server callbacks:
- `banking:open` - Opens banking menu for player
- `banking:transfer` - Handles character-to-character transfers
- `banking:withdraw` - Processes cash withdrawals
- `banking:deposit` - Processes cash deposits
- `banking:addFavorite` - Adds a payee to favorites
- `banking:removeFavorite` - Removes a payee from favorites

### 4. SQL Functions

**Location**: `server/[SQL]/_banking.lua`

- `GetTransactions` - Retrieves transaction history
- `AddTransaction` - Logs a new transaction
- `GetFavorites` - Gets saved favorites
- `AddFavorite` - Adds a new favorite
- `RemoveFavorite` - Removes a favorite
- `AddBankOffline` - Updates bank balance for offline characters

### 5. Player Class Extensions

**Location**: `server/[Classes]/_player.lua`

Added functions:
- `GetIban()` - Returns player's IBAN
- Enhanced state tracking for IBAN field

### 6. Character SQL Extensions

**Location**: `server/[SQL]/_character.lua`

Added functions:
- `GetByIban(iban)` - Retrieves character by IBAN

### 7. Database Schema

**Location**: `server/[SQL]/_banking_migration.sql`

New database elements:
- `Banking_Favorites` column in `characters` table (JSON array)
- `banking_transactions` table for transaction history

## Installation

### 1. Run Database Migration

Execute the SQL migration file to add required database fields:

```sql
-- Run this in your MySQL database
source server/[SQL]/_banking_migration.sql
```

Or manually run:

```sql
-- Add Banking_Favorites column
ALTER TABLE `characters` 
ADD COLUMN IF NOT EXISTS `Banking_Favorites` LONGTEXT DEFAULT '[]' 
COMMENT 'JSON array of favorite payees';

-- Create transactions table
CREATE TABLE IF NOT EXISTS `banking_transactions` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `Character_ID` VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Type` VARCHAR(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` VARCHAR(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Amount` DECIMAL(10,2) NOT NULL,
  `Date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `Character_ID` (`Character_ID`),
  KEY `Date` (`Date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### 2. Build NUI

```bash
cd nui
npm install
npm run build
```

### 3. Restart Resource

```
restart ingenium
```

## Usage

### Opening Banking Interface

Players can access banking through:

1. **ATMs**: Walk up to any ATM prop and use the target system
2. **Bank Buildings**: Enter a bank zone and use the target system
3. **Command** (if added): `/banking` or similar

### Transfers

1. Open banking interface
2. Navigate to "Transfer" tab
3. Enter target IBAN (9-digit number)
4. Enter amount
5. Add optional description
6. Click "Transfer"

The system will:
- Validate IBAN exists
- Check sender has sufficient funds
- Deduct from sender's bank account
- Add to recipient's bank account (even if offline)
- Log transactions for both parties
- Notify recipient if online

### Withdrawals

1. Open banking interface
2. Navigate to "Withdraw" tab
3. Enter amount to withdraw
4. Click "Withdraw"

The system will:
- Deduct from bank account
- Add cash items to inventory
- Log the transaction

### Deposits

1. Open banking interface
2. Navigate to "Deposit" tab
3. Enter amount to deposit
4. Click "Deposit"

The system will:
- Remove cash items from inventory
- Add to bank account
- Log the transaction

### Favorites

1. Complete a successful transfer
2. Navigate to "Favorites" tab
3. Add the IBAN with a friendly name
4. Use favorites in future transfers for quick access

Favorites are stored per character in the database.

## Technical Details

### Dirty Flag System

The implementation leverages Ingenium's built-in dirty flag system:
- Bank balance changes automatically mark player as dirty
- Changes are saved to database during regular save cycles (every 90 seconds)
- No manual save calls required

### Security

- All transactions are logged with security audit trail
- `ig.security.LogPlayerTransaction` integration for monitoring
- Server-side validation for all operations
- Parameterized SQL queries prevent injection
- IBAN validation ensures recipient exists

### State Management

- Uses Pinia for reactive state management
- Real-time NUI updates on balance changes
- Transaction history updates dynamically
- Favorites sync automatically

### Error Handling

- Comprehensive validation on all inputs
- User-friendly error messages
- Graceful handling of offline transfers
- Proper transaction rollback on failures

## Configuration

### ATM Locations

Add or modify ATM props in `client/[Callbacks]/_banking.lua`:

```lua
local atmModels = {
    "prop_atm_01",
    "prop_atm_02",
    "prop_atm_03",
    "prop_fleeca_atm"
}
```

### Bank Locations

Add or modify bank zones in `client/[Callbacks]/_banking.lua`:

```lua
local bankLocations = {
    {coords = vector3(149.46, -1040.53, 29.37), radius = 2.0, name = "Fleeca Bank"},
    -- Add more locations
}
```

### Transaction History Limit

Modify in `server/[Callbacks]/_banking.lua`:

```lua
local transactions = ig.sql.banking.GetTransactions(xPlayer.GetCharacter_ID(), 50) -- Change 50 to desired limit
```

## Troubleshooting

### Banking Menu Not Opening

1. Check console for errors
2. Verify NUI is built (`nui/dist/index.html` exists)
3. Ensure callbacks are registered (`RegisterServerCallback` errors)
4. Check target system is loaded

### Transfers Failing

1. Verify IBAN exists in database
2. Check sender has sufficient funds
3. Review server console for SQL errors
4. Ensure `Banking_Favorites` column exists

### Missing Transactions

1. Run database migration script
2. Verify `banking_transactions` table exists
3. Check SQL logs for errors

## Code Standards Compliance

This implementation follows all Ingenium standards:

✅ **Vue 3 Single-App Architecture**: All UI in one NUI resource  
✅ **Pinia State Management**: Centralized reactive state  
✅ **Lua Naming**: Functions use `UpperCamelCase`  
✅ **SQL Security**: Parameterized queries throughout  
✅ **Documentation**: Comprehensive JSDoc/LuaDoc comments  
✅ **Dirty Flag System**: Automatic save triggering  
✅ **Player Class Integration**: Uses existing xPlayer functions  
✅ **Target System**: ig.target.AddGlobalObject usage  
✅ **Error Handling**: Validation and user feedback  
✅ **Security Logging**: Transaction audit trail  

## Future Enhancements

Potential additions:
- Loan system integration with existing `ig.bank` cron jobs
- Interest rates for savings accounts
- Transaction search and filtering
- Bank statements export
- Multi-currency support
- Transaction limits and daily caps
- Account types (checking, savings, business)
- Overdraft protection settings

## Support

For issues or questions:
- Review server console logs
- Check NUI console (F12 in FiveM)
- Verify database schema matches migration
- Ensure all files are in correct locations per fxmanifest.lua

## Credits

Implementation by: Copilot Agent  
Based on: ig.bank reference repository  
Framework: Ingenium by Twiitchter  
License: Proprietary - © 2021-2026 Ingenium Games
