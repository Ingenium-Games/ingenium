# SQL Architecture

## Overview

The ingenium SQL system is a fully integrated MySQL2-based database layer that replaces the external `mysql-async` dependency. It provides high-performance query execution, connection pooling, transaction support, and comprehensive performance monitoring.

## Architecture Components

### 1. Connection Pool (`server/[SQL]/_pool.js`)

The connection pool manages MySQL2 connections using a robust pooling strategy:

**Features:**
- Configurable connection limits (default: 10 connections)
- Automatic connection keep-alive
- Connection health monitoring
- Graceful shutdown handling
- Timezone normalization (UTC)
- BigInt and date string handling

**Configuration (server.cfg):**
```bash
# Full connection string (recommended)
set mysql_connection_string "mysql://user:password@host:port/database"

# Or individual parameters
set mysql_host "localhost"
set mysql_port "3306"  
set mysql_user "root"
set mysql_password "password"
set mysql_database "fivem"
set mysql_connection_limit "10"
set mysql_charset "utf8mb4"
```

**Key Responsibilities:**
- Initialize and maintain connection pool
- Provide connections for query execution
- Track performance statistics
- Emit lifecycle events (`ig:sql:ready`)

### 2. Query Executor (`server/[SQL]/_query.js`)

Handles all query execution with intelligent parameter conversion:

**Features:**
- Named parameter conversion (`@param` → `?`)
- Positional parameter support
- Type-safe result formatting
- Error handling and logging
- Prepared statement management

**Query Types Supported:**
- `query()` - SELECT queries returning multiple rows
- `fetchSingle()` - SELECT returning single row
- `fetchScalar()` - SELECT returning single value
- `insert()` - INSERT operations with insertId
- `update()` - UPDATE/DELETE with affectedRows
- `prepareQuery()` - Prepare statements for reuse
- `executePrepared()` - Execute prepared statements

### 3. Transaction Manager (`server/[SQL]/_transaction.js`)

Provides ACID-compliant transaction support:

**Features:**
- Automatic BEGIN/COMMIT/ROLLBACK
- Multi-query atomic execution
- Error rollback with logging
- Batch execution (non-transactional)

**Transaction Patterns:**
```lua
-- Atomic transaction
ig.sql.Transaction({
    {query = "UPDATE accounts SET balance = balance - ?", parameters = {100, accountId}},
    {query = "INSERT INTO transactions VALUES (?, ?, ?)", parameters = {accountId, 100, timestamp}}
}, function(success, results)
    if success then
        print("Transaction committed")
    else
        print("Transaction rolled back")
    end
end)
```

### 4. Lua Wrapper (`server/[SQL]/_handler.lua`)

Provides clean Lua interface to JavaScript query engine:

**Key Functions:**
- `ig.sql.Query(query, params, callback)` - SELECT all
- `ig.sql.FetchScalar(query, params, callback)` - Single value
- `ig.sql.FetchSingle(query, params, callback)` - Single row
- `ig.sql.Insert(query, params, callback)` - INSERT
- `ig.sql.Update(query, params, callback)` - UPDATE/DELETE
- `ig.sql.Transaction(queries, callback)` - Transactions
- `ig.sql.PrepareQuery(query)` - Prepare statement
- `ig.sql.ExecutePrepared(id, params, callback)` - Execute prepared
- `ig.sql.IsReady()` - Connection status
- `ig.sql.AwaitReady(timeout)` - Wait for connection
- `ig.sql.GetStats()` - Performance metrics

### 5. Compatibility Layer (`server/[SQL]/_compatibility.lua`)

Maintains backward compatibility with mysql-async:

**Supported Legacy APIs:**
- `MySQL.Async.fetchAll()`
- `MySQL.Async.fetchScalar()`
- `MySQL.Async.execute()`
- `MySQL.Async.insert()`
- `MySQL.Async.store()`
- `MySQL.Async.transaction()`
- `MySQL.Sync.*` equivalents

**Migration Strategy:**
The compatibility layer allows gradual migration:
1. Existing code continues working unchanged
2. New code uses `ig.sql.*` API
3. Deprecated calls can be tracked with warnings
4. Full removal in future major version

## Performance Monitoring

### Query Profiling

Every query is automatically profiled:
- Execution time tracking (milliseconds)
- Slow query detection (>150ms)
- Query success/failure logging
- Performance statistics aggregation

### Events

