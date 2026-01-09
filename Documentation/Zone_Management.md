# Zone Management (ig.zone)

## Overview

Ingenium includes an integrated zone management system built on PolyZone, accessible through the `ig.zone` namespace. This system provides powerful zone definition and point-checking capabilities for creating interactive areas in your FiveM resource.

## Credits

The zone system is based on [PolyZone](https://github.com/mkafrin/PolyZone) by Michael Afrin, integrated into Ingenium with full MIT license compliance. See `client/[Zones]/LICENSE` for the original license.

## Zone Types

### PolyZone (ig.zone.Poly)
Define complex polygonal zones with any number of points.

```lua
local zone = ig.zone.Poly:Create({
    vector2(100.0, 100.0),
    vector2(200.0, 100.0),
    vector2(200.0, 200.0),
    vector2(100.0, 200.0)
}, {
    name = "my_polygon_zone",
    minZ = 0.0,
    maxZ = 100.0,
    debugPoly = false
})
```

### BoxZone (ig.zone.Box)
Rectangular zones with rotation support.

```lua
local zone = ig.zone.Box:Create(
    vector3(100.0, 100.0, 20.0),  -- center
    10.0,  -- length
    10.0,  -- width
    {
        name = "my_box_zone",
        heading = 45.0,
        minZ = 15.0,
        maxZ = 25.0,
        debugPoly = false
    }
)
```

### CircleZone (ig.zone.Circle)
Circular or spherical zones.

```lua
-- 2D Circle (ignores Z coordinate)
local zone = ig.zone.Circle:Create(
    vector2(100.0, 100.0),  -- center
    50.0,  -- radius
    {
        name = "my_circle_zone",
        debugPoly = false
    }
)

-- 3D Sphere (uses Z coordinate)
local zone = ig.zone.Circle:Create(
    vector3(100.0, 100.0, 20.0),  -- center
    50.0,  -- radius
    {
        name = "my_sphere_zone",
        useZ = true,
        debugPoly = false
    }
)
```

### EntityZone (ig.zone.Entity)
Zones attached to and following an entity (vehicle, ped, object).

```lua
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
local zone = ig.zone.Entity:Create(
    vehicle,
    {
        name = "vehicle_zone",
        useZ = true,
        debugPoly = false
    }
)
```

### ComboZone (ig.zone.Combo)
Combine multiple zones with grid optimization for efficient checking.

```lua
local zones = {
    ig.zone.Box:Create(vector3(100.0, 100.0, 20.0), 10.0, 10.0, {name = "box1"}),
    ig.zone.Circle:Create(vector2(200.0, 200.0), 50.0, {name = "circle1"}),
    ig.zone.Poly:Create(points, {name = "poly1"})
}

local combo = ig.zone.Combo:Create(zones, {
    name = "my_combo_zone",
    debugPoly = false
})
```

## Common Methods

### Check if Point is Inside Zone

```lua
local playerPos = GetEntityCoords(PlayerPedId())
if zone:isPointInside(playerPos) then
    print("Player is inside the zone!")
end
```

### Player In/Out Callbacks

**⚠️ Performance Note:** All zone callbacks use a consolidated single-thread manager for optimal performance. Multiple zones share one checking thread instead of creating individual threads per zone.

```lua
zone:onPlayerInOut(function(isInside, point)
    if isInside then
        print("Player entered the zone")
    else
        print("Player left the zone")
    end
end, 500)  -- Check every 500ms (default: 250ms)
```

**How it works:**
- All zones using `onPlayerInOut()` or `onPointInOut()` are managed by a single thread
- Each zone can have its own check interval
- The manager efficiently schedules checks based on each zone's configured interval
- This approach dramatically reduces resource usage compared to per-zone threads

### Custom Point Callbacks

```lua
zone:onPointInOut(function()
    -- Return the point to check
    return GetEntityCoords(someEntity)
end, function(isInside, point)
    if isInside then
        print("Entity entered the zone")
    else
        print("Entity left the zone")
    end
end, 500)
```

### Pause/Resume Zone Checking

```lua
zone:setPaused(true)   -- Pause zone checks
zone:setPaused(false)  -- Resume zone checks
print(zone:isPaused()) -- Check if paused
```

### Destroy Zone

```lua
zone:destroy()  -- Clean up zone and stop all callbacks
```

### Debug Visualization

```lua
-- Enable debug polygon visualization
local zone = ig.zone.Box:Create(center, length, width, {
    name = "debug_zone",
    debugPoly = true,  -- Shows zone outline
    debugBlip = true   -- Adds a blip at zone center
})
```

## Helper Functions

### Get Player Position
```lua
local pos = ig.zone.GetPlayerPosition()
```

### Get Player Head Position
```lua
local headPos = ig.zone.GetPlayerHeadPosition()
```

### Ensure Zone Metatable
```lua
-- Restore zone metatable after deserialization
ig.zone.EnsureMetatable(zoneObject)
```

## Zone Properties

All zones have these common properties:

- `name` - Optional name for the zone
- `minZ` - Minimum Z coordinate (height)
- `maxZ` - Maximum Z coordinate (height)
- `debugPoly` - Enable debug visualization
- `debugColors` - Custom debug colors
- `data` - Custom data storage for the zone

## Advanced Features

### Grid Optimization

PolyZone and ComboZone use grid optimization by default to speed up point checking:

```lua
local zone = ig.zone.Poly:Create(points, {
    name = "optimized_zone",
    useGrid = true,      -- Enable grid (default)
    lazyGrid = true,     -- Lazy grid calculation (default)
    gridDivisions = 30   -- Grid density (default 30)
})
```

### Scale and Offset (BoxZone)

```lua
local zone = ig.zone.Box:Create(center, length, width, {
    name = "scaled_box",
    scale = {1.5, 1.5, 2.0},    -- Scale forward/back, left/right, up/down
    offset = {0.0, 0.0, 5.0}    -- Offset forward/back, left/right, up/down
})
```

### Zone Modifications

BoxZone supports dynamic modifications:

```lua
-- Change box dimensions
zone:setLength(20.0)
zone:setWidth(15.0)
zone:setCenter(vector3(150.0, 150.0, 20.0))
zone:setHeading(90.0)

-- Get current values
local length = zone:getLength()
local width = zone:getWidth()
local heading = zone:getHeading()
```

CircleZone supports dynamic modifications:

```lua
-- Change circle properties
zone:setRadius(75.0)
zone:setCenter(vector2(150.0, 150.0))

-- Get current values
local radius = zone:getRadius()
local center = zone:getCenter()
```

### ComboZone Management

```lua
-- Add zone to combo
combo:AddZone(newZone)

-- Remove zone by name
combo:RemoveZone("zone_name")

-- Remove zone by predicate function
combo:RemoveZone(function(zone)
    return zone.data.type == "temporary"
end)

-- Check specific zone in combo
local isInside, zone = combo:isPointInside(point, "specific_zone_name")
```

## Examples

### Simple Interaction Zone

```lua
local shopZone = ig.zone.Circle:Create(
    vector2(100.0, 200.0),
    5.0,
    {name = "shop_entrance"}
)

shopZone:onPlayerInOut(function(isInside)
    if isInside then
        -- Show help text or marker
        print("Press E to open shop")
    else
        -- Hide help text
        print("Left shop area")
    end
end)
```

### Vehicle Damage Zone

```lua
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
local damageZone = ig.zone.Entity:Create(vehicle, {
    name = "vehicle_damage_zone",
    useZ = true
})

damageZone:onEntityDamaged(function(died, attacker, weapon, melee)
    print("Vehicle damaged!", died, attacker, weapon, melee)
end)
```

### Multi-Zone Area

```lua
local policeStation = ig.zone.Combo:Create({
    ig.zone.Box:Create(vector3(400.0, -1000.0, 29.0), 50.0, 50.0, {
        name = "main_building",
        minZ = 25.0,
        maxZ = 35.0
    }),
    ig.zone.Circle:Create(vector2(450.0, -1000.0), 30.0, {
        name = "parking_lot"
    })
}, {
    name = "police_station_complex"
})

policeStation:onPlayerInOutExhaustive(function(isInside, point, insideZones, enteredZones, leftZones)
    if enteredZones then
        for _, zone in ipairs(enteredZones) do
            print("Entered:", zone.name)
        end
    end
    if leftZones then
        for _, zone in ipairs(leftZones) do
            print("Left:", zone.name)
        end
    end
end)
```

## PolyZone Compatibility

Ingenium provides PolyZone compatibility through the `provide "polyzone"` directive in fxmanifest.lua. This means:

1. Resources that depend on PolyZone will automatically use Ingenium's implementation
2. External resources can access zones via `exports.ingenium:GetZone()`
3. All standard PolyZone functions and methods are available

## Performance Tips

1. **Use Grid Optimization**: Keep `useGrid = true` for PolyZone and ComboZone
2. **Appropriate Check Intervals**: Use 500-1000ms intervals for most cases
3. **Destroy Unused Zones**: Always call `zone:destroy()` when done
4. **ComboZone for Multiple Zones**: Use ComboZone instead of separate zones when checking the same point against many zones
5. **Pause When Not Needed**: Use `zone:setPaused(true)` when temporarily not needed
6. **Consolidated Manager**: All zones automatically use a single-thread manager - no need for manual optimization

### Zone Manager Statistics

Monitor zone performance and active zones:

```lua
-- In-game command (client-side)
/zonestats

-- Programmatically
local stats = ig.zoneManager.GetStats()
print("Total Zones:", stats.totalZones)
print("Manager Running:", stats.isRunning)
print("Check Interval:", stats.checkInterval, "ms")

-- Inspect zones by type
for zoneType, count in pairs(stats.byType) do
    print(zoneType .. ":", count)
end
```

### Developer Commands

**View Active Zones** (client-side):
```
/zonestats
```
Shows:
- Total number of registered zones
- Manager running status
- Default check interval
- Breakdown by zone type (PolyZone, BoxZone, CircleZone, etc.)

**List Client Zones** (client-side):
```
/listzones
```
Shows all zones registered for the current client with details about each zone.

## See Also

- [IPL Management (ig.ipl/ig.ipls)](./Zone_IPL_Management.md)
- [PolyZone Original Documentation](https://github.com/mkafrin/PolyZone)
