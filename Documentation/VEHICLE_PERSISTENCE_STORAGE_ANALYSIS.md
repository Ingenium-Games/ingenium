# Vehicle Persistence Storage: DB vs File Analysis

## Overview

This document outlines the architectural decision between storing persistent vehicle data in the database versus JSON files, with consideration for owned vs tracked vehicles.

---

## Storage Strategy Decision Matrix

### Owned Vehicles (Character_ID Present)
| Aspect | Approach |
|--------|----------|
| **Storage** | Database Only |
| **Rationale** | Player ownership, character-tied, needs query capability |
| **Backup** | Inherent to database backup strategy |
| **Load Time** | Query on character load via existing systems |
| **Sync Frequency** | Already handled by existing garage system |
| **Consistency** | ACID compliance via SQL |

**Owned vehicles are queried by character, belong to player accounts, and integrate with existing garage/impound systems. Database is appropriate.**

---

### Persistent Tracked Vehicles (Character_ID NULL)
These are NPC/world vehicles that players have interacted with, making them persistent.

#### Option A: Database Storage
**Pros:**
- ✅ Persistent across server restarts
- ✅ Queryable with complex SQL filters
- ✅ ACID compliance for consistency
- ✅ Easier for admin tools
- ✅ Integrates with existing SQL patterns
- ✅ Audit trail capabilities
- ✅ Centralized with owned vehicles

**Cons:**
- ❌ Additional database queries every 10s (batch updates)
- ❌ Network latency for state syncing
- ❌ Separate from Lua runtime state
- ❌ Higher database load for frequent updates
- ❌ More complex state synchronization (DB ↔ Lua)
- ❌ Less flexible for rapid changes

**Database Load Estimate:**
- Vehicles: 200 persistent tracked vehicles
- Update Frequency: Every 10 seconds (batch)
- Per-vehicle Data: Position, condition, fuel, statebag
- Queries/second: ~2-3 queries per batch cycle
- Total: ~10-15 queries/minute for persistence

---

#### Option B: JSON File Storage (Recommended)
**Pros:**
- ✅ Fast in-memory access (no network latency)
- ✅ Minimal database load
- ✅ Flexible data structure (can add fields easily)
- ✅ Easy to inspect/debug (human-readable)
- ✅ Efficient batch operations
- ✅ Separates concerns (Lua state ≠ player data)
- ✅ Reduces database query count by 80%+
- ✅ Allows for simple versioning
- ✅ Can sync to DB periodically if needed

**Cons:**
- ❌ Less ACID compliance (manual write management)
- ❌ Can't query complex filters without loading all data
- ❌ File system operations (potential I/O blocking)
- ❌ Manual backup considerations
- ❌ Fewer admin tool integrations initially

**Storage Estimate:**
- File Location: `data/persistent_vehicles.json`
- Per-Vehicle Data: ~500 bytes average
- 200 vehicles: ~100 KB
- Write Frequency: Every 5-10 minutes or on save interval
- Disk I/O: Minimal, can be async

---

## Recommended Architecture

```lua
┌─────────────────────────────────────┐
│  Server Startup                     │
├─────────────────────────────────────┤
│ 1. Load owned vehicles from DB      │
│    (existing system)                │
│ 2. Load persistent_vehicles.json    │
│    into ig.vehicleCache             │
│ 3. Spawn vehicles within range      │
│    (proximity manager)              │
└─────────────────────────────────────┘
                ↓
┌─────────────────────────────────────┐
│  Runtime: Vehicle Events            │
├─────────────────────────────────────┤
│ Player enters vehicle               │
│  → RegisterPersistent() called       │
│  → Add to ig.vehicleCache           │
│  → Queue for JSON save              │
└─────────────────────────────────────┘
                ↓
┌─────────────────────────────────────┐
│  State Tracking (Lua)               │
├─────────────────────────────────────┤
│ Monitor position/damage via         │
│ xVehicle properties                 │
│ (no database queries)               │
└─────────────────────────────────────┘
                ↓
┌─────────────────────────────────────┐
│  Periodic Sync (5-10 min)           │
├─────────────────────────────────────┤
│ Save persistent_vehicles.json       │
│ (async write)                       │
│ Optional: sync critical data to DB  │
└─────────────────────────────────────┘
                ↓
┌─────────────────────────────────────┐
│  Shutdown/Cleanup                   │
├─────────────────────────────────────┤
│ Save final state to JSON            │
│ Optional: cleanup old tracked       │
│ vehicles from DB                    │
└─────────────────────────────────────┘
```

---

## Implementation Pattern

### JSON File Structure
```json
{
  "version": 1,
  "lastSaved": "2026-01-13T10:30:00Z",
  "vehicles": {
    "ABC1234": {
      "plate": "ABC1234",
      "model": "adder",
      "type": "npc",
      "npcOwner": "Ped_Manager_001",
      "coords": {"x": 100.5, "y": 200.3, "z": 50.0, "h": 45.5},
      "condition": {...},
      "statebag": {...},
      "fuel": 85,
      "mileage": 15000,
      "lastInteraction": "2026-01-13T10:25:00Z",
      "interactionCount": 3,
      "firstRegistered": "2026-01-10T08:15:00Z"
    },
    "XYZ5678": {...}
  }
}
```

