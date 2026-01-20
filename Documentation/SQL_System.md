# SQL Database System

## Overview

Ingenium uses an integrated **MySQL2 database layer** with built-in connection pooling, prepared statements, and performance monitoring. The system is server-authoritative with dirty flag optimization.

## Architecture

### MySQL2 Backend

The database layer consists of:
- **JavaScript MySQL2** resource (`server/[SQL]/_pool.js`, `_query.js`)
- **Lua wrapper** (`server/[SQL]/_handler.lua`)
- **Query exports** exposed to the main resource

```lua
-- Lua calls JS resource via exports
exports['ingenium.sql']:query(query, params, cb)
exports['ingenium.sql']:fetchSingle(query, params, cb)
exports['ingenium.sql']:insert(query, params, cb)
```

### Configuration

Set in `server.cfg`:

```bash
# Option 1: Connection string
set mysql_connection_string "mysql://user:password@host:port/database"

# Option 2: Individual parameters
set mysql_host "localhost"
set mysql_port "3306"
set mysql_user "root"
set mysql_password "password"
set mysql_database "fivem"
set mysql_connection_limit "10"
```

## Query API

### Basic Queries

#### Query - Multiple Results

```lua
ig.sql.Query(sql, params, callback)
```

Returns array of rows:

```lua
ig.sql.Query("SELECT * FROM characters WHERE Job = ?", {'police'}, function(results)
    for _, char in ipairs(results) do
        print(char.Full_Name)
    end
end)
```

#### FetchSingle - Single Row

```lua
ig.sql.FetchSingle(sql, params, callback)
```

Returns single row object:

```lua
local char = ig.sql.FetchSingle(
    "SELECT * FROM characters WHERE Character_ID = ?",
    {charId}
)
print(char.Full_Name)
```

#### FetchScalar - Single Value

```lua
ig.sql.FetchScalar(sql, params, callback)
```

Returns single value:

```lua
local count = ig.sql.FetchScalar(
    "SELECT COUNT(*) FROM characters WHERE Job = ?",
    {'police'}
)
```

### Modification Queries

#### Insert

```lua
ig.sql.Insert(sql, params, callback)
```

Returns `insertId`:

```lua
ig.sql.Insert(
    "INSERT INTO characters (Full_Name, Gender) VALUES (?, ?)",
    {'John Doe', 'Male'},
    function(insertId)
        print('New character ID:', insertId)
    end
)
```

#### Update

```lua
ig.sql.Update(sql, params, callback)
```

Returns affected row count:

```lua
ig.sql.Update(
    "UPDATE characters SET Cash = ? WHERE Character_ID = ?",
    {1000, charId},
    function(affectedRows)
        print('Updated rows:', affectedRows)
    end
)
```

### Advanced Operations

#### Transaction - Atomic Operations

```lua
ig.sql.Transaction(queries, callback)
```

All queries succeed or all fail:

```lua
local queries = {
    {query = "UPDATE banking_accounts SET Balance = Balance - ? WHERE Account_Number = ?", params = {100, fromAccount}},
    {query = "UPDATE banking_accounts SET Balance = Balance + ? WHERE Account_Number = ?", params = {100, toAccount}},
    {query = "INSERT INTO transactions VALUES (?, ?, ?)", params = {fromAccount, toAccount, 100}}
}

ig.sql.Transaction(queries, function(success, results)
    if success then
        print('Transfer completed')
    else
        print('Transfer failed, rolled back')
    end
end)
```

#### Batch - Multiple Queries

```lua
ig.sql.Batch(queries, callback)
```

Executes multiple queries (non-atomic):

```lua
local queries = {
    {query = "UPDATE characters SET Hunger = ?", params = {50}},
    {query = "UPDATE characters SET Thirst = ?", params = {50}}
}

ig.sql.Batch(queries, function(results)
    print('Batch completed')
end)
```

#### Prepared Statements

```lua
-- Prepare once
ig.sql.PrepareQuery(sql, callback)

-- Execute many times
ig.sql.ExecutePrepared(queryId, params, callback)
```

Pre-compiled for performance:

