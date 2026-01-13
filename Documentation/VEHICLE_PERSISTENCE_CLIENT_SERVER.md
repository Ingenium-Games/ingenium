# Vehicle Persistence - Client-Server Integration

## Overview

The client-server integration for vehicle persistence has been refactored to work seamlessly with the event-driven architecture:

- **Client Side** (`client/[Events]/_vehicles.lua`): Captures vehicle condition/modifications using `ig.func` utilities
- **Server Side** (`server/[Events]/_vehicle.lua`): Receives data and updates persistence system
- **No Callbacks**: Simple `TriggerServerEvent` instead of callback-based system
- **Automatic Persistence**: Vehicles registered on player entry, updated on exit

---

## Flow Diagram

```
Player Enters Vehicle
  ↓
gameEventTriggered fires (CEventNetworkPlayerEnteredVehicle)
  ↓
Client:EnteredVehicle event fires
  ↓
Client captures condition + modifications using ig.func:
  - ig.func.GetVehicleCondition()
  - ig.func.GetVehicleModifications()
  ↓
TriggerServerEvent("vehicle:persistence:registerCondition", ...)
  ↓
Server receives event
  ↓
ig.vehicle.UpdateVehicleState() updates cache
  ↓
Vehicle added to ig.vehicleCache with condition data
  ↓
JSON synced on next 5-minute interval

---

Player Leaves Vehicle
  ↓
gameEventTriggered fires (CEventNetworkPlayerLeftVehicle)
  ↓
Client:LeftVehicle event fires
  ↓
Client captures final condition + coordinates + fuel
  ↓
TriggerServerEvent("vehicle:persistence:updateCondition", ...)
  ↓
Server receives event
  ↓
ig.vehicle.UpdateVehicleState() updates condition
  ↓
ig.vehicle.UpdateVehicleLocation() updates position
  ↓
Vehicle state persisted in cache
```

---

## Client-Side Event Handlers

### EnteredVehicle Handler

```lua
AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, net)
    -- Validate vehicle exists
    if not DoesEntityExist(vehicle) then return end
    
    -- Capture state using ig.func utilities
    local condition = ig.func.GetVehicleCondition(vehicle)
    local modifications = ig.func.GetVehicleModifications(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    -- Send to server for persistence
    TriggerServerEvent("vehicle:persistence:registerCondition", net, plate, condition, modifications)
end)
```

**Purpose:** Immediately capture and send vehicle condition when player enters

**Data Sent:**
- `net` - Network ID of vehicle
- `plate` - License plate
- `condition` - Full condition data (health, doors, windows, tires, panels)
- `modifications` - All vehicle modifications (mods, colors, liveries)

**When Triggered:**
- Player enters ANY vehicle seat (driver or passenger)
- Uses `ig.func` utilities for consistent data capture

**Server Action:**
- Registers vehicle as persistent
- Stores condition data in cache

---

### LeftVehicle Handler

```lua
AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, net)
    -- Validate vehicle exists
    if not DoesEntityExist(vehicle) then return end
    
    -- Capture final state
    local condition = ig.func.GetVehicleCondition(vehicle)
    local modifications = ig.func.GetVehicleModifications(vehicle)
    local coords = GetEntityCoords(vehicle)
    local heading = GetEntityHeading(vehicle)
    local fuel = GetVehicleFuelLevel(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    
    -- Send final state to server
    TriggerServerEvent("vehicle:persistence:updateCondition", net, plate, condition, modifications, {
        x = coords.x,
        y = coords.y,
        z = coords.z,
        h = heading
    }, fuel)
end)
```

**Purpose:** Capture and send final vehicle state when player leaves

**Data Sent:**
- `net` - Network ID of vehicle
- `plate` - License plate
- `condition` - Final condition (damage from usage)
- `modifications` - Final modifications state
- `coords` - Final vehicle position {x, y, z, h}
- `fuel` - Current fuel level

**When Triggered:**
- Player exits vehicle (any seat)
- Captures state at moment of exit

**Server Action:**
- Updates condition with final damage
- Updates location and fuel
- Saves to cache for persistence

