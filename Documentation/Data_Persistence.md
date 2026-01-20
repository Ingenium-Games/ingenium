# Data Persistence System

## Overview

Ingenium uses a **hybrid persistence model** combining SQL database storage for user-generated data with JSON file storage for dynamic runtime data. This approach optimizes for both performance and data integrity.

## Persistence Strategy

### SQL Database (Persistent User Data)

Stored in MySQL/MariaDB:

- **Characters** - Player stats, inventory, money, appearance
- **Vehicles** - Owned vehicles with modifications
- **Banking** - Accounts, transactions, favorites
- **Job Accounts** - Job finances and member lists
- **Objects** - Persistent world objects (optional)
- **Phone Data** - Contacts, call history
- **User Accounts** - License mappings, ACE permissions

### JSON Files (Dynamic Runtime Data)

Stored in `data/` directory:

| File | Purpose | Save Frequency |
|------|---------|----------------|
| `drops.json` | Items dropped on ground | 5 minutes |
| `pickups.json` | Pickup spawn locations | 5 minutes |
| `scenes.json` | Scene definitions | 5 minutes |
| `notes.json` | Player notes/evidence | 5 minutes |
| `gsr.json` | Gunshot residue entries | 5 minutes |
| `objects.json` | Object metadata | 5 minutes |

### Reference Data (Read-Only JSON)

Never modified at runtime:

- `items.json` - Item definitions
- `vehicles.json` - Vehicle models
- `weapons.json` - Weapon data
- `jobs.json` - Job structures
- `peds.json` - Ped models
- `tattoos.json` - Tattoo collections

**Protection:** Wrapped with `ig.table.MakeReadOnly()` to prevent modification.

## Startup Loading Sequence

```lua
function ig.data.Initilize()
    ig._loading = true
    
    -- 1. Wait for SQL connection (40s timeout)
    local sqlReady = ig.sql.AwaitReady(40000)
    if not sqlReady then
        ig.log.Error('CRITICAL: SQL connection failed')
        return
    end
    
    -- 2. Load JSON static data
    ig.data.LoadJSONData(function()
        -- 3. Restore drops from JSON to world
        ig.data.RestoreDrops()
        
        -- 4. Load job objects
        ig.data.CreateJobObjects()
        
        -- 5. Mark ready
        ig._loading = false
        ig._dataloaded = true
        
        -- 6. Start save loops
        ConsolidatedSaveLoop()
        SaveDynamicData()
    end)
end
```

### Load JSON Data

```lua
function ig.data.LoadJSONData(callback)
    -- Load reference data (protected)
    ig.items = ig.json.Load('items')
    ig.vehicles = ig.json.Load('vehicles')
    ig.weapons = ig.json.Load('weapons')
    ig.jobs = ig.json.Load('jobs')
    ig.peds = ig.json.Load('peds')
    ig.tattoos = ig.json.Load('tattoos')
    
    -- Protect from modification
    ig.table.MakeReadOnly(ig.weapons)
    ig.table.MakeReadOnly(ig.vehicles)
    ig.table.MakeReadOnly(ig.tattoos)
    ig.table.MakeReadOnly(ig.peds)
    
    -- Load dynamic data (mutable)
    ig.drops = ig.json.Load('drops') or {}
    ig.picks = ig.json.Load('pickups') or {}
    ig.scenes = ig.json.Load('scenes') or {}
    ig.notes = ig.json.Load('notes') or {}
    ig.gsrs = ig.json.Load('gsr') or {}
    ig.objects = ig.json.Load('objects') or {}
    
    callback()
end
```

### Restore Drops

Recreates physical objects from JSON:

```lua
function ig.data.RestoreDrops()
    for uuid, drop in pairs(ig.drops) do
        if drop.coords then
            local obj = CreateObject(
                drop.model,
                drop.coords.x,
                drop.coords.y,
                drop.coords.z,
                true, true, false
            )
            
            FreezeEntityPosition(obj, true)
            SetEntityCollision(obj, true, true)
            
            -- Update object reference
            drop.object = obj
        end
    end
end
```

## Save System

### Consolidated Save Loop

Single-threaded scheduler handles all entity saves:

