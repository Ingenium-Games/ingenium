# Job-Owned Vehicles - Integration Guide

## Quick Start

This guide shows how the job-owned vehicles system integrates with your existing Ingenium setup.

## What Was Added

### 1. Configuration File
**Location:** `data/job_vehicles.json`

This file defines which vehicles each job can access. Example:

```json
{
  "police": [
    {
      "model": "police",
      "name": "Police Cruiser",
      "minGrade": 1,
      "description": "Standard patrol vehicle"
    }
  ]
}
```

### 2. Server-Side Logic
**Location:** `server/[Garage]/_job_vehicles.lua`

- Validates player job/grade before spawning
- Provides exports for other resources:
  - `exports.ingenium:GetJobVehiclesForPlayer(playerId)`
  - `exports.ingenium:SpawnVehicleForPlayer(playerId, model, location)`

### 3. Client-Side Handler
**Location:** `client/[Garage]/_job_vehicles.lua`

- Handles NUI callbacks for vehicle spawning
- Integrates with existing parking machine system
- Finds available parking spots automatically

### 4. UI Component
**Locations:**
- `nui/src/components/GarageJobVehicles.vue` (new component)
- `nui/src/components/GarageMenu.vue` (updated to include job vehicles)

## How It Works

### For Players

1. **Open Garage**: Approach a parking machine and press E (or configured interact key)
2. **View Vehicles**: Personal vehicles appear at top, job vehicles appear below
3. **Spawn Job Vehicle**: Click "Spawn Vehicle" on any available job vehicle
4. **Vehicle Spawns**: Appears at nearest available parking spot (free of charge)

### For Server Owners

#### Adding Vehicles to a Job

Edit `data/job_vehicles.json`:

```json
{
  "yourJobId": [
    {
      "model": "vehicleSpawnName",
      "name": "Display Name",
      "minGrade": 2,
      "description": "Vehicle description"
    }
  ]
}
```

**Important:** The job ID must match the job ID in `data/jobs.json`

#### Grade Requirements

Grades are based on the `rank` field in `data/jobs.json`:

```json
{
  "police": {
    "Cadet": { "rank": 1 },        // Can access minGrade: 1
    "Officer": { "rank": 3 }        // Can access minGrade: 1, 2, 3
  }
}
```

#### Role Restrictions (Optional)

To restrict a vehicle to specific roles instead of grade:

```json
{
  "model": "riot",
  "name": "SWAT Van",
  "allowedRoles": ["Senior Officer", "Cheif of Police"],
  "description": "Only for senior staff"
}
```

**Note:** Role names must exactly match those in `data/jobs.json`

## File Manifest

All files have been added to `fxmanifest.lua` automatically:

```lua
-- Server
server_scripts {
    "server/[Garage]/_job_vehicles.lua",  -- Added
    -- ...
}

-- Client
client_scripts {
    "client/[Garage]/_job_vehicles.lua",  -- Added
    -- ...
}

-- Data files already included via pattern
files {
    "data/*.json",  -- Includes job_vehicles.json
    -- ...
}
```

## Integration with Other Resources

### Example: Custom Spawn Hook

If you have a custom vehicle spawn system, modify `server/[Garage]/_job_vehicles.lua`:

```lua
-- Find the SpawnVehicleWithTimeout function (around line 37)
-- Replace CreateVehicle with your custom spawn:

local function SpawnVehicleWithTimeout(vehicleModel, spawnLocation, timeout)
    timeout = timeout or 3000
    
    -- Replace this line:
    -- local entity = CreateVehicle(...)
    
    -- With your custom spawn:
    local entity = exports.yourResource:SpawnVehicle(vehicleModel, spawnLocation)
    
    -- Rest of the function stays the same
    local startTime = GetGameTimer()
    while not DoesEntityExist(entity) do
        -- timeout logic...
    end
    
    return true, entity, net
end
```

### Example: Using the Export

Other resources can check available job vehicles:

```lua
-- Get vehicles for a player
local vehicles = exports.ingenium:GetJobVehiclesForPlayer(playerId)

-- Returns:
-- {
--   {model = "police", name = "Police Cruiser", description = "...", minGrade = 1},
--   {model = "police2", name = "Interceptor", description = "...", minGrade = 3}
-- }

-- Spawn a vehicle for a player
local success, netId = exports.ingenium:SpawnVehicleForPlayer(playerId, "police", {
    x = 123.45,
    y = -67.89,
    z = 10.11,
    h = 90.0
})

if success then
    print("Spawned vehicle with network ID: " .. netId)
end
```

