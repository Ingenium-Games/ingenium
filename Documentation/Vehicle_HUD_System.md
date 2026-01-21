# Vehicle HUD System

## Overview

The Vehicle HUD is a dynamic heads-up display that shows vehicle speed and fuel level when the player is driving. The HUD automatically appears when entering the driver's seat and disappears in first-person mode or when exiting the vehicle.

## Features

- **Speed Display**: Real-time vehicle speed in MPH or KPH
- **Fuel Display**: Fuel level as a percentage with visual fuel bar
- **Driver Seat Only**: Only displays when sitting in the driver's seat
- **First-Person Aware**: Automatically hides in first-person mode
- **Smooth Updates**: Updates every 100ms for responsive feedback
- **Clean Design**: Minimalist, unobtrusive design in bottom-right corner

## Visual Design

The Vehicle HUD displays two primary stats:

### Speed Indicator
- **Icon**: Gauge/speedometer icon (🏎️)
- **Value**: Current speed (integer)
- **Unit**: MPH or KPH label
- **Color**: Blue icon with white text

### Fuel Indicator
- **Icon**: Gas pump icon (⛽)
- **Bar**: Color-coded fuel bar (red → yellow → green)
- **Value**: Percentage (0-100%)
- **Color**: Gradient from red (empty) to green (full)

## Display Conditions

The Vehicle HUD will **show** when:
- ✅ Player is in a vehicle
- ✅ Player is in the driver's seat (-1 seat index)
- ✅ Camera is NOT in first-person mode

The Vehicle HUD will **hide** when:
- ❌ Player is not in a vehicle
- ❌ Player is a passenger (not driver)
- ❌ Camera is in first-person mode
- ❌ Player exits the vehicle

## Position and Layout

**Default Position**: Bottom-right corner
- Right: 20px from edge
- Bottom: 20px from edge
- Layout: Vertical stack (speed on top, fuel below)

```
┌─────────────────────────┐
│                         │
│                         │
│                    ┌────┤
│                    │ 65 │ ← Speed
│                    │MPH │
│                    ├────┤
│                    │ 78%│ ← Fuel
│                    │████│
└────────────────────┴────┘
```

## Technical Implementation

### Client-Side Logic

File: `client/_vehicle_hud.lua`

The system uses a continuous thread that:
1. Checks if player is in a vehicle
2. Verifies player is in driver's seat
3. Detects first-person camera mode
4. Calculates speed and fuel level
5. Sends updates to NUI only when values change

```lua
-- Main update loop (every 100ms)
CreateThread(function()
    while true do
        UpdateVehicleHUD()
        Wait(100)
    end
end)
```

### Speed Conversion

Speed is converted from native m/s to display units:

```lua
-- MPH conversion
speed_mph = speed_ms * 2.236936

-- KPH conversion
speed_kph = speed_ms * 3.6
```

### Fuel Level

Fuel is retrieved using the native function:
```lua
local fuel = GetVehicleFuelLevel(vehicle)  -- Returns 0-100
```

### Vue Component

File: `nui/src/components/VehicleHUD.vue`

The Vue component listens for `vehicleHudUpdate` messages:

```javascript
{
  event: 'vehicleHudUpdate',
  data: {
    visible: true,
    speed: 65,      // Integer speed value
    fuel: 78,       // Integer fuel percentage
    unit: 'MPH'     // Speed unit string
  }
}
```

## Customization

### Change Position

Edit `nui/src/components/VehicleHUD.vue`:

```css
.vehicle-hud {
  position: fixed;
  bottom: 20px;    /* Adjust vertical position */
  right: 20px;     /* Adjust horizontal position */
  /* ... */
}
```

**Common positions:**
- Bottom-right: `bottom: 20px; right: 20px;` (default)
- Bottom-left: `bottom: 20px; left: 20px;`
- Top-right: `top: 20px; right: 20px;`
- Bottom-center: `bottom: 20px; left: 50%; transform: translateX(-50%);`

### Change Speed Unit

Edit `client/_vehicle_hud.lua`:

```lua
-- Change this line from MPH to KPH
local displaySpeed = ConvertSpeed(speed, true)  -- true = MPH
-- To:
local displaySpeed = ConvertSpeed(speed, false) -- false = KPH
```

And update the unit sent to NUI:
```lua
unit = 'KPH'  -- Changed from 'MPH'
```

### Change Update Rate

Edit `client/_vehicle_hud.lua`:

```lua
CreateThread(function()
    while true do
        UpdateVehicleHUD()
        Wait(100)  -- Change this value (milliseconds)
    end
end)
```

**Recommended values:**
- `50`: Very smooth, higher CPU usage
- `100`: Smooth, balanced (default)
- `200`: Slightly choppy, lower CPU usage
- `500`: Very choppy, minimal CPU usage

### Modify Styling

Edit `nui/src/components/VehicleHUD.vue` style section:

