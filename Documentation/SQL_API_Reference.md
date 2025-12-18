# SQL API Reference

Complete reference for all SQL functions in ig.core.

## Core Query Functions

### ig.sql.Query

Execute a SELECT query that returns multiple rows.

**Syntax:**
```lua
ig.sql.Query(query, parameters, callback)
```

**Parameters:**
- `query` (string) - SQL SELECT query with `?` placeholders or `@named` parameters
- `parameters` (table, optional) - Query parameters as array for `?` or table for `@named`
- `callback` (function, optional) - Callback function called with results

**Returns:**
- `table` - Array of result rows

**Examples:**
```lua
-- Positional parameters
local players = ig.sql.Query("SELECT * FROM characters WHERE primary_id = ?", {licenseId})

-- Named parameters (compatibility)
local players = ig.sql.Query("SELECT * FROM characters WHERE primary_id = @id", {["@id"] = licenseId})

-- With callback
ig.sql.Query("SELECT * FROM characters", {}, function(results)
    for i, char in ipairs(results) do
        print(char.First_Name)
    end
end)
```

---

### ig.sql.FetchScalar

Execute a SELECT query that returns a single value.

**Syntax:**
```lua
ig.sql.FetchScalar(query, parameters, callback)
```

**Parameters:**
- `query` (string) - SQL SELECT query returning one column
- `parameters` (table, optional) - Query parameters
- `callback` (function, optional) - Callback function called with value

**Returns:**
- `any` - Single scalar value (string, number, boolean, etig.) or `nil`

**Examples:**
```lua
-- Get bank balance
local balance = ig.sql.FetchScalar("SELECT Bank FROM character_accounts WHERE Character_ID = ?", {characterId})

-- Get count
local count = ig.sql.FetchScalar("SELECT COUNT(*) FROM characters WHERE Primary_ID = ?", {primaryId})

-- Check existence
local exists = ig.sql.FetchScalar("SELECT License_ID FROM users WHERE License_ID = ? LIMIT 1", {licenseId})
if exists then
    print("User exists")
end
```

---

### ig.sql.FetchSingle

Execute a SELECT query that returns a single row.

**Syntax:**
```lua
ig.sql.FetchSingle(query, parameters, callback)
```

**Parameters:**
- `query` (string) - SQL SELECT query with LIMIT 1
- `parameters` (table, optional) - Query parameters
- `callback` (function, optional) - Callback function called with row

**Returns:**
- `table` or `nil` - Single row as table or `nil` if not found

**Examples:**
```lua
-- Get single user
local user = ig.sql.FetchSingle("SELECT * FROM users WHERE License_ID = ? LIMIT 1", {licenseId})
if user then
    print(user.Username)
end

-- Get character details
local character = ig.sql.FetchSingle("SELECT * FROM characters WHERE Character_ID = ?", {characterId})
```

---

### ig.sql.Insert

Execute an INSERT query.

**Syntax:**
```lua
ig.sql.Insert(query, parameters, callback)
```

**Parameters:**
- `query` (string) - SQL INSERT query
- `parameters` (table, optional) - Query parameters
- `callback` (function, optional) - Callback function called with insertId

**Returns:**
- `number` - Auto-increment insert ID or 0

**Examples:**
```lua
-- Insert character
local insertId = ig.sql.Insert(
    "INSERT INTO characters (Created, Primary_ID, Character_ID, First_Name, Last_Name) VALUES (?, ?, ?, ?, ?)",
    {timestamp, primaryId, characterId, firstName, lastName}
)

-- With callback
ig.sql.Insert(
    "INSERT INTO character_accounts (Character_ID, Account_Number, Bank) VALUES (?, ?, ?)",
    {characterId, accountNumber, startingBalance},
    function(insertId)
        print("Created account with ID: " .. insertId)
    end
)
```

---

### ig.sql.Update

Execute an UPDATE or DELETE query.

**Syntax:**
```lua
ig.sql.Update(query, parameters, callback)
```

