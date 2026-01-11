# Job-Specific Vehicle Spawning System - Quick Start

## What Was Implemented

A complete job-specific vehicle spawning system that allows players with specific jobs (like police, EMS, mechanics) to spawn job-appropriate vehicles at designated locations without any cost.

## Quick Setup Guide

### 1. Configuration

Edit `_config/job_vehicles.lua` to add or modify vehicle spawners:

```lua
{
    job = "police",              -- Job name
    grade = nil,                 -- Minimum grade (nil = any)
    label = "Police Vehicle Spawner",
    prop = {x=438.42, y=-1018.09, z=28.59, h=90.0},  -- Prop location
    spawn = {x=438.42, y=-1026.35, z=28.48, h=90.0}, -- Vehicle spawn
    vehicles = {
        {model = "police", label = "Police Cruiser"},
        {model = "police2", label = "Police Buffalo"},
    }
}
```

### 2. Included Examples

Pre-configured spawners for:
- **Police** - 4 locations (Mission Row, Davis, Sandy Shores, Paleto Bay)
- **EMS** - Hospital spawner
- **Mechanic** - Repair shop with tow trucks

### 3. How It Works

1. Props are created at configured locations (default: traffic cones)
2. Players with correct job can interact using the target system
3. A modern UI shows available vehicles
4. Vehicle spawns instantly at designated location
5. Player is placed inside the vehicle
6. **No cost** for spawning

### 4. Finding Coordinates

Use in-game command:
```
/getcoords
```

Then copy the output to your spawner configuration.

### 5. Testing

1. Restart the resource
2. Join the server with a character
3. Set your job to "police" (or another configured job)
4. Go to one of the spawner locations
5. Look for the traffic cone prop
6. Use target system (Left Alt) to interact
7. Select a vehicle from the menu

## Key Features

✅ Job-based access control  
✅ Grade requirements (optional)  
✅ Free vehicle spawning  
✅ Target system integration  
✅ Modern Vue 3 UI  
✅ Multiple locations per job  
✅ Multiple vehicles per spawner  

## File Structure

```
_config/job_vehicles.lua                    - Configuration
server/[Callbacks]/_job_vehicles.lua        - Server logic
client/[Job Vehicles]/_job_vehicles.lua     - Client logic
nui/src/components/JobVehiclesMenu.vue      - UI component
Documentation/Job_Vehicles_System.md        - Full documentation
```

## Customization

### Change Prop Model

```lua
conf.job_vehicles.spawner_prop = `prop_parking_sign_07`
```

### Add New Job

Add a new spawner block in `conf.job_vehicles.spawners`:

```lua
{
    job = "taxi",
    grade = nil,
    label = "Taxi Vehicle Spawner",
    prop = {x=100.0, y=200.0, z=30.0, h=90.0},
    spawn = {x=105.0, y=200.0, z=30.0, h=90.0},
    vehicles = {
        {model = "taxi", label = "Taxi"},
    }
}
```

### Grade Requirements

Set minimum grade for spawner access:

```lua
grade = 2,  -- Requires grade 2 or higher
```

## Troubleshooting

**Props not showing?**
- Check coordinates are correct
- Verify resource restarted
- Check server console for errors

**Target not working?**
- Verify player has correct job
- Check interaction distance setting
- Ensure target system is enabled

**Vehicles not spawning?**
- Check vehicle model exists
- Verify spawn point is clear
- Check server console for errors

**Menu not opening?**
- Check NUI was built (npm run build)
- Verify browser console (F12)
- Check callback registration

## Full Documentation

See `Documentation/Job_Vehicles_System.md` for complete documentation including:
- API reference
- Advanced configuration
- Best practices
- Troubleshooting guide

## Support

The system is fully integrated with the ingenium framework and follows all existing patterns. It uses:
- Existing target system
- Existing vehicle creation methods
- Existing callback system
- Existing Vue 3 architecture

No external dependencies required!

---

**Ready to test!** The system is production-ready and follows all framework conventions.
