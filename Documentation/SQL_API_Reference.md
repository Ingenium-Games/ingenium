# SQL API Reference

Complete reference for all SQL functions in ig.core.

## Core Query Functions

### c.sql.Query

Execute a SELECT query that returns multiple rows.

**Syntax:**
```lua
c.sql.Query(query, parameters, callback)
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
local players = c.sql.Query("SELECT * FROM characters WHERE primary_id = ?", {licenseId})

-- Named parameters (compatibility)
local players = c.sql.Query("SELECT * FROM characters WHERE primary_id = @id", {["@id"] = licenseId})

-- With callback
c.sql.Query("SELECT * FROM characters", {}, function(results)
    for i, char in ipairs(results) do
        print(char.First_Name)
    end
end)
```

---

### c.sql.FetchScalar

Execute a SELECT query that returns a single value.

**Syntax:**
```lua
c.sql.FetchScalar(query, parameters, callback)
```

**Parameters:**
- `query` (string) - SQL SELECT query returning one column
- `parameters` (table, optional) - Query parameters
- `callback` (function, optional) - Callback function called with value

**Returns:**
- `any` - Single scalar value (string, number, boolean, etc.) or `nil`

**Examples:**
```lua
-- Get bank balance
local balance = c.sql.FetchScalar("SELECT Bank FROM character_accounts WHERE Character_ID = ?", {characterId})

-- Get count
local count = c.sql.FetchScalar("SELECT COUNT(*) FROM characters WHERE Primary_ID = ?", {primaryId})

-- Check existence
local exists = c.sql.FetchScalar("SELECT License_ID FROM users WHERE License_ID = ? LIMIT 1", {licenseId})
if exists then
    print("User exists")
end
```

---

### c.sql.FetchSingle

Execute a SELECT query that returns a single row.

**Syntax:**
```lua
c.sql.FetchSingle(query, parameters, callback)
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
local user = c.sql.FetchSingle("SELECT * FROM users WHERE License_ID = ? LIMIT 1", {licenseId})
if user then
    print(user.Username)
end

-- Get character details
local character = c.sql.FetchSingle("SELECT * FROM characters WHERE Character_ID = ?", {characterId})
```

---

### c.sql.Insert

Execute an INSERT query.

**Syntax:**
```lua
c.sql.Insert(query, parameters, callback)
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
local insertId = c.sql.Insert(
    "INSERT INTO characters (Created, Primary_ID, Character_ID, First_Name, Last_Name) VALUES (?, ?, ?, ?, ?)",
    {timestamp, primaryId, characterId, firstName, lastName}
)

-- With callback
c.sql.Insert(
    "INSERT INTO character_accounts (Character_ID, Account_Number, Bank) VALUES (?, ?, ?)",
    {characterId, accountNumber, startingBalance},
    function(insertId)
        print("Created account with ID: " .. insertId)
    end
)
```

---

### c.sql.Update

Execute an UPDATE or DELETE query.

**Syntax:**
```lua
c.sql.Update(query, parameters, callback)
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
local affected = c.sql.Update("UPDATE character_accounts SET Bank = ? WHERE Character_ID = ?", {newBalance, characterId})

-- Delete character
c.sql.Update("DELETE FROM characters WHERE Character_ID = ? LIMIT 1", {characterId}, function(affected)
    print("Deleted " .. affected .. " characters")
end)

-- Batch update
local count = c.sql.Update("UPDATE vehicles SET Parked = TRUE", {})
```

---

### c.sql.Transaction

Execute multiple queries in an atomic transaction.

**Syntax:**
```lua
c.sql.Transaction(queries, callback)
```

**Parameters:**
- `queries` (table) - Array of query objects: `{query = "...", parameters = {...}}`
- `callback` (function, optional) - Callback function called with (success, results)

**Returns:**
- `table` - `{success = boolean, results = table}`

