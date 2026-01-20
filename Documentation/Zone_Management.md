# Zone Management System

## Overview

Ingenium's zone management system wraps **PolyZone** with an integrated IPL (Interior Prop List) loader for proximity-based interior management. The system uses a **consolidated single-threaded manager** for optimal performance.

## Zone Types

### Available Zone Classes

| Zone Type | Class | Use Case |
|-----------|-------|----------|
| **Poly** | PolyZone | Custom polygon shapes, irregular areas |
| **Box** | BoxZone | Rectangular zones with rotation |
| **Circle** | CircleZone | Circular/spherical zones |
| **Entity** | EntityZone | Zones that follow entities |
| **Combo** | ComboZone | Multiple zones as single unit |

## Zone Creation

### Circle Zone

```lua
local zone = ig.zone.Circle:Create(center, radius, options)
```

Example:
```lua
local bankZone = ig.zone.Circle:Create(
    vector3(150.0, -1040.0, 29.37),  -- Center
    25.0,                              -- Radius
    {
        name = "bank_entrance",
        debugPoly = false,
        useZ = true
    }
)
```

### Box Zone

```lua
local zone = ig.zone.Box:Create(center, length, width, options)
```

Example:
```lua
local garageZone = ig.zone.Box:Create(
    vector3(215.0, -809.0, 30.73),
    40.0,   -- Length
    30.0,   -- Width
    {
        name = "garage_area",
        heading = 45.0,
        minZ = 29.0,
        maxZ = 32.0
    }
)
```

### Polygon Zone

```lua
local zone = ig.zone.Poly:Create(points, options)
```

Example:
```lua
local customZone = ig.zone.Poly:Create(
    {
        vector2(150.0, -1040.0),
        vector2(200.0, -1040.0),
        vector2(200.0, -1080.0),
        vector2(150.0, -1080.0)
    },
    {
        name = "custom_area",
        minZ = 28.0,
        maxZ = 35.0
    }
)
```

### Entity Zone

```lua
local zone = ig.zone.Entity:Create(entity, options)
```

Example:
```lua
local playerZone = ig.zone.Entity:Create(
    PlayerPedId(),
    {
        name = "player_proximity",
        scale = vector3(5.0, 5.0, 2.0),  -- Size around entity
        debugPoly = false
    }
)
```

### Combo Zone

```lua
local zone = ig.zone.Combo:Create({zone1, zone2, ...}, options)
```

Example:
```lua
local restrictedArea = ig.zone.Combo:Create(
    {militaryBaseZone, airportZone},
    {
        name = "restricted_combined"
    }
)
```

## Zone Options

### Common Options

```lua
{
    name = "zone_name",           -- Zone identifier (string)
    debugPoly = false,            -- Visualize zone (green outline)
    debugBlip = false,            -- Add map blip
    debugColor = {0, 255, 0},     -- Debug visualization color (RGB)
    data = {},                    -- Custom data storage (table)
    useZ = false                  -- Include Z-axis in distance checks (boolean)
}
```

### Circle-Specific Options

```lua
{
    type = "circle",
    coords = vector2(x, y) or vector3(x, y, z),
    radius = 100.0,
    useZ = false  -- If false, uses 2D distance
}
```

### Box-Specific Options

```lua
{
    type = "box",
    coords = vector3(x, y, z),
    length = 100.0,
    width = 50.0,
    heading = 0.0,      -- Rotation in degrees
    minZ = 0.0,         -- Height boundaries
    maxZ = 20.0
}
```

### Polygon-Specific Options

```lua
{
    type = "poly",
    points = {
        vector2(x1, y1),
        vector2(x2, y2),
        vector2(x3, y3)
        -- ... more points
    },
    minZ = 0.0,
    maxZ = 100.0
}
```

## Zone Methods

### Check if Point Inside

```lua
zone:isPointInside(point)
```

Example:
```lua
local coords = GetEntityCoords(PlayerPedId())
if bankZone:isPointInside(coords) then
    print("Player is inside bank")
end
```

### Player Enter/Exit Events

```lua
zone:onPlayerInOut(callback, interval)
```

Example:
```lua
bankZone:onPlayerInOut(function(isInside, point, zone)
    if isInside then
        print("Player entered bank:", zone.name)
        -- Show UI, load interior, etc.
    else
        print("Player left bank:", zone.name)
        -- Hide UI, unload interior, etc.
    end
end, 250)  -- Check every 250ms
```

### Custom Point Tracking

```lua
zone:onPointInOut(getPointFunc, callback, interval)
```

