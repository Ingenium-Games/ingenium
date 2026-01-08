# Garage System Documentation

## Overview
Integrated vehicle garage and parking system for ingenium framework. Formerly `ig.garage`, now built into the core framework with Vue 3 UI integration.

**Location:** `client/[Garage]/` and `server/[Garage]/`
**Configuration:** `_config/garage.lua`
**UI Component:** `nui/src/components/GarageMenu.vue`

## Table of Contents
- [Features](#features)
- [Client-Side](#client-side)
- [Server-Side](#server-side)
- [UI System](#ui-system)
- [Configuration](#configuration)
- [Parking Spots](#parking-spots)
- [Integration](#integration)

---

## Features

- **900+ Parking Locations** across the map
- **Parking Machine Interactions** using integrated targeting system
- **Vehicle Storage & Retrieval** with SQL integration
- **Vue 3 UI** for modern, responsive interface
- **Real-time Status** showing parked vs. out vehicles
- **Blip System** (optional) for garage locations
- **Fee System** (optional) for parking/retrieval charges

---

## Client-Side

### Main Files

#### _var.lua
Contains parking spot locations and global variables.

**Parking Spots Structure:**
```lua
ParkingSpots = {
    {x=-61.02, y=-1118.52, z=25.99, h=342.99},
    {x=140.43, y=-725.22, z=32.82, h=158.74},
    -- 900+ more locations
}
```

**Global Variables:**
```lua
TicketMachine = `prop_parkingpay`  -- Machine prop model
MachinePosition = nil              -- Current machine location
AtMachine = false                  -- Within interaction distance
OpenMachine = false                -- UI is open
UseMachine = false                 -- Animation playing
VehicleData = {}                   -- Player's vehicles
VehicleBlip = nil                  -- Vehicle location blip
```

---

#### _client.lua
Handles entity creation and management.

**Functions:**
- Creates parking machine props at configured locations
- Manages entity lifecycle
- Handles prop placement and rotation

---

#### _blips.lua
Manages map blips for parking locations.

**Configuration:**
```lua
conf.garage.ui.show_blips = false  -- Enable/disable blips
conf.garage.ui.blip_sprite = 50    -- Blip icon
conf.garage.ui.blip_color = 3      -- Blip color
```

**Usage:**
```lua
-- Blips are automatically created based on Props table
-- Each prop location gets a blip if enabled
```

---

#### _machine.lua
Handles parking machine interactions and animations.

**Features:**
- Targeting system integration
- Player animations during interaction
- UI opening/closing
- Vehicle retrieval confirmation

**Interaction Flow:**
1. Player approaches parking machine
2. Target prompt appears
3. Player selects "Access Garage"
4. Animation plays
5. UI opens with vehicle list
6. Player selects vehicle
7. Vehicle spawns at nearest spot
8. UI closes

---

### Client-Side Events

#### Open Garage UI
```lua
-- Triggered by machine interaction
TriggerEvent('garage:open', vehicleData)
```

#### Close Garage UI
```lua
-- Triggered by ESC or close button
TriggerEvent('garage:close')
```

#### Spawn Vehicle
```lua
-- Triggered when player selects vehicle
TriggerServerEvent('garage:spawnVehicle', plate)
```

---

## Server-Side

### Main Files

#### _var.lua
Contains server-side vehicle data (42KB file with extensive vehicle information).

---

#### _callbacks.lua
Server callbacks for vehicle data retrieval.

**Callback Examples:**
```lua
-- Get player vehicles
TriggerServerCallback({
    eventName = 'garage:getVehicles',
    args = {},
    callback = function(vehicles)
        -- vehicles = array of player's vehicles
    end
})
```

---

#### _server.lua
Server-side logic for vehicle management.

**Functions:**
- Vehicle spawning
- Database integration
- State synchronization
- Parking fee processing

---

### Server-Side Events

#### Get Vehicles
```lua
RegisterServerEvent('garage:getVehicles')
AddEventHandler('garage:getVehicles', function()
    local src = source
    -- Query database for player vehicles
    -- Return vehicle data to client
end)
```

#### Spawn Vehicle
```lua
RegisterServerEvent('garage:spawnVehicle')
AddEventHandler('garage:spawnVehicle', function(plate)
    local src = source
    -- Validate ownership
    -- Update database (set Parked = false)
    -- Spawn vehicle for player
    -- Apply vehicle modifications
end)
```

#### Park Vehicle
```lua
RegisterServerEvent('garage:parkVehicle')
AddEventHandler('garage:parkVehicle', function(plate, location)
    local src = source
    -- Update database (set Parked = true)
    -- Store location data
    -- Process parking fees if enabled
end)
```

---

## UI System

### Vue Component
**Location:** `nui/src/components/GarageMenu.vue`

#### Features
- Modern, responsive design
- Smooth animations
- Keyboard support (ESC to close)
- Real-time vehicle status
- Click-to-retrieve interaction

#### Component Structure
```vue
<template>
  <div v-if="isVisible" class="garage-container">
    <div class="garage-menu">
      <div class="garage-header">
        <h2>Garage and Parked Vehicles</h2>
        <button @click="closeGarage">✕</button>
      </div>
      
      <div class="garage-content">
        <table class="garage-table">
          <thead>
            <tr>
              <th>Plate</th>
              <th>Name</th>
              <th>Retrieve</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="vehicle in vehicles">
              <td>{{ vehicle.Plate }}</td>
              <td>{{ vehicle.Model }}</td>
              <td>
                <button v-if="vehicle.Parked" 
                        @click="retrieveVehicle(vehicle.Plate)">
                  Return Vehicle
                </button>
                <span v-else>OUT</span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
```

---

### UI Communication

#### Open Garage
```lua
-- Client-side
SendNUIMessage({
    message = 'garage:open',
    data = vehicleData
})
```

#### Close Garage
```lua
-- Client-side
SendNUIMessage({
    message = 'garage:close'
})
```

#### Vehicle Selected
```javascript
// NUI JavaScript
sendNuiMessage('GUI:SelectVehicle', { Plate: plate })
```

---

## Configuration

### Main Configuration File
**Location:** `_config/garage.lua`

### Basic Settings

```lua
-- Enable/disable garage system
conf.garage.enabled = true

-- Parking machine prop model
conf.garage.machine_prop = `prop_parkingpay`

-- Distance settings
conf.garage.interaction_distance = 2.5  -- Interaction range
conf.garage.parking_spot_radius = 2.0   -- Spot detection radius
```

---

### UI Settings

```lua
conf.garage.ui = {
    show_blips = false,  -- Show parking location blips
    blip_sprite = 50,    -- Blip icon ID
    blip_color = 3,      -- Blip color ID
}
```

---

### Vehicle Retrieval Settings

```lua
conf.garage.retrieval = {
    spawn_in_vehicle = true,   -- Put player in vehicle
    repair_on_spawn = false,   -- Repair vehicle when spawning
    fuel_on_spawn = 100,       -- Set fuel level (0-100)
}
```

---

### Fee System (Optional)

```lua
conf.garage.fees = {
    enabled = false,      -- Enable parking/retrieval fees
    parking_fee = 0,      -- Fee to park vehicle
    retrieval_fee = 0,    -- Fee to retrieve vehicle
}
```

**To enable fees:**
```lua
conf.garage.fees = {
    enabled = true,
    parking_fee = 50,     -- $50 to park
    retrieval_fee = 25,   -- $25 to retrieve
}
```

---

### Integration Settings

```lua
conf.garage.integration = {
    use_sql_vehicles = true,   -- Use ingenium vehicle SQL system
    sync_parked_state = true,  -- Sync parked state to database
}
```

---

## Parking Spots

### Location Data

900+ parking spots are defined in `client/[Garage]/_var.lua`:

```lua
ParkingSpots = {
    -- Legion Square
    {x=-61.02, y=-1118.52, z=25.99, h=342.99},
    {x=-57.39, y=-1117.86, z=25.99, h=340.16},
    
    -- Pillbox Hill
    {x=140.43, y=-725.22, z=32.82, h=158.74},
    {x=133.2, y=-741.72, z=32.82, h=158.74},
    
    -- And 900+ more across the map
}
```

### Adding New Spots

```lua
-- Add to ParkingSpots table in client/[Garage]/_var.lua
table.insert(ParkingSpots, {
    x = 100.0,    -- X coordinate
    y = -200.0,   -- Y coordinate
    z = 30.0,     -- Z coordinate
    h = 90.0,     -- Heading (vehicle rotation)
})
```

### Parking Machine Props

```lua
-- Add to Props table in client/[Garage]/_var.lua
Props = {
    {x=-934.63, y=-2076.8, z=9.3, h=127.56},
    -- Coordinates for parking machine prop
}
```

---

## Integration

### SQL Integration

The garage system integrates with ingenium's vehicle SQL system (`server/[SQL]/_vehicles.lua`).

**Database Fields:**
- `Plate` - Vehicle license plate (primary key)
- `Model` - Vehicle model name
- `Parked` - Boolean parking status
- `GarageLocation` - Last known garage location
- `Owner` - Player identifier

**Example Query:**
```lua
-- Get player vehicles
local vehicles = exports['ingenium']:GetPlayerVehicles(identifier)

-- Update parking status
exports['ingenium']:UpdateVehicleParkedStatus(plate, true)
```

---

### Targeting System Integration

The garage uses the integrated targeting system for machine interactions:

```lua
exports['ingenium']:AddModel(`prop_parkingpay`, {
    {
        icon = 'fas fa-car',
        label = 'Access Garage',
        action = function(entity)
            -- Open garage UI
            TriggerEvent('garage:open')
        end,
    },
})
```

---

## Usage Examples

### Example 1: Basic Garage Access

```lua
-- Player approaches parking machine
-- Target option appears: "Access Garage"
-- Player presses interaction key
-- UI opens showing all vehicles
-- Player clicks "Return Vehicle" on a parked car
-- Vehicle spawns at nearest parking spot
```

---

### Example 2: Parking a Vehicle

```lua
-- Player drives vehicle to parking area
-- Exits vehicle near parking machine
-- Accesses garage UI
-- Selects "Park Vehicle" option
-- Vehicle is stored in database
-- Vehicle despawns
```

---

### Example 3: Custom Garage Location

```lua
-- Add new garage location
-- 1. Add parking spots in _var.lua
ParkingSpots = {
    -- Existing spots...
    -- New custom location
    {x=1200.0, y=-3000.0, z=5.0, h=0.0},
    {x=1205.0, y=-3000.0, z=5.0, h=0.0},
    {x=1210.0, y=-3000.0, z=5.0, h=0.0},
}

-- 2. Add parking machine prop
Props = {
    -- Existing props...
    {x=1207.5, y=-2995.0, z=5.5, h=180.0},
}

-- 3. Optionally add blip in _blips.lua
```

---

## Best Practices

### Performance
1. **Limit active props** - Only spawn props near players
2. **Use culling** - Despawn distant props
3. **Optimize parking spots** - Don't check all 900+ spots every frame

### Security
1. **Validate ownership** - Always check vehicle ownership server-side
2. **Prevent exploits** - Verify vehicle exists and is parked before spawning
3. **Rate limiting** - Prevent rapid spawning/despawning

### User Experience
1. **Clear feedback** - Show notifications for parking/retrieval
2. **Nearest spot** - Spawn vehicles at the closest available spot
3. **Vehicle state** - Preserve vehicle damage, fuel, modifications

---

## Troubleshooting

### UI Not Opening
- Check if `conf.garage.enabled = true`
- Verify targeting system is working
- Check console for NUI errors
- Ensure Vue component is imported in App.vue

### Vehicles Not Spawning
- Verify SQL integration is enabled
- Check vehicle ownership in database
- Ensure parking spots array is populated
- Check for spawn point obstructions

### Blips Not Showing
- Set `conf.garage.ui.show_blips = true`
- Verify Props table has locations
- Check blip sprite and color IDs

### Parking Machines Missing
- Verify Props table in _var.lua
- Check if prop model exists (`prop_parkingpay`)
- Ensure _client.lua is loading

---

## API Reference

### Client Exports

```lua
-- Get nearest parking spot
local spot = exports['ingenium']:GetNearestParkingSpot(coords)

-- Check if location is a parking area
local isParking = exports['ingenium']:IsInParkingArea(coords)

-- Open garage UI manually
exports['ingenium']:OpenGarage()

-- Close garage UI manually
exports['ingenium']:CloseGarage()
```

### Server Exports

```lua
-- Get player vehicles
local vehicles = exports['ingenium']:GetPlayerVehicles(identifier)

-- Park vehicle
exports['ingenium']:ParkVehicle(plate, location)

-- Unpark vehicle
exports['ingenium']:UnparkVehicle(plate)

-- Check if vehicle is parked
local isParked = exports['ingenium']:IsVehicleParked(plate)
```

---

## Related Documentation
- [Target System API](Target_System_API.md)
- [SQL API Reference](SQL_API_Reference.md)
- [Development Tools](Development_Tools.md)
- [Vehicle System](Vehicle_System.md)
