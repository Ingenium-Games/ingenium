# Vehicle Persistence System

## Overview

The Vehicle Persistence System manages the lifecycle of vehicles in the world, ensuring that vehicles remain in their last known state across server restarts and tracking their condition throughout their lifetime.

**Key Features:**
- Automatic registration of vehicles when players interact with them
- Position and condition preservation across restarts
- Proximity-based spawn/despawn management
- NPC vehicle tracking (optional persistence on player interaction)
- Statebag and livery persistence
- Event-driven architecture for scalability
- Configurable cleanup routines

## Architecture

### Three-Layer Design

```
┌─────────────────────────────────────┐
│     CLIENT LAYER (Detection)        │
│  - Detects seat entry               │
│  - Captures initial condition       │
│  - Notifies server                  │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     SERVER LAYER (Management)       │
│  - Registers persistent vehicles    │
│  - Tracks state changes             │
│  - Manages spawn/despawn            │
│  - Batch DB updates                 │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│     DATABASE LAYER (Storage)        │
│  - Stores vehicle state             │
│  - Tracks interactions              │
│  - Persistence state cache          │
└─────────────────────────────────────┘
```

### In-Memory Cache

Server maintains `ig.vehicleCache` for quick lookups:
```lua
ig.vehicleCache = {
    [plate] = {
        entity = vehicleEntity,
        plate = plate,
        type = 'owned|npc|world',
        owner = 'characterId|npcName',
        registeredBy = playerId,
        registeredAt = timestamp,
        lastCoords = vector3,
        lastCondition = table,
        lastStatebag = table,
    }
}
```

## Vehicle Classification

### Owned Vehicles
- Player-owned vehicles from garage/purchase
- Always persistent
- Tracked to character ID
- Survive player logout
- Can only be destroyed via impound/RP mechanics

### NPC Vehicles
- Spawned by game ambient traffic or scripts
- Ephemeral by default (removed after timeout)
- **Become persistent when player enters** (ANY seat)
- Tracked to NPC name or random identifier
- Can be despawned if player doesn't interact

### World Vehicles
- Script-spawned vehicles
- Ephemeral by default
- Can become persistent on player interaction
- Removed if not accessed within timeout

## Persistence Triggers

### Registration (Vehicle becomes persistent)
```
Player Action → Event Trigger → Server Registration → DB Save
    │                                      │
    └─ Enters driver seat        →        Store condition
    └─ Enters passenger seat     →        Capture liveries
    └─ Sits in any vehicle seat  →        Track statebag
                                      Store coordinates
                                      Assign ownership
```

### Non-Triggering Actions (Vehicle stays ephemeral)
- Shooting at vehicle
- Vehicle taking damage
- Explosions near vehicle
- Physics collisions
- ✗ **Does NOT register as persistent**

## Configuration

Located in `_config/vehicles.lua` under `conf.persistence`:

### Core Settings
```lua
conf.persistence = {
    enablePersistence = true,
    enableNpcVehiclePersistence = true,
    spawnDistance = 200,              -- Spawn radius
    despawnDistance = 400,            -- Despawn radius
    spawnTimeout = 10000,             -- Check interval
}
```

### Parking Behavior
```lua
parking = {
    despawnWhenParked = false,    -- Remove from world when parked?
    persistWhileParked = true,    -- Keep in DB?
    updateCoordsIfChanged = true, -- Restore if moved?
    parkingUpdateInterval = 30000,
}
```

### State Tracking
```lua
stateTracking = {
    trackDamage = true,
    trackLiveries = true,
    trackStatebag = true,
    trackFuel = true,
    damageCheckInterval = 5000,
    movementThreshold = 5.0,      -- Distance to register as moved
}
```

### Cleanup
```lua
cleanup = {
    enabled = true,
    runInterval = 60000,
    abandonedVehicleTimeout = 604800000,  -- 7 days
    npcVehicleTimeout = 1800000,          -- 30 minutes
    maxTrackedVehicles = 500,
}
```

## Workflow Examples

### Example 1: Player Steals NPC Vehicle

```
1. NPC driving ambient traffic vehicle
2. Player shoots: Vehicle takes damage ✗ (NOT persistent)
3. Player enters driver seat: Vehicle registered ✓
4. Server saves:
   - Plate registered to NPC name
   - marked as 'npc' type
   - Current condition snapshot
   - Position coordinates
   - Set persistent=true
5. Vehicle now survives restarts
6. On next restart: Vehicle spawned at saved location
```

