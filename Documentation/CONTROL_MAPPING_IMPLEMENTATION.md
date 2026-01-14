# Control Mapping Implementation Guide

## Overview

This guide documents the implementation of the FiveM RegisterKeyMapping system for Ingenium, providing users with customizable keybindings for critical UI interactions.

---

## System Architecture

### Key Components

1. **Configuration Layer** (`_config/defaults.lua`)
   - Defines default keybindings
   - User customizable settings
   - Feature flags for each system

2. **Lua Command Handlers** (`nui/lua/*.lua`)
   - Register commands with FiveM
   - Handle key press events
   - Communicate with NUI via SendNUIMessage

3. **Vue Components** (`nui/src/components/*.vue`)
   - React to Lua commands
   - Provide visual feedback
   - Handle state management

---

## Implemented Keybindings

### 1. Inventory Open - `openInventory`

**Files**:
- Config: `_config/defaults.lua` → `conf.inventory.openKey`
- Handler: `nui/lua/inventory.lua`
- Command: `openInventory`

**Default Key**: `I`

**Behavior**:
```
Press I → Opens player inventory
Press ESC or click Close → Closes inventory
```

**Code Example** (in `inventory.lua`):
```lua
RegisterCommand('openInventory', function()
    if not inventoryOpen and ig.data.IsPlayerLoaded() then
        TriggerEvent("Client:Inventory:OpenSingle")
    end
end, false)

RegisterKeyMapping(
    'openInventory',
    'Open Inventory',
    'keyboard',
    conf.inventory.openKey:lower()
)
```

**User Customization**:
Players can customize this in: **FiveM Settings → Keybinds → ingenium → Open Inventory**

---

### 2. HUD Focus/Drag Toggle - `toggleHudFocus`

**Files**:
- Config: `_config/defaults.lua` → `conf.hud.focusKey`
- Handler: `nui/lua/hud.lua`
- Component: `nui/src/components/HUD.vue`
- Command: `toggleHudFocus`

**Default Key**: `F2`

**Behavior**:
```
Press F2 → HUD becomes focused/draggable (green border appears)
Click and drag → Reposition HUD
Press F2 again → HUD returns to normal state (unfocused)
Position saved → Automatically persisted to localStorage
```

**Visual Feedback**:
- **Unfocused**: HUD at z-index 100 (behind other menus)
- **Focused**: HUD at z-index 1001 (above other menus) with green border and enhanced glow

**Code Example** (in `hud.lua`):
```lua
RegisterCommand('toggleHudFocus', function()
    hudFocused = not hudFocused
    SendNUIMessage({
        message = "Client:NUI:HUDFocus",
        data = { 
            focused = hudFocused,
            timestamp = GetGameTimer()
        }
    })
    TriggerEvent("Client:HUD:FocusToggled", hudFocused)
end, false)

RegisterKeyMapping(
    'toggleHudFocus',
    'Toggle HUD Drag Mode',
    'keyboard',
    conf.hud.focusKey:lower()
)
```

**User Customization**:
Players can customize this in: **FiveM Settings → Keybinds → ingenium → Toggle HUD Drag Mode**

---

## Configuration Reference

### Inventory Configuration

Location: `_config/defaults.lua`

```lua
conf.inventory = {
    openKey = "I",                -- Default key to open/toggle inventory
    closeKey = "ESC",             -- Key to close inventory (built into Vue component)
    allowHotkey = true            -- Enable/disable the hotkey entirely
}
```

**Options**:
- `openKey`: Any valid FiveM key identifier (case-insensitive)
  - Examples: "i", "f1", "f5", "return", "delete", "space"
- `allowHotkey`: Set to `false` to disable inventory hotkey (users must use `/openInventory` command or exports)

---

### HUD Configuration

Location: `_config/defaults.lua`

```lua
conf.hud = {
    focusKey = "F2",              -- Key to toggle HUD drag/focus mode
    allowDragging = true,         -- Allow users to drag and reposition HUD
    persistPosition = true,       -- Save HUD position to localStorage
    enableFocusHighlight = true,  -- Show border/highlight when HUD is in focus mode
    normalZIndex = 100,           -- Default z-index (behind other menus)
    focusedZIndex = 1001          -- Z-index when focused/dragging (above other menus)
}
```

**Options**:
- `focusKey`: Any valid FiveM key identifier (case-insensitive)
- `allowDragging`: Set to `false` to completely disable HUD repositioning
- `persistPosition`: Set to `false` to reset HUD position on each session
- `enableFocusHighlight`: Visual feedback for focus state
- `normalZIndex`/`focusedZIndex`: Control layering behavior

