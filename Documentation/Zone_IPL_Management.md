# IPL Management (ig.ipl / ig.ipls)

## Overview

Ingenium provides a comprehensive IPL (Interior Prop List) management system through the `ig.ipl` and `ig.ipls` namespaces. This system handles loading and unloading of game interiors with optional zone-based triggers for dynamic loading.

## What are IPLs?

IPLs (Interior Prop Lists) are game assets that define interior spaces and props in GTA V. They need to be explicitly loaded to become visible in the game world. Common examples include building interiors, hidden areas, and special map features.

## Basic IPL Functions (ig.ipl)

### Load an IPL

```lua
ig.ipl.Load("v_carshowroom")
```

### Unload an IPL

```lua
ig.ipl.Unload("v_carshowroom")
```

### Check if IPL is Loaded

```lua
if ig.ipl.IsLoaded("v_carshowroom") then
    print("Car showroom is loaded")
end
```

### Load Multiple IPLs

```lua
ig.ipl.LoadMultiple({
    "v_carshowroom",
    "v_bahama",
    "v_janitor"
})
```

### Unload Multiple IPLs

```lua
ig.ipl.UnloadMultiple({
    "v_carshowroom",
    "v_bahama"
})
```

## IPL Registry System (ig.ipls)

The registry system allows you to define IPL configurations with metadata, zones, and automatic loading.

### Register an IPL Configuration

```lua
ig.ipls.Register({
    name = "carshowroom",
    ipls = {
        "v_carshowroom",
        "shutter_open",
        "csr_afterMission"
    },
    autoload = true,  -- Load immediately on registration
    zone = {          -- Optional zone configuration
        type = "circle",
        coords = vector2(-60.0, -1100.0),
        radius = 100.0,
        dynamicLoad = true  -- Load/unload based on player proximity
    }
})
```

### Load Registered Configuration

```lua
ig.ipls.LoadByName("carshowroom")
```

### Unload Registered Configuration

```lua
ig.ipls.UnloadByName("carshowroom")
```

### Get All Registered Configurations

```lua
local allConfigs = ig.ipls.GetAll()
for name, config in pairs(allConfigs) do
    print(name, config.loaded)
end
```

### Get Specific Configuration

```lua
local config = ig.ipls.Get("carshowroom")
if config then
    print("IPLs:", json.encode(config.ipls))
    print("Loaded:", config.loaded)
end
```

## Zone Integration

The IPL system integrates with `ig.zone` for proximity-based loading. When a player enters or leaves a zone, IPLs can automatically load or unload.

### Circle Zone Example

```lua
ig.ipls.Register({
    name = "nightclub",
    ipls = {
        "ba_barriers_case0",
        "ba_case_0",
        "ba_interior_mod_1",
        "ba_lights_screen",
        "ba_security_upgrade"
    },
    zone = {
        type = "circle",
        coords = vector2(-1569.0, -3017.0),
        radius = 150.0,
        dynamicLoad = true,
        debug = false
    }
})
```

### Box Zone Example

```lua
ig.ipls.Register({
    name = "bunker",
    ipls = {
        "gr_case0_bunkerclosed",
        "gr_case0a_bunkerclosed",
        "gr_case1a_bunkerclosed"
    },
    zone = {
        type = "box",
        coords = vector3(848.0, 2996.0, 45.0),
        length = 20.0,
        width = 20.0,
        heading = 0.0,
        minZ = 40.0,
        maxZ = 50.0,
        dynamicLoad = true,
        debug = false
    }
})
```

### Polygon Zone Example

```lua
ig.ipls.Register({
    name = "custom_building",
    ipls = {
        "interior_01",
        "interior_props"
    },
    zone = {
        type = "poly",
        points = {
            vector2(100.0, 100.0),
            vector2(200.0, 100.0),
            vector2(200.0, 200.0),
            vector2(150.0, 250.0),
            vector2(100.0, 200.0)
        },
        minZ = 0.0,
        maxZ = 100.0,
        dynamicLoad = true,
        debug = false
    }
})
```

## Zone Configuration Options

### Common Options
- `type` - Zone type: "circle", "box", or "poly"
- `dynamicLoad` - Enable automatic load/unload on zone entry/exit
- `debug` - Enable debug visualization

### Circle Zone Options
- `coords` - Center position (vector2 or vector3)
- `radius` - Radius of the circle
- `useZ` - Use 3D sphere instead of 2D circle (requires vector3 coords)

### Box Zone Options
- `coords` - Center position (vector3)
- `length` - Box length
- `width` - Box width
- `heading` - Rotation in degrees
- `minZ` - Minimum height
- `maxZ` - Maximum height

### Polygon Zone Options
- `points` - Array of vector2 points defining the polygon
- `minZ` - Minimum height
- `maxZ` - Maximum height

## Complete Examples

### Basic IPL Loading (No Zones)

