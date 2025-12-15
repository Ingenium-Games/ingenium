# Drop System Usage Guide

## Overview
The drop system allows players to drop items as physical props in the world. Drops persist across server restarts and support multi-player interaction.

## Configuration

Located in `_config/config.lua`:

```lua
conf.drops = {}
conf.drops.cleanup_enabled = false              -- Auto-cleanup disabled by default
conf.drops.cleanup_time = 30 * conf.min         -- 30 minutes before cleanup (if enabled)
conf.drops.default_model = "v_ret_gc_box1"      -- Default prop model
conf.drops.active_timeout = 5 * conf.min        -- 5 minutes before deactivating
```

## Server-Side Usage

### Creating a Drop

```lua
local coords = {x = 100.0, y = 200.0, z = 30.0, h = 90.0}
local items = {
    {"bread", 2, 100, false, {}},
    {"water", 1, 100, false, {}}
}
local model = "v_ret_gc_box1"  -- Optional, uses default if nil

local netId = c.drop.Create(coords, items, model)
```

### Removing a Drop

```lua
c.drop.Remove(netId)
```

### Activating/Deactivating Drops

Drops are automatically activated when opened and deactivated when closed:

```lua
c.drop.Activate(netId)   -- Move to active state
c.drop.Deactivate(netId) -- Move back to persistent state
```

## Client-Side Usage

### Dropping Items

Trigger the server event:

```lua
TriggerServerEvent('Server:Item:Drop', item, quantity, quality, weapon, meta)
```

Example:
```lua
TriggerServerEvent('Server:Item:Drop', 'bread', 2, 100, false, {})
```

### Picking Up Items

The `ig.target` integration automatically handles pickup. Players can:
1. Approach a drop (within 2.0 meters)
2. See "Pick Up Items" option
3. Press the interaction key
4. All items transfer to player inventory
5. Drop is removed if empty

## Events

### Server Events

- `Server:Item:Drop` - Player drops an item
  - Parameters: `item, quantity, quality, weapon, meta`
  
- `Server:Item:Pickup` - Player picks up items from a drop
  - Parameters: `netId`

### Client Events

- `Client:Drop:Update` - Drop inventory updated (for UI sync)
  - Parameters: `netId, inventory`

## Multi-Player Synchronization

The system uses Entity State Bags for real-time synchronization:

1. Player A opens drop → Server activates it
2. Player A takes item → `Entity(entity).state.Inventory` updates
3. Player B (nearby) sees update automatically via State Bag
4. Both players can interact simultaneously
5. Last player closes → Drop deactivates

## Persistence

Drops are saved to `data/Drops.json`:

```json
{
  "uuid-here": {
    "UUID": "uuid-here",
    "NetID": 12345,
    "Coords": {"x": 100.0, "y": 200.0, "z": 30.0, "h": 90.0},
    "Model": "v_ret_gc_box1",
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
1. Drops loaded from JSON
2. Physical props recreated at saved positions
3. Inventory items restored
4. State Bags initialized

## Cleanup System

Optional cleanup of old drops:

```lua
-- Enable in config
conf.drops.cleanup_enabled = true
conf.drops.cleanup_time = 30 * conf.min  -- 30 minutes

-- Manual cleanup
c.drop.CleanupOld()
```

Cleanup runs every 5 minutes (if enabled) and removes drops older than `cleanup_time`.

## State Management

### c.drops
Persistent drops stored in memory and JSON

### c.active_drops
Drops currently being accessed by players

### Flow
```
c.drops → c.active_drops (on open)
c.active_drops → c.drops (on close)
c.drops + c.active_drops → JSON (on save)
JSON → c.drops (on load)
```

## Integration with Inventory

The drop system integrates with the existing xObject inventory system:

- `xObject.AddItem()` - Add items to drop
- `xObject.RemoveItem()` - Remove items from drop
- `xObject.GetInventory()` - Get current inventory
- `xObject.CompressInventory()` - Get compressed format for saving
- `Entity(entity).state.Inventory` - State Bag for synchronization

## Error Handling

- Invalid items are skipped during restoration
- Failed object creation is logged
- Nil xObjects are handled gracefully during save
- Quantity validation prevents duplication exploits

## Commands

- `savedata` - Manual save of all dynamic data (admin only)
  - Includes active drops merged with persistent drops

## Best Practices

1. **Validation**: Always validate items exist before creating drops
2. **Quantities**: Check player has sufficient quantity before dropping
3. **Cleanup**: Enable cleanup on public servers to prevent world clutter
4. **Models**: Use consistent prop models for visual coherence
5. **State Bags**: Let State Bags handle synchronization (don't manually sync)

## Troubleshooting

### Drops not appearing
- Check `c.drops` table in server console
- Verify model hash is valid
- Check entity creation in logs

### Items not persisting
- Verify JSON write permissions
- Check `data/Drops.json` file
- Review save routine logs

### Synchronization issues
- Ensure State Bags are enabled (OneSync)
- Check `Entity(entity).state.Inventory` is being set
- Verify clients are receiving State Bag updates

## Examples

### Drop all bread
```lua
local itemName = "bread"
local quantity = xPlayer.GetItemQuantity(itemName)
if quantity > 0 then
    TriggerServerEvent('Server:Item:Drop', itemName, quantity, 100, false, {})
end
```

### Create drop with multiple items
```lua
local coords = GetEntityCoords(PlayerPedId())
local items = {
    {"bread", 5, 100, false, {}},
    {"water", 3, 100, false, {}},
    {"bandage", 2, 100, false, {}}
}
c.drop.Create(coords, items)
```

### Manual drop cleanup (server console)
```lua
c.drop.CleanupOld()
```
