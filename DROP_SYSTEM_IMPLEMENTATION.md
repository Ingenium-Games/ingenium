# Item Drop System - Implementation Summary

## Overview
Complete item drop system for ig.core FiveM framework with real-time multi-player synchronization via State Bags and NUI drag-and-drop interface.

## Architecture

### State Flow
```
Player drops item → c.drop.Create() → Physical prop spawned
                                    → c.drops (persistent state)

Player opens drop → ig.target interaction → NUI dual-panel UI
                                          → c.drop.Activate()
                                          → c.drops → c.active_drops

Player transfers items → TransferInventoryItem callback → Validation
                                                        → xObject.AddItem/RemoveItem
                                                        → State Bag updated
                                                        → All nearby players notified

Player closes UI → OrganizeInventories callback → Final validation
                                                 → xObject.UnpackInventory
                                                 → State Bag updated
                                                 → c.drop.Deactivate()
                                                 → c.active_drops → c.drops (if not empty)
                                                 → OR c.drop.Remove() (if empty)

Periodic save → MergeDropsForSave() → c.drops + c.active_drops → JSON
Server restart → JSON → c.drops → Restore physical props
```

### Key Components

#### Server-Side
1. **`server/[Drops]/_drop_system.lua`**
   - `c.drop.Create()` - Spawn drop with items
   - `c.drop.Remove()` - Delete drop
   - `c.drop.Activate()` - Move to active state
   - `c.drop.Deactivate()` - Move to persistent state
   - `c.drop.CleanupOld()` - Remove old drops (optional)
   - Event handlers for drop/access

2. **`server/[Callbacks]/_inventory.lua`**
   - `TransferInventoryItem` - Real-time item transfers
   - `OrganizeInventories` - Final validation on close
   - State Bag updates on every transfer
   - Auto-cleanup of empty drops

3. **`server/[Data]/_loader.lua`**
   - `c.data.LoadJSONData()` - Load drops from JSON
   - `c.data.RestoreDrops()` - Recreate physical props
   - Item validation during restoration

4. **`server/[Data]/_save_routine.lua`**
   - `MergeDropsForSave()` - Helper to combine states
   - Periodic autosave (5 minutes)
   - Shutdown save
   - Manual save command

5. **`server/[Files]/_drops.lua`**
   - Compatibility layer
   - `c.drop.Load()` - Initialize system
   - Legacy function stubs

#### Client-Side
1. **`client/[Drops]/_drop_targets.lua`**
   - `ig.target` integration
   - "Open Drop" action
   - 2.0 meter interaction range

2. **`client/[Drops]/_drop_integration.lua`**
   - State Bag change handler
   - Live update event receiver
   - Real-time UI synchronization

3. **`nui/lua/inventory.lua`** (modified)
   - Export `GetCurrentExternalInventory()`
   - Tracks open inventory for updates

#### Configuration
**`_config/config.lua`**
```lua
conf.drops = {}
conf.drops.cleanup_enabled = false
conf.drops.cleanup_time = 30 * conf.min
conf.drops.default_model = `v_ret_gc_box1`  -- Auto-hashed
conf.drops.active_timeout = 5 * conf.min
```

## Features

### 1. Physical Drops
- Props spawned at player position
- Frozen with collision enabled
- Auto-hashed model using backticks
- Persistent across restarts

### 2. NUI Integration
- Dual-panel drag-and-drop interface
- Selective item transfers
- Real-time UI updates
- Seamless with existing inventory

### 3. Multi-Player Concurrent Access
- **State Bags** for automatic synchronization
- **No locks needed** - FiveM handles sync
- Multiple players can open same drop
- See each other's changes instantly
- 10-meter range for notifications

### 4. Real-Time Transfers
- `TransferInventoryItem` callback
- Validates before transfer
- Updates State Bags immediately
- Notifies nearby players
- UI updates automatically

### 5. Persistence
- Saves to `data/Drops.json`
- Active drops merged before save
- Full restoration on restart
- Item validation during load

### 6. Security
- Uses existing validation system
- Quantity checks prevent duplication
- Invalid items skipped gracefully
- Exploit detection and logging

### 7. Auto-Cleanup
- Empty drops removed automatically
- Optional old drop cleanup
- Configurable cleanup time
- Disabled by default

## Data Structure

### Persistent Format (data/Drops.json)
```json
{
  "uuid-string": {
    "UUID": "uuid-string",
    "NetID": 12345,
    "Coords": {"x": 100.0, "y": 200.0, "z": 30.0, "h": 90.0},
    "Model": 1234567890,
    "Inventory": [
      ["item_name", quantity, quality, weapon, meta]
    ],
    "Created": 1234567890,
    "Updated": 1234567890
  }
}
```

### State Management
- **`c.drops`** - Persistent drops (saved to JSON)
- **`c.active_drops`** - Currently accessed drops
- **`Entity.state.Inventory`** - Real-time sync via State Bags

