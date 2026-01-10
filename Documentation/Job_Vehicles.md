# Job-Owned Vehicles System

## Overview

The Job-Owned Vehicles system allows certain jobs to spawn predefined vehicles at no cost based on job role and grade. This feature integrates seamlessly with the existing Ingenium garage system and provides server-side validation to ensure security.

## Features

- **Job-based vehicle access**: Configure specific vehicles for each job
- **Grade requirements**: Set minimum grades for vehicle access
- **Role restrictions**: Optionally restrict vehicles to specific job roles
- **Free spawning**: Job vehicles spawn at no cost to the player
- **Server-side validation**: All permissions and spawning handled server-side for security
- **Integrated UI**: Job vehicles appear in the existing garage interface

## Configuration

### Job Vehicles Configuration File

Location: `data/job_vehicles.json`

The configuration file defines which vehicles are available to each job:

```json
{
  "jobId": [
    {
      "model": "vehicleModel",
      "name": "Display Name",
      "minGrade": 1,
      "allowedRoles": ["Role 1", "Role 2"],
      "description": "Optional description"
    }
  ]
}
```

#### Configuration Fields

- **model** (required): The spawn name of the vehicle (e.g., "police", "ambulance")
- **name** (required): Display name shown in the UI
- **minGrade** (optional): Minimum grade/rank required (default: 1)
- **allowedRoles** (optional): Array of specific role names that can access this vehicle (overrides minGrade)
  - **Note:** Role names must exactly match those in `data/jobs.json` (case-sensitive, including any typos)
- **description** (optional): Description shown in the UI

### Job Grades

The system reads job grades from `data/jobs.json`. Each job role has a `rank` field that determines the grade level:

```json
{
  "police": {
    "Cadet": {
      "org": "Police Department",
      "rank": 1,
      "pay": 17
    },
    "Officer": {
      "org": "Police Department",
      "rank": 3,
      "pay": 26
    }
  }
}
```

## Example Configurations

### Police Department Vehicles

```json
{
  "police": [
    {
      "model": "police",
      "name": "Police Cruiser",
      "minGrade": 1,
      "description": "Standard patrol vehicle"
    },
    {
      "model": "police2",
      "name": "Police Interceptor",
      "minGrade": 3,
      "description": "High-speed pursuit vehicle"
    },
    {
      "model": "riot",
      "name": "SWAT Riot Van",
      "minGrade": 4,
      "allowedRoles": ["Senior Officer", "Cheif of Police"],
      "description": "Armored vehicle for special operations"
    }
  ]
}
```

**Note:** Role names like "Cheif of Police" must exactly match the spelling in `data/jobs.json`, even if misspelled.

### EMS Vehicles

```json
{
  "medic": [
    {
      "model": "ambulance",
      "name": "Ambulance",
      "minGrade": 1,
      "description": "Emergency medical response vehicle"
    },
    {
      "model": "firetruk",
      "name": "Fire Truck",
      "minGrade": 3,
      "allowedRoles": ["Doctor", "Cheif Medical Officer"],
      "description": "Fire and rescue vehicle"
    }
  ]
}
```

### Mechanic Vehicles

```json
{
  "mechanic": [
    {
      "model": "towtruck",
      "name": "Tow Truck",
      "minGrade": 1,
      "description": "Vehicle recovery truck"
    },
    {
      "model": "flatbed",
      "name": "Flatbed Truck",
      "minGrade": 2,
      "description": "Heavy duty vehicle transport"
    }
  ]
}
```

## Integration

### File Structure

The job vehicles system consists of the following files:

```
ingenium/
├── data/
│   └── job_vehicles.json              # Vehicle configuration
├── server/[Garage]/
│   └── _job_vehicles.lua              # Server-side logic
├── client/[Garage]/
│   └── _job_vehicles.lua              # Client-side handler
└── nui/src/components/
    ├── GarageMenu.vue                  # Updated to include job vehicles
    └── GarageJobVehicles.vue          # Job vehicles UI component
```

### fxmanifest.lua Integration

The system is automatically loaded via `fxmanifest.lua`:

**Server Scripts** (already added):
```lua
"server/[Garage]/_job_vehicles.lua",
```

**Client Scripts** (already added):
```lua
"client/[Garage]/_job_vehicles.lua",
```

**Data Files** (already included via pattern):
```lua
files {
    "data/*.json",
    -- other files...
}
```

### UI Integration

The job vehicles component is integrated into the existing garage menu. When a player opens the garage:

1. Their personal vehicles are shown in the top section
2. Job vehicles (if available) are shown in a separate section below
3. Job vehicles are filtered server-side based on the player's current job and grade

## Server Exports

### GetJobVehiclesForPlayer

Get all job vehicles available to a specific player.

```lua
-- Usage
local vehicles = exports.ingenium:GetJobVehiclesForPlayer(playerId)

-- Returns: Array of vehicle configs
-- Example: {
--   {model = "police", name = "Police Cruiser", description = "...", minGrade = 1},
--   {model = "police2", name = "Police Interceptor", description = "...", minGrade = 3}
-- }
```