```lua
-- Emitted on every query
AddEventHandler('ig:sql:queryExecuted', function(data)
    -- data = {query, duration, success, error?}
end)

-- Emitted for slow queries
AddEventHandler('ig:sql:slowQuery', function(data)
    -- data = {query, duration, parameters}
end)

-- Connection ready
AddEventHandler('ig:sql:ready', function()
    -- Database connection established
end)
```

### Statistics

```lua
local stats = ig.sql.GetStats()
--[[
{
    totalQueries = 1523,
    slowQueries = 12,
    failedQueries = 2,
    totalTime = 45234.56,  -- milliseconds
    averageTime = 29.71,   -- milliseconds
    isReady = true,
    config = {
        host = "localhost",
        port = 3306,
        database = "fivem",
        connectionLimit = 10
    }
}
]]
```

### Console Commands

```
sqlstats - Display current SQL performance statistics
```

## Prepared Statements

Optimized for high-frequency operations like save systems:

```lua
-- One-time preparation (at resource start)
local SaveQuery = -1
ig.sql.PrepareQuery(
    "UPDATE characters SET health = ?, coords = ? WHERE id = ?",
    function(queryId)
        SaveQuery = queryId
    end)

-- Repeated execution (in save loop)
ig.sql.ExecutePrepared(SaveQuery, {health, coords, characterId}, function(affected)
    print("Saved character")
end)
```

**Benefits:**
- Reduced query parsing overhead
- Better performance for batch operations
- Parameter type inference
- Protection against SQL injection

## Security Features

### SQL Injection Prevention
- Parameterized queries only
- Automatic parameter escaping
- No string concatenation in queries
- Named and positional parameter support

### Connection Security
- Connection string encryption support
- Configurable charset (UTF8MB4 default)
- Timezone normalization
- BigNumber handling for precision

### Error Handling
- Detailed error logging
- Query context in errors
- Automatic transaction rollback
- Connection recovery

## Migration from mysql-async

### Key Differences

| mysql-async | ingenium SQL |
|-------------|-------------|
| `MySQL.Async.fetchAll()` | `ig.sql.Query()` |
| `MySQL.Async.fetchScalar()` | `ig.sql.FetchScalar()` |
| `MySQL.Async.execute()` | `ig.sql.Update()` or `ig.sql.Insert()` |
| `MySQL.Async.insert()` | `ig.sql.Insert()` |
| `MySQL.Async.store()` | `ig.sql.PrepareQuery()` |
| `@paramName` | `?` (or use compatibility) |

### Gradual Migration

1. **Immediate**: Compatibility layer handles all existing code
2. **Recommended**: Migrate high-frequency operations first
3. **Optional**: Migrate remaining calls over time
4. **Future**: Remove compatibility layer in major version

## Best Practices

### Query Optimization
1. Use prepared statements for repeated queries
2. Minimize SELECT * usage
3. Use appropriate indexes
4. Limit result sets with WHERE clauses
5. Monitor slow query events

### Connection Management
1. Don't manually manage connections
2. Let the pool handle connection lifecycle
3. Configure appropriate pool size for load
4. Monitor connection statistics

### Error Handling
1. Always provide callbacks for critical operations
2. Check `ig.sql.IsReady()` before critical queries
3. Use transactions for related updates
4. Log errors appropriately

### Performance
1. Use `ig.sql.Batch()` for non-critical bulk updates
2. Leverage prepared statements for saves
3. Monitor `ig.sql.GetStats()` regularly
4. Optimize queries based on slow query logs

## Troubleshooting

### Connection Issues

**Problem**: "Connection pool is not initialized"
- **Solution**: Wait for `ig:sql:ready` event or use `ig.sql.AwaitReady()`

**Problem**: Too many connections
- **Solution**: Increase `mysql_connection_limit` or optimize query patterns

### Performance Issues

**Problem**: Slow queries
- **Solution**: Check `ig:sql:slowQuery` events, add indexes, optimize WHERE clauses

**Problem**: High total queries
- **Solution**: Use prepared statements for repeated operations

### Migration Issues

**Problem**: Named parameters not working
- **Solution**: Compatibility layer should handle this automatically. Check parameter format.

**Problem**: Callback timing differences
- **Solution**: New system executes synchronously by default. Wrap in `Citizen.CreateThread` if needed.

## Future Enhancements

- Query result caching
- Read replica support
- Connection pooling per-resource
- Advanced query builders
- Schema migration tools
- Automated backup integration

---

**Related Documentation:**
- [SQL API Reference](./SQL_API_Reference.md)
- [SQL Migration Guide](./SQL_Migration_Guide.md)
- [SQL Performance](./SQL_Performance.md)
- [SQL Compatibility](./SQL_Compatibility.md)
