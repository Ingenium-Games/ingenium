# Class-Based Entity System

## Overview

Ingenium uses a **server-authoritative class-based entity system** where all game state is managed through entity classes that automatically sync to clients via StateBags. This ensures data integrity and prevents client-side exploits.

## Entity Types

| Class | File | Purpose |
|-------|------|---------|
| **Player** | `server/[Classes]/_player.lua` | Active player characters with full state management |
| **OwnedVehicle** | `server/[Classes]/_owned_vehicle.lua` | Player-owned persistent vehicles |
| **Vehicle** | `server/[Classes]/_vehicle.lua` | Temporary/unowned vehicles |
| **Job** | `server/[Classes]/_job.lua` | Job organization management |
| **NPC** | `server/[Classes]/_npc.lua` | Non-player characters |
| **BlankObject** | `server/[Classes]/_blank_object.lua` | Newly created world objects |
| **ExistingObject** | `server/[Classes]/_existing_object.lua` | Loaded persistent objects |
| **OfflinePlayer** | `server/[Classes]/_offline_player.lua` | Read-only offline character data |

## Core Patterns

### Dual-Update Pattern

All entity setters automatically sync to **both** internal state and StateBags:

```lua
-- Example from Player class
self.SetHealth = function(v)
    local n = ig.check.Number(v, 0, 100)
    if self.Health ~= n then
        self.Health = n              -- Update server state
        self.State.Health = n         -- Replicate to clients
        self.IsDirty = true           -- Mark for database save
        self.DirtyFields.Health = true
    end
end
```

**Critical Rules:**
- Always use setters (`xPlayer.SetHealth(100)`)
- Never set StateBags directly (`xPlayer.State.Health = 100` ❌)
- Never trust client data without validation

### Dirty Flag System

Entities track changes to optimize database writes:

```lua
-- Entity changes trigger dirty flag
self.IsDirty = true                 -- Mark entity as modified
self.DirtyFields.Health = true      -- Track specific field

-- Saves run on intervals via ConsolidatedSaveLoop
-- Only dirty entities are saved
if entity.GetIsDirty() then
    ig.sql.save.User(entity)
    entity.ClearDirty()
end
```

### StateBag Synchronization

Clients automatically receive updates via StateBag replication:

```lua
-- Server (automatic via setter)
xPlayer.SetCash(1000)  -- Updates State.Cash

-- Client (read-only access)
local ped = PlayerPedId()
local cash = Player(PlayerId()).state.Cash
-- OR
local cash = Entity(ped).state.Cash
```

**Requirements:** OneSync Infinity is mandatory for StateBag replication.

### Cached JSON Encoding

Complex data structures are cached to optimize performance:

```lua
-- Cache invalidated when dirty
self.SetInventory = function(v)
    self.Inventory = v
    self.EncodedInventory = nil  -- Invalidate cache
    self.IsDirty = true
end

-- Lazy-load encoded data
self.GetEncodedInventory = function()
    if not self.EncodedInventory then
        self.EncodedInventory = json.encode(self.Inventory)
    end
    return self.EncodedInventory
end
```

## Entity Properties

### Player Entity

**Identity:**
- License_ID, Steam_ID, Discord_ID, Character_ID, City_ID

**Character:**
- Full_Name, Gender, Phone, Instance

**Stats:**
- Health, Armour, Hunger, Thirst, Stress

**Inventory:**
- Items, Cash, Bank, Ammo, Hotbar

**State:**
- Job, Grade, Wanted, Cuffed, Dead, Duty

**Voice:**
- Mode, Frequency, Radio/Call states

### Vehicle Entities

**OwnedVehicle:**
- Owner (Character_ID), Plate, Model
- Fuel, Parked, Impound, Instance, Garage
- Modifications, Condition, Keys, Inventory

**Vehicle (Temporary):**
- Plate (random), Model
- Wanted, Fuel, Instance, Garage, Parked
- Keys, Modifications, Condition

### Job Entity