**Parameters:**
- `query` (string) - SQL UPDATE or DELETE query
- `parameters` (table, optional) - Query parameters
- `callback` (function, optional) - Callback function called with affectedRows

**Returns:**
- `number` - Number of affected rows

**Examples:**
```lua
-- Update bank balance
local affected = ig.sql.Update("UPDATE character_accounts SET Bank = ? WHERE Character_ID = ?", {newBalance, characterId})

-- Delete character
ig.sql.Update("DELETE FROM characters WHERE Character_ID = ? LIMIT 1", {characterId}, function(affected)
    print("Deleted " .. affected .. " characters")
end)

-- Batch update
local count = ig.sql.Update("UPDATE vehicles SET Parked = TRUE", {})
```

---

### ig.sql.Transaction

Execute multiple queries in an atomic transaction.

**Syntax:**
```lua
ig.sql.Transaction(queries, callback)
```

**Parameters:**
- `queries` (table) - Array of query objects: `{query = "...", parameters = {...}}`
- `callback` (function, optional) - Callback function called with (success, results)

**Returns:**
- `table` - `{success = boolean, results = table}`

**Examples:**
```lua
-- Transfer money between accounts
ig.sql.Transaction({
    {query = "UPDATE character_accounts SET Bank = Bank - ? WHERE Character_ID = ?", parameters = {amount, fromId}},
    {query = "UPDATE character_accounts SET Bank = Bank + ? WHERE Character_ID = ?", parameters = {amount, toId}},
    {query = "INSERT INTO transactions (From_ID, To_ID, Amount, Timestamp) VALUES (?, ?, ?, ?)", parameters = {fromId, toId, amount, timestamp}}
}, function(success, results)
    if success then
        print("Transfer completed")
    else
        print("Transfer failed, rolled back")
    end
end)
```

---

### ig.sql.Batch

Execute multiple queries without transaction (fire and forget).

**Syntax:**
```lua
ig.sql.Batch(queries, callback)
```

**Parameters:**
- `queries` (table) - Array of query objects
- `callback` (function, optional) - Callback function called with results array

**Returns:**
- `table` - Array of result objects with `{success, result/error}`

**Examples:**
```lua
-- Batch update multiple records
ig.sql.Batch({
    {query = "UPDATE characters SET Active = FALSE WHERE Character_ID = ?", parameters = {char1}},
    {query = "UPDATE characters SET Active = FALSE WHERE Character_ID = ?", parameters = {char2}},
    {query = "UPDATE characters SET Active = FALSE WHERE Character_ID = ?", parameters = {char3}}
}, function(results)
    local successCount = 0
    for _, result in ipairs(results) do
        if result.success then
            successCount = successCount + 1
        end
    end
    print(successCount .. " updates succeeded")
end)
```

---

## Prepared Statements

### ig.sql.PrepareQuery

Prepare a query for repeated execution (optimization).

**Syntax:**
```lua
ig.sql.PrepareQuery(query, callback)
```

**Parameters:**
- `query` (string) - SQL query with `?` placeholders
- `callback` (function, optional) - Callback function called with queryId

**Returns:**
- `string` - Unique query ID for use with `ExecutePrepared`

**Examples:**
```lua
-- Prepare at resource start
local PlayerSaveQuery = -1
ig.sql.PrepareQuery(
    "UPDATE characters SET Health = ?, Coords = ?, Inventory = ? WHERE Character_ID = ?",
    function(queryId)
        PlayerSaveQuery = queryId
    end
)
```

---

### ig.sql.ExecutePrepared

Execute a prepared query.

**Syntax:**
```lua
ig.sql.ExecutePrepared(queryId, parameters, callback)
```

**Parameters:**
- `queryId` (string/number) - Query ID from `PrepareQuery`
- `parameters` (table) - Positional parameters
- `callback` (function, optional) - Callback function called with affectedRows

**Returns:**
- `number` - Affected rows

**Examples:**
```lua
-- Execute in save loop
ig.sql.ExecutePrepared(PlayerSaveQuery, {health, coords, inventory, characterId}, function(affected)
    print("Saved character")
end)
```

