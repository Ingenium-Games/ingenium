# Job-Specific Vehicle Spawning System

## Overview

The Job-Specific Vehicle Spawning System allows players with specific jobs to spawn job-appropriate vehicles at designated locations without any cost. This system is ideal for roleplaying scenarios where emergency services, mechanics, or other job-specific roles need quick access to their work vehicles.

## Features

- **Job-Based Access Control**: Only players with the correct job can use spawners
- **Grade Requirements**: Optional minimum grade requirements for spawners
- **Free Vehicle Spawning**: No cost for job members
- **Target System Integration**: Uses the existing prop targeting system
- **Vue 3 UI**: Modern, responsive vehicle selection menu
- **Multiple Spawners**: Support for multiple locations per job
- **Multiple Vehicles**: Each spawner can offer multiple vehicle types

## Configuration

### Location

Configuration is in `_config/job_vehicles.lua`

### Basic Settings

```lua
-- Enable/disable the entire system
conf.job_vehicles.enabled = true

-- Distance settings
conf.job_vehicles.interaction_distance = 2.5  -- Distance to interact with prop
conf.job_vehicles.spawn_offset = 5.0          -- Distance from prop to spawn vehicle

-- Prop model for spawners (default: traffic cone)
conf.job_vehicles.spawner_prop = `prop_roadcone02a`
```

### Adding Spawners

Each spawner definition includes:

```lua
{
    job = "police",              -- Job name required to use this spawner
    grade = nil,                 -- Minimum grade (nil = any grade)
    label = "Police Vehicle Spawner",  -- Display name
    prop = {                     -- Interaction prop location
        x = 438.42,
        y = -1018.09,
        z = 28.59,
        h = 90.0
    },
    spawn = {                    -- Vehicle spawn location
        x = 438.42,
        y = -1026.35,
        z = 28.48,
        h = 90.0
    },
    vehicles = {                 -- Available vehicles
        {model = "police", label = "Police Cruiser"},
        {model = "police2", label = "Police Buffalo"},
        {model = "police3", label = "Police Interceptor"},
    }
}
```

## Example Configurations

### Police Department Spawner

```lua
{
    job = "police",
    grade = nil,  -- Any police officer can use
    label = "Police Vehicle Spawner",
    prop = {x = 438.42, y = -1018.09, z = 28.59, h = 90.0},
    spawn = {x = 438.42, y = -1026.35, z = 28.48, h = 90.0},
    vehicles = {
        {model = "police", label = "Police Cruiser"},
        {model = "police2", label = "Police Buffalo"},
        {model = "police3", label = "Police Interceptor"},
        {model = "sheriff", label = "Sheriff Cruiser"},
        {model = "policeb", label = "Police Bike"},
    }
}
```

### EMS Station Spawner

```lua
{
    job = "ems",
    grade = nil,
    label = "EMS Vehicle Spawner",
    prop = {x = 307.68, y = -1433.26, z = 29.97, h = 230.0},
    spawn = {x = 297.09, y = -1429.01, z = 29.75, h = 230.0},
    vehicles = {
        {model = "ambulance", label = "Ambulance"},
    }
}
```

### Mechanic Shop with Grade Requirement

```lua
{
    job = "mechanic",
    grade = 2,  -- Requires grade 2 or higher
    label = "Mechanic Vehicle Spawner",
    prop = {x = -197.69, y = -1339.39, z = 34.89, h = 180.0},
    spawn = {x = -197.69, y = -1344.88, z = 34.02, h = 180.0},
    vehicles = {
        {model = "towtruck", label = "Tow Truck"},
        {model = "towtruck2", label = "Flatbed Tow Truck"},
        {model = "utillitruck3", label = "Utility Truck"},
    }
}
```

## Usage

### For Players

1. **Approach the spawner prop** (default: traffic cone)
2. **Look at the prop** to see the target prompt
3. **Press the interaction key** (default: Left Alt) to open the menu
4. **Select a vehicle** from the menu by clicking on it
5. **Vehicle spawns** at the designated location and player is placed inside

### For Server Owners

1. **Configure spawners** in `_config/job_vehicles.lua`
2. **Set job names** to match your job system
3. **Position props and spawn points** using coordinates
4. **Add vehicle models** that exist in your server
5. **Restart resource** to apply changes