### Example 2: Player Interaction Timeout

```
1. NPC vehicle spawned at coordinates
2. Player doesn't interact (just passes by)
3. Cleanup routine checks: 30 minutes elapsed
4. Vehicle not registered (persistent=0)
5. Vehicle deleted from DB
```

### Example 3: Parking & Despawn

```
1. Player's owned vehicle is persistent
2. Player parks vehicle (conf.parking.despawnWhenParked=true)
3. No player within despawnDistance (400m)
4. Server despawns vehicle entity
5. Vehicle still in DB, marked despawned=1
6. When player returns within spawnDistance
7. Vehicle spawned again at saved location
```

## Database Schema

### vehicles Table (Extended)

| Field | Type | Purpose |
|-------|------|---------|
| `vehicle_type` | ENUM | 'owned', 'npc', 'world' |
| `npc_owner` | VARCHAR | NPC name if NPC-driven |
| `persistent` | TINYINT | Is vehicle registered as persistent? |
| `server_owner_id` | INT | Server-side ownership tracking |
| `last_position` | VARCHAR | Previous coords for change detection |
| `previous_condition` | LONGTEXT | Previous damage state |
| `statebag_data` | LONGTEXT | xVehicle/custom states JSON |
| `liveries` | LONGTEXT | Livery and paint data JSON |
| `despawn_on_park` | TINYINT | Remove from world when parked? |
| `despawned` | TINYINT | Currently despawned? |
| `despawn_time` | TIMESTAMP | When despawned |
| `last_interaction` | TIMESTAMP | Last player interaction |
| `interaction_count` | INT | Times vehicle was entered |

### vehicle_persistence_state Table

Runtime tracking for quick lookups:
```sql
CREATE TABLE vehicle_persistence_state (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    plate VARCHAR(8) UNIQUE,
    spawned_entity_id INT,
    current_coords VARCHAR(255),
    last_check TIMESTAMP,
    movement_detected TINYINT,
    damage_detected TINYINT,
    in_cache TINYINT,
    player_in_vehicle TINYINT,
    owner_identifier VARCHAR(100),
    FOREIGN KEY (plate) REFERENCES vehicles(Plate)
);
```

### vehicle_interactions Table

Audit trail:
```sql
CREATE TABLE vehicle_interactions (
    ID INT PRIMARY KEY AUTO_INCREMENT,
    plate VARCHAR(8),
    player_id INT,
    character_id VARCHAR(50),
    interaction_type ENUM('entered', 'exited', 'damaged', 'destroyed', 'registered', 'despawned', 'impounded'),
    timestamp TIMESTAMP,
    vehicle_condition LONGTEXT,
    FOREIGN KEY (plate) REFERENCES vehicles(Plate)
);
```

## Event Flow

### Vehicle Registration Event

```lua
-- CLIENT SIDE
Player enters vehicle seat
  ↓
ig.vehicle.OnVehicleSeatChange() triggered
  ↓
Captures vehicle condition
  ↓
Triggers: 'vehicle:persistence:register'
  ├─ plate
  ├─ vehicle entity
  ├─ seat number
  └─ condition data

-- SERVER SIDE
Receives: 'vehicle:persistence:register'
  ↓
ig.vehicle.RegisterVehicle() called
  ↓
Adds to ig.vehicleCache
  ↓
ig.sql.veh.RegisterPersistent() called
  ├─ Updates persistent flag
  ├─ Sets vehicle_type
  ├─ Assigns npc_owner
  └─ Logs interaction

-- CLIENT SIDE
Receives: 'vehicle:persistence:registered' confirmation
  ↓
Displays notification: "Vehicle X is now persistent"
```

## State Preservation

### Captured On Registration
- Vehicle damage (doors, windows, tires, panels, lights)
- Engine and body health
- Current position and heading
- Fuel level
- Mileage (if available)
- Liveries and paint jobs
- Statebag properties (xvehicle, custom metadata)

### Restored On Spawn
- All damage states
- Health values
- Liveries and paint
- Statebag properties
- Position and heading
- Fuel level

## Monitoring & Logging

### Log Levels
```lua
conf.persistence.logging = {
    enabled = true,
    logLevel = "info",      -- "trace|debug|info|warn|error"
    logSpawns = true,
    logDespawns = true,
    logPersistence = true,
    logStateChanges = true,
    logInteractions = true,
}
```

