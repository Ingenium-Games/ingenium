# Drop System Usage Guide

## Overview
The drop system allows players to drop items as physical props in the world. Drops persist across server restarts and support multi-player interaction through a drag-and-drop NUI inventory interface.

## Configuration

Located in `_config/config.lua`:

```lua
conf.drops = {}
conf.drops.cleanup_enabled = false              -- Auto-cleanup disabled by default
conf.drops.cleanup_time = 30 * conf.min         -- 30 minutes before cleanup (if enabled)
conf.drops.default_model = `v_ret_gc_box1`      -- Default prop model (backticks auto-hash)
conf.drops.active_timeout = 5 * conf.min        -- 5 minutes before deactivating
```

**Note:** The backtick notation (`) allows FiveM runtime to automatically hash the model, eliminating manual GetHashKey calls.

## How It Works

### Player Interaction Flow

1. **Opening a Drop**
   - Player approaches drop (within 2.0 meters)
   - Uses `ig.target` to see "Open Drop" option
   - Clicks to open dual-panel inventory UI
   - Server activates drop (moves to `c.active_drops`)

2. **Transferring Items**
   - Player sees their inventory on left panel
   - Drop inventory on right panel
   - Drag and drop items between panels
   - State Bags sync changes in real-time
   - Other nearby players see updates instantly

3. **Closing the Drop**
   - Player closes inventory UI
   - NUI sends final inventories to server
   - Server validates and saves via `OrganizeInventories`
   - Drop deactivates (moves back to `c.drops`)
   - If empty, drop is automatically removed

## Server-Side Usage

### Creating a Drop

```lua
local coords = {x = 100.0, y = 200.0, z = 30.0, h = 90.0}
local items = {
    {"bread", 2, 100, false, {}},
    {"water", 1, 100, false, {}}
}
local model = `v_ret_gc_box1`  -- Optional, uses default if nil

local netId = c.drop.Create(coords, items, model)
```

### Removing a Drop

```lua
c.drop.Remove(netId)
```

### Activating/Deactivating Drops

Drops are automatically managed:
- **Activated** when player opens inventory UI
- **Deactivated** when player closes UI (if not empty)
- **Removed** automatically if inventory becomes empty

```lua
c.drop.Activate(netId)   -- Manual activation (rare)
c.drop.Deactivate(netId) -- Manual deactivation (rare)
```

## Client-Side Usage

### Opening a Drop

The target system handles this automatically. Alternatively, trigger programmatically:

```lua
local netId = NetworkGetNetworkIdFromEntity(dropEntity)
TriggerEvent("Client:Inventory:OpenDual", netId, "Ground Drop")
TriggerServerEvent('Server:Drop:Access', netId)
```

### Dropping Items from Inventory

Players can drop items using the inventory UI "drop" action, which triggers:

```lua
TriggerServerEvent('Server:Item:Drop', item, quantity, quality, weapon, meta)
```

Example:
```lua
TriggerServerEvent('Server:Item:Drop', 'bread', 2, 100, false, {})
```

## Events

### Server Events

- `Server:Drop:Access` - Player opens a drop
  - Parameters: `netId`
  - Auto-activates drop
  
- `Server:Drop:Close` - Player closes drop UI
  - Parameters: `netId`
  - Auto-deactivates or removes drop
  
- `Server:Item:Drop` - Player drops item from inventory
  - Parameters: `item, quantity, quality, weapon, meta`
  - Creates new drop at player's feet

### Client Events

- `Client:Drop:InventoryUpdated` - Drop inventory changed
  - Parameters: `netId, inventory`
  - Triggered by State Bag updates

### Server Callbacks

- `GetInventory` - Gets inventory for any entity (vehicle, object, player)
  - Used when opening dual inventory
  
- `OrganizeInventories` - Validates and saves dual inventory changes
  - Handles drag-and-drop transfers
  - Auto-removes empty drops
  - Auto-deactivates non-empty drops

## Multi-Player Synchronization

The system uses Entity State Bags for seamless real-time sync:

1. Player A opens drop → Server activates it
2. Player A drags item to their inventory
3. NUI updates both inventories locally
4. Player A closes UI → `OrganizeInventories` called
5. Server validates and updates `xObject.Inventory`
6. `xObject.UnpackInventory()` updates `Entity.state.Inventory`
7. Player B (nearby) receives State Bag change
8. Player B's client updates automatically if they have drop UI open

**Key Benefits:**
- No manual sync events needed
- Automatic propagation to all clients
- Built-in by FiveM/OneSync
- Works with existing inventory system

## Persistence

Drops are saved to `data/Drops.json`:

```json
{
  "uuid-here": {
    "UUID": "uuid-here",
    "NetID": 12345,
    "Coords": {"x": 100.0, "y": 200.0, "z": 30.0, "h": 90.0},
    "Model": 123456789,
    "Inventory": [
      ["bread", 2, 100, false, {}]
    ],
    "Created": 1234567890,
    "Updated": 1234567890
  }
}
```

### Automatic Restoration

On server restart:
1. Drops loaded from JSON via `c.data.LoadJSONData()`
2. Physical props recreated at saved positions
3. Inventory items validated and restored
4. State Bags initialized
5. All drops ready for interaction

## Cleanup System

Optional cleanup of old drops:

```lua
-- Enable in config
conf.drops.cleanup_enabled = true
conf.drops.cleanup_time = 30 * conf.min  -- 30 minutes

-- Manual cleanup
c.drop.CleanupOld()
```

- Runs every 5 minutes (if enabled)
- Removes drops older than `cleanup_time`
- Respects `cleanup_enabled` flag

## State Management

### c.drops
Persistent drops stored in memory and JSON

### c.active_drops
Drops currently being accessed by players

### Flow
```
Player opens drop:
  c.drops → c.active_drops

Player closes drop (not empty):
  c.active_drops → c.drops

Player closes drop (empty):
  c.active_drops → removed

Periodic save:
  c.drops + c.active_drops → JSON

Server restart:
  JSON → c.drops → world entities
```

## Integration with Existing Systems

### Inventory System
- Uses existing `OrganizeInventories` callback
- Leverages `xObject.UnpackInventory()` for validation
- State Bags already configured on objects
- No changes needed to core inventory logic

### Validation System
- `c.validation.ValidateInventoryIntegrity()` prevents duplication
- Item existence checked during restoration
- Quantity validation on drops
- Exploit detection and logging

### Target System
- `ig.target` integration for drop interaction
- Model-based targeting (automatic for all drops)
- Configurable distance and labels

## Error Handling

- **Invalid items** skipped during restoration
- **Failed object creation** logged with UUID
- **Nil xObjects** handled gracefully in save routine
- **Quantity validation** prevents duplication exploits
- **Empty drops** auto-removed after UI close

## Commands

- `savedata` - Manual save of all dynamic data (admin only)
  - Includes active drops merged with persistent drops
  - Validates and updates all inventories before saving

## Best Practices

1. **Model Hashing**: Always use backticks for models: `` `v_ret_gc_box1` ``
2. **Validation**: Trust the existing validation system
3. **State Bags**: Let them handle synchronization automatically
4. **Cleanup**: Enable on public servers to prevent clutter
5. **UI Integration**: Use `Client:Inventory:OpenDual` for consistent UX

## Troubleshooting

### Drops not appearing
- Check `c.drops` table in server console
- Verify model hash is valid: `conf.drops.default_model`
- Check entity creation in server logs

### Items not persisting
- Verify JSON write permissions on `data/Drops.json`
- Check save routine logs for errors
- Ensure `c.drop.Deactivate()` is called on close

### UI not opening
- Verify `ig.target` is installed and running
- Check client console for NUI errors
- Ensure `Client:Inventory:OpenDual` event exists

### Synchronization issues
- Ensure OneSync is enabled (required for State Bags)
- Check `Entity(entity).state.Inventory` is being set
- Verify State Bag change handler is registered

### Empty drops not removing
- Check `OrganizeInventories` callback in logs
- Verify `c.drop.Remove()` is being called
- Check entity existence after removal

## Examples

### Drop all of one item type
```lua
-- Client-side
local itemName = "bread"
local quantity = c.inventory.GetItemQuantity(itemName)
if quantity > 0 then
    TriggerServerEvent('Server:Item:Drop', itemName, quantity, 100, false, {})
end
```

### Create drop with multiple items
```lua
-- Server-side
local coords = GetEntityCoords(GetPlayerPed(source))
local items = {
    {"bread", 5, 100, false, {}},
    {"water", 3, 100, false, {}},
    {"bandage", 2, 100, false, {}}
}
c.drop.Create(coords, items)
```

### Open drop programmatically
```lua
-- Client-side
local entity = GetClosestObjectOfType(coords, 2.0, conf.drops.default_model, false, false, false)
if entity ~= 0 then
    local netId = NetworkGetNetworkIdFromEntity(entity)
    TriggerEvent("Client:Inventory:OpenDual", netId, "Supply Drop")
    TriggerServerEvent('Server:Drop:Access', netId)
end
```

### Manual cleanup
```lua
-- Server console or command
c.drop.CleanupOld()
```

## Technical Notes

- **Object Type**: Drops are type 3 entities (objects)
- **Network Ownership**: Managed by FiveM networking
- **State Bags**: Replicated automatically by OneSync
- **Inventory Format**: Same as vehicles/objects/players
- **Validation**: Shared with all inventory operations

