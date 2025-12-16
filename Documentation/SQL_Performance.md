# SQL Performance Optimization

Guide to optimizing SQL performance in ig.core.

## Connection Pooling

### Configuration

Optimize pool size based on your server load:

```bash
# Light load (< 32 players)
set mysql_connection_limit "5"

# Medium load (32-64 players)
set mysql_connection_limit "10"

# Heavy load (64+ players)
set mysql_connection_limit "15"

# Very heavy load (128+ players)
set mysql_connection_limit "20"
```

**Note**: More connections aren't always better. Monitor with `c.sql.GetStats()`.

## Query Optimization

### 1. Use Prepared Statements

For repeated queries (saves, updates):

```lua
-- BAD: Repeated parsing
for i = 1, 100 do
    c.sql.Update("UPDATE chars SET data = ? WHERE id = ?", {data, i})
end

-- GOOD: Parse once, execute many
local query = c.sql.PrepareQuery("UPDATE chars SET data = ? WHERE id = ?")
for i = 1, 100 do
    c.sql.ExecutePrepared(query, {data, i})
end
```

**Performance**: ~50% faster for batch operations

### 2. Limit Result Sets

```lua
-- BAD: Return all rows
local chars = c.sql.Query("SELECT * FROM characters", {})

-- GOOD: Limit what you need
local chars = c.sql.Query("SELECT * FROM characters WHERE active = TRUE LIMIT 100", {})
```

### 3. Use Specific Columns

```lua
-- BAD: Select everything
local names = c.sql.Query("SELECT * FROM characters", {})

-- GOOD: Select only needed columns
local names = c.sql.Query("SELECT first_name, last_name FROM characters", {})
```

**Performance**: Reduces data transfer and memory usage

### 4. Index Your Tables

Ensure proper indexes on frequently queried columns:

```sql
-- Add index on character lookups
CREATE INDEX idx_primary_id ON characters(Primary_ID);
CREATE INDEX idx_license ON users(License_ID);
CREATE INDEX idx_plate ON vehicles(Plate);

-- Composite indexes for multi-column queries
CREATE INDEX idx_char_active ON characters(Primary_ID, Active);
```

### 5. Use WHERE Clauses

```lua
-- BAD: Filter in Lua
local allChars = c.sql.Query("SELECT * FROM characters", {})
local filtered = {}
for _, char in ipairs(allChars) do
    if char.Active then
        table.insert(filtered, char)
    end
end

-- GOOD: Filter in SQL
local filtered = c.sql.Query("SELECT * FROM characters WHERE Active = TRUE", {})
```

## Transaction Optimization

### When to Use Transactions

Use transactions for:
- ✅ Related updates that must succeed together
- ✅ Financial operations (transfers, purchases)
- ✅ Multi-table updates with dependencies

Don't use transactions for:
- ❌ Single, independent updates
- ❌ Read-only operations
- ❌ Non-critical batch updates

### Batch vs Transaction

```lua
-- Use Transaction for atomic operations
c.sql.Transaction({
    {query = "UPDATE accounts SET balance = balance - ?", parameters = {100}},
    {query = "UPDATE accounts SET balance = balance + ?", parameters = {100}}
}) -- Both succeed or both fail

-- Use Batch for independent operations
c.sql.Batch({
    {query = "UPDATE chars SET last_seen = ? WHERE id = ?", parameters = {time, id1}},
    {query = "UPDATE chars SET last_seen = ? WHERE id = ?", parameters = {time, id2}}
}) -- Each can fail independently
```

## Save System Optimization

### Dirty Flag System

The save system uses dirty flags to only save changed data:

```lua
-- xPlayer object tracks changes
xPlayer.SetHealth(100)  -- Marks as dirty
xPlayer.SetArmour(50)   -- Still dirty

-- Save only saves if dirty
c.sql.save.User(xPlayer) -- Saves and clears dirty flag
c.sql.save.User(xPlayer) -- Skipped - not dirty
```

**Performance**: 60-80% reduction in save operations

### Save Intervals

Configure save intervals based on your needs:

```lua
-- Critical data: Every 30 seconds
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000)
        c.sql.save.Users()
    end
end)

-- Non-critical data: Every 5 minutes
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        c.sql.save.Objects()
    end
end)
```

### Batch Saves

```lua
-- BAD: Save one at a time
for _, player in pairs(GetPlayers()) do
    local xPlayer = c.data.GetPlayer(player)
    c.sql.save.User(xPlayer)
end

-- GOOD: Use bulk save function
c.sql.save.Users() -- Batches all dirty players
```

## Query Profiling

### Monitor Slow Queries

```lua
AddEventHandler('ig:sql:slowQuery', function(data)
    -- Log to file
    local file = io.open("slow_queries.log", "a")
    file:write(string.format("[%s] %.2fms - %s\n", 
        os.date("%Y-%m-%d %H:%M:%S"),
        data.duration,
        data.query
    ))
    file:close()
    
    -- Alert admins
    for _, playerId in ipairs(GetPlayers()) do
        if IsPlayerAceAllowed(playerId, "admin") then
            TriggerClientEvent('chat:addMessage', playerId, {
                color = {255, 165, 0},
                args = {"[SQL]", string.format("Slow query: %.2fms", data.duration)}
            })
        end
    end
end)
```

### Performance Thresholds