```css
/* Background opacity */
background: rgba(0, 0, 0, 0.6);  /* 0.0 = transparent, 1.0 = opaque */

/* Icon color */
.stat-icon {
  color: #3b82f6;  /* Blue (default) */
}

/* Fuel bar gradient */
.fuel-bar {
  background: linear-gradient(90deg, #ef4444 0%, #f59e0b 50%, #22c55e 100%);
  /* Red → Yellow → Green */
}
```

## Performance Considerations

### Update Throttling

The system only sends NUI messages when values change:

```lua
-- Only update if speed or fuel changed
if math.abs(displaySpeed - lastSpeed) > 0 or 
   math.abs(fuel - lastFuel) > 0.5 then
    SendNUIMessage(...)
end
```

This reduces unnecessary UI updates and improves performance.

### Native Caching

Frequently-used natives are cached at the top of the file:

```lua
local GetEntitySpeed = GetEntitySpeed
local GetVehicleFuelLevel = GetVehicleFuelLevel
local IsPedInAnyVehicle = IsPedInAnyVehicle
-- etc.
```

This provides minor performance gains over repeated global lookups.

## First-Person Detection

The system uses `GetFollowPedCamViewMode()` to detect camera mode:

```lua
local function IsFirstPersonMode()
    return GetFollowPedCamViewMode() == 4
end
```

**Camera modes:**
- `4`: First-person
- `0`, `1`, `2`: Third-person variations

## Integration with Existing Systems

### HUD Component Structure

The Vehicle HUD is separate from the main player stats HUD (`HUD.vue`):

- `HUD.vue`: Health, Armor, Hunger, Thirst, Stress (always visible)
- `VehicleHUD.vue`: Speed, Fuel (vehicle only)

They are independently rendered in `App.vue`:

```vue
<HUD v-if="uiStore.showHUD" />
<VehicleHUD />
```

The Vehicle HUD does not rely on any store state and manages its own visibility.

### StateBag Integration

The Vehicle HUD uses **client-side only** data:
- Speed: Direct entity speed calculation
- Fuel: Client-side fuel level native

It does NOT read from StateBags, making it very responsive with no server delay.

## Troubleshooting

### HUD Not Appearing

1. **Check if in driver seat**: Passenger seats won't show HUD
2. **Disable first-person**: HUD hidden in first-person mode
3. **Verify resource loaded**: Check F8 console for errors
4. **Rebuild NUI**: Run `npm run build` in `nui/` folder

### Speed Incorrect

1. **Check unit setting**: MPH vs KPH in `_vehicle_hud.lua`
2. **Verify conversion**: Ensure proper multiplier (2.236936 for MPH, 3.6 for KPH)

### Fuel Not Updating

1. **Check vehicle fuel system**: Some vehicles may not support fuel natives
2. **Verify GetVehicleFuelLevel**: Native must return valid value (0-100)

### HUD Position Wrong

Edit CSS in `nui/src/components/VehicleHUD.vue` (see Customization section above).

### Performance Issues

1. **Increase update interval**: Change `Wait(100)` to `Wait(200)` or higher
2. **Check other scripts**: Conflicts with other HUD resources
3. **GPU acceleration**: Enable in browser settings

## Example Use Cases

### Racing Server
- Show MPH for American-style racing
- Reduce update interval to 50ms for very smooth updates
- Position in bottom-center for better visibility

### Roleplay Server
- Show KPH for European-style RP
- Standard 100ms update rate
- Keep in bottom-right to minimize screen clutter

### Drift/Stunt Server
- Show MPH with larger, more visible design
- Very fast updates (50ms) for precision driving
- Move to top-right to avoid blocking minimap

## Future Enhancements

Possible future additions:
- Gear indicator
- RPM/tachometer
- Damage indicator
- Engine temperature
- Nitrous/boost level
- Lap times (racing)
- GPS direction
- Custom positioning system (draggable)

## Related Files

- `client/_vehicle_hud.lua` - Client-side logic and update loop
- `nui/src/components/VehicleHUD.vue` - Vue UI component
- `nui/src/App.vue` - Component registration
- `fxmanifest.lua` - Resource manifest (includes _vehicle_hud.lua)

## Configuration

Currently, the Vehicle HUD has no configuration file. All settings are hardcoded in the source files. If you need configuration options, you can add them to `_config/config.lua`:

```lua
-- Example configuration structure (not implemented)
conf.vehicleHud = {}
conf.vehicleHud.enabled = true
conf.vehicleHud.speedUnit = "MPH"  -- "MPH" or "KPH"
conf.vehicleHud.updateRate = 100    -- milliseconds
conf.vehicleHud.position = "bottom-right"  -- position preset
conf.vehicleHud.showInFirstPerson = false  -- always false for realism
```

This would require modifications to `client/_vehicle_hud.lua` to read these values.
