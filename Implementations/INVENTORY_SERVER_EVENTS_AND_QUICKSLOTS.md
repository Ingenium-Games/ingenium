# Inventory System - Server Events and Quick Slots Implementation

**Date:** January 21, 2026  
**Status:** Completed  
**Related PR:** Fix inventory NUI: callback routing, code deduplication, draggable window

---

## Overview

This document outlines the implementation of server-side inventory event handlers (use, give, drop) and quick slot hotkey bindings (keyboard keys 1-4) with NUI indicators.

---

## Server-Side Inventory Events

### Event Chain Flow

```
NUI (Vue) → Client Callback → Server Event → Player Class → Client Event (if consumable)
```

### 1. Server:Inventory:UseItem

**Purpose:** Use an item from inventory (triggered from NUI or quick slots)

**Parameters:**
- `itemName` (string) - The name of the item to use
- `quantity` (number) - The quantity to use
- `position` (number) - The inventory slot position
- `panelId` (string) - The panel ID ("player" or "external")

**Flow:**
```lua
1. Validate invoking resource (security check)
2. Get player entity (xPlayer)
3. Validate input parameters
4. Get item from position
5. Verify item exists and matches
6. Call xPlayer.ConsumeItem(position)
7. ConsumeItem triggers "Inventory:Consume:{ItemName}" event
8. Event handler checks if item is consumable/weapon
9. If consumable: TriggerClientCallback("Client:Item:Consumeable", {itemName})
10. Client applies item effects (hunger, thirst, health, etc.)
```

**Consumable Item Example:**
```lua
-- Server triggers (from server/[Data - Save to File]/_items.lua line 433-442)
if ig.item.IsConsumeable(itemName) then
    xPlayer.RemoveItem(itemName, position)
    TriggerClientCallback({
        source = src,
        eventName = "Client:Item:Consumeable",
        args = {itemName}
    })
end

-- Client receives (from client/[Callbacks]/_inventory.lua line 58-116)
RegisterClientCallback({
    eventName = "Client:Item:Consumeable",
    eventCallback = function(itemName)
        local Data = ig.item.GetData(itemName)
        -- Apply hunger/thirst/stress modifiers
        -- Apply health/armour/status changes
        -- Add ammo if item is ammo type
    end
})
```

**Security Features:**
- Resource invocation validation
- Input sanitization via `ig.check.*`
- Item existence verification
- Position/quantity validation

---

### 2. Server:Inventory:GiveItem

**Purpose:** Give an item to the nearest player

**Parameters:**
- `itemName` (string) - The name of the item to give
- `quantity` (number) - The quantity to give
- `position` (number) - The inventory slot position

**Flow:**
```lua
1. Validate invoking resource
2. Get player entity (xPlayer)
3. Validate input parameters
4. Get item from position
5. Find nearest player within 3.0 meters
6. If no player nearby, notify and return
7. Remove item from giver's inventory
8. Add item to receiver's inventory
9. Notify both players
```

**Distance Calculation:**
```lua
local playerCoords = GetEntityCoords(playerPed)
local targetCoords = GetEntityCoords(targetPed)
local distance = #(playerCoords - targetCoords)
if distance < 3.0 then
    -- Transfer item
end
```

---

### 3. Server:Inventory:DropItem

**Purpose:** Drop an item on the ground creating a drop object

**Parameters:**
- `itemName` (string) - The name of the item to drop
- `quantity` (number) - The quantity to drop
- `position` (number) - The inventory slot position

**Flow:**
```lua
1. Validate invoking resource
2. Get player entity (xPlayer)
3. Validate input parameters
4. Get item from position
5. Calculate drop position (0.5m in front of player)
6. Remove item from player inventory
7. Create drop object via ig.drop.Create()
8. Notify player
```

**Drop Position Calculation:**
```lua
local playerHeading = GetEntityHeading(playerPed)
local forwardX = math.sin(math.rad(playerHeading)) * 0.5
local forwardY = math.cos(math.rad(playerHeading)) * 0.5
local dropCoords = vector3(
    playerCoords.x + forwardX,
    playerCoords.y + forwardY,
    playerCoords.z - 0.3
)
```