Example:
```lua
local function getVehicleCoords()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        return GetEntityCoords(vehicle)
    end
    return nil
end

garageZone:onPointInOut(getVehicleCoords, function(isInside, point, zone)
    if isInside then
        print("Vehicle entered garage")
    else
        print("Vehicle left garage")
    end
end, 500)
```

### Pause/Resume

```lua
zone:setPaused(paused)
```

Example:
```lua
-- Pause checking
zone:setPaused(true)

-- Resume checking
zone:setPaused(false)
```

### Destroy Zone

```lua
zone:destroy()
```

Example:
```lua
-- Cleanup when done
bankZone:destroy()
```

## Helper Functions

### Get Player Position

```lua
ig.zone.GetPlayerPosition()
```

Returns current player coordinates:

```lua
local coords = ig.zone.GetPlayerPosition()
print(coords.x, coords.y, coords.z)
```

### Get Player Head Position

```lua
ig.zone.GetPlayerHeadPosition()
```

Returns player's head coordinates (useful for line-of-sight):

```lua
local headCoords = ig.zone.GetPlayerHeadPosition()
```

### Validate Zone Metatable

```lua
ig.zone.EnsureMetatable(zone)
```

Ensures zone has proper metatable (internal use).

## IPL (Interior Prop List) System

### Core Functions

#### Load Single IPL

```lua
ig.ipl.Load(iplName)
```

Example:
```lua
ig.ipl.Load("v_carshowroom")  -- Load car showroom
```

#### Unload Single IPL

```lua
ig.ipl.Unload(iplName)
```

Example:
```lua
ig.ipl.Unload("v_carshowroom")
```

#### Check if Loaded

```lua
ig.ipl.IsLoaded(iplName)
```

Example:
```lua
if ig.ipl.IsLoaded("v_carshowroom") then
    print("Car showroom is loaded")
end
```

#### Load Multiple IPLs

```lua
ig.ipl.LoadMultiple(table)
```

Example:
```lua
ig.ipl.LoadMultiple({
    "v_carshowroom",
    "vw_casino_main",
    "hei_carrier"
})
```

#### Unload Multiple IPLs

```lua
ig.ipl.UnloadMultiple(table)
```

Example:
```lua
ig.ipl.UnloadMultiple({"v_carshowroom", "vw_casino_main"})
```

### IPL Registry System

#### Register Configuration

```lua
ig.ipl.Register(config)
```

Example:
```lua
ig.ipl.Register({
    name = "casino",
    ipls = {"vw_casino_main", "vw_casino_garage"},
    autoload = true,
    zone = {
        type = "circle",
        coords = vector3(925.0, 46.0, 81.0),
        radius = 150.0,
        dynamicLoad = true
    }
})
```

#### Load by Name

```lua
ig.ipl.LoadByName(name)
```

Example:
```lua
ig.ipl.LoadByName("casino")
```

#### Unload by Name

```lua
ig.ipl.UnloadByName(name)
```

Example:
```lua
ig.ipl.UnloadByName("casino")
```

#### Setup Zone Handler

```lua
ig.ipl.SetupZoneHandler(name, zoneConfig)
```

Automatically load/unload IPL based on zone proximity:

```lua
ig.ipl.SetupZoneHandler("casino", {
    type = "circle",
    coords = vector3(925.0, 46.0, 81.0),
    radius = 150.0
})
```

#### Get Configuration

```lua
ig.ipl.Get(name)
ig.ipl.GetAll()
```

Example:
```lua
local casinoConfig = ig.ipl.Get("casino")
local allConfigs = ig.ipl.GetAll()
```

### IPL Configuration Structure

```lua
-- In _config/ipls.lua
conf.ipls.example = {
    name = "example",
    ipls = {"ipl_name_1", "ipl_name_2"},  -- IPL array
    autoload = true,                       -- Load on startup
    zone = {
        type = "circle",
        coords = vector3(x, y, z),
        radius = 100.0,
        dynamicLoad = true                 -- Auto load/unload on enter/exit
    },
    loaded = false                         -- Track state
}
```

## Common IPLs

### Interiors

```lua
-- Car Showroom
ig.ipl.Load("v_carshowroom")

-- Casino
ig.ipl.LoadMultiple({"vw_casino_main", "vw_casino_garage", "vw_casino_carpark"})

-- Nightclub (After Hours DLC)
ig.ipl.LoadMultiple({"ba_case_0", "ba_barriers_case0"})

-- Aircraft Carrier
ig.ipl.Load("hei_carrier")

-- FIB Building
ig.ipl.Load("FIBlobby")

-- Bunker Interior
ig.ipl.Load("gr_case0")

-- Yacht
ig.ipl.Load("hei_yacht_heist")
```