---

## Server-Side Event Handlers

### RegisterCondition Handler

```lua
RegisterNetEvent("vehicle:persistence:registerCondition", function(netId, plate, condition, modifications)
    local source = source  -- Player who triggered
    
    -- Validate
    if not plate or plate == "" then
        ig.log.Warn("Invalid plate from client")
        return
    end
    
    -- Update persistence system
    if ig.vehicle and ig.vehicle.UpdateVehicleState then
        ig.vehicle.UpdateVehicleState(plate, condition, modifications)
    end
    
    -- Log if enabled
    if conf.persistence.logging.enabled then
        ig.log.Debug("Vehicle condition registered: " .. plate)
    end
end)
```

**Purpose:** Receive initial condition data from client on vehicle entry

**Flow:**
1. Validates plate is not empty
2. Calls `ig.vehicle.UpdateVehicleState()` to update cache
3. Logs the registration if logging enabled

**Result:**
- Vehicle now has condition data in cache
- Data will be saved to JSON on next 5-minute sync

---

### UpdateCondition Handler

```lua
RegisterNetEvent("vehicle:persistence:updateCondition", function(netId, plate, condition, modifications, coords, fuel)
    local source = source  -- Player who triggered
    
    -- Validate
    if not plate or plate == "" then
        ig.log.Warn("Invalid plate from client")
        return
    end
    
    -- Update both state and location
    if ig.vehicle then
        ig.vehicle.UpdateVehicleState(plate, condition, modifications)
        ig.vehicle.UpdateVehicleLocation(plate, coords, 0, fuel)
    end
    
    -- Log if enabled
    if conf.persistence.logging.enabled then
        ig.log.Debug("Vehicle updated on exit: " .. plate)
    end
end)
```

**Purpose:** Receive final condition and location data from client on vehicle exit

**Flow:**
1. Validates plate is not empty
2. Calls `ig.vehicle.UpdateVehicleState()` to update condition
3. Calls `ig.vehicle.UpdateVehicleLocation()` to update position and fuel
4. Logs the update if logging enabled

**Result:**
- Vehicle position, fuel, and damage all persisted
- Data will be saved to JSON on next sync

---

## Data Flow: Complete Example

### Scenario: Player enters & drives vehicle

```
TIME 1: Player enters vehicle ABC1234

CLIENT:
  GetVehicleCondition(vehicle)
  → {health: 1000, engineHealth: 1000, doors: {}, windows: {}, ...}
  
  GetVehicleModifications(vehicle)
  → {suspension, engine tuning, paint jobs, ...}
  
  TriggerServerEvent("vehicle:persistence:registerCondition", net, "ABC1234", condition, mods)

SERVER (received):
  → ig.vehicle.UpdateVehicleState("ABC1234", condition, mods)
  → ig.vehicleCache["ABC1234"].condition = condition
  → ig.vehicleCache["ABC1234"].modifications = mods
  
  Cache now: {plate: ABC1234, condition: {...}, modifications: {...}, ...}

---

TIME 2: Player drives for 5 minutes, takes damage

[Vehicle gets damaged, door broken, health reduced]
[Vehicle moves to new location]
[Fuel decreases]

---

TIME 3: Player exits vehicle

CLIENT:
  GetVehicleCondition(vehicle)
  → {health: 850, engineHealth: 920, doors: [{1: damaged}], ...}
  
  GetVehicleModifications(vehicle)
  → [same as before, unchanged]
  
  GetEntityCoords(vehicle)
  → {x: 150.5, y: 250.3, z: 50.0}
  
  GetVehicleNumberPlateText(vehicle)
  → "ABC1234"
  
  GetVehicleFuelLevel(vehicle)
  → 65
  
  TriggerServerEvent("vehicle:persistence:updateCondition", net, "ABC1234", condition, mods, coords, 65)

SERVER (received):
  → ig.vehicle.UpdateVehicleState("ABC1234", condition, mods)
  → ig.vehicle.UpdateVehicleLocation("ABC1234", coords, 0, 65)
  
  Cache now: {
    plate: ABC1234,
    coords: {x: 150.5, y: 250.3, z: 50.0},
    fuel: 65,
    condition: {health: 850, doors: [{1: damaged}], ...},
    modifications: {...}
  }

---

TIME 4: Every 5 minutes, periodic save

SERVER (StartPeriodicSave thread):
  ig.vehicle.SavePersistentVehicles()
  → Writes data/persistent_vehicles.json
  → File now contains final state with damage, location, fuel

---

TIME 5: Server restarts

SERVER (Startup):
  ig.vehicle.LoadPersistentVehicles()
  → Reads data/persistent_vehicles.json
  → Loads ABC1234 with all saved state:
    - Position: {x: 150.5, y: 250.3, z: 50.0}
    - Health: 850
    - Damage: door broken
    - Fuel: 65
    - Modifications: all preserved

---

TIME 6: Player joins and approaches vehicle location

SERVER:
  ig.vehicle.RestorePersistentVehicle(vehicleData)
  → CreateVehicle at saved position
  → SetVehicleCondition with saved damage
  → SetVehicleModifications with saved mods
  → SetVehicleFuelLevel to 65

CLIENT:
  Player sees vehicle exactly as left it:
  ✓ Same location
  ✓ Same damage (broken door)
  ✓ Same health values
  ✓ Same fuel level
  ✓ Same modifications
```