```lua
-- Server startup
ig.sql.PrepareQuery(
    "UPDATE characters SET Cash = ?, Bank = ? WHERE Character_ID = ?",
    function(queryId)
        PlayerSaveData = queryId
    end
)

-- Later use
ig.sql.ExecutePrepared(PlayerSaveData, {cash, bank, charId})
```

## Dirty Flag Save System

### Save Configuration

Save intervals configured in `_config/config.lua`:

```lua
conf.serversync     = 90000   -- Players: 90 seconds
conf.vehiclesync    = 300000  -- Vehicles: 5 minutes
conf.jobsync        = 600000  -- Jobs: 10 minutes
conf.objectsync     = 300000  -- Objects: 5 minutes
```

### Consolidated Save Loop

Single-threaded scheduler runs at smallest interval:

```lua
function ConsolidatedSaveLoop()
    if ig.player.ArePlayersActive() ~= nil then
        local currentTime = os.clock()
        
        -- Check each save type's timer
        if (currentTime - lastRun.users) >= (conf.serversync / 1000) then
            ig.sql.save.Users()  -- Save all dirty players
            lastRun.users = currentTime
        end
        
        if (currentTime - lastRun.vehicles) >= (conf.vehiclesync / 1000) then
            ig.sql.save.Vehicles()  -- Save all dirty vehicles
            lastRun.vehicles = currentTime
        end
        
        -- Jobs, Objects...
    end
    
    SetTimeout(conf.serversync, ConsolidatedSaveLoop)
end
```

**Benefits:**
- Reduces threads from 4 to 1
- Timer-based scheduling prevents drift
- Only saves entities marked dirty

### Save Functions

#### Individual Entity Saves

```lua
-- Single character
ig.sql.save.User(xPlayer, callback)

-- Single vehicle
ig.sql.save.Vehicle(xVehicle, callback)

-- Single object
ig.sql.save.Object(xObject, callback)
```

#### Bulk Saves

```lua
-- All online players
ig.sql.save.Users(callback)

-- All active vehicles
ig.sql.save.Vehicles(callback)

-- All jobs (to JSON)
ig.sql.save.Jobs(callback)

-- All objects
ig.sql.save.Objects(callback)
```

### Dirty Flag Pattern

```lua
-- Entity modification
xPlayer.SetCash(1000)  -- Automatically sets IsDirty = true

-- Save check
if xPlayer.GetIsDirty() then
    ig.sql.save.User(xPlayer)
    xPlayer.ClearDirty()
end
```

## Prepared Queries

Three main prepared statements for performance:

| Query ID | Purpose | Frequency |
|----------|---------|-----------|
| `PlayerSaveData` | UPDATE characters | Every 90s |
| `VehicleSaveData` | UPDATE vehicles | Every 5min |
| `ObjectSaveData` | UPDATE objects | Every 5min |

**Initialization:**

```lua
-- Wait for prepared queries
ig.sql.save.AwaitPreparedQueries(timeout, callback)

-- Check status
local ready = ig.sql.save.ArePreparedQueriesReady()
```

## Character Data Management

### Character Lifecycle

```lua
-- Create new character
ig.sql.character.Create(data, callback)

-- Fetch character data
ig.sql.character.Fetch(Character_ID, callback)

-- Update character
ig.sql.character.Update(Character_ID, fields, callback)

-- Delete character
ig.sql.character.Delete(Character_ID, callback)
```

### User Management

```lua
-- Get user by license
ig.sql.users.GetUser(License_ID, callback)

-- Create user account
ig.sql.users.CreateUser(data, callback)

-- Update locale
ig.sql.users.UpdateLocale(License_ID, locale, callback)
```

## Vehicle Persistence

### Vehicle Data

```lua
-- Load persistent vehicles
ig.vehicle.LoadPersistentVehicles(callback)

-- Register vehicle
ig.vehicle.RegisterPersistent(vehicleData)

-- Update location
ig.vehicle.UpdateVehicleLocation(plate, coords)

-- Update state
ig.vehicle.UpdateVehicleState(plate, stateData)

-- Save all vehicles
ig.vehicle.SavePersistentVehicles(callback)
```

### Spawn Persistent Vehicles

```lua
-- Restore vehicles on startup
ig.vehicle.InitializePersistence()

-- Restore single vehicle
ig.vehicle.RestorePersistentVehicle(vehicleData, callback)
```