---

## Quick Slot Hotkeys (Keyboard 1-4)

### Configuration

**File:** `_config/defaults.lua` (line 52-65)

```lua
conf.inventory = {
    openKey = "I",
    closeKey = "ESC",
    allowHotkey = true,
    quickSlots = {
        slot1 = "1",
        slot2 = "2",
        slot3 = "3",
        slot4 = "4"
    },
    allowQuickSlots = true
}
```

**User Customization:**
Players can rebind quick slots in FiveM Settings:
1. ESC → Settings → Key Bindings → FiveM
2. Find "Use Quick Slot 1" through "Use Quick Slot 4"
3. Click to rebind to any preferred key

---

### Client Implementation

**File:** `nui/lua/inventory.lua` (line 162-240)

**Key Features:**
- Registers 4 commands: `useQuickSlot1` through `useQuickSlot4`
- Maps to keyboard keys 1, 2, 3, 4 via `RegisterKeyMapping`
- Only works when inventory is closed (prevents conflicts)
- Requires player to be loaded (`ig.data.IsPlayerLoaded()`)
- Uses existing `UseItemQuick` server callback

**Command Registration:**
```lua
RegisterCommand('useQuickSlot1', function()
    useQuickSlot(1)
end, false)

RegisterKeyMapping(
    'useQuickSlot1',
    'Use Quick Slot 1',
    'keyboard',
    conf.inventory.quickSlots.slot1:lower()
)
```

**UseItemQuick Callback:**
```lua
-- server/[Callbacks]/_inventory.lua (line 48-66)
local UseItemQuick = RegisterServerCallback({
    eventName = "UseItemQuick",
    eventCallback = function(source, number)
        local xPlayer = ig.data.GetPlayer(source)
        local itemtbl = xPlayer.GetItemFromPosition(number)
        if itemtbl then
            local useable = ig.item.CanHotkey(itemtbl.Item)
            if useable then
                xPlayer.ConsumeItem(number)
                return true
            else
                xPlayer.Notify("Item is not useable via quickslot: " .. number)
                return false
            end
        end
        xPlayer.Notify("No Item in Quickslot id: " .. number)
        return false
    end
})
```

**Item Hotkey Flag:**
Items must have `"Hotkey": true` in `data/items.json` to be useable via quick slots.

---

## NUI Quick Slot Indicators

### Visual Implementation

**File:** `nui/inventory/src/components/InventoryItem.vue`

**Features:**
- Gold badges (1-4) displayed on first 4 player inventory slots
- Visible on both full and empty slots
- Special gold border for quick slot items
- Badge shows slot number (1-based, not 0-based)

**Badge Display Logic:**
```javascript
// Only show for player inventory (not external)
const isQuickSlot = computed(() => {
    return props.panelId === 'player' && props.index >= 0 && props.index <= 3
})

// Display as 1-4 instead of 0-3
const quickSlotNumber = computed(() => {
    return props.index + 1
})
```

**CSS Styling:**
```css
.quickslot-badge {
    position: absolute;
    top: 4px;
    left: 4px;
    background: rgba(255, 193, 7, 0.9);  /* Gold */
    color: #000;
    font-size: 0.7rem;
    font-weight: 700;
    padding: 2px 6px;
    border-radius: 4px;
    z-index: 10;
}

.quickslot-badge.empty-badge {
    background: rgba(150, 150, 150, 0.5);  /* Gray for empty */
    color: rgba(255, 255, 255, 0.6);
}

.inventory-item.quickslot-item {
    border-color: rgba(255, 193, 7, 0.3);  /* Gold border */
}
```

---

## Security Considerations

### Server Event Validation

All server events implement:

1. **Resource Validation:**
   ```lua
   if GetInvokingResource() ~= conf.resourcename then
       ig.log.Error("Inventory", "Unauthorized resource attempted to trigger event")
       return
   end
   ```

2. **Input Sanitization:**
   ```lua
   itemName = ig.check.String(itemName)
   quantity = ig.check.Number(quantity, 1, 9999)
   position = ig.check.Number(position, 1, 100)
   ```