---

### Menu Configuration

Location: `_config/defaults.lua`

```lua
conf.menus = {
    allowDragging = true,         -- Allow users to drag and reposition menus
    persistPosition = true,       -- Save menu positions to localStorage
    dragCursorStyle = "grab"      -- CSS cursor style when hovering draggable area
}
```

**Affected Menus**:
- Banking Menu (`BankingMenu.vue`)
- Generic Menu (`Menu.vue`)
- Garage Menu (`GarageMenu.vue`)
- **NOT Inventory** (dual-panel layout exempt)

---

## NUI Message Protocol

### HUD Messages

#### `Client:NUI:HUDFocus`
Sent from Lua when user presses F2 toggle.

```lua
SendNUIMessage({
    message = "Client:NUI:HUDFocus",
    data = { 
        focused = true,  -- or false
        timestamp = GetGameTimer()
    }
})
```

**Handler** (in HUD.vue):
```javascript
if (message === 'Client:NUI:HUDFocus') {
    isFocused.value = data.focused
}
```

#### `Client:NUI:HUDResetPosition`
Reset HUD to default bottom-left position.

```lua
SendNUIMessage({
    message = "Client:NUI:HUDResetPosition",
    data = { }
})
```

#### `Client:NUI:HUDSetPosition`
Set HUD position programmatically.

```lua
SendNUIMessage({
    message = "Client:NUI:HUDSetPosition",
    data = { position = { x = 100, y = 200 } }
})
```

#### `NUI:Client:HUDPositionUpdate`
Sent from NUI when user drags HUD (callback).

```javascript
// Sent from HUD.vue drag handler
postMessage('NUI:Client:HUDPositionUpdate', {
    position: { x: 150, y: 300 }
})
```

---

## Exports API

All functionality is exposed via exports for external resource integration.

### HUD Exports

**Location**: `nui/lua/hud.lua`

#### `IsHudFocused()`
Check if HUD is currently in focus/drag mode.

```lua
local focused = exports['ingenium']:IsHudFocused()
```

#### `ToggleHudFocus()`
Programmatically toggle HUD focus.

```lua
exports['ingenium']:ToggleHudFocus()
```

#### `GetHudPosition()`
Get current HUD position.

```lua
local pos = exports['ingenium']:GetHudPosition()
print(pos.x, pos.y)
```

#### `SetHudPosition(x, y)`
Set HUD position programmatically.

```lua
exports['ingenium']:SetHudPosition(100, 200)
```

---

### Inventory Exports

**Location**: `nui/lua/inventory.lua`

#### `OpenSingleInventory()`
Open player inventory (already implemented).

```lua
exports['ingenium']:OpenSingleInventory()
```

#### `OpenDualInventory(netId, title)`
Open dual inventory (already implemented).

```lua
exports['ingenium']:OpenDualInventory(networkId, "Vehicle Trunk")
```

---

## Event Hooks

External resources can listen for these events to react to keybinding actions.

### HUD Events

#### `Client:HUD:FocusToggled`
Fired when user toggles HUD focus via F2 (or configured key).

```lua
RegisterNetEvent("Client:HUD:FocusToggled", function(isFocused)
    if isFocused then
        print("HUD now in drag mode")
    else
        print("HUD drag mode disabled")
    end
end)
```

#### `Client:HUD:PositionChanged`
Fired when user finishes dragging HUD.

```lua
RegisterNetEvent("Client:HUD:PositionChanged", function(position)
    print(string.format("HUD position: %.0f, %.0f", position.x, position.y))
end)
```

#### `Client:HUD:PositionReset`
Fired when HUD position is reset to default.

```lua
RegisterNetEvent("Client:HUD:PositionReset", function(position)
    print("HUD reset to default position")
end)
```

---

## User Guide (For Server Operators)

### How Players Customize Keys

1. **Open FiveM Settings**
   - Alt+Tab to FiveM window
   - Press Escape to show menu
   - Go to Settings

2. **Navigate to Keybinds**
   - Click "Keybinds" tab
   - Look for your server name or filter by resource

3. **Find Ingenium Keybinds**
   - Look for entries starting with "ingenium" or search for:
     - "Open Inventory"
     - "Toggle HUD Drag Mode"
     - "Cycle Voice Range" (if VoIP enabled)

4. **Customize Keys**
   - Click on any keybind entry
   - Press desired key
   - Confirm (green checkmark appears)

5. **Primary vs Alternate Keys**
   - Most keybinds support both primary and alternate keys
   - Example: `I` and `Alt+I` for redundancy