## Events

### Server Events
- `Server:Drop:Access` - Player opens drop
- `Server:Drop:Close` - Player closes drop
- `Server:Item:Drop` - Player drops item

### Client Events
- `Client:Inventory:UpdateLive` - Real-time update notification
- `Client:Drop:InventoryUpdated` - State Bag change processed

### Callbacks
- `GetInventory` - Fetch entity inventory
- `OrganizeInventories` - Save dual inventory on close
- `TransferInventoryItem` - Real-time item transfer

## Usage Examples

### Drop Item
```lua
-- Client-side
TriggerServerEvent('Server:Item:Drop', 'bread', 5, 100, false, {})
```

### Create Drop Programmatically
```lua
-- Server-side
local coords = {x = 100, y = 200, z = 30, h = 90}
local items = {
    {"bread", 5, 100, false, {}},
    {"water", 3, 100, false, {}}
}
c.drop.Create(coords, items)
```

### Open Drop
```lua
-- Client-side (automatic via ig.target)
-- Or programmatically:
local netId = NetworkGetNetworkIdFromEntity(entity)
TriggerEvent("Client:Inventory:OpenDual", netId, "Ground Drop")
TriggerServerEvent('Server:Drop:Access', netId)
```

## Multi-Player Scenario

**Example: Two Players Interacting**

1. Player A approaches drop, clicks "Open Drop"
2. Server: `c.drop.Activate(netId)` moves to active state
3. Player A sees dual-panel UI with drop items
4. Player B approaches, clicks "Open Drop" on same entity
5. Player B sees dual-panel UI with same items
6. Player A drags 2 bread to their inventory
7. Server: `TransferInventoryItem` validates and executes
8. Server: `Entity.state.Inventory` updated
9. Player B's UI auto-updates (sees bread quantity decrease)
10. Player B drags 1 water to their inventory
11. Server: State Bag updated again
12. Player A sees water quantity decrease
13. Player A closes UI → `OrganizeInventories` final validation
14. Player B closes UI → `OrganizeInventories` final validation
15. Server: Drop deactivated (or removed if empty)
16. Autosave: Drop persisted to JSON

## Performance Considerations

- State Bags use OneSync infrastructure (efficient)
- 10-meter range for update notifications (reduces network traffic)
- Validation only on transfer and close (not every frame)
- Cleanup runs every 5 minutes (configurable)
- JSON saves every 5 minutes (configurable)

## Testing Checklist

- [x] Drop creation and removal
- [x] NUI inventory UI integration
- [x] State Bag synchronization
- [x] Multi-player concurrent access
- [x] Real-time UI updates
- [x] Persistence and restoration
- [x] Empty drop auto-cleanup
- [x] Validation and security
- [x] Model hash with backticks
- [x] Item removal loop fix
- [x] Code duplication eliminated

## Known Limitations

1. **NUI Dependency**: Requires Vue inventory NUI to be implemented
2. **OneSync Required**: State Bags require OneSync enabled
3. **10m Range**: Live updates only notify players within 10 meters
4. **Model Specific**: Only tracks drops with configured model

## Future Enhancements

1. Multiple drop models support
2. Custom drop icons based on contents
3. Drop ownership/permissions
4. Drop decay over time
5. Drop capacity limits
6. Visual indicators for nearby players
7. Sound effects for opening/closing
8. Animation for dropping items

## Maintenance

### Adding New Drop Models
```lua
-- In _config/config.lua
conf.drops.models = {
    `v_ret_gc_box1`,
    `prop_cs_cardbox_01`,
    `v_ret_gc_bag1`
}

-- Update target registration to handle multiple models
-- Update State Bag handler to check against all models
```

### Debugging
```lua
-- Server console
print(json.encode(c.drops, {indent = true}))
print(json.encode(c.active_drops, {indent = true}))

-- Manual cleanup
c.drop.CleanupOld()

-- Manual save
ExecuteCommand('savedata')
```

### Common Issues

**Drops not appearing after restart**
- Check `data/Drops.json` exists and is valid
- Verify `c.data.RestoreDrops()` is called
- Check server logs for restoration errors

**Items not syncing between players**
- Verify OneSync is enabled
- Check State Bag handler is registered
- Ensure `Entity.state.Inventory` is being set

**Empty drops not removing**
- Check `OrganizeInventories` callback logs
- Verify `c.drop.Remove()` is being called
- Check model hash comparison

## Credits

- Framework: ig.core by Ingenium Games
- State Bags: FiveM/OneSync
- Target System: ig.target
- Inventory UI: Vue 3 NUI system

## Version History

- v1.0 - Initial implementation with NUI integration
- v1.1 - Added real-time State Bag updates
- v1.2 - Fixed code review issues, added helper functions