### Example Log Output
```
[Vehicle] Vehicle registered as persistent: ABC1234 by player 1
[Vehicle] Vehicle spawned: ABC1234
[Vehicle] Vehicle state updated: ABC1234
[Vehicle] Vehicle despawned: ABC1234
[Vehicle] Cleaned up 15 abandoned NPC vehicles
```

## Batch Update System

To improve performance, vehicle state changes are:
1. Collected in `ig.vehicleState` table
2. Batched together every 10 seconds
3. Sent to database in bulk
4. Cleared after successful update

```
State Change → Batched → DB Insert/Update
    │             │
    └─ 250ms      └─ 10 second interval
    └─ 500ms      └─ Max 50 vehicles per batch
```

## Cleanup Routine

Automatically removes:
1. **Abandoned NPC vehicles** (30 minutes no interaction)
2. **Abandoned world vehicles** (7 days no interaction)
3. **Excess vehicles** (keeps max 500, removes oldest parked)

### Running Cleanup
```lua
-- Runs every 60 seconds (configurable)
-- Checks timeout settings
-- Deletes from database
-- Clears from cache
-- Logs cleanup results
```

## Integration Points

### With Player Class
```lua
-- On player leave, reassign ownership
if conf.persistence.onPlayerLeave.transferOwnership then
    -- Convert to NPC owner
    -- Clear player identifiers
end
```

### With xVehicle Framework
```lua
-- Automatically persist xvehicle state
conf.persistence.persistStatebag = {
    "xvehicle",
    "vehicle_customization",
    "vehicle_meta",
    "livery_data",
}
```

### With Garage System
- Owned vehicles always persistent
- Player can impound/remove from persistence
- Garage commands integrate with persistence state

## API Functions

### Server-Side

```lua
-- Register vehicle as persistent
ig.vehicle.RegisterVehicle(vehicleEntity, playerId, plate, vehicleType, npcOwner)

-- Spawn vehicle from database
ig.vehicle.SpawnVehicle(vehicleData)

-- Despawn vehicle entity
ig.vehicle.DespawnVehicleEntity(plate, vehicleData)

-- Get vehicle condition
ig.vehicle.GetVehicleCondition(vehicle)

-- Restore vehicle condition
ig.vehicle.RestoreVehicleCondition(vehicle, condition)

-- Get vehicle statebag
ig.vehicle.GetVehicleStatebag(vehicle)

-- Restore vehicle statebag
ig.vehicle.RestoreVehicleStatebag(vehicle, data)
```

### Database Functions

```lua
-- Register persistent
ig.sql.veh.RegisterPersistent(plate, characterId, npcOwner, vehicleType, cb)

-- Update position
ig.sql.veh.UpdatePosition(plate, coords, cb)

-- Update state
ig.sql.veh.UpdateVehicleState(plate, condition, statebag, cb)

-- Update stats
ig.sql.veh.UpdateVehicleStats(plate, fuel, mileage, cb)

-- Despawn vehicle
ig.sql.veh.DespawnVehicle(plate, cb)

-- Get persistent vehicles
ig.sql.veh.GetPersistentVehicles(cb)

-- Log interaction
ig.sql.veh.LogInteraction(plate, playerId, characterId, type, condition, cb)

-- Cleanup abandoned
ig.sql.veh.CleanupAbandonedVehicles(type, timeoutMs, cb)
```

## Performance Considerations

- **Cache Size**: Limited to in-memory vehicles only
- **Batch Updates**: Groups changes to reduce DB queries
- **Proximity Management**: Only checks vehicles within range
- **Cleanup Routine**: Runs in background thread every 60s
- **Database Indexes**: Added on frequently queried fields

## Troubleshooting

### Vehicle Not Persisting
- Check: Is player entering vehicle seat?
- Check: Vehicle has valid plate?
- Check: `enablePersistence` is true?
- Check: Logs for registration confirmation

### Vehicle Not Spawning
- Check: Vehicle within spawn distance?
- Check: Model hash is valid?
- Check: Despawned flag is 0?
- Check: Any player online?

### Performance Issues
- Reduce `maxSpawnsPerTick` (currently 5)
- Increase `spawnTimeout` (currently 10000ms)
- Enable cleanup to remove abandoned vehicles
- Check database performance

## Future Enhancements

Potential additions:
- Vehicle rental system (time-based persistence)
- Tow truck integration (remove vehicle)
- Traffic incident recovery
- Multi-player vehicle state sync
- Vehicle GPS/location tracking
- Insurance tracking integration