## Banking System

### Banking Accounts

```lua
-- Get account
ig.sql.banking.GetAccount(Account_Number, callback)

-- Create account
ig.sql.banking.CreateAccount(Character_ID, callback)

-- Update balance
ig.sql.banking.UpdateBalance(Account_Number, amount, callback)

-- Get transactions
ig.sql.banking.GetTransactions(Account_Number, limit, callback)

-- Add favorite
ig.sql.banking.AddFavorite(Account_Number, Target_Account, callback)
```

### Loan System

```lua
-- Calculate interest
ig.bank.CalculateInterest()

-- Calculate payments
ig.bank.CalculatePayments()

-- Check overdrafts
ig.bank.CheckNegativeBalances()
```

## Job System

### Job Accounts

```lua
-- Get job account
ig.sql.jobs.GetAccount(Job_Name, callback)

-- Update balance
ig.sql.jobs.UpdateBalance(Job_Name, amount, callback)

-- Process payroll
ig.job.ProcessPayroll(Job_Name, callback)

-- Calculate payroll
ig.job.CalculatePayroll(Job_Name, callback)
```

## Performance Monitoring

### Statistics

```lua
-- Get performance stats
local stats = ig.sql.GetStats()
```

Returns:
- Total queries executed
- Average query time
- Slow query count
- Connection pool status

### Slow Query Detection

```lua
AddEventHandler('ingenium.sql:SlowQuery', function(data)
    ig.log.Warn("SQL", "Slow query: %.2fms", data.duration)
    ig.log.Debug("SQL", "Query: %s", data.query)
end)
```

Automatically logs queries over threshold.

### Save Performance

```lua
-- Timing is automatic in save functions
local startTime = os.clock()
-- ... save operation ...
local elapsed = (os.clock() - startTime) * 1000

if elapsed > 100 then
    ig.log.Warn("SQL", "Save took %.2fms", elapsed)
end
```

## Connection Management

### Ready Check

```lua
-- Wait for SQL connection
local ready = ig.sql.AwaitReady(timeoutMs)

-- Check status
if ig.sql.IsReady() then
    -- Database is ready
end
```

Uses exponential backoff:
- Starts at 50ms intervals
- Doubles each check
- Caps at 500ms
- Non-blocking with SetTimeout chains

### Startup Sequence

```lua
1. Server starts
2. Wait for SQL connection (40s timeout)
3. Load JSON static data
4. Initialize prepared queries
5. Load job/vehicle data
6. Begin ConsolidatedSaveLoop
```

## Parameter Handling

### Type Conversion

- **Booleans** → integers (true=1, false=0)
- **Numbers** → validated ranges
- **Strings** → sanitized for SQL injection
- **Tables** → rejected (must encode as JSON first)

### Parameter Formats

**Positional (`?` placeholders):**
```lua
ig.sql.Query("SELECT * FROM characters WHERE Job = ?", {'police'})
```

**Named (`@name` placeholders):**
```lua
ig.sql.Query("SELECT * FROM characters WHERE Job = @job", {job = 'police'})
```

## Error Handling

### Query Errors

```lua
ig.sql.Query(sql, params, function(results, err)
    if err then
        ig.log.Error("SQL", "Query failed: %s", err)
        return
    end
    -- Process results
end)
```

### Transaction Rollback

```lua
ig.sql.Transaction(queries, function(success, results)
    if not success then
        ig.log.Error("SQL", "Transaction failed, rolled back")
        -- Handle failure
    end
end)
```

## Best Practices

1. **Use prepared statements** for frequently executed queries
2. **Batch related updates** with transactions
3. **Mark entities dirty** only when data changes
4. **Avoid blocking calls** - use callbacks or promises
5. **Monitor slow queries** via performance events
6. **Validate input** before passing to SQL
7. **Use appropriate query type** (Query vs FetchSingle vs FetchScalar)
8. **Handle errors** in all callbacks
9. **Wait for ready** before executing queries at startup
10. **Clean up** - remove unused prepared statements

## Related Documentation

- [Class System](Class_System.md) - Entity dirty flags
- [Data Persistence](Data_Persistence.md) - Hybrid DB+JSON model
- [Validation System](Validation_System.md) - Input validation
