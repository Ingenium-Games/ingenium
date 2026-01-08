# Target System API Reference

## Overview
The integrated targeting system provides raycast-based entity interaction capabilities. Formerly `ig.target`, now integrated as core ingenium functionality.

**Export Name:** `exports['ingenium']` (also available as `exports['ig.target']` for backward compatibility)

## Table of Contents
- [Zone Functions](#zone-functions)
- [Global Target Functions](#global-target-functions)
- [Model Target Functions](#model-target-functions)
- [Entity Target Functions](#entity-target-functions)
- [Configuration](#configuration)

---

## Zone Functions

### AddPolyZone
Creates a polygon-shaped interaction zone.

**Syntax:**
```lua
exports['ingenium']:AddPolyZone(data)
```

**Parameters:**
- `data` (table): Zone configuration
  - `name` (string): Unique identifier for the zone
  - `points` (table): Array of vector3 points defining the polygon
  - `options` (table): Array of interaction options
  - `distance` (number, optional): Interaction distance (default: 2.5)
  - `debugPoly` (boolean, optional): Show debug visualization

**Example:**
```lua
exports['ingenium']:AddPolyZone({
    name = "police_station",
    points = {
        vector3(440.0, -982.0, 30.0),
        vector3(442.0, -995.0, 30.0),
        vector3(430.0, -997.0, 30.0),
        vector3(428.0, -984.0, 30.0),
    },
    options = {
        {
            icon = 'fas fa-clipboard',
            label = 'Check In',
            action = function()
                print("Checked in at police station")
            end,
        },
    },
    distance = 2.5,
})
```

---

### AddBoxZone
Creates a box-shaped interaction zone.

**Syntax:**
```lua
exports['ingenium']:AddBoxZone(data)
```

**Parameters:**
- `data` (table): Zone configuration
  - `name` (string): Unique identifier
  - `coords` (vector3): Center coordinates
  - `length` (number): Box length
  - `width` (number): Box width
  - `options` (table): Interaction options
  - `heading` (number, optional): Box rotation
  - `minZ` (number, optional): Minimum Z coordinate
  - `maxZ` (number, optional): Maximum Z coordinate

**Example:**
```lua
exports['ingenium']:AddBoxZone({
    name = "atm_interaction",
    coords = vector3(147.0, -1035.0, 29.0),
    length = 1.0,
    width = 1.0,
    heading = 340.0,
    options = {
        {
            icon = 'fas fa-dollar-sign',
            label = 'Use ATM',
            action = function()
                -- Open banking UI
            end,
        },
    },
})
```

---

### AddSphereZone
Creates a sphere-shaped interaction zone.

**Syntax:**
```lua
exports['ingenium']:AddSphereZone(data)
```

**Parameters:**
- `data` (table): Zone configuration
  - `name` (string): Unique identifier
  - `coords` (vector3): Center coordinates
  - `radius` (number): Sphere radius
  - `options` (table): Interaction options

**Example:**
```lua
exports['ingenium']:AddSphereZone({
    name = "mission_pickup",
    coords = vector3(215.0, -810.0, 30.0),
    radius = 3.0,
    options = {
        {
            icon = 'fas fa-box',
            label = 'Pickup Package',
            action = function()
                -- Mission logic
            end,
        },
    },
})
```

---

### removeZone
Removes a zone by ID.

**Syntax:**
```lua
exports['ingenium']:removeZone(id)
```

**Parameters:**
- `id` (number): Zone ID returned from Add*Zone functions

---

## Global Target Functions

### AddGlobalPed
Adds target options to all peds (NPCs).

**Syntax:**
```lua
exports['ingenium']:AddGlobalPed(options)
```

**Parameters:**
- `options` (table): Array of interaction options

**Example:**
```lua
exports['ingenium']:AddGlobalPed({
    {
        name = 'talk_to_ped',
        icon = 'fas fa-comments',
        label = 'Talk',
        interact = function(entity, distance, coords, name, bone)
            -- Check if should show option
            return not IsPedAPlayer(entity)
        end,
        action = function(data)
            -- data.entity contains the ped
            print("Talking to ped", data.entity)
        end,
    },
})
```

---

### AddGlobalVehicle
Adds target options to all vehicles.

**Syntax:**
```lua
exports['ingenium']:AddGlobalVehicle(options)
```

**Example:**
```lua
exports['ingenium']:AddGlobalVehicle({
    {
        name = 'enter_vehicle',
        icon = 'fas fa-car',
        label = 'Enter Vehicle',
        bones = {'door_dside_f'},
        interact = function(entity, distance, coords, name, bone)
            return GetVehicleDoorLockStatus(entity) == 1
        end,
        action = function(data)
            TaskEnterVehicle(PlayerPedId(), data.entity, -1, -1, 1.0, 1, 0)
        end,
    },
})
```

---

### AddGlobalObject
Adds target options to all objects.

**Syntax:**
```lua
exports['ingenium']:AddGlobalObject(options)
```

---

### AddGlobalPlayer
Adds target options to all player peds.

**Syntax:**
```lua
exports['ingenium']:AddGlobalPlayer(options)
```

**Example:**
```lua
exports['ingenium']:AddGlobalPlayer({
    {
        name = 'trade_player',
        icon = 'fas fa-handshake',
        label = 'Trade',
        action = function(data)
            local targetPlayer = NetworkGetPlayerIndexFromPed(data.entity)
            -- Open trade UI
        end,
    },
})
```

---

## Model Target Functions

### AddModel
Adds target options to specific models.

**Syntax:**
```lua
exports['ingenium']:AddModel(models, options)
```

**Parameters:**
- `models` (number|table): Model hash or array of model hashes
- `options` (table): Array of interaction options

**Example:**
```lua
-- Single model
exports['ingenium']:AddModel(`prop_atm_01`, {
    {
        icon = 'fas fa-dollar-sign',
        label = 'Use ATM',
        action = function(entity)
            -- Open banking
        end,
    },
})

-- Multiple models
exports['ingenium']:AddModel({
    `prop_vend_soda_01`,
    `prop_vend_soda_02`,
}, {
    {
        icon = 'fas fa-shopping-cart',
        label = 'Buy Soda',
        action = function(entity)
            -- Purchase logic
        end,
    },
})
```

---

### removeModel
Removes target options from models.

**Syntax:**
```lua
exports['ingenium']:removeModel(models, options)
```

---

## Entity Target Functions

### AddEntity
Adds target to a networked entity.

**Syntax:**
```lua
exports['ingenium']:AddEntity(netIds, options)
```

**Parameters:**
- `netIds` (number|table): Network ID or array of network IDs
- `options` (table): Interaction options

---

### AddLocalEntity
Adds target to a local (client-side) entity.

**Syntax:**
```lua
exports['ingenium']:AddLocalEntity(entities, options)
```

**Parameters:**
- `entities` (number|table): Entity handle or array of entity handles
- `options` (table): Interaction options

**Example:**
```lua
local entity = CreateObject(`prop_cs_cardbox_01`, coords.x, coords.y, coords.z, false, false, false)
exports['ingenium']:AddLocalEntity(entity, {
    {
        icon = 'fas fa-box-open',
        label = 'Open Box',
        action = function(data)
            DeleteEntity(data.entity)
        end,
    },
})
```

---

### AddEntityZone
Compatibility wrapper for door system integration.

**Syntax:**
```lua
exports['ingenium']:AddEntityZone(name, entity, zoneOptions, targetOptions)
```

---

## Option Structure

Each interaction option can have the following properties:

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Unique identifier for the option |
| `icon` | string | FontAwesome icon class |
| `label` | string | Display text |
| `action` | function | Callback when option is selected |
| `interact` | function | Conditional display check |
| `job` | string/table | Required job(s) |
| `item` | string/table | Required item(s) |
| `distance` | number | Max interaction distance |
| `bones` | string/table | Vehicle bone names to attach to |

### Action Callback
```lua
action = function(data)
    -- data.entity: The entity being targeted
    -- data.coords: World coordinates of the target point
    -- data.distance: Distance to target
    -- data.bone: Bone ID if targeting a vehicle bone
end
```

### Interact Callback
```lua
interact = function(entity, distance, coords, name, bone)
    -- Return true to show option, false to hide
    return someCondition
end
```

---

## Configuration

Target system configuration is located in `client/[Target]/_var.lua`:

```lua
MaxTargetDistance = 7.0  -- Maximum raycast distance
Debug = false           -- Enable debug visualization
```

---

## Migration Guide

### From ig.target to ingenium

**Old:**
```lua
exports['ig.target']:AddModel(model, {
    options = { ... },
    distance = 2.0,
})
```

**New:**
```lua
exports['ingenium']:AddModel(model, {
    { ... },  -- Array of options directly
})
```

**Note:** The old format with `options` wrapper is no longer used. Pass options array directly.

---

## Best Practices

1. **Use Unique Names:** Always provide unique `name` properties for options
2. **Optimize Interact Functions:** Keep interact checks lightweight
3. **Clean Up:** Remove targets when no longer needed
4. **Distance Optimization:** Use appropriate distance values to reduce performance impact
5. **Resource Tracking:** The system automatically cleans up when resources stop

---

## Troubleshooting

### Target Not Appearing
- Check if `interact` function returns true
- Verify distance is within MaxTargetDistance
- Ensure model/entity exists

### Performance Issues
- Reduce MaxTargetDistance if needed
- Limit number of global targets
- Use model-specific targets instead of global when possible

---

## Related Documentation
- [Development Tools](Development_Tools.md)
- [Zone Management](Zone_Management.md)
- [Garage System](Garage_System.md)
