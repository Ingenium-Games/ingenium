# Development Tools Documentation

## Overview
Integrated development tools for ingenium framework development and debugging. Formerly `ig.dev`, now built into the core framework.

**Location:** `client/[Dev]/` and `server/[Dev]/`
**Configuration:** `_config/dev.lua`

## Table of Contents
- [Client-Side Tools](#client-side-tools)
- [Server-Side Tools](#server-side-tools)
- [Configuration](#configuration)
- [Output Options](#output-options)

---

## Client-Side Tools

### Debug Drawing Functions

Located in `client/[Dev]/_debug.lua`

#### DrawText3Ds
Draws 3D text in the game world for debugging.

**Usage:**
```lua
-- Function is available globally once loaded
DrawText3Ds(x, y, z, text)
```

**Parameters:**
- `x, y, z` (number): World coordinates
- `text` (string): Text to display

**Example:**
```lua
CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        DrawText3Ds(coords.x, coords.y, coords.z + 1.0, "Player Position")
    end
end)
```

---

#### ShowVehicles
Shows debug information for nearby vehicles.

**Configuration:**
```lua
conf.dev.debug.show_vehicles = true
```

---

#### ShowObjects
Shows debug information for nearby objects.

**Configuration:**
```lua
conf.dev.debug.show_objects = true
```

---

### Door Creator Tool

Located in `client/[Dev]/_doorcreator.lua`

Interactive tool for creating door configurations using raycasting.

**Features:**
- Raycast targeting to identify doors
- Automatic door configuration generation
- Output to console and/or file
- Compatible with ingenium's door system format

**Configuration:**
```lua
conf.dev.door_creator = {
    enabled = true,
    raycast_distance = 10.0,
    output = {
        console = true,        -- Print to console
        file = true,           -- Save to file
        location = "local",    -- "local" or "server"
        file_path = "door_configs/",
    },
}
```

**Usage:**
1. Enable the tool in configuration
2. Use the targeting system to aim at a door
3. Follow on-screen prompts to configure the door
4. Output is generated in ingenium door format

**Output Format:**
```lua
{
    hash = 110411286,
    coords = vector3(434.7, -981.9, 30.7),
    locked = true,
    heading = 90.0,
    model = "v_ilev_ph_gendoor004",
}
```

---

### Vehicle Seats System

Located in `client/[Dev]/_vehicleseats.lua`

Provides enhanced vehicle seat interaction capabilities.

**Configuration:**
```lua
conf.dev.vehicle_seats = {
    enabled = true,
}
```

---

### Ammunation Locations

Located in `client/[Dev]/_ammunation.lua`

Reference data for ammunation locations and delivery points used in development.

---

### Global Variables

Located in `client/[Dev]/_var.lua`

Provides access to development-specific variables and utilities:
- Freecam integration
- Debug mode toggles
- Development state management

---

## Server-Side Tools

### Development Commands

Located in `server/[Dev]/_commands.lua`

Provides server-side commands for development and debugging.

**Command Registration:**
Commands are automatically registered when the resource starts.

**Common Commands:**
- Vehicle spawning
- Teleportation
- Permission testing
- State manipulation

---

### Server Variables

Located in `server/[Dev]/_var.lua`

Server-side development variables and state management.

---

## Configuration

### Main Configuration File
**Location:** `_config/dev.lua`

### Global Settings

```lua
-- Enable/disable all development tools
conf.dev.enabled = true

---

### Debug Settings

```lua
conf.dev.debug = {
    draw_text_3d = true,     -- Enable 3D text debug drawing
    show_vehicles = false,   -- Show vehicle debug info
    show_objects = false,    -- Show object debug info
}
```

---

### Door Creator Settings

```lua
conf.dev.door_creator = {
    enabled = true,
    raycast_distance = 10.0,
    output = {
        console = true,          -- Print configurations to console
        file = true,             -- Save configurations to file
        location = "local",      -- "local" = client files, "server" = server files
        file_path = "door_configs/",  -- Output directory
    },
}
```

---

## Output Options

The development tools provide flexible output options for collaboration and external development.

### Global Output Configuration

```lua
conf.dev.output = {
    -- Console output settings
    console = {
        enabled = true,
        use_colors = true,    -- Use colored output for readability
        verbose = false,      -- Show detailed debug information
    },
    
    -- File output settings
    file = {
        enabled = true,
        location = "local",   -- "local" or "server"
        base_path = "dev_output/",  -- Base directory for output
        timestamp = true,     -- Include timestamp in filenames
        format = "lua",       -- "lua", "json", or "txt"
    },
    
    -- Collaboration settings
    collaboration = {
        share_output = false,        -- Allow sharing with other developers
        export_format = "json",      -- Format for shared exports
        include_metadata = true,     -- Include creator, timestamp, etc.
    },
}
```

---

### Command-Specific Overrides

Override global settings for specific commands:

```lua
conf.dev.commands = {
    door_creator = {
        output = {
            console = true,
            file = true,
            location = "local",
        },
    },
    debug_draw = {
        output = {
            console = true,
            file = false,  -- Don't save debug visualizations
        },
    },
}
```

---

### Output Formats

#### Lua Format
```lua
-- Output example
return {
    creator = "PlayerName",
    timestamp = "2026-01-08 10:00:00",
    data = {
        -- Configuration data
    },
}
```

#### JSON Format
```json
{
    "creator": "PlayerName",
    "timestamp": "2026-01-08T10:00:00Z",
    "data": {
        // Configuration data
    }
}
```

#### Text Format
```
Creator: PlayerName
Timestamp: 2026-01-08 10:00:00
---
Configuration data as readable text
```

---

### File Output Locations

#### Local (Client-Side)
- Files saved to FiveM application data directory
- Accessible by the player creating them
- Format: `FiveM/Application Data/ingenium/dev_output/`

#### Server (Server-Side)
- Files saved to server resource directory
- Accessible to all developers with server access
- Format: `resources/ingenium/dev_output/`

---

## Best Practices

### Development Mode
1. **Enable only in development environments**
   ```lua
   conf.dev.enabled = GetConvar('sv_environment', 'production') == 'development'
   ```

2. **Disable in production**
   - Set `conf.dev.enabled = false` in production server.cfg

### Collaboration
1. **Use JSON format for sharing**
   - More portable across different systems
   - Easier to version control

2. **Include metadata**
   - Helps track who created configurations
   - Useful for troubleshooting

3. **Organize output files**
   - Use descriptive filenames
   - Group related configurations

### Performance
1. **Disable unused debug features**
   - Turn off `show_vehicles` and `show_objects` when not needed
   - Disable 3D text drawing when not actively debugging

2. **Limit debug output**
   - Use conditional debug statements
   - Clean up debug code before production

---

## Examples

### Example 1: Creating Door Configurations

```lua
-- 1. Configure in _config/dev.lua
conf.dev.door_creator = {
    enabled = true,
    output = {
        console = true,
        file = true,
        location = "local",
        file_path = "door_configs/",
    },
}

-- 2. Use the tool in-game
-- Aim at door with targeting system
-- Follow prompts to configure
-- Configuration saved to: dev_output/door_configs/door_TIMESTAMP.lua
```

---

### Example 2: Debug Vehicle Information

```lua
-- Enable in configuration
conf.dev.debug.show_vehicles = true

-- Now shows debug info for nearby vehicles
-- Displays: Model, Health, Fuel, Plate, etc.
```

---

### Example 3: Custom Debug Output

```lua
-- In your development code
if conf.dev.enabled then
    if conf.dev.output.console.enabled then
        print("^2[DEV]^0 Custom debug message")
    end
    
    if conf.dev.output.file.enabled then
        -- Save to file logic
        local filename = string.format("%s/custom_debug_%s.%s",
            conf.dev.output.file.base_path,
            os.date("%Y%m%d_%H%M%S"),
            conf.dev.output.file.format
        )
        -- Write to filename
    end
end
```

---

## Troubleshooting

### Tools Not Working
- Check `conf.dev.enabled = true`
- Verify specific tool is enabled in configuration
- Check console for error messages

### Output Files Not Created
- Verify `conf.dev.output.file.enabled = true`
- Check file path permissions
- Ensure base_path directory exists

### Performance Issues
- Disable unused debug features
- Reduce raycast distance for door creator
- Turn off 3D text drawing when not needed

---

## Security Considerations

1. **Never enable dev tools in production**
2. **Restrict command access to developers**
3. **Review output files before sharing**
4. **Don't commit sensitive data to version control**
5. **Use server-side file output for sensitive configurations**

---

## Related Documentation
- [Target System API](Target_System_API.md)
- [Door System Documentation](Door_System.md)
- [Security Guide](Security_Guide.md)
- [Configuration Guide](Configuration_Guide.md)
