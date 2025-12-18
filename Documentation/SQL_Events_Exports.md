# SQL Events & Exports

Complete reference for SQL-related events, exports, and commands in ig.core.

## Server Events

### ig:sql:ready

Emitted when the database connection is established and ready for queries.

**Usage:**
```lua
AddEventHandler('ig:sql:ready', function()
    print("Database connection established")
    -- Safe to execute queries now
end)
```

---

### ig:sql:queryExecuted

Emitted after every query execution (success or failure).

**Parameters:**
- `data` (table) - Query execution information

**Data Structure:**
```lua
{
    query = "SELECT * FROM...",  -- SQL query executed
    duration = 25.43,             -- Execution time in milliseconds
    success = true,               -- Whether query succeeded
    error = nil                   -- Error message if failed (optional)
}
```

**Usage:**
```lua
AddEventHandler('ig:sql:queryExecuted', function(data)
    if not data.success then
        print("Query failed: " .. data.error)
    end
    
    -- Log all queries over 100ms
    if data.duration > 100 then
        print(string.format("Slow query: %.2fms - %s", data.duration, data.query:sub(1, 50)))
    end
end)
```

---

### ig:sql:slowQuery

Emitted when a query takes longer than 150ms to execute.

**Parameters:**
- `data` (table) - Slow query information

**Data Structure:**
```lua
{
    query = "SELECT * FROM...",  -- SQL query
    duration = 187.65,            -- Execution time in milliseconds
    parameters = {...}            -- Query parameters
}
```

**Usage:**
```lua
AddEventHandler('ig:sql:slowQuery', function(data)
    print(string.format("^3[SLOW QUERY] %.2fms: %s^7", data.duration, data.query))
    
    -- Log to file or external service
    LogSlowQuery(data.query, data.duration, data.parameters)
end)
```

---

## Exports

### query

Execute a SELECT query from another resource.

**Syntax:**
```lua
exports['ingenium']:query(query, params, callback)
```

**Example:**
```lua
-- From another resource
local characters = exports['ingenium']:query("SELECT * FROM characters WHERE Primary_ID = ?", {licenseId})
```

---

### fetchScalar

Fetch a single value from another resource.

**Syntax:**
```lua
exports['ingenium']:fetchScalar(query, params, callback)
```

**Example:**
```lua
local balance = exports['ingenium']:fetchScalar("SELECT Bank FROM character_accounts WHERE Character_ID = ?", {charId})
```

---

### fetchSingle

Fetch a single row from another resource.

**Syntax:**
```lua
exports['ingenium']:fetchSingle(query, params, callback)
```

**Example:**
```lua
local user = exports['ingenium']:fetchSingle("SELECT * FROM users WHERE License_ID = ?", {licenseId})
```

---

### insert

Execute INSERT from another resource.

**Syntax:**
```lua
exports['ingenium']:insert(query, params, callback)
```

**Example:**
```lua
local insertId = exports['ingenium']:insert("INSERT INTO logs (message, timestamp) VALUES (?, ?)", {message, timestamp})
```

---

### update

Execute UPDATE/DELETE from another resource.

**Syntax:**
```lua
exports['ingenium']:update(query, params, callback)
```

**Example:**
```lua
local affected = exports['ingenium']:update("UPDATE characters SET Active = FALSE", {})
```

---

### transaction

Execute transaction from another resource.

**Syntax:**
```lua
exports['ingenium']:transaction(queries, callback)
```

**Example:**
```lua
exports['ingenium']:transaction({
    {query = "UPDATE accounts SET balance = balance - ?", parameters = {100}},
    {query = "INSERT INTO transactions VALUES (?)", parameters = {data}}
}, function(success, results)
    print("Transaction " .. (success and "succeeded" or "failed"))
end)
```

---

### isReady

Check if database is ready from another resource.

**Syntax:**
```lua
exports['ingenium']:isReady()
```

**Returns:**
- `boolean` - Connection status

**Example:**
```lua
if exports['ingenium']:isReady() then
    print("Database is ready")
end
```

---

### getStats

Get performance statistics from another resource.

**Syntax:**
```lua
exports['ingenium']:getStats()
```

**Returns:**
- `table` - Performance statistics

**Example:**
```lua
local stats = exports['ingenium']:getStats()
print("Total queries: " .. stats.totalQueries)
print("Average time: " .. string.format("%.2fms", stats.averageTime))
```

---

## Console Commands

### sqlstats

Display current SQL performance statistics in the console.

**Usage:**
```
sqlstats
```

**Output:**
```
=== SQL Performance Statistics ===
Total Queries: 1523
Slow Queries: 12 (0.79%)
Failed Queries: 2 (0.13%)
Average Query Time: 29.71ms
Total Time: 45234.56ms

Connection: localhost:3306/fivem
Pool Size: 10 connections
Status: Ready
```

---

## Usage Examples

### Monitor All Queries

```lua
-- Log all queries for debugging
AddEventHandler('ig:sql:queryExecuted', function(data)
    local logFile = io.open("queries.log", "a")
    logFile:write(string.format("[%s] %s (%dms) - %s\n", 
        os.date("%Y-%m-%d %H:%M:%S"),
        data.success and "SUCCESS" or "FAILED",
        data.duration,
        data.query
    ))
    logFile:close()
end)
```

### Alert on Slow Queries

```lua
-- Send Discord webhook for slow queries
AddEventHandler('ig:sql:slowQuery', function(data)
    PerformHttpRequest('https://discord.com/api/webhooks/...', function(err, text, headers)
    end, 'POST', json.encode({
        content = string.format("**Slow Query Alert**\nDuration: %.2fms\nQuery: `%s`", 
            data.duration, 
            data.query:sub(1, 100)
        )
    }), {['Content-Type'] = 'application/json'})
end)
```

### Wait for Database on Resource Start

```lua
Citizen.CreateThread(function()
    print("Waiting for database...")
    
    if ig.sql.AwaitReady(30000) then
        print("Database ready - loading data")
        -- Load your resource data
        local data = ig.sql.Query("SELECT * FROM my_table", {})
    else
        print("ERROR: Database connection timeout!")
    end
end)
```

### Cross-Resource Query

```lua
-- In another resource that depends on ig.core
RegisterCommand('checkplayer', function(source, args)
    local license = args[1]
    
    -- Use export to query ig.core database
    local user = exports['ingenium']:fetchSingle(
        "SELECT * FROM users WHERE License_ID = ?",
        {license}
    )
    
    if user then
        print("User found: " .. user.Username)
    else
        print("User not found")
    end
end, true)
```

### Performance Monitoring

```lua
-- Check performance every 5 minutes
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- 5 minutes
        
        local stats = ig.sql.GetStats()
        
        if stats.averageTime > 50 then
            print(string.format("^3[WARNING] High average query time: %.2fms^7", stats.averageTime))
        end
        
        if stats.slowQueries > 100 then
            print(string.format("^3[WARNING] %d slow queries detected^7", stats.slowQueries))
        end
        
        if stats.failedQueries > 0 then
            print(string.format("^1[ERROR] %d failed queries^7", stats.failedQueries))
        end
    end
end)
```

---

**Related Documentation:**
- [SQL Architecture](./SQL_Architecture.md)
- [SQL API Reference](./SQL_API_Reference.md)
- [SQL Performance](./SQL_Performance.md)