- Structure: Name, Label, Grades, Members, Boss
- Locations: Sales, Delivery, Safe zones
- Management: Prices, Settings, Memos, Inventory/Stock
- Supplies tracking

### NPC Entity

- Identity: City_ID, First_Name, Last_Name
- Properties: Gender, Model, IsHuman
- State: Cuffed, Escorted
- Inventory: Random cash (25-89)

### Object Entities

**BlankObject:**
- UUID (generated), Model
- Coords (x, y, z, h, rx, ry, rz)
- Inventory, Created/Updated timestamps
- In-memory only initially

**ExistingObject:**
- UUID (from database), Model
- Coords, Inventory
- Pre-loaded from database

## Entity Lifecycle

### Player Lifecycle

```
Login → Create/Load → State.Bag sync → Activity → Dirty flag saves → Logout
```

1. Player connects, validated by deferrals
2. Character selection (isolated instance)
3. `ig.data.LoadPlayer(source, Character_ID)` creates Player class
4. StateBag sync to client
5. Client spawns ped, applies appearance
6. Server marks as ready, assigns ACL permissions
7. Periodic saves every 90 seconds (if dirty)
8. On disconnect: final save, cleanup

### Vehicle Lifecycle

**Owned Vehicle:**
```
Spawned from garage → Sync state → Modifications/Fuel updates → Park → Despawn → Save to DB
```

**Temporary Vehicle:**
```
Spawned (random plate) → No DB persistence → Despawn → Discarded
```

### Job Lifecycle

```
Loaded at startup → Members modify → DirtyFlag triggers save → Persistent
```

Jobs are loaded once at server start and persist throughout runtime.

### NPC Lifecycle

```
Spawned (random name) → Cuff/Escort during session → Despawn on disconnect
```

### Object Lifecycle

**BlankObject:**
```
Created in-world → Track changes → Optional save to DB as ExistingObject
```

**ExistingObject:**
```
Load from DB (UUID key) → Modify/Move → Save via dirty flag → Persist indefinitely
```

## Entity Indexes

Entities are stored in global indexes for fast lookup:

| Index | Purpose | Key Format |
|-------|---------|-----------|
| `ig.pdex` | Active players | source number |
| `ig.vdex` | Active vehicles | network ID |
| `ig.ndex` | Active NPCs | network ID |
| `ig.odex` | World objects | UUID string |
| `ig.jdex` | Job instances | job name string |

**Usage:**
```lua
local xPlayer = ig.pdex[source]
local xVehicle = ig.vdex[netId]
local xJob = ig.jdex['police']
```

## Data Helpers

Convenience functions for accessing entities:

```lua
-- Server
local xPlayer = ig.data.GetPlayer(source)
local xJob = ig.data.GetJob('police')

-- Client
local playerData = ig.data.GetLocalPlayer()
local playerState = ig.data.GetLocalPlayerState()
local entityState = ig.data.GetEntityState(entity)
```

## Validation

All entity setters use the `ig.check` validation module:

```lua
-- Type validation
local health = ig.check.Number(value, 0, 100)
local name = ig.check.String(value, 1, 50)
local active = ig.check.Boolean(value)

-- Inventory validation
ig.validation.ValidateAndUnpack(inventory)
ig.validation.ValidateInventoryIntegrity(before, after)
```

See [Validation System](Validation_System.md) for details.

## Best Practices

1. **Always use getters/setters** - Never access properties directly
2. **Validate client data** - Use `ig.check.*` before setting values
3. **Mark entities dirty** - Set `IsDirty = true` when modifying
4. **Check entity exists** - Verify entity not nil before accessing
5. **Use indexes efficiently** - Cache entity references when possible
6. **Clean up references** - Remove from indexes on entity destruction

## Related Documentation

- [Data Persistence System](Data_Persistence.md)
- [Validation System](Validation_System.md)
- [StateBag Security](Security_StateBags.md)
- [SQL Database Layer](SQL_System.md)