---

## Integration Points

### With ig.func Utilities (Comprehensive Getters)
- `ig.func.GetVehicleCondition()` - Captures: health, body, engine, fuel, doors, windows, tires
- `ig.func.GetVehicleModifications()` - Captures: all vehicle mods
- `ig.func.GetVehicleStatebag()` - **NEW**: Captures ALL entity statebag data (including custom script additions)
- All functions already exist or newly added, no duplication
- Future-proof: New script modifications to statebag automatically captured

### With Existing Events
- `Client:EnteredVehicle` - From gameEventTriggered
- `Client:LeftVehicle` - From gameEventTriggered
- `Server:OnPlayerEnteredVehicle` - Already fired by server

### With Persistence System
- `ig.vehicle.UpdateVehicleState()` - Update cache with condition & mods
- `ig.vehicle.UpdateVehicleLocation()` - Update cache with position
- Both functions added to server/_vehicle_persistence.lua

---

## Benefits of This Approach

✅ **No Callbacks:** Simple TriggerServerEvent instead of callback system
✅ **Immediate Registration:** Condition captured on entry, not delayed
✅ **Final State Capture:** Exit handler captures final damage/position/fuel
✅ **Uses Existing Utilities:** ig.func already has all needed functions
✅ **Event-Driven:** No polling, reactive to player actions
✅ **Clean Data Flow:** Client captures, server receives, persistence saves
✅ **Automatic Persistence:** No manual registration needed by other systems
✅ **Minimal Network Traffic:** Only two events per vehicle lifetime

---

## Configuration

No special configuration needed. Uses existing settings:

```lua
conf.persistence.logging.enabled     -- Log vehicle events
conf.persistence.enablePersistence   -- Master toggle
```

---

## Troubleshooting

### Vehicle not registering on entry?
- Check: Is `ig.vehicle` initialized?
- Check: Is `Server:OnPlayerEnteredVehicle` firing?
- Check: Client sending event with correct parameters?
- Enable logging: `conf.persistence.logging.enabled = true`

### Condition not persisting?
- Check: Does `ig.func.GetVehicleCondition()` exist?
- Check: Is client sending condition data?
- Check: Server receiving event?
- Verify: ig.vehicleCache has condition data

### Position not updating on exit?
- Check: Client captures coords correctly?
- Check: Server handler receiving coords?
- Check: `ig.vehicle.UpdateVehicleLocation()` called?

---

## Summary

The client-server integration is **simple, event-driven, and automatic**:

1. **Client Side:** Capture condition/mods using ig.func, send events to server
2. **Server Side:** Receive events, update persistence cache
3. **Result:** Vehicles automatically persist with complete state

No manual registration needed, no callbacks, no polling. Just events!