## Security Features

✅ **Server-Side Validation**: All job/grade checks happen server-side  
✅ **No Client Bypass**: Clients cannot request unauthorized vehicles  
✅ **Secure Logging**: Sensitive data not exposed in logs  
✅ **Spawn Validation**: Location and model validation before spawn  

## Troubleshooting

### Vehicles Not Showing in UI

**Check:**
1. Job ID in `job_vehicles.json` matches `jobs.json`
2. Player's grade meets minimum requirement
3. Vue build completed successfully: `cd nui && npm run build`

**Debug:**
Enable debug logging in `_config/config.lua`:
```lua
conf.debug_1 = true
```

Check server console for messages like:
```
[Job Vehicles] Loaded job vehicles configuration
[Job Vehicles] Found X available vehicles for player Y
```

### Spawn Issues

**Check:**
1. Parking spots available (other vehicles not blocking)
2. Vehicle model names are valid GTA V models
3. Server console for error messages

### Permission Problems

**Check:**
1. Role names exactly match (case-sensitive)
2. Player's job is correctly set
3. Grade ranks are correct in `jobs.json`

## Testing Your Configuration

### 1. Verify JSON Syntax

```bash
# In the ingenium directory:
python3 -c "import json; json.load(open('data/job_vehicles.json'))"
```

If valid, no output. If invalid, shows error.

### 2. Test Job Assignment

Give yourself a test job:
```lua
-- In game console or admin command
/setjob [playerid] police Officer
```

### 3. Check Available Vehicles

Open garage and verify job vehicles section appears with correct vehicles for your grade.

### 4. Test Spawning

Click spawn on a vehicle - should appear at nearest parking spot.

## Example Configurations

### Police Department (Full Setup)

```json
{
  "police": [
    {
      "model": "police",
      "name": "Police Cruiser",
      "minGrade": 1,
      "description": "Standard patrol vehicle for all officers"
    },
    {
      "model": "police2",
      "name": "Police Interceptor",
      "minGrade": 3,
      "description": "High-performance pursuit vehicle"
    },
    {
      "model": "policeb",
      "name": "Police Motorcycle",
      "minGrade": 2,
      "description": "Agile patrol bike for traffic enforcement"
    },
    {
      "model": "riot",
      "name": "SWAT Riot Van",
      "minGrade": 4,
      "allowedRoles": ["Senior Officer", "Cheif of Police"],
      "description": "Armored vehicle for tactical operations"
    }
  ]
}
```

### EMS (Medical Services)

```json
{
  "medic": [
    {
      "model": "ambulance",
      "name": "Ambulance",
      "minGrade": 1,
      "description": "Standard emergency medical response vehicle"
    },
    {
      "model": "firetruk",
      "name": "Fire Engine",
      "minGrade": 3,
      "allowedRoles": ["Doctor", "Cheif Medical Officer"],
      "description": "Fire and rescue operations vehicle"
    },
    {
      "model": "lguard",
      "name": "Lifeguard Truck",
      "minGrade": 2,
      "description": "Beach and water rescue vehicle"
    }
  ]
}
```

### Mechanic Shop

```json
{
  "mechanic": [
    {
      "model": "towtruck",
      "name": "Tow Truck",
      "minGrade": 1,
      "description": "Standard vehicle recovery truck"
    },
    {
      "model": "towtruck2",
      "name": "Heavy Tow Truck",
      "minGrade": 2,
      "description": "Heavy duty vehicle recovery"
    },
    {
      "model": "flatbed",
      "name": "Flatbed Transporter",
      "minGrade": 3,
      "description": "Multi-vehicle transport truck"
    },
    {
      "model": "utillitruck",
      "name": "Utility Truck",
      "minGrade": 2,
      "description": "Mobile repair and parts vehicle"
    }
  ]
}
```

## Need More Help?

- **Full Documentation**: See `Documentation/Job_Vehicles.md`
- **Configuration Schema**: See examples in `data/job_vehicles.json`
- **Server Logs**: Enable `conf.debug_1 = true` for detailed logging
- **UI Issues**: Check browser console (F12) in-game for JavaScript errors

## Summary

The job-owned vehicles system is fully integrated and ready to use:

✅ Server scripts loaded in `fxmanifest.lua`  
✅ Client scripts loaded in `fxmanifest.lua`  
✅ UI component integrated into garage  
✅ Configuration file ready for customization  
✅ Documentation complete  

**To customize:** Simply edit `data/job_vehicles.json` and restart the resource!