```lua
-- Simple autoload configuration
ig.ipls.Register({
    name = "yacht",
    ipls = {
        "hei_yacht_heist",
        "hei_yacht_heist_Bar",
        "hei_yacht_heist_Bedrm",
        "hei_yacht_heist_Bridge",
        "hei_yacht_heist_DistantLights",
        "hei_yacht_heist_enginrm",
        "hei_yacht_heist_LODLights",
        "hei_yacht_heist_Lounge",
        "hei_yacht_heist_slod_03",
        "hei_yacht_heist_slod_05",
        "hei_yacht_heist_Spa",
        "hei_yacht_heist_sr"
    },
    autoload = true
})
```

### Dynamic Loading with Zone

```lua
-- Load nightclub when player approaches
ig.ipls.Register({
    name = "afterhours_nightclub",
    ipls = {
        "ba_barriers_case0",
        "ba_case_0",
        "ba_clubname_01",
        "ba_equipment_setup",
        "ba_equipment_upgrade",
        "ba_security_upgrade",
        "ba_style01",
        "ba_trophy01"
    },
    zone = {
        type = "circle",
        coords = vector2(-1569.0, -3017.0),
        radius = 200.0,
        dynamicLoad = true
    }
})
```

### Manual Control with Zone

```lua
-- Register with zone but don't use dynamic loading
-- This allows manual control while still having zone data
ig.ipls.Register({
    name = "casino",
    ipls = {
        "vw_casino_main",
        "vw_casino_garage",
        "vw_casino_carpark",
        "vw_casino_door"
    },
    zone = {
        type = "box",
        coords = vector3(920.0, 50.0, 80.0),
        length = 100.0,
        width = 100.0,
        heading = 0.0,
        minZ = 75.0,
        maxZ = 85.0,
        dynamicLoad = false  -- Manual control
    }
})

-- Load manually when needed
ig.ipls.LoadByName("casino")

-- Later, unload when done
ig.ipls.UnloadByName("casino")
```

### Multiple IPL Configurations

```lua
-- Aircraft carrier
ig.ipls.Register({
    name = "aircraft_carrier",
    ipls = {"hei_carrier", "hei_carrier_DistantLights", "hei_Carrier_int1", "hei_Carrier_int2"},
    zone = {
        type = "circle",
        coords = vector2(3084.0, -4700.0),
        radius = 500.0,
        dynamicLoad = true
    }
})

-- FIB building interior
ig.ipls.Register({
    name = "fib_interior",
    ipls = {"FIBlobby"},
    zone = {
        type = "circle",
        coords = vector2(136.0, -750.0),
        radius = 100.0,
        dynamicLoad = true
    }
})

-- Hospital interior
ig.ipls.Register({
    name = "hospital",
    ipls = {"rc12b_default"},
    zone = {
        type = "circle",
        coords = vector2(307.0, -590.0),
        radius = 80.0,
        dynamicLoad = true
    }
})
```

## Best Practices

1. **Use Autoload for Permanent IPLs**: If an IPL should always be loaded, use `autoload = true`
2. **Use Dynamic Loading for Large Interiors**: Save resources by loading only when players are nearby
3. **Appropriate Zone Sizes**: Make zones large enough to load before players see the interior
4. **Group Related IPLs**: Keep related IPLs together in a single configuration
5. **Descriptive Names**: Use clear, descriptive names for configurations
6. **Test Zone Boundaries**: Use `debug = true` during development to visualize zones

## Common IPL Names

Here are some commonly used IPLs in GTA V:

### Properties
- `v_carshowroom` - Car showroom
- `v_bahama` - Bahama Mamas nightclub
- `v_michael` - Michael's house
- `v_franklins` - Franklin's house

### Facilities
- `gr_case0_bunkerclosed` - Bunker (closed)
- `ba_barriers_case0` - Nightclub (After Hours)
- `hei_carrier` - Aircraft carrier
- `FIBlobby` - FIB building interior

### Heist Locations
- `hei_yacht_heist` - Yacht heist location
- `id2_14_during_door` - Jewel store

For a comprehensive list of IPLs, refer to community resources and IPL databases.

## Integration with ig.zone

The IPL system uses `ig.zone` internally for all zone operations. You can access the zone handler:

```lua
local config = ig.ipls.Get("nightclub")
if config and config.zoneHandler then
    -- Access the zone directly
    local isInside = config.zoneHandler:isPointInside(GetEntityCoords(PlayerPedId()))
    
    -- Pause/unpause zone checking
    config.zoneHandler:setPaused(true)
end
```

## Troubleshooting

### IPL Not Loading
- Check the IPL name is correct
- Verify the IPL exists in the game
- Check for conflicting IPLs that may override

### Zone Not Triggering
- Verify zone coordinates are correct
- Increase zone radius/size
- Enable `debug = true` to visualize the zone
- Check that `dynamicLoad = true` is set

### Performance Issues
- Use appropriate zone sizes (not too large)
- Limit the number of dynamic zones
- Use circle zones when possible (faster than poly zones)

## See Also

- [Zone Management (ig.zone)](./Zone_Management.md)
- [PolyZone Documentation](https://github.com/mkafrin/PolyZone)