### SpawnVehicleForPlayer

Generic export for spawning vehicles (can be used by other systems).

```lua
-- Usage
local success, netId = exports.ingenium:SpawnVehicleForPlayer(playerId, "police", {
    x = 0.0,
    y = 0.0,
    z = 0.0,
    h = 0.0
})

if success then
    print("Vehicle spawned with network ID: " .. netId)
else
    print("Failed to spawn vehicle: " .. netId)
end
```

## Server Callbacks

### ingenium:GetJobVehicles

Client can request available job vehicles for the calling player.

```lua
-- Client-side usage
local vehicles = ig.callback.Await("ingenium:GetJobVehicles")
```

### ingenium:SpawnJobVehicle

Client can request to spawn a job vehicle (with server-side validation).

```lua
-- Client-side usage
local success, result = ig.callback.Await("ingenium:SpawnJobVehicle", "police", {
    x = 0.0, y = 0.0, z = 0.0, h = 0.0
})
```

## Security

### Server-Side Validation

All job vehicle permissions and spawning are validated server-side:

1. **Player validation**: Ensures the requesting player exists
2. **Job validation**: Checks if player has a job with configured vehicles
3. **Vehicle validation**: Verifies the requested vehicle is in the job's config
4. **Grade validation**: Checks player's grade meets minimum requirements
5. **Role validation**: If specified, checks player's role matches allowed roles
6. **Spawn location validation**: Ensures valid spawn coordinates are provided

### Logging

The system includes comprehensive logging:

- Debug logs for vehicle requests and spawns
- Alert logs for invalid requests or errors
- All logs use the project's standard logging functions (`ig.func.Debug_1`, `ig.func.Alert`)

## Usage

### For Players

1. Approach any parking machine
2. Interact with the machine to open the garage
3. Personal vehicles appear in the top section
4. Job vehicles (if available) appear in the "Job Vehicles" section
5. Click "Spawn Vehicle" to spawn a job vehicle
6. Vehicle spawns at the nearest available parking spot

### For Administrators

#### Adding New Job Vehicles

1. Edit `data/job_vehicles.json`
2. Add vehicle configuration to the appropriate job
3. Restart the resource or server

Example:
```json
{
  "police": [
    {
      "model": "policeb",
      "name": "Police Motorcycle",
      "minGrade": 2,
      "description": "Patrol motorcycle for quick response"
    }
  ]
}
```

#### Creating a New Job with Vehicles

1. Ensure the job exists in `data/jobs.json`
2. Add a new entry in `data/job_vehicles.json`:

```json
{
  "taxi": [
    {
      "model": "taxi",
      "name": "Taxi Cab",
      "minGrade": 1,
      "description": "Standard taxi vehicle"
    }
  ]
}
```

## Troubleshooting

### Vehicles Not Showing

- Check that the job ID in `job_vehicles.json` matches the job ID in `jobs.json`
- Verify the player's grade meets the `minGrade` requirement
- Check server console for debug messages (enable with `conf.debug_1 = true`)

### Spawn Failures

- Ensure parking spots are available and clear
- Check that vehicle models are valid and loaded
- Review server logs for specific error messages

### Permission Issues

- Verify role names in `allowedRoles` exactly match role names in `jobs.json`
- Check that grade ranks are correctly configured
- Ensure player's job data is properly loaded

## Customization

### Hooking Vehicle Spawn

To integrate with a custom vehicle spawn system, modify the spawn logic in `server/[Garage]/_job_vehicles.lua`:

```lua
-- Replace the CreateVehicle section with your custom spawn logic
-- Example:
local entity = exports.yourResource:CustomSpawnVehicle(vehicleModel, spawnLocation)
```

### Custom UI Styling

The job vehicles component can be styled by editing `nui/src/components/GarageJobVehicles.vue`. All styles are scoped to the component.

### Adding Vehicle Properties

To add custom properties (fuel, extras, etc.), modify the spawn callback in `server/[Garage]/_job_vehicles.lua` after the vehicle is created:

```lua
-- After vehicle creation:
if DoesEntityExist(entity) then
    -- Set fuel
    Entity(entity).state.fuel = 100
    
    -- Enable extras
    SetVehicleExtra(entity, 1, 0)
end
```

## Future Enhancements

Potential improvements for the system:

- **Cooldown system**: Prevent spam spawning
- **Vehicle tracking**: Track which players spawned which job vehicles
- **Automatic return**: Return job vehicles when player goes off-duty
- **Customization per vehicle**: Allow per-vehicle cosmetic modifications
- **Usage logging**: Log job vehicle usage for administrative purposes

## Support

For issues or questions:

1. Check server console logs with debug enabled
2. Verify configuration syntax in JSON files
3. Review this documentation for proper setup
4. Check that all files are properly loaded in `fxmanifest.lua`