### Server Configuration

Admins can set default keys by editing `_config/defaults.lua`:

```lua
-- Change default inventory key to E
conf.inventory.openKey = "E"

-- Change HUD drag toggle to F1
conf.hud.focusKey = "F1"

-- Disable inventory hotkey entirely
conf.inventory.allowHotkey = false

-- Disable HUD dragging
conf.hud.allowDragging = false
```

---

## Troubleshooting

### Key Not Working?

1. **Check if hotkey is enabled**
   ```lua
   -- In _config/defaults.lua
   conf.inventory.allowHotkey = true  -- Must be true
   conf.hud.focusKey = "F2"           -- Must be set
   ```

2. **Check FiveM Keybinds**
   - FiveM Settings → Keybinds → Search for "ingenium"
   - Verify keys are properly bound
   - No conflicts with other scripts

3. **Check console logs**
   ```
   /client
   [Inventory] Inventory hotkey registered: I
   [HUD] HUD focus enabled - drag mode active
   ```

### HUD Not Dragging?

1. **Is HUD in focus mode?**
   - Look for green border around HUD
   - If not visible, press F2 (or configured key)

2. **Are other menus open?**
   - Banking, Inventory, or other menus capture input
   - Close them first or use focus toggle to elevate HUD z-index

3. **Position not saving?**
   ```lua
   -- Check localStorage is enabled
   conf.hud.persistPosition = true
   ```

### Position Resets Every Session?

```lua
-- In _config/defaults.lua
conf.hud.persistPosition = true  -- Must be true

-- Clear browser cache if stuck
-- Or manually reset:
exec resetHudPosition
```

---

## FiveM Key Identifiers

### Keyboard Keys

Common key identifiers used with RegisterKeyMapping:

| Key | Identifier | Key | Identifier |
|-----|-----------|-----|-----------|
| A-Z | a-z | 0-9 | 0-9 |
| F1-F12 | f1-f12 | Enter | return |
| Spacebar | space | Shift | lshift/rshift |
| Ctrl | lctrl/rctrl | Alt | lalt/ralt |
| Delete | delete | Backspace | back |
| Tab | tab | Escape | escape |
| Arrow Keys | up, down, left, right | - | minus |
| = | equals | [ | lbracket |
| ] | rbracket | \ | backslash |
| ; | semicolon | ' | apostrophe |
| , | comma | . | period |
| / | slash | ~ | tilde |

---

## Implementation Checklist

- [x] Add configuration options to `_config/defaults.lua`
- [x] Create `nui/lua/hud.lua` for HUD control commands
- [x] Update `nui/lua/inventory.lua` to use RegisterKeyMapping
- [x] Update `nui/src/components/HUD.vue` for focus toggle and visual feedback
- [x] Add NUI message handlers for HUD focus
- [x] Create exports API for external resources
- [x] Add event triggers for resource hooks
- [x] Document all keybindings and configuration options
- [ ] Test all keybindings in-game
- [ ] Test HUD dragging with other menus open
- [ ] Test position persistence across sessions
- [ ] Test alternate keybindings (if enabled)
- [ ] Add user-facing documentation to main README

---

## Future Enhancements

1. **Context Menu Dragging**
   - Apply same pattern to context/interaction menus

2. **Keybind Profiles**
   - Allow users to save/load keybind profiles
   - Useful for players with multiple control schemes

3. **Visual Keybind Tutorial**
   - On first join, show tooltip: "Press F2 to move HUD"
   - Help new players discover keybindings

4. **Conflict Detection**
   - Warn if multiple commands use same key
   - Suggest alternatives

5. **Keymap Presets**
   - "WASD Movement" profile
   - "Controller" profile
   - "MMO Style" profile
   - etc.

---

## Files Modified

1. `_config/defaults.lua` - Added conf.inventory, conf.hud, conf.menus
2. `nui/lua/inventory.lua` - Converted to RegisterKeyMapping
3. `nui/lua/hud.lua` - **NEW** - HUD control system
4. `nui/src/components/HUD.vue` - Added focus state, NUI message handlers
5. `CONTROL_MAPPING_REVIEW.md` - Comprehensive review document

---

## References

- [FiveM RegisterKeyMapping Documentation](https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/RegisterKeyMapping/)
- [FiveM SetNuiFocus Documentation](https://docs.fivem.net/docs/scripting-reference/runtimes/lua/functions/SetNuiFocus/)
- [FiveM Input Control List](https://docs.fivem.net/docs/game-references/input-mapper/)