---

## Utility Functions

### ig.sql.IsReady

Check if SQL connection is established.

**Syntax:**
```lua
ig.sql.IsReady()
```

**Returns:**
- `boolean` - `true` if ready, `false` otherwise

**Examples:**
```lua
if ig.sql.IsReady() then
    print("Database connected")
else
    print("Waiting for database...")
end
```

---

### ig.sql.AwaitReady

Wait for SQL connection to be ready (blocking).

**Syntax:**
```lua
ig.sql.AwaitReady(timeout)
```

**Parameters:**
- `timeout` (number, optional) - Timeout in milliseconds (default: 30000)

**Returns:**
- `boolean` - `true` if ready before timeout, `false` if timeout

**Examples:**
```lua
-- Wait up to 30 seconds
if ig.sql.AwaitReady() then
    print("Database ready!")
    -- Proceed with queries
else
    print("Database connection timeout!")
end

-- Custom timeout
if ig.sql.AwaitReady(10000) then -- 10 seconds
    print("Connected")
end
```

---

### ig.sql.GetStats

Get SQL performance statistics.

**Syntax:**
```lua
ig.sql.GetStats()
```

**Returns:**
- `table` - Statistics object

**Result Structure:**
```lua
{
    totalQueries = 1523,      -- Total queries executed
    slowQueries = 12,         -- Queries > 150ms
    failedQueries = 2,        -- Failed queries
    totalTime = 45234.56,     -- Total execution time (ms)
    averageTime = 29.71,      -- Average query time (ms)
    isReady = true,           -- Connection status
    config = {                -- Connection config
        host = "localhost",
        port = 3306,
        database = "fivem",
        connectionLimit = 10
    }
}
```

**Examples:**
```lua
local stats = ig.sql.GetStats()
print(string.format("Executed %d queries, avg %.2fms", stats.totalQueries, stats.averageTime))
if stats.slowQueries > 0 then
    print("Warning: " .. stats.slowQueries .. " slow queries detected")
end
```

---

## Parameter Formats

### Positional Parameters (Recommended)

Use `?` placeholders and pass parameters as an array:

```lua
ig.sql.Query("SELECT * FROM users WHERE license = ? AND active = ?", {license, true})
```

### Named Parameters (Compatibility)

Use `@paramName` placeholders and pass parameters as a table:

```lua
ig.sql.Query("SELECT * FROM users WHERE license = @license", {["@license"] = license})
```

Both formats are automatically converted to MySQL2 positional parameters.

---

## Callback Patterns

### Synchronous (Blocking)

```lua
local result = ig.sql.Query("SELECT * FROM characters", {})
-- result is immediately available
```

### Asynchronous (Non-blocking)

```lua
ig.sql.Query("SELECT * FROM characters", {}, function(result)
    -- result available in callback
end)
```

### Thread-safe

```lua
Citizen.CreateThread(function()
    local result = ig.sql.Query("SELECT * FROM characters", {})
    -- Safe to use blocking calls in threads
end)
```

---

## Error Handling

All query functions handle errors gracefully:

```lua
-- Failed queries return safe defaults
local result = ig.sql.Query("INVALID SQL", {})
-- result = {}

local scalar = ig.sql.FetchScalar("INVALID SQL", {})
-- scalar = nil

local insertId = ig.sql.Insert("INVALID SQL", {})
-- insertId = 0
```

Errors are automatically logged to console with query context.

---

## Performance Tips

1. **Use Prepared Statements** for repeated queries
2. **Batch Operations** with `ig.sql.Batch()` for non-critical updates
3. **Limit Result Sets** with WHERE clauses and LIMIT
4. **Monitor Performance** with `ig.sql.GetStats()` and slow query events
5. **Use Transactions** for related updates to ensure atomicity

---

**Related Documentation:**
- [SQL Architecture](./SQL_Architecture.md)
- [SQL Migration Guide](./SQL_Migration_Guide.md)
- [SQL Events & Exports](./SQL_Events_Exports.md)
- [SQL Performance](./SQL_Performance.md)
