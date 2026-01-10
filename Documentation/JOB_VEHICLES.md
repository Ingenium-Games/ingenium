# Job-Owned Vehicle System

## Overview

This system allows server administrators to configure job-specific vehicles that can be spawned by players with the appropriate job, rank, and/or role. Job vehicles spawn at no cost and are automatically integrated into the existing garage UI.

## Features

- **Framework Auto-Detection**: Automatically detects QBCore or ESX frameworks
- **Flexible Configuration**: Support for numeric grades and/or string-based roles
- **Server-Side Security**: All permission checks performed server-side
- **No Cost Spawning**: Job vehicles spawn without charging the player
- **UI Integration**: Seamlessly integrated into existing garage menu
- **Easy to Extend**: Simple configuration format for adding new jobs and vehicles

## File Structure

```
_config/
  └── job_vehicles.lua          # Job vehicle configuration

server/[Garage]/
  └── garage_job_vehicles.lua   # Server-side logic and validation

client/[Garage]/
  └── garage_job_vehicles.lua   # Client-side spawn handler

nui/src/components/
  ├── GarageMenu.vue            # Updated to include job vehicles
  └── GarageJobVehicles.vue     # Job vehicles UI component
```

## Configuration

### Adding Job Vehicles

Edit `_config/job_vehicles.lua` to add or modify job vehicles:

```lua
conf.garage.job_vehicles = {
  police = {
    vehicles = {
      { model = "police", label = "Police Cruiser", minGrade = 0 },
      { model = "police2", label = "Police Interceptor", minGrade = 2 },
      { model = "fbi", label = "Unmarked Cruiser", minGrade = 5 }
    }
  },
  
  ambulance = {
    vehicles = {
      { model = "ambulance", label = "Standard Ambulance", minGrade = 0 },
      { model = "firetruk", label = "Fire Truck", minGrade = 2 }
    }
  }
}
```

### Configuration Options

Each vehicle entry supports:

- `model` (required): Vehicle spawn name
- `label` (required): Display name in UI
- `minGrade` (optional): Minimum numeric grade/rank required
- `roles` (optional): Array of role names allowed
- `spawnProps` (optional): Additional spawn properties

### Permission Logic

- If **only** `minGrade` is specified: Player must have that grade or higher
- If **only** `roles` is specified: Player must have at least one of the roles
- If **both** are specified: Player must meet both conditions
- If **neither** is specified: Any player with that job can spawn the vehicle

### Examples

#### Grade-Based Access
```lua
{ model = "police3", label = "Police SUV", minGrade = 3 }
```
Only players with police job and grade 3+ can spawn.

#### Role-Based Access
```lua
{ model = "towtruck", label = "Tow Truck", roles = {"technician", "senior_technician"} }
```
Only players with mechanic job and one of the specified roles can spawn.

#### Combined Requirements
```lua
{ model = "riot", label = "SWAT Van", minGrade = 4, roles = {"swat_member", "swat_leader"} }
```
Player must be grade 4+ AND have one of the specified roles.

## Framework Support

### QBCore
Automatically reads from:
- `player.PlayerData.job.name` (job)
- `player.PlayerData.job.grade.level` or `player.PlayerData.job.grade` (grade)
- `player.PlayerData.metadata.jobRole` (roles, if available)

### ESX
Automatically reads from:
- `xPlayer.job.name` (job)
- `xPlayer.job.grade` (grade)
- Roles not typically available in ESX

### Custom Framework
If neither QBCore nor ESX is detected, you must implement the `getPlayerJobInfo` function in `server/[Garage]/garage_job_vehicles.lua`:

```lua
local function getPlayerJobInfo(source)
  -- Your custom implementation
  return { 
    job = "jobname", 
    grade = 2, 
    roles = {"role1", "role2"} 
  }
end
```

## API

### Server Events

#### `ingenium:requestJobVehicles`
**Type**: Client → Server  
**Description**: Request list of allowed job vehicles for the requesting player  
**Response**: Triggers `ingenium:receiveJobVehicles` on client with vehicle array

#### `ingenium:spawnJobVehicle`
**Type**: Client → Server  
**Data**: `{ model: string, spawnCoords?: {x, y, z, h} }`  
**Description**: Request to spawn a job vehicle (validated server-side)  
**Response**: Triggers `ingenium:clientSpawnVehicle` on client if authorized

### Client Events

#### `ingenium:receiveJobVehicles`
**Type**: Server → Client  
**Data**: Array of allowed vehicles  
**Description**: Receives list of vehicles player can spawn

#### `ingenium:clientSpawnVehicle`
**Type**: Server → Client  
**Data**: `{ model: string, coords?: {x, y, z, h}, jobVehicle: boolean }`  
**Description**: Triggers client-side vehicle spawn after server authorization

### Exports

#### `GetJobVehiclesForPlayer`
**Type**: Server Export  
**Parameters**: `playerId` (number)  
**Returns**: Array of allowed vehicles  
**Example**:
```lua
local vehicles = exports['ingenium']:GetJobVehiclesForPlayer(source)
```

## Security

### Server-Side Validation
- All job, grade, and role checks performed server-side
- Client cannot request unauthorized vehicles
- Spawn coordinates validated for reasonable bounds:
  - X/Y: -20000 to +20000
  - Z: -2000 to +2000

### Client Trust
- Client provides preferred spawn coordinates only
- Server validates all permissions before spawning
- Actual spawn handled client-side for performance

## Integration Notes

### Existing Spawn System
The system uses the existing garage spawn logic and parking spots defined in `_config/garage.lua`. Job vehicles will:
- Spawn at the nearest available parking spot
- Respect the `spawn_in_vehicle` configuration
- Support fuel system integration (LegacyFuel, okokGasStation, state bags)

### UI Integration
Job vehicles appear in a separate section below owned vehicles in the garage menu. The section:
- Shows loading state while fetching from server
- Displays empty state if no vehicles available
- Updates when garage menu is opened

## Troubleshooting

### No vehicles showing for my job
1. Check job name matches exactly (case-sensitive)
2. Verify player has required grade/role
3. Check server console for framework detection message
4. Enable debug logging in server script

### Framework not detected
1. Ensure QBCore/ESX resource is started before ingenium
2. Check resource state with `/status` command
3. Implement custom `getPlayerJobInfo` function

### Vehicles not spawning
1. Check server console for authorization messages
2. Verify parking spots are available near player
3. Check vehicle model names are valid

## Testing

1. Configure test vehicles in `_config/job_vehicles.lua`
2. Restart the resource
3. Log in as a player with a configured job
4. Open the garage menu (interact with parking machine)
5. Verify "Job Vehicles" section appears
6. Click "Spawn" on an authorized vehicle
7. Vehicle should spawn at nearest parking spot

## Future Enhancements

Potential improvements for future versions:
- Per-vehicle spawn cooldowns
- Usage tracking/statistics
- Custom spawn locations per job
- Vehicle damage/persistence options
- Integration with vehicle ownership systems

## Support

For issues or questions:
1. Check server console for error messages
2. Verify configuration syntax in Lua files
3. Test with minimal config (single job, single vehicle)
4. Check framework compatibility