```lua
local lastRun = {
    users = 0,
    vehicles = 0,
    jobs = 0,
    objects = 0
}

function ConsolidatedSaveLoop()
    if ig.player.ArePlayersActive() ~= nil then
        local currentTime = os.clock()
        
        -- Players: Every 90 seconds
        if (currentTime - lastRun.users) >= (conf.serversync / 1000) then
            ig.sql.save.Users()
            lastRun.users = currentTime
        end
        
        -- Vehicles: Every 5 minutes
        if (currentTime - lastRun.vehicles) >= (conf.vehiclesync / 1000) then
            ig.sql.save.Vehicles()
            lastRun.vehicles = currentTime
        end
        
        -- Jobs: Every 10 minutes
        if (currentTime - lastRun.jobs) >= (conf.jobsync / 1000) then
            ig.sql.save.Jobs()
            lastRun.jobs = currentTime
        end
        
        -- Objects: Every 5 minutes
        if (currentTime - lastRun.objects) >= (conf.objectsync / 1000) then
            ig.sql.save.Objects()
            lastRun.objects = currentTime
        end
    end
    
    SetTimeout(conf.serversync, ConsolidatedSaveLoop)
end
```

**Key Benefits:**
- Single thread instead of 4 separate threads
- Timer-based scheduling prevents drift
- Only saves entities marked dirty
- Reduces database load significantly

### Dynamic Data Save

Periodic JSON file saves:

```lua
function SaveDynamicData()
    if not ig._loading then
        -- Merge and save drops
        local dropsToSave = ig.drop.MergeDropsForSave()
        ig.json.Write('drops', dropsToSave)
        
        -- Save other dynamic data
        ig.json.Write('pickups', ig.picks or {})
        ig.json.Write('scenes', ig.scenes or {})
        ig.json.Write('notes', ig.notes or {})
        ig.json.Write('gsr', ig.gsrs or {})
        ig.json.Write('objects', ig.objects or {})
    end
    
    SetTimeout(conf.objectsync, SaveDynamicData)
end
```

**Save Frequency:** Every 5 minutes (conf.objectsync)

### Critical Saves

Force saves on important events:

```lua
-- Server shutdown
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        -- Force save all data
        ig.sql.save.Users()
        ig.sql.save.Vehicles()
        ig.sql.save.Jobs()
        ig.sql.save.Objects()
        
        SaveDynamicData()
    end
end)

-- Manual admin command
RegisterCommand('savedata', function(source)
    if IsPlayerAceAllowed(source, 'command.savedata') then
        ig.sql.save.Users()
        ig.sql.save.Vehicles()
        ig.sql.save.Jobs()
        ig.sql.save.Objects()
        SaveDynamicData()
        
        ig.log.Info('Manual save triggered by admin')
    end
end, true)
```

## Dirty Flag Optimization

### Entity Dirty Tracking

```lua
-- Entity modification sets dirty flag
xPlayer.SetCash(1000)
-- Internally:
--   self.Cash = 1000
--   self.IsDirty = true
--   self.DirtyFields.Cash = true

-- Save only if dirty
if xPlayer.GetIsDirty() then
    ig.sql.save.User(xPlayer)
    xPlayer.ClearDirty()
end
```

### Save Functions

#### Individual Entity Save

```lua
function ig.sql.save.User(data, callback)
    if not data.GetIsDirty() then
        return callback and callback(true)
    end
    
    -- Execute prepared query
    ig.sql.ExecutePrepared(PlayerSaveData, {
        data.Cash,
        data.Bank,
        data.Inventory,
        data.Character_ID
    }, function(result)
        data.ClearDirty()
        callback and callback(true)
    end)
end
```

#### Bulk Entity Save

```lua
function ig.sql.save.Users(callback)
    local dirtyCount = 0
    
    for source, xPlayer in pairs(ig.pdex) do
        if xPlayer.GetIsDirty() then
            dirtyCount = dirtyCount + 1
            ig.sql.save.User(xPlayer)
        end
    end
    
    if dirtyCount > 0 then
        ig.log.Debug("Saved %d dirty players", dirtyCount)
    end
    
    callback and callback(true)
end
```

## Entity Indexes

Global tables store active entities:

```lua
-- Initialized in server/_var.lua
ig.pdex = {}  -- Players by source
ig.vdex = {}  -- Vehicles by netId
ig.ndex = {}  -- NPCs by netId
ig.odex = {}  -- Objects by UUID
ig.jdex = {}  -- Jobs by name
```