3. **Item Verification:**
   ```lua
   local item = xPlayer.GetItemFromPosition(position)
   if not item or item.Item ~= itemName then
       xPlayer.Notify("Item not found in inventory")
       return
   end
   ```

4. **Quantity Validation:**
   ```lua
   if item.Quantity < quantity then
       xPlayer.Notify("Insufficient quantity")
       return
   end
   ```

---

## Testing Checklist

### Server Events
- [ ] UseItem works for consumable items (food, water, medkit)
- [ ] UseItem works for weapon items (equips weapon)
- [ ] UseItem validates item position correctly
- [ ] GiveItem finds nearest player within 3m
- [ ] GiveItem transfers item correctly
- [ ] GiveItem notifies both players
- [ ] DropItem creates drop object in front of player
- [ ] DropItem removes item from inventory
- [ ] All events validate security properly

### Quick Slots
- [ ] Pressing 1-4 uses items from slots 1-4
- [ ] Quick slots only work when inventory is closed
- [ ] Quick slots only work for items with Hotkey=true
- [ ] Quick slots notify if slot is empty
- [ ] Quick slots notify if item not hotkey-able
- [ ] Users can rebind keys in FiveM settings

### NUI Indicators
- [ ] Gold badges show on slots 1-4 in player inventory
- [ ] No badges show on external inventory slots
- [ ] Badges display correct numbers (1-4)
- [ ] Empty quick slots show gray badges
- [ ] Quick slot items have gold border
- [ ] Badges don't interfere with dragging

---

## Known Limitations

1. **Quick Slot Distance:** No validation that item can be used from current player state (e.g., can't eat while in vehicle - depends on item-specific logic)

2. **Give Item Range:** Fixed 3.0 meter range, not configurable

3. **Drop Position:** Always 0.5m in front of player, not adjustable

4. **Badge Positioning:** Fixed top-left corner, may overlap with item image for some items

---

## Future Enhancements

1. **Quick Slot Customization:**
   - Allow players to assign any slot to quick slots (not just first 4)
   - Save quick slot assignments per character

2. **Context-Aware Usage:**
   - Prevent using certain items in vehicles
   - Check if player is in combat before allowing item use

3. **Visual Feedback:**
   - Animation when quick slot is used
   - Cooldown indicator on quick slot badge
   - Key binding displayed on badge (not just number)

4. **Configuration:**
   - Configurable give item range
   - Configurable drop offset distance
   - Badge position and style options

---

## API Reference

### Server Events

```lua
-- Use item
TriggerServerEvent("Server:Inventory:UseItem", itemName, quantity, position, panelId)

-- Give item
TriggerServerEvent("Server:Inventory:GiveItem", itemName, quantity, position)

-- Drop item
TriggerServerEvent("Server:Inventory:DropItem", itemName, quantity, position)
```

### Client Commands

```lua
-- Use quick slots (1-4)
ExecuteCommand("useQuickSlot1")
ExecuteCommand("useQuickSlot2")
ExecuteCommand("useQuickSlot3")
ExecuteCommand("useQuickSlot4")
```

### Configuration

```lua
-- Enable/disable quick slots
conf.inventory.allowQuickSlots = true

-- Customize key bindings
conf.inventory.quickSlots = {
    slot1 = "1",
    slot2 = "2",
    slot3 = "3",
    slot4 = "4"
}
```

---

## References

- **Server Events:** `server/[Events]/_inventory.lua`
- **Server Callbacks:** `server/[Callbacks]/_inventory.lua`
- **Client Hotkeys:** `nui/lua/inventory.lua`
- **Client Callbacks:** `client/[Callbacks]/_inventory.lua`
- **NUI Component:** `nui/inventory/src/components/InventoryItem.vue`
- **Configuration:** `_config/defaults.lua`
- **Item Data:** `data/items.json`

---

## Conclusion

The inventory system now has complete server-side event handling for use, give, and drop actions, along with quick slot hotkey bindings (1-4) and visual indicators in the NUI. All changes maintain security through validation and follow the Ingenium architectural patterns.