## Finding Coordinates

Use the built-in development tools:

```lua
-- In-game console or F8
/getcoords
```

This will output your current position and heading, which you can use for `prop` and `spawn` locations.

## Customizing Props

You can change the prop model used for spawners:

```lua
-- Use a different prop model
conf.job_vehicles.spawner_prop = `prop_parking_sign_07`

-- Or use a hash directly
conf.job_vehicles.spawner_prop = 0x356E6A9B
```

Common prop models:
- `prop_roadcone02a` - Traffic cone (default)
- `prop_parking_sign_07` - Parking sign
- `prop_traffic_01a` - Construction sign
- `v_ilev_fos_panel` - Panel/terminal

## System Architecture

### Client-Side (`client/[Job Vehicles]/_job_vehicles.lua`)

- Creates spawner props at configured locations
- Integrates with target system for interactions
- Handles vehicle selection menu
- Manages vehicle spawning callbacks

### Server-Side (`server/[Callbacks]/_job_vehicles.lua`)

- Validates player job and grade
- Handles vehicle creation
- Logs spawning events
- Returns network IDs to client

### UI (`nui/src/components/JobVehiclesMenu.vue`)

- Modern Vue 3 component
- Grid-based vehicle selection
- Keyboard support (ESC to close)
- Smooth animations

## API Reference

### Server Callbacks

#### JobVehicles:GetVehicles

Get available vehicles for a spawner.

```lua
TriggerServerCallback({
    eventName = "JobVehicles:GetVehicles",
    args = {spawnerId},
    callback = function(vehicles)
        -- Returns array of vehicles or false
    end
})
```

#### JobVehicles:SpawnVehicle

Spawn a vehicle from a spawner.

```lua
TriggerServerCallback({
    eventName = "JobVehicles:SpawnVehicle",
    args = {spawnerId, vehicleIndex},
    callback = function(netId)
        -- Returns network ID or false
    end
})
```

### Client Functions

#### ig.job_vehicles.Init()

Initialize all spawners. Called automatically on player load.

#### ig.job_vehicles.CreateSpawner(id, spawner)

Create a single spawner prop and target.

#### ig.job_vehicles.OpenMenu(spawnerId)

Open the vehicle selection menu for a spawner.

#### ig.job_vehicles.SpawnVehicle(spawnerId, vehicleIndex)

Request vehicle spawn from server.

#### ig.job_vehicles.Cleanup()

Remove all spawner props. Called on resource stop.

## Troubleshooting

### Props Not Appearing

1. Check that coordinates are correct
2. Verify prop model exists
3. Check console for errors
4. Ensure resource started properly

### Target Not Working

1. Verify target system is enabled
2. Check `canInteract` function in code
3. Ensure player has correct job
3. Try different interaction distance

### Vehicles Not Spawning

1. Check vehicle model exists in server
2. Verify spawn point is not blocked
3. Check server console for errors
4. Ensure player job matches spawner

### Menu Not Opening

1. Check NUI is working
2. Verify Vue component is imported
3. Check browser console (F12)
4. Ensure callback is registered

## Best Practices

### Placement

- Place spawners near logical locations (stations, garages)
- Ensure spawn points are clear of obstructions
- Test spawning with different vehicle sizes

### Balance

- Limit high-tier vehicles to higher grades
- Consider spawn cooldowns if needed (not included)
- Balance vehicle selection per job

### Performance

- Don't create too many spawners in one area
- Use appropriate prop models
- Clean up old spawners if locations change

## Future Enhancements

Potential additions:
- Spawn cooldowns
- Vehicle limits per player
- Custom prop models per spawner
- Vehicle persistence/tracking
- Spawn notifications to nearby players
- Job-specific vehicle customization

## Related Systems

- [Target System](../Documentation/Target_System_API.md)
- [Garage System](../Documentation/Garage_System.md)
- [Job System](../Documentation/Job_System.md)
- [Vehicle System](../Documentation/Vehicle_System.md)

---

**Note**: This system integrates with the existing ingenium framework. Ensure your job names in the configuration match your actual job system setup.
