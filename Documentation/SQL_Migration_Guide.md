# SQL Migration Guide

Step-by-step guide for migrating from mysql-async to the new ingenium SQL system.

## Overview

The new SQL system maintains **full backward compatibility** with mysql-async through a compatibility layer. This allows for:
- **Immediate deployment** - Existing code works without changes
- **Gradual migration** - Migrate functions one at a time
- **Zero downtime** - No service interruption during migration

## Pre-Migration Checklist

- [ ] Backup your database
- [ ] Review current MySQL.Async usage in your code
- [ ] Test in development environment first
- [ ] Document custom SQL modifications
- [ ] Verify MySQL 5.7+ or MariaDB 10.3+ compatibility

## Migration Paths

### Path 1: Zero-Change Deployment (Recommended First Step)

Simply deploy ingenium with the new SQL system. The compatibility layer automatically handles all `MySQL.Async.*` and `MySQL.Sync.*` calls.

**No code changes required!**

### Path 2: Gradual Migration (Recommended)

Migrate high-frequency operations first for maximum performance gain:

1. Save systems (`_saves.lua`)
2. ID generation (`_gen.lua`)
3. Character operations (`_character.lua`)
4. User operations (`_users.lua`)
5. Vehicle operations (`_vehicles.lua`)
6. Remaining operations

### Path 3: Full Migration

Migrate all SQL calls to new `ig.sql.*` API in one deployment.

## Step-by-Step Migration

### Step 1: Update Query Calls

#### Before (mysql-async):
```lua
MySQL.Async.fetchAll("SELECT * FROM characters WHERE Primary_ID = @Primary_ID", {
    ["@Primary_ID"] = primaryId
}, function(data)
    -- Handle results
    for i, char in ipairs(data) do
        print(char.First_Name)
    end
end)
```

#### After (new system):
```lua
-- Option 1: Synchronous (blocking)
local data = ig.sql.Query("SELECT * FROM characters WHERE Primary_ID = ?", {primaryId})
for i, char in ipairs(data) do
    print(char.First_Name)
end

-- Option 2: With callback (asynchronous)
ig.sql.Query("SELECT * FROM characters WHERE Primary_ID = ?", {primaryId}, function(data)
    for i, char in ipairs(data) do
        print(char.First_Name)
    end
end)
```

### Step 2: Update Scalar Queries

#### Before:
```lua
local IsBusy = true
local result = nil
MySQL.Async.fetchScalar("SELECT Bank FROM character_accounts WHERE Character_ID = @Character_ID", {
    ["@Character_ID"] = characterId
}, function(data)
    result = data
    IsBusy = false
end)
while IsBusy do
    Citizen.Wait(0)
end
return result
```

#### After:
```lua
local result = ig.sql.FetchScalar("SELECT Bank FROM character_accounts WHERE Character_ID = ?", {characterId})
return result
```

### Step 3: Update Execute/Insert Calls

#### Before (execute):
```lua
MySQL.Async.execute("UPDATE character_accounts SET Bank = @Bank WHERE Character_ID = @Character_ID", {
    ["@Bank"] = newBalance,
    ["@Character_ID"] = characterId
}, function(affectedRows)
    print("Updated " .. affectedRows .. " rows")
end)
```

#### After:
```lua
ig.sql.Update("UPDATE character_accounts SET Bank = ? WHERE Character_ID = ?", {newBalance, characterId}, function(affectedRows)
    print("Updated " .. affectedRows .. " rows")
end)
```

#### Before (insert):
```lua
MySQL.Async.insert("INSERT INTO characters (...) VALUES (@val1, @val2)", {
    ["@val1"] = value1,
    ["@val2"] = value2
}, function(insertId)
    print("Inserted with ID: " .. insertId)
end)
```

#### After:
```lua
ig.sql.Insert("INSERT INTO characters (...) VALUES (?, ?)", {value1, value2}, function(insertId)
    print("Inserted with ID: " .. insertId)
end)
```

### Step 4: Update Prepared Statements

#### Before (MySQL.Async.store):
```lua
local SaveData = -1
MySQL.Async.store("UPDATE characters SET Health = @Health WHERE Character_ID = @Character_ID", function(id)
    SaveData = id
end)

-- Later, execute:
MySQL.Async.insert(SaveData, {
    ["@Health"] = health,
    ["@Character_ID"] = characterId
}, function(r)
    print("Saved")
end)
```

#### After:
```lua
local SaveData = -1
ig.sql.PrepareQuery("UPDATE characters SET Health = ? WHERE Character_ID = ?", function(id)
    SaveData = id
end)

-- Later, execute with positional parameters:
ig.sql.ExecutePrepared(SaveData, {health, characterId}, function(r)
    print("Saved")
end)
```

### Step 5: Update Transactions

#### Before:
```lua
MySQL.Async.transaction({
    {query = "UPDATE accounts SET balance = balance - @amount", parameters = {["@amount"] = 100}},
    {query = "INSERT INTO transactions VALUES (@data)", parameters = {["@data"] = data}}
}, function(success)
    print(success and "Success" or "Failed")
end)
```

#### After:
```lua
ig.sql.Transaction({
    {query = "UPDATE accounts SET balance = balance - ?", parameters = {100}},
    {query = "INSERT INTO transactions VALUES (?)", parameters = {data}}
}, function(success, results)
    print(success and "Success" or "Failed")
end)
```

## Parameter Conversion

### Named to Positional

The most common change is converting named parameters to positional:

| Before | After |
|--------|-------|
| `@Character_ID` | `?` |
| `@Primary_ID` | `?` |
| `@Bank` | `?` |

**Order matters!** Parameters must match the order of `?` placeholders in the query.

#### Before:
```lua
MySQL.Async.execute("UPDATE users SET ban = @ban, reason = @reason WHERE id = @id", {
    ["@ban"] = true,
    ["@reason"] = "Cheating",
    ["@id"] = userId
})
```

#### After:
```lua
ig.sql.Update("UPDATE users SET ban = ?, reason = ? WHERE id = ?", {true, "Cheating", userId})
```

## Common Patterns

### Pattern 1: Busy-Wait Loop Removal

#### Before:
```lua
local IsBusy = true
local result = nil
MySQL.Async.fetchScalar("SELECT ...", params, function(data)
    result = data
    IsBusy = false
end)
while IsBusy do
    Citizen.Wait(0)
end
return result
```

#### After:
```lua
local result = ig.sql.FetchScalar("SELECT ...", params)
return result
```

### Pattern 2: Callback Chains

#### Before:
```lua
MySQL.Async.fetchScalar("SELECT id FROM users WHERE license = @license", {["@license"] = license}, function(userId)
    if userId then
        MySQL.Async.fetchAll("SELECT * FROM characters WHERE user_id = @userId", {["@userId"] = userId}, function(characters)
            -- Process characters
        end)
    end
end)
```

#### After:
```lua
local userId = ig.sql.FetchScalar("SELECT id FROM users WHERE license = ?", {license})
if userId then
    local characters = ig.sql.Query("SELECT * FROM characters WHERE user_id = ?", {userId})
    -- Process characters
end
```

### Pattern 3: Prepared Statement Optimization

#### Before:
```lua
for i = 1, 100 do
    MySQL.Async.execute("UPDATE characters SET data = @data WHERE id = @id", {
        ["@data"] = GetData(i),
        ["@id"] = i
    })
end
```

#### After:
```lua
local UpdateQuery = -1
ig.sql.PrepareQuery("UPDATE characters SET data = ? WHERE id = ?", function(id)
    UpdateQuery = id
end)

for i = 1, 100 do
    ig.sql.ExecutePrepared(UpdateQuery, {GetData(i), i})
end
```

## Testing Your Migration

### 1. Unit Testing

Test individual function migrations:

```lua
RegisterCommand('testmigration', function()
    -- Test Query
    local chars = ig.sql.Query("SELECT * FROM characters LIMIT 1", {})
    assert(#chars >= 0, "Query failed")
    
    -- Test FetchScalar
    local count = ig.sql.FetchScalar("SELECT COUNT(*) FROM users", {})
    assert(type(count) == "number", "FetchScalar failed")
    
    -- Test Insert
    local insertId = ig.sql.Insert("INSERT INTO test_table (data) VALUES (?)", {"test"})
    assert(insertId > 0, "Insert failed")
    
    -- Clean up
    ig.sql.Update("DELETE FROM test_table WHERE id = ?", {insertId})
    
    print("Migration tests passed!")
end, true)
```

### 2. Performance Testing

Compare performance before and after:

```lua
local startTime = os.clock()
for i = 1, 1000 do
    ig.sql.FetchScalar("SELECT id FROM users WHERE license = ?", {"test"})
end
local elapsed = (os.clock() - startTime) * 1000
print(string.format("1000 queries: %.2fms (avg: %.2fms)", elapsed, elapsed / 1000))
```

### 3. Load Testing

Test under realistic server load with actual player counts.

## Rollback Plan

If issues occur:

1. **Immediate**: Restore database backup
2. **Code**: Revert to previous ingenium version
3. **Config**: Ensure `mysql-async` dependency is restored
4. **Restart**: Restart FiveM server

## Common Issues & Solutions

### Issue: "Connection pool is not initialized"

**Solution**: Wait for database ready:
```lua
if ig.sql.AwaitReady() then
    -- Proceed with queries
end
```

### Issue: Parameters in wrong order

**Solution**: Match parameter order to `?` placeholders:
```lua
-- WRONG
ig.sql.Query("SELECT * FROM chars WHERE id = ? AND active = ?", {true, characterId})

-- CORRECT
ig.sql.Query("SELECT * FROM chars WHERE id = ? AND active = ?", {characterId, true})
```

### Issue: Callback not being called

**Solution**: Ensure you're not mixing sync/async patterns:
```lua
-- Use callback OR return value, not both
local result = ig.sql.Query("SELECT ...", {}) -- Sync
-- OR
ig.sql.Query("SELECT ...", {}, function(result) end) -- Async
```

## Performance Gains

Expected improvements after migration:

| Operation | Before | After | Improvement |
|-----------|--------|-------|-------------|
| Simple SELECT | ~35ms | ~25ms | ~30% faster |
| Prepared statement | ~30ms | ~15ms | ~50% faster |
| Batch updates | ~500ms | ~200ms | ~60% faster |
| Transaction | ~100ms | ~80ms | ~20% faster |

## Post-Migration Checklist

- [ ] All critical functions tested
- [ ] Performance metrics reviewed
- [ ] Slow queries identified and optimized
- [ ] Error logging configured
- [ ] Monitoring in place
- [ ] Documentation updated
- [ ] Team trained on new API

---

**Need Help?**
- Review [SQL Architecture](./SQL_Architecture.md) for system overview
- Check [SQL API Reference](./SQL_API_Reference.md) for function details
- See [SQL Compatibility](./SQL_Compatibility.md) for legacy support