### Lua Cache Structure
```lua
ig.vehicleCache = {
  ["ABC1234"] = {
    plate = "ABC1234",
    entity = 12345,                    -- Currently spawned entity
    owner = "npc_id" or "char_id",
    type = "npc" or "world",
    coords = {x, y, z, h},
    condition = {...},
    statebag = {...},
    fuel = 85,
    lastCondition = {...},             -- Previous state for comparison
    lastCoords = {x, y, z, h},         -- Previous position for comparison
    spawned = true,
    registeredAt = now(),
    lastUpdated = now(),
  },
  ["XYZ5678"] = {...}
}
```

### Sync Points
1. **Vehicle Registration** (Event-Driven)
   - Player enters vehicle → Register immediately
   - Queue for JSON save
   
2. **Periodic State Saves** (Every 5-10 minutes)
   - Write `data/persistent_vehicles.json`
   - Optional: Sync critical vehicles to DB
   
3. **Server Shutdown**
   - Final JSON save
   - Optional: Cleanup routines
   
4. **Manual Admin Commands**
   - Save/load on demand
   - Cleanup deprecated vehicles

---

## Database vs File: Decision Tree

```
Is it an owned vehicle (Character_ID present)?
├─ YES → Store in DATABASE (existing system)
│         Query by character
│         Integrated with garage/impound
│
└─ NO → Is it a persistent tracked vehicle?
        └─ YES → Store in JSON FILE + Memory Cache
                 Event-driven registration
                 Minimal DB queries
                 Fast access
                 Periodic sync
```

---

## Practical Comparison: 200 Vehicle Scenario

### Database-Only Approach
```
Operations per 10-second cycle:
- Load persistent vehicles: 1 query
- Update positions: ~4 batch queries (50 vehicles/batch)
- Update conditions: ~4 batch queries
- Total: 8-10 queries per cycle
- Per minute: 48-60 queries
- Per hour: 2,880-3,600 queries
- Database CPU: ~2-3% for persistence alone

Write Operations (position/condition):
- Very frequent (every 10 seconds)
- Network latency: 5-50ms each
- Total latency: 400ms-2.5s per cycle
```

### JSON + Memory Cache Approach
```
Operations per 10-second cycle:
- Load persistent vehicles: 0 queries (memory)
- Update positions: 0 queries (memory tracking)
- Update conditions: 0 queries (xVehicle state)
- Total: 0 queries during runtime
- Per minute: 0 queries
- Database CPU: ~0% for persistence operations
- Only 1 async file write every 5-10 minutes

Performance gain: ~80% reduction in database load
```

---

## When to Use Each Approach

### Use Database Storage When:
- ✅ Data must be queryable by complex criteria
- ✅ ACID compliance is critical
- ✅ Data is already owned by characters/accounts
- ✅ Integration with admin tools is essential
- ✅ Multi-server synchronization needed (cluster)

### Use JSON Storage When:
- ✅ Data is ephemeral or session-based
- ✅ Performance is critical
- ✅ Quick serialization/deserialization needed
- ✅ Data structure is simple and known
- ✅ File system I/O is acceptable
- ✅ Minimal admin querying needed

---

## Recommendation

**Hybrid Approach: JSON Primary + Optional DB Sync**

```lua
-- Load at startup
ig.vehicleCache = LoadPersistentVehiclesFromJSON()

-- Event-driven registration (fast, in-memory)
RegisterNetEvent("Server:OnPlayerEnteredVehicle", function(...)
    ig.vehicle.RegisterPersistent(...)  -- Updates Lua table only
end)

-- Periodic sync to file (async)
CreateThread(function()
    while true do
        Wait(300000)  -- Every 5 minutes
        SavePersistentVehiclesToJSON(ig.vehicleCache)
    end
end)

-- Optional: Sync critical data to DB for backup/admin queries
CreateThread(function()
    while true do
        Wait(600000)  -- Every 10 minutes
        SyncCriticalVehiclesToDatabase()  -- Backup only
    end
end)
```

---

## Migration Path

1. **Phase 1: JSON Storage (Primary)**
   - All persistent tracked vehicles → `data/persistent_vehicles.json`
   - Runtime tracking in Lua memory
   - Event-driven registration
   
2. **Phase 2: Optional Database Backup**
   - Periodically sync subset to DB
   - For admin queries and backups
   - Not required for gameplay
   
3. **Phase 3: Admin Tools** (future)
   - Build admin UI querying JSON
   - Optional database integration
   - Query builder for JSON data

---

## Summary

| Aspect | Database | JSON File |
|--------|----------|-----------|
| Persistence | ✅ Yes | ✅ Yes |
| Query Speed | ⚠️ Slow | ✅ Fast |
| Update Speed | ⚠️ Slow | ✅ Fast |
| Memory Usage | ✅ Low | ⚠️ Medium |
| DB Load | ❌ High | ✅ Low |
| Simplicity | ⚠️ Complex | ✅ Simple |
| Admin Tools | ✅ Yes | ⚠️ Custom |
| **Recommendation** | Owned vehicles | Tracked vehicles |

**Decision: Use JSON for persistent tracked vehicles, Database for owned vehicles.**

