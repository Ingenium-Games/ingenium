# Vue Inventory System - Developer Documentation

## Overview

This document provides comprehensive information about the Vue-based inventory system with drag-and-drop functionality and enhanced server-side security validation.

## Table of Contents

1. [Architecture](#architecture)
2. [Features](#features)
3. [Installation](#installation)
4. [Usage Examples](#usage-examples)
5. [Security Features](#security-features)
6. [API Reference](#api-reference)
7. [Development](#development)

---

## Architecture

The inventory system is integrated into ig.core's single NUI page approach and consists of three main layers:

### 1. Client-Side (Vue.js)
- **Location**: `/nui/inventory/`
- **Framework**: Vue 3 with Vite build system
- **Integration**: Embedded into `/nui/index.html` as a module
- **Mount Point**: `#inventory-app` div element
- **Components**:
  - `App.vue` - Main application container, handles NUI messages
  - `InventoryPanel.vue` - Reusable panel component for both player and external inventories
  - `InventoryItem.vue` - Individual item display with context menu

**Note**: The Vue inventory follows ig.core's "one NUI" pattern where all UI elements are loaded in a single `index.html` file. The inventory Vue app is compiled to `/nui/inventory/dist/assets/` and loaded as a module script.

### 2. Client-Side (Lua)
- **Location**: `/nui/lua/inventory.lua`
- **Purpose**: Bridge between FiveM client and Vue NUI
- **Functions**: Event handlers, NUI callbacks, keybinds

### 3. Server-Side (Lua)
- **Callbacks**: `/server/[Callbacks]/_inventory.lua`
- **Validation**: `/server/[Validation]/_inventory_validator.lua`
- **Purpose**: Secure inventory operations with exploit prevention

---

## Features

### ✅ Dual-Panel Inventory
- Left panel: External storage (vehicles, objects, NPCs, other players)
- Right panel: Player inventory
- Seamless drag-and-drop between panels

### ✅ Drag-and-Drop
- Powered by `vuedraggable` library
- Smooth animations and visual feedback
- Support for reordering within same inventory
- Support for moving items between inventories

### ✅ Persistent Positions
- Item positions saved to browser localStorage
- Per-client customization
- Automatically restored on inventory open

### ✅ Item Actions
- **Use**: Consume or equip items
- **Give**: Transfer items to nearby players
- **Drop**: Drop items on the ground
- Context menu on right-click

### ✅ Visual Feedback
- Quality degradation bar
- Item quantity display
- Hover effects
- Ghost element during drag

### ✅ Enhanced Security
- Server-side validation of all inventory operations
- Item quantity tracking (prevents duplication)
- Item type validation (prevents injection)
- Automatic kick/ban on exploit attempts
- Comprehensive logging

---

## Installation

### Prerequisites
- Node.js 16+ (for building Vue app)
- FiveM server with ig.core resource

### Building the Vue Application

The Vue inventory is integrated into the main NUI page. To rebuild after making changes:

```bash
cd nui/inventory
npm install
npm run build
```

The built files (`index.css` and `index.js`) are output to `nui/inventory/dist/assets/` and are automatically loaded by `nui/index.html`.

### FiveM Server

1. Ensure the resource is properly loaded in `server.cfg`:
   ```
   ensure ig.core
   ```

2. Restart the server or refresh the resource:
   ```
   restart ig.core
   ```

---

## Usage Examples

### Opening Inventory

#### Single Inventory (Player Only)

```lua
-- From client-side script
TriggerEvent("Client:Inventory:OpenSingle")

-- Or via export
exports['ig.core']:OpenSingleInventory()
```

#### Dual Inventory (Player + External)

```lua
-- From client-side script
local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
TriggerEvent("Client:Inventory:OpenDual", vehicleNetId, "Vehicle Trunk")

-- Or via export
exports['ig.core']:OpenDualInventory(vehicleNetId, "Storage Container")
```

### Keybind

By default, the inventory opens when pressing the **I** key (Control 170). This can be customized in `/nui/lua/inventory.lua`.

### Server-Side Item Operations

```lua
-- Get player inventory
local xPlayer = c.data.GetPlayer(source)
local inventory = xPlayer.GetInventory()

-- Get external entity inventory
local xVehicle = c.data.GetVehicle(netId)
local vehicleInventory = xVehicle.GetInventory()

-- The validation happens automatically in the callbacks
```

---

## Security Features

### Exploit Prevention

The system includes comprehensive validation to prevent:

1. **Item Duplication**
   - Tracks total quantities before and after operations
   - Rejects if any item type increases in quantity

2. **Item Injection**
   - Validates that no new item types appear
   - All items must exist in `c.items` database

3. **Invalid Data**
   - Quantity validation (must be positive number)
   - Quality validation (0-100 range)
   - Weapon stacking prevention
   - Item type validation

4. **Array Length Manipulation**
   - Previous system only checked `#size == #inv1`
   - New system validates actual item contents

### Validation Flow

```
Client submits inventory
    ↓
Server receives data
    ↓
Get "before" state from server memory
    ↓
Validate inventory integrity:
  - Check for item injection
  - Check for quantity increases
  - Validate each slot data
    ↓
If valid: Apply changes
If invalid: Kick player + log exploit
```

### Logging

All exploit attempts are logged with:
- Player name and character ID
- Exact reason for rejection
- Timestamp
- Logged to console and database (via txaLogger)

Example log entry:
```
[INVENTORY EXPLOIT] Player: John_Doe (ABC123XYZ456) | Reason: Item duplication detected: Pistol quantity increased from 1 to 2
```

---

## API Reference

### Client Events

#### `Client:Inventory:OpenSingle`
Opens single-panel inventory (player only).

**Parameters**: None

**Example**:
```lua
TriggerEvent("Client:Inventory:OpenSingle")
```

---

#### `Client:Inventory:OpenDual`
Opens dual-panel inventory (player + external).

**Parameters**:
- `externalNetId` (number): Network ID of external entity
- `externalTitle` (string): Display title for external panel

**Example**:
```lua
TriggerEvent("Client:Inventory:OpenDual", netId, "Vehicle Trunk")
```

---

#### `Client:Inventory:Close`
Closes the inventory (server-initiated).

**Parameters**: None

**Example**:
```lua
TriggerClientEvent("Client:Inventory:Close", source)
```

---

#### `Client:Inventory:Update`
Updates inventory contents (live update from server).

**Parameters**:
- `playerInventory` (table): Updated player inventory
- `externalInventory` (table): Updated external inventory (optional)

**Example**:
```lua
TriggerClientEvent("Client:Inventory:Update", source, newPlayerInv, newExternalInv)
```

---

### Server Callbacks

#### `GetInventory`
Retrieves inventory from an entity.

**Parameters**:
- `net` (number): Network ID of entity

**Returns**: Inventory table

---

#### `OrganizeInventory`
Saves single inventory with enhanced validation.

**Parameters**:
- `net` (number): Network ID of entity
- `inv1` (table): Updated inventory

**Returns**: `true` if successful, `false` if validation failed

**Security**: Full validation with exploit detection

---

#### `OrganizeInventories`
Saves dual inventories with enhanced validation.

**Parameters**:
- `net` (number): Network ID of external entity
- `inv1` (table): Player inventory
- `inv2` (table): External inventory

**Returns**: `true` if successful, `false` if validation failed

**Security**: Combined validation of both inventories

---

### NUI Messages

#### `openInventory`
Opens dual-panel inventory UI.

**Data**:
```javascript
{
  playerInventory: Array,
  externalInventory: Array,
  externalTitle: String,
  externalNetId: Number,
  playerMaxSlots: Number,
  externalMaxSlots: Number
}
```

---

#### `openSingleInventory`
Opens single-panel inventory UI.

**Data**:
```javascript
{
  playerInventory: Array,
  playerMaxSlots: Number
}
```

---

#### `closeInventory`
Closes the inventory UI.

**Data**: `{}`

---

#### `updateInventory`
Updates inventory contents in real-time.

**Data**:
```javascript
{
  playerInventory: Array,
  externalInventory: Array
}
```

---

### NUI Callbacks

#### `inventory_close`
Triggered when user closes inventory.

**Request Data**:
```javascript
{
  playerInventory: Array,
  externalInventory: Array,
  externalNetId: Number
}
```

**Response**: `{ message: "ok", data: null }`

---

#### `inventory_action`
Triggered on item action (Use, Give, Drop).

**Request Data**:
```javascript
{
  action: String,  // "use", "give", "drop"
  item: Object,
  position: Number,
  panelId: String  // "player" or "external"
}
```

**Response**: `{ message: "ok", data: null }`

---

## Development

### Building for Development

```bash
cd nui/inventory
npm run dev
```

This starts a development server on `http://localhost:3000` with hot reload.

**Note**: For FiveM integration, you must build the production version:
```bash
npm run build
```

### Modifying Components

#### Styling
Edit CSS in component `<style scoped>` sections or `/nui/inventory/src/style.css`.

#### Item Images
Place item images in `/nui/img/` with format: `{ItemName}.png`

Example: `Pistol.png`, `Burger.png`

#### Max Slots
Modify `maxSlots` in the component or pass dynamically via NUI message.

### Testing Security

To test the validation system:

1. **Normal Operation**: Drag items between inventories - should work
2. **Duplication Test**: Attempt to modify client data to duplicate items - should kick
3. **Injection Test**: Attempt to add items not in original inventories - should kick
4. **Invalid Data Test**: Send invalid quantities/qualities - should kick

---

## Troubleshooting

### Inventory doesn't open
- Check console for errors
- Verify `c.data.IsPlayerLoaded()` returns true
- Ensure NUI focus is not stuck (restart resource)

### Items not dragging
- Check browser console (F8 in FiveM)
- Verify vuedraggable is properly loaded
- Ensure Vue app built correctly

### Kicked for "exploit" during normal use
- Check server console for exact error
- Verify item database has all items
- Check for item data corruption in database
- Report issue with logs

### Images not showing
- Verify image files exist in `/nui/img/`
- Check image naming matches `Item` property
- Check browser console for 404 errors

---

## Future Enhancements

Potential improvements for future versions:

- [ ] Item stacking/splitting interface
- [ ] Search/filter functionality
- [ ] Sort buttons (by name, type, value)
- [ ] Hover tooltips with item details
- [ ] Craftable items recipes
- [ ] Weight/capacity visualization
- [ ] Mobile responsive design
- [ ] Accessibility improvements

---

## Support

For issues or questions:
1. Check this documentation
2. Review server console logs
3. Check client console (F8)
4. Submit issue to repository with logs

---

## License

See main repository LICENSE file.

---

**Last Updated**: December 2024
**Version**: 1.0.0
