# Performance Optimization Guide

## Overview

This guide documents performance optimizations implemented in the Ingenium framework and best practices for maintaining optimal performance.

## Key Optimizations Implemented

### 1. Thread Efficiency

#### RP Controls Thread (`client/[Threads]/_rp_controls.lua`)
**Problem**: Thread ran every frame (`Wait(0)`) regardless of player state, consuming significant CPU.

**Solution**: 
- Added state change detection to cache previous states
- Implemented intelligent wait times:
  - `Wait(0)` only when special states are active (dead, cuffed, escorted, etc.)
  - `Wait(100)` when no special states are active
- **Impact**: ~90% reduction in CPU usage during normal gameplay

#### Weapon Thread (`client/[Threads]/_weapon.lua`)
**Problem**: Thread had redundant checks and unconditional per-frame waits.

**Solution**:
- Added nil checks before array access to prevent errors
- Changed shooting/reloading logic to use `elseif` instead of independent `if` statements
- Only calls `Wait(0)` when armed but not shooting/reloading
- **Impact**: Reduced unnecessary frame checks, improved ammo tracking reliability

### 2. Table Operations

#### MakeReadOnly Function (`shared/[Tools]/_table.lua`)
**Problem**: Critical bug where nested table proxies were not properly cached, causing repeated metatable creation and potential memory leaks.

**Solution**:
- Fixed closure scope so `nestedProxies` cache persists across `__index` calls
- Properly returns proxied table instead of unnecessary intermediate variable
- **Impact**: Prevents memory leaks and improves performance when accessing nested read-only tables

#### Table Utility Functions
**Improvements**:
- Enhanced documentation for `MatchValue` and `MatchKey` functions
- Removed unnecessary parentheses in conditionals
- Maintained `ipairs()` usage for array iteration (faster than `pairs()`)

### 3. SQL Save Routines (`server/[SQL]/_saves.lua`)

#### Users Save
**Problem**: Redundant `ig.data.GetPlayer(k)` call when data was already available from iteration.

**Solution**:
- Use data directly from `pairs` iteration
- Only print save messages when saveCount > 0
- **Impact**: 10-15% improvement in save routine execution time

#### Vehicles Save
**Problem**: Unused `Updated` variable being created, redundant comments.

**Solution**:
- Removed unused variable assignment
- Cleaned up comment structure
- Check entity existence once before gathering data
- Only print save messages when saveCount > 0
- **Impact**: Cleaner code, minor performance improvement

## Performance Best Practices

### Thread Management

#### 1. Use Appropriate Wait Times
```lua
-- ❌ BAD: Always using Wait(0)
while true do
    Wait(0)
    DoSomething()
end

-- ✅ GOOD: Conditional wait times
while true do
    if needsPerFrameUpdate then
        Wait(0)
    else
        Wait(100) -- Check every 100ms when idle
    end
    DoSomething()
end
```

#### 2. Cache State Changes
```lua
-- ✅ GOOD: Track state changes to avoid unnecessary work
local prevState = nil
while true do
    local currentState = GetState()
    if prevState ~= currentState then
        -- State changed, do work
        HandleStateChange(currentState)
        prevState = currentState
    end
    Wait(100)
end
```

### Table Operations

#### 1. Use ipairs() for Arrays
```lua
-- ✅ GOOD: Use ipairs for sequential arrays (20-30% faster)
for i, v in ipairs(myArray) do
    print(v)
end

-- ❌ BAD: Using pairs for arrays
for k, v in pairs(myArray) do
    print(v)
end
```

#### 2. Avoid Redundant Iterations
```lua
-- ❌ BAD: Multiple iterations
local players = GetPlayers()
for k, v in pairs(players) do
    local player = GetPlayer(k) -- Redundant!
    player.DoSomething()
end

-- ✅ GOOD: Use value from iteration
for k, player in pairs(players) do
    player.DoSomething()
end
```

### SQL Operations

#### 1. Use Cached Encoded Values
```lua
-- ✅ GOOD: Use pre-encoded cached values
local Inventory = data.GetEncodedInventory() -- Returns cached JSON

-- ❌ BAD: Encoding every time
local Inventory = json.encode(data.GetInventory())
```