```lua
-- Get stats periodically
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000) -- 5 minutes
        
        local stats = c.sql.GetStats()
        
        -- Warning thresholds
        if stats.averageTime > 50 then
            print("^3[WARNING] Average query time high: " .. stats.averageTime .. "ms^7")
        end
        
        if stats.slowQueries > (stats.totalQueries * 0.05) then -- > 5%
            print("^3[WARNING] High slow query rate: " .. stats.slowQueries .. "^7")
        end
        
        if stats.failedQueries > 0 then
            print("^1[ERROR] Failed queries detected: " .. stats.failedQueries .. "^7")
        end
    end
end)
```

## Performance Targets

### Query Time Targets

| Type | Good | Warning | Critical |
|------|------|---------|----------|
| Simple SELECT | < 20ms | < 50ms | > 100ms |
| JOIN query | < 50ms | < 100ms | > 150ms |
| INSERT | < 10ms | < 30ms | > 50ms |
| UPDATE | < 15ms | < 40ms | > 75ms |
| Transaction | < 80ms | < 120ms | > 200ms |

### Color-Coded Logging

```lua
local function LogQuery(query, duration)
    local color
    if duration < 50 then
        color = "^2" -- Green
    elseif duration < 100 then
        color = "^3" -- Yellow
    else
        color = "^1" -- Red
    end
    print(string.format("%s[SQL] %.2fms - %s^7", color, duration, query:sub(1, 50)))
end
```

## Best Practices

### 1. Avoid N+1 Queries

```lua
-- BAD: N+1 query pattern
local users = c.sql.Query("SELECT * FROM users", {})
for _, user in ipairs(users) do
    local chars = c.sql.Query("SELECT * FROM characters WHERE user_id = ?", {user.id})
    -- Process chars
end

-- GOOD: Single JOIN query
local data = c.sql.Query([[
    SELECT u.*, c.* 
    FROM users u 
    LEFT JOIN characters c ON u.id = c.user_id
]], {})
```

### 2. Cache Frequently Accessed Data

```lua
-- Cache static data at resource start
local ItemList = {}
Citizen.CreateThread(function()
    if c.sql.AwaitReady() then
        ItemList = c.sql.Query("SELECT * FROM items", {})
    end
end)

-- Use cache instead of querying
function GetItem(itemId)
    for _, item in ipairs(ItemList) do
        if item.id == itemId then
            return item
        end
    end
    return nil
end
```

### 3. Optimize WHERE Clauses

```lua
-- Use indexed columns in WHERE
c.sql.Query("SELECT * FROM characters WHERE Primary_ID = ?", {primaryId}) -- INDEXED

-- Avoid functions in WHERE (prevents index use)
-- BAD
c.sql.Query("SELECT * FROM characters WHERE LOWER(First_Name) = ?", {name:lower()})
-- GOOD
c.sql.Query("SELECT * FROM characters WHERE First_Name = ?", {name})
```

### 4. Use LIMIT

```lua
-- Always use LIMIT for single-row queries
c.sql.FetchSingle("SELECT * FROM users WHERE license = ? LIMIT 1", {license})

-- Paginate large result sets
local page = 1
local perPage = 50
local offset = (page - 1) * perPage
c.sql.Query("SELECT * FROM characters LIMIT ? OFFSET ?", {perPage, offset})
```

### 5. Async for UI, Sync for Logic

```lua
-- UI operations: Use callbacks (async)
c.sql.Query("SELECT * FROM characters", {}, function(characters)
    TriggerClientEvent('showCharacterMenu', source, characters)
end)

-- Game logic: Use sync (simpler code)
local balance = c.sql.FetchScalar("SELECT bank FROM accounts WHERE id = ?", {accountId})
if balance >= price then
    -- Proceed with purchase
end
```

## Monitoring Dashboard

Create a performance monitoring command:

```lua
RegisterCommand('sqlperf', function(source)
    local stats = c.sql.GetStats()
    
    local report = string.format([[
=== SQL Performance Report ===
Total Queries: %d
Slow Queries: %d (%.2f%%)
Failed Queries: %d (%.2f%%)
Average Query Time: %.2fms
Total Execution Time: %.2fs

Connection Status: %s
Database: %s:%d/%s
Pool Size: %d connections

Thresholds:
  Good: < 50ms
  Warning: 50-100ms
  Critical: > 100ms
============================
    ]],
        stats.totalQueries,
        stats.slowQueries,
        (stats.slowQueries / stats.totalQueries) * 100,
        stats.failedQueries,
        (stats.failedQueries / stats.totalQueries) * 100,
        stats.averageTime,
        stats.totalTime / 1000,
        stats.isReady and "Ready" or "Not Ready",
        stats.config.host,
        stats.config.port,
        stats.config.database,
        stats.config.connectionLimit
    )
    
    print(report)
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"[SQL]", "Check server console for performance report"}
        })
    end
end, true)
```

## Troubleshooting Performance

### High Average Query Time

1. Check slow query log
2. Review table indexes
3. Optimize query WHERE clauses
4. Consider caching frequently accessed data

### High Slow Query Count

1. Identify problematic queries with `ig:sql:slowQuery` event
2. Add missing indexes
3. Reduce result set sizes with LIMIT
4. Split complex JOINs into simpler queries

### Connection Timeouts

1. Increase `mysql_connection_limit`
2. Reduce query frequency
3. Use prepared statements
4. Batch operations together

---

**Related Documentation:**
- [SQL Architecture](./SQL_Architecture.md)
- [SQL API Reference](./SQL_API_Reference.md)
- [SQL Events & Exports](./SQL_Events_Exports.md)