## Zone-IPL Integration

### Automatic Loading

Configure zones to automatically load IPLs on enter:

```lua
local config = {
    name = "bunker_entrance",
    ipls = {"gr_case0"},
    zone = {
        type = "circle",
        coords = vector3(892.0, -3245.0, -98.0),
        radius = 50.0,
        dynamicLoad = true,  -- Enable auto load/unload
        debug = false
    }
}

ig.ipl.Register(config)
ig.ipl.SetupZoneHandler("bunker_entrance", config.zone)
```

### Manual Control

```lua
local bunkerZone = ig.zone.Circle:Create(
    vector3(892.0, -3245.0, -98.0),
    50.0,
    {name = "bunker"}
)

bunkerZone:onPlayerInOut(function(isInside)
    if isInside then
        ig.ipl.LoadByName("bunker_entrance")
    else
        ig.ipl.UnloadByName("bunker_entrance")
    end
end, 500)
```

## Consolidated Zone Manager

The zone system uses a **single consolidated thread** for all zone checks:

**Features:**
- One thread manages all zones (reduces overhead)
- Configurable check intervals per zone
- Automatic state tracking (only callbacks on enter/exit)
- Supports pause/resume and destruction tracking
- Efficient callback dispatch

**Performance Benefits:**
- 100 zones with individual threads = 100 threads
- 100 zones with consolidated manager = 1 thread
- Significantly reduced CPU usage

## Debugging Commands

### Zone Statistics

```bash
/zonestats
```

Displays:
- Total zones active
- Zones by type
- Callback count
- Thread status

### List Zones

```bash
/listzones
```

Shows all active zones with:
- Name
- Type
- Center coordinates
- Radius/dimensions
- Callback status

## Best Practices

1. **Use appropriate zone types** - Circle for simple areas, Poly for complex shapes
2. **Set reasonable intervals** - 250-500ms for most cases
3. **Clean up zones** - Call destroy() when done
4. **Use debugPoly during development** - Visualize zone boundaries
5. **Consolidate checks** - Let manager handle timing
6. **Cache zone references** - Don't recreate zones repeatedly
7. **Use IPL registry** - Register common interiors once
8. **Test zone boundaries** - Verify enter/exit triggers correctly
9. **Avoid excessive zones** - Too many zones can still impact performance
10. **Use combo zones** - Combine related areas

## Configuration Reference

### Complete Zone Config

```lua
conf.zones = {
    checkInterval = 250,        -- Default check interval (ms)
    debugEnabled = false,       -- Enable all debug visuals
    maxZones = 500             -- Maximum zones allowed
}
```

### Complete IPL Config

```lua
conf.ipls = {
    autoload = true,           -- Auto-load registered IPLs on startup
    dynamicLoading = true,     -- Enable proximity-based loading
    unloadDistance = 200.0     -- Distance to unload (meters)
}
```

## Example: Complete Zone Setup

```lua
-- Register IPL configuration
ig.ipl.Register({
    name = "police_station",
    ipls = {"cs1_02_cf_onmission1", "cs1_02_cf_onmission2"},
    autoload = false,
    zone = {
        type = "box",
        coords = vector3(442.0, -982.0, 30.69),
        length = 50.0,
        width = 40.0,
        heading = 0.0,
        minZ = 28.0,
        maxZ = 35.0,
        dynamicLoad = true
    }
})

-- Create zone with callbacks
local policeZone = ig.zone.Box:Create(
    vector3(442.0, -982.0, 30.69),
    50.0,
    40.0,
    {
        name = "police_station",
        debugPoly = false,
        heading = 0.0,
        minZ = 28.0,
        maxZ = 35.0,
        data = {
            jobRequired = "police"
        }
    }
)

-- Setup enter/exit handler
policeZone:onPlayerInOut(function(isInside, point, zone)
    local xPlayer = ig.data.GetLocalPlayer()
    
    if isInside then
        -- Player entered
        if xPlayer.Job == "police" then
            ig.ipl.LoadByName("police_station")
            TriggerEvent('Client:UI:ShowNotification', {
                message = "Welcome to LSPD",
                type = "info"
            })
        else
            TriggerEvent('Client:UI:ShowNotification', {
                message = "Authorized personnel only",
                type = "warning"
            })
        end
    else
        -- Player left
        ig.ipl.UnloadByName("police_station")
    end
end, 250)
```

## Related Documentation

- [Data Persistence](Data_Persistence.md) - Zone data storage
- [Callback System](Callback_System.md) - Zone event handling
- [NUI Architecture](NUI_Architecture.md) - Zone UI integration