**Examples:**
```lua
-- Transfer money between accounts
c.sql.Transaction({
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

### c.sql.Batch

Execute multiple queries without transaction (fire and forget).

**Syntax:**
```lua
c.sql.Batch(queries, callback)
```

**Parameters:**
- `queries` (table) - Array of query objects
- `callback` (function, optional) - Callback function called with results array

**Returns:**
- `table` - Array of result objects with `{success, result/error}`

**Examples:**
```lua
-- Batch update multiple records
c.sql.Batch({
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

### c.sql.PrepareQuery

Prepare a query for repeated execution (optimization).

**Syntax:**
```lua
c.sql.PrepareQuery(query, callback)
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
c.sql.PrepareQuery(
    "UPDATE characters SET Health = ?, Coords = ?, Inventory = ? WHERE Character_ID = ?",
    function(queryId)
        PlayerSaveQuery = queryId
    end
)
```

---

### c.sql.ExecutePrepared

Execute a prepared query.

**Syntax:**
```lua
c.sql.ExecutePrepared(queryId, parameters, callback)
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
c.sql.ExecutePrepared(PlayerSaveQuery, {health, coords, inventory, characterId}, function(affected)
    print("Saved character")
end)
```

---

## Utility Functions

### c.sql.IsReady

Check if SQL connection is established.

**Syntax:**
```lua
c.sql.IsReady()
```

**Returns:**
- `boolean` - `true` if ready, `false` otherwise

**Examples:**
```lua
if c.sql.IsReady() then
    print("Database connected")
else
    print("Waiting for database...")
end
```

---

### c.sql.AwaitReady

Wait for SQL connection to be ready (blocking).

**Syntax:**
```lua
c.sql.AwaitReady(timeout)
```

**Parameters:**
- `timeout` (number, optional) - Timeout in milliseconds (default: 30000)

**Returns:**
- `boolean` - `true` if ready before timeout, `false` if timeout

**Examples:**
```lua
-- Wait up to 30 seconds
if c.sql.AwaitReady() then
    print("Database ready!")
    -- Proceed with queries
else
    print("Database connection timeout!")
end

-- Custom timeout
if c.sql.AwaitReady(10000) then -- 10 seconds
    print("Connected")
end
```

---

### c.sql.GetStats

Get SQL performance statistics.

**Syntax:**
```lua
c.sql.GetStats()
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
local stats = c.sql.GetStats()
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
c.sql.Query("SELECT * FROM users WHERE license = ? AND active = ?", {license, true})
```

### Named Parameters (Compatibility)

Use `@paramName` placeholders and pass parameters as a table:

```lua
c.sql.Query("SELECT * FROM users WHERE license = @license", {["@license"] = license})
```

Both formats are automatically converted to MySQL2 positional parameters.

---

## Callback Patterns

### Synchronous (Blocking)

```lua
local result = c.sql.Query("SELECT * FROM characters", {})
-- result is immediately available
```

### Asynchronous (Non-blocking)

```lua
c.sql.Query("SELECT * FROM characters", {}, function(result)
    -- result available in callback
end)
```

### Thread-safe

```lua
Citizen.CreateThread(function()
    local result = c.sql.Query("SELECT * FROM characters", {})
    -- Safe to use blocking calls in threads
end)
```

---

## Error Handling

All query functions handle errors gracefully:

```lua
-- Failed queries return safe defaults
local result = c.sql.Query("INVALID SQL", {})
-- result = {}

local scalar = c.sql.FetchScalar("INVALID SQL", {})
-- scalar = nil

local insertId = c.sql.Insert("INVALID SQL", {})
-- insertId = 0
```

Errors are automatically logged to console with query context.

---

## Performance Tips

1. **Use Prepared Statements** for repeated queries
2. **Batch Operations** with `c.sql.Batch()` for non-critical updates
3. **Limit Result Sets** with WHERE clauses and LIMIT
4. **Monitor Performance** with `c.sql.GetStats()` and slow query events
5. **Use Transactions** for related updates to ensure atomicity

---

**Related Documentation:**
- [SQL Architecture](./SQL_Architecture.md)
- [SQL Migration Guide](./SQL_Migration_Guide.md)
- [SQL Events & Exports](./SQL_Events_Exports.md)
- [SQL Performance](./SQL_Performance.md)