### Usage Pattern

```lua
-- Add to index
ig.pdex[source] = xPlayer

-- Get from index
local xPlayer = ig.pdex[source]

-- Remove from index
ig.pdex[source] = nil
```

### Helper Functions

```lua
-- Get player
local xPlayer = ig.data.GetPlayer(source)

-- Get player by character ID
local xPlayer = ig.data.GetPlayerByCharacterId(charId)

-- Get job
local xJob = ig.data.GetJob('police')

-- Get all jobs
local jobs = ig.data.GetJobs()
```

## Character Lifecycle

### Character Load

```lua
function ig.data.LoadPlayer(source, Character_ID)
    -- Create player class (loads from DB)
    local xPlayer = ig.class.Player(source, Character_ID)
    
    -- Add to index
    ig.pdex[source] = xPlayer
    
    -- Sync to client
    TriggerClientEvent('Client:Character:Loaded', source, xPlayer.GetAll())
    
    return xPlayer
end
```

### Character Unload

```lua
function ig.data.UnloadPlayer(source)
    local xPlayer = ig.pdex[source]
    
    if xPlayer then
        -- Force save
        if xPlayer.GetIsDirty() then
            ig.sql.save.User(xPlayer)
        end
        
        -- Remove from index
        ig.pdex[source] = nil
        
        ig.log.Debug("Unloaded character for source %d", source)
    end
end
```

## Data Integrity

### Save During Active Play

```lua
-- Only save when players are active
if ig.player.ArePlayersActive() ~= nil then
    -- Perform saves
end
```

### Skip During Loading

```lua
-- Prevent saves during startup
if ig._loading then
    return
end
```

### Concurrent Access Protection

Inventory validation prevents race conditions:

```lua
-- Gets CURRENT server state (not cached)
local serverInv = xPlayer.GetInventory()

-- Validates client changes against server state
local valid = ig.validation.ValidateInventoryIntegrity(
    serverInv,
    clientInv
)
```

## Performance Considerations

### Why Hybrid Model?

**Database (SQL):**
- ✅ ACID compliance for critical data
- ✅ Complex queries (player lookups, transactions)
- ✅ Relational integrity (foreign keys)
- ❌ Slower for frequent writes
- ❌ Limited to structured data

**JSON Files:**
- ✅ Fast writes for high-churn data
- ✅ Flexible schema (any structure)
- ✅ Easy backup/restore
- ❌ No query capabilities
- ❌ No referential integrity

### Optimization Patterns

1. **Dirty flags** - Only save changed entities
2. **Batch writes** - Group related updates
3. **Prepared statements** - Pre-compile frequent queries
4. **Deferred saves** - Write on intervals, not per-change
5. **Consolidated loop** - Single scheduler thread
6. **JSON for volatility** - High-churn data in files
7. **Protected references** - Read-only static data

## Backup & Recovery

### Manual Backup

```bash
# Database backup
mysqldump -u user -p database > backup.sql

# JSON files backup
cp -r data/ backup-data/
```

### Auto-save Triggers

Saves occur:
- Every 90s - Players (if dirty)
- Every 5min - Vehicles (if dirty)
- Every 10min - Jobs (if dirty)
- Every 5min - Objects (if dirty)
- Every 5min - Dynamic JSON data
- On resource stop
- On admin command

## Configuration

Set save intervals in `_config/config.lua`:

```lua
conf.serversync     = 90000   -- Players (ms)
conf.vehiclesync    = 300000  -- Vehicles (ms)
conf.jobsync        = 600000  -- Jobs (ms)
conf.objectsync     = 300000  -- Objects & JSON (ms)
```

## Best Practices

1. **Mark entities dirty** when data changes
2. **Check dirty state** before saving
3. **Clear dirty flags** after successful save
4. **Use indexes efficiently** - Cache entity references
5. **Handle disconnects** - Force save on player drop
6. **Monitor save times** - Log slow operations
7. **Test recovery** - Verify data restored correctly
8. **Backup regularly** - Both DB and JSON files
9. **Avoid race conditions** - Use current state for validation
10. **Protect static data** - MakeReadOnly() for reference tables

## Related Documentation

- [Class System](Class_System.md) - Entity dirty flags
- [SQL System](SQL_System.md) - Database layer
- [Validation System](Validation_System.md) - Data integrity