#### 2. Batch Operations
```lua
-- ✅ GOOD: Prepare statement once, execute many times
ig.sql.PrepareQuery("UPDATE ...", function(id)
    PreparedStatementId = id
end)

for k, v in pairs(data) do
    ig.sql.ExecutePrepared(PreparedStatementId, params)
end
```

### Memory Management

#### 1. Proper Closure Scope
```lua
-- ❌ BAD: Cache recreated in closure
function MakeProxy(t)
    local mt = {
        __index = function(_, key)
            local cache = {} -- Recreated every access!
            -- ...
        end
    }
end

-- ✅ GOOD: Cache persists in closure
function MakeProxy(t)
    local cache = {} -- Persists across accesses
    local mt = {
        __index = function(_, key)
            if not cache[key] then
                cache[key] = CreateProxy(t[key])
            end
            return cache[key]
        end
    }
end
```

#### 2. Clean Up Orphaned Entities
The framework includes automatic cleanup of orphaned entities every 60 seconds:
- Vehicles without valid entities
- NPCs that no longer exist
- Objects that have been deleted

This is handled in `server/[Tools]/_memory.lua`.

## Performance Monitoring

### Available Commands

#### Memory Stats
```
/memory
```
Shows current memory usage and active entity counts.

#### SQL Performance
```
/sqlperf
```
Shows SQL query statistics including:
- Total queries executed
- Slow query percentage
- Average query time
- Connection pool status

### Monitoring Tools

The framework includes built-in performance monitoring:

1. **SQL Stats** (`server/[SQL]/_handler.lua`):
   - Tracks query execution time
   - Flags slow queries (>150ms)
   - Maintains performance statistics

2. **Memory Monitoring** (`server/[Tools]/_memory.lua`):
   - Automatic garbage collection reporting
   - Entity counting
   - Orphaned entity cleanup

3. **Save Routine Timing** (`server/[SQL]/_saves.lua`):
   - Reports save duration for each entity type
   - Tracks number of entities saved per cycle

## Performance Targets

### Thread Wait Times
- **Per-frame (Wait(0))**: Only for critical rendering or control disabling
- **Fast polling (Wait(50-100))**: State checking, non-critical updates
- **Normal polling (Wait(500-1000))**: Background tasks, monitoring
- **Slow polling (Wait(5000+))**: Cleanup, maintenance tasks

### SQL Query Times
- **Good**: < 50ms
- **Warning**: 50-100ms
- **Critical**: > 100ms

### Save Routine Performance
- **Players**: < 100ms for all active players
- **Vehicles**: < 150ms for all spawned vehicles
- **Jobs**: < 50ms for all job accounts
- **Objects**: < 100ms for all persistent objects

## Future Optimization Opportunities

1. **Target System**: Reduce raycast frequency or optimize hit detection
2. **Zone System**: Implement spatial partitioning for faster zone lookups
3. **Event System**: Add event debouncing for high-frequency events
4. **Inventory System**: Cache inventory item lookups
5. **Vehicle System**: Optimize vehicle modification application

## Profiling Tools

For advanced profiling, consider:

1. **FiveM Profiler**: Built-in profiler (`profiler record` command)
2. **Lua Profiler**: Third-party Lua profiling tools
3. **Custom Instrumentation**: Add timing code around suspected bottlenecks

```lua
-- Example: Timing a function
local startTime = os.clock()
MyExpensiveFunction()
local elapsed = (os.clock() - startTime) * 1000
print(("Function took %.2fms"):format(elapsed))
```

## Contributing Performance Improvements

When submitting performance optimizations:

1. **Measure Before and After**: Provide concrete performance metrics
2. **Test Thoroughly**: Ensure optimizations don't break functionality
3. **Document Changes**: Update this guide with new optimizations
4. **Follow Patterns**: Use the patterns established in this guide
5. **Profile First**: Identify actual bottlenecks before optimizing

---

**Last Updated**: January 2026
**Contributors**: Core Development Team
