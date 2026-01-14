# Control Mapping & NUI Focus System Review

## Executive Summary

This document provides a comprehensive review of all control mappings, key bindings, and NUI focus system implementations in the Ingenium framework. Key findings include:

1. **Inventory Opening**: Currently hardcoded to `I` key (INPUT_CELLPHONE_LEFT = 170) with no user customization
2. **HUD Interaction**: No dedicated focus mechanism - HUD is always-active but lacks keystroke to enable drag mode
3. **NUI Focus Management**: Properly implemented for menus (Banking, Menu, Garage) with SetNuiFocus
4. **Key Configuration**: Only VoIP has configurable key binding (`conf.voip.rangeKey = "F6"`)
5. **Control Mapping System**: FiveM's RegisterKeyMapping partially used but not comprehensive

---

## Current Control Mappings

### 1. Registered Key Mappings (FiveM RegisterKeyMapping)

| Command | Key | Description | File | Configurable |
|---------|-----|-------------|------|--------------|
| `+chat` | `T` | Open chat | `/nui/lua/chat.lua:104` | ❌ No |
| `+cross` | `Z` | Cross arms | `/client/_commands.lua:9` | ❌ No |
| `crossarms` | `NumPad1` | Cross arms | `/client/_commands.lua:17` | ❌ No |
| `handsup` | `NumPad2` | Hands up | `/client/_commands.lua:25` | ❌ No |
| `armhold` | `NumPad3` | Arm hold | `/client/_commands.lua:33` | ❌ No |
| `+voiceRange` | Config (F6) | Cycle voice range | `/client/[Voice]/_voip.lua:458` | ✅ Yes |

**Key Observation**: Most commands use hardcoded keys instead of being configurable. Only VoIP uses a configurable key from `conf.voip.rangeKey`.

### 2. Hardcoded Key Bindings (Not Using RegisterKeyMapping)

#### Inventory Opening
**File**: `/workspaces/ingenium/nui/lua/inventory.lua:241-243`

```lua
if IsControlJustReleased(0, 170) then -- I key (170 = INPUT_CELLPHONE_LEFT)
    if not inventoryOpen and ig.data.IsPlayerLoaded() then
        TriggerEvent("Client:Inventory:OpenSingle")
        TriggerEvent("Client:NUI:InventoryOpenSingle")
    end
end
```

**Status**: 
- ❌ **Hardcoded** to `I` key (INPUT_CELLPHONE_LEFT = 170)
- ❌ Not registered with `RegisterKeyMapping`
- ❌ Not configurable
- ❌ No user preference support
- **Recommendation**: Convert to configurable key via `conf.inventory.openKey`

#### HUD Drag/Focus Control
**File**: `/workspaces/ingenium/nui/src/components/HUD.vue`

**Status**:
- ❌ **No keystroke to enable focus/drag mode**
- ✅ Local drag-and-drop works (mouse down/move/up)
- ❌ No way to "focus" HUD for easier interaction
- ❌ No dedicated "move mode" toggle key
- **Observation**: HUD is always on z-index 100, behind other windows, making it inaccessible while other menus are open
- **Recommendation**: Implement a dedicated HUD focus key (e.g., `conf.hud.focusKey`) to temporarily elevate z-index and enable mouse interaction

---

## NUI Focus System Analysis

### Current Implementation

#### How SetNuiFocus Works
- `SetNuiFocus(bool, bool)` parameters: (focus, mouse)
- When `true, true`: Captures keyboard/mouse input exclusively
- When `false, false`: Releases focus back to game

#### Focus States by Component

| Component | Open Focus | Close Focus | File | Issue |
|-----------|-----------|------------|------|-------|
| Banking Menu | `true, true` | `false, false` | `/client/[Callbacks]/_banking.lua` | ✅ Proper |
| Inventory | `true, true` | `false, false` | `/nui/lua/inventory.lua` | ✅ Proper |
| Generic Menu | `true, true` | `false, false` | `/nui/lua/ui.lua` | ✅ Proper |
| HUD | ❌ **Never sets focus** | N/A | `/nui/src/components/HUD.vue` | **CRITICAL** |

### HUD-Specific Issues

**Problem**: HUD is always-visible but never receives NUI focus, making it undraggable while other UI elements are active.

**Code Location**: `/nui/src/components/HUD.vue`

**Current Behavior**:
1. HUD renders at fixed position (now: dynamically positioned via `position` ref)
2. Drag handlers are implemented (`startDrag`, `handleDrag`, `stopDrag`)
3. **BUT**: When other menus (Banking, Inventory) have `SetNuiFocus(true, true)`, mouse input is captured and HUD drag doesn't work
4. Users cannot reposition HUD while interacting with other UI elements
5. HUD is locked behind other windows (z-index: 100)

**Root Cause**: There's no way to "unlock" or gain focus on the HUD without closing all other menus.

---

## Key Configuration System

### Existing Pattern: VoIP Range Key

**File**: `/_config/voip.lua:45-49`

```lua
--[[
VOICE RANGE KEY :
    The key used to cycle through voice modes.
    Default: "F6" (can be changed or set to nil to disable)
]]--
conf.voip.rangeKey = "F6"
```

**Implementation**: `/client/[Voice]/_voip.lua:458`

```lua
RegisterKeyMapping("+voiceRange", "Cycle Voice Range", "keyboard", conf.voip.rangeKey)
```

**Pattern**: ✅ Uses `RegisterKeyMapping` with a config-driven key

### Recommended Configuration Pattern

Create new sections in `/`_config/config.lua`` or appropriate files:

```lua
-- Inventory Configuration
conf.inventory = {}
conf.inventory.openKey = "I"           -- Open/toggle inventory

-- HUD Configuration  
conf.hud = {}
conf.hud.focusKey = "F2"               -- Toggle HUD focus/drag mode
conf.hud.allowDragging = true          -- Allow users to move HUD
conf.hud.persistPosition = true        -- Save/restore HUD position

-- Menu Configuration
conf.menu = {}
conf.menu.allowDragging = true         -- Allow moving menus
conf.menu.persistPosition = true       -- Save/restore menu positions
```

---

## Recommendations

### Priority 1: Implement Inventory Key Configuration

**Status**: ❌ Currently hardcoded

**Action**:

1. Add to `_config/defaults.lua`:
```lua
conf.inventory = {
    openKey = "I",
    closeKey = "ESC",
    allowHotkey = true
}
```

2. Update `/nui/lua/inventory.lua` to use `RegisterKeyMapping`:
```lua
if conf.inventory.allowHotkey then
    RegisterKeyMapping(
        "+openInventory",
        "Open Inventory",
        "keyboard",
        conf.inventory.openKey
    )
end

-- Use this instead of IsControlJustReleased check
RegisterCommand("+openInventory", function()
    if not inventoryOpen and ig.data.IsPlayerLoaded() then
        TriggerEvent("Client:Inventory:OpenSingle")
    end
end, false)
```

**User Impact**: Players can customize their inventory hotkey in FiveM settings UI

---

### Priority 2: Implement HUD Focus/Drag Control

**Status**: ❌ No focus mechanism exists

**Problem**: HUD cannot be dragged while other menus are open due to input capture

**Solution**: Implement a dedicated HUD focus toggle key

**Implementation**:

1. Add to config:
```lua
conf.hud = {
    focusKey = "F2",              -- Toggle HUD drag mode
    allowDragging = true,
    persistPosition = true,
    zIndex = 100,                 -- Normal z-index
    zIndexFocused = 1001          -- When dragging (above menus)
}
```

2. Update HUD.vue with focus state:
```vue
<script setup>
import { ref, onMounted, computed } from 'vue'

const position = ref({ x: 20, y: window.innerHeight - 120 })
const isDragging = ref(false)
const dragStart = ref({ x: 0, y: 0 })
const isHudFocused = ref(false)  // NEW: Track focus state

const hudZIndex = computed(() => 
  isHudFocused.value ? 1001 : 100
)

// Listen for HUD focus toggle from Lua
window.addEventListener('message', (event) => {
  if (event.data.message === 'Client:NUI:HUDFocus') {
    isHudFocused.value = event.data.data.focused
  }
})
</script>

<template>
  <div 
    class="hud-container"
    :style="{ 
      left: position.x + 'px', 
      top: position.y + 'px',
      zIndex: hudZIndex,
      opacity: isHudFocused ? 1 : 0.8,
      border: isHudFocused ? '2px solid #4CAF50' : 'none'
    }"
    @mousedown="startDrag"
    :class="{ 'hud-focused': isHudFocused }"
  >
    <!-- ... -->
  </div>
</template>
```

3. Create `/nui/lua/hud.lua` for HUD control:
```lua
-- HUD Focus Toggle
RegisterCommand("toggleHudFocus", function()
    local hudFocus = not hudFocused
    SendNUIMessage({
        message = "Client:NUI:HUDFocus",
        data = { focused = hudFocus }
    })
    TriggerEvent("Client:HUD:FocusChanged", hudFocus)
end, false)

RegisterKeyMapping(
    "toggleHudFocus",
    "Toggle HUD Drag Mode",
    "keyboard",
    conf.hud.focusKey
)
```

**User Impact**:
- Press F2 (or configured key) to "lock" HUD for dragging
- HUD becomes highlighted/outlined when focused
- Z-index elevates above all menus
- Click and drag to reposition
- Press F2 again to unlock
- Position saved to localStorage

---

### Priority 3: Standardize Menu Dragging Configuration

**Status**: ✅ Partially implemented (Banking, Menu, Garage are draggable)

**Action**: Add configuration options for menu behavior:

```lua
conf.ui = {
    menus = {
        allowDragging = true,
        persistPosition = true,
        dragCursor = "grab",
        focusOverride = false  -- If true, dragging menus doesn't capture input
    }
}
```

**Documentation**: Update NUI ARCHITECTURE.md with:
- Which menus support dragging
- How position persistence works (localStorage)
- How to enable/disable per-menu

---

## Summary Table: Control Mapping Status

| Feature | Current | Status | Key | Configurable | Focus | Recommendation |
|---------|---------|--------|-----|--------------|-------|-----------------|
| **Inventory Open** | I | ❌ Hardcoded | 170 | ❌ No | N/A | Add `conf.inventory.openKey` |
| **Chat Open** | T | ✅ Mapped | T | ❌ No | Auto | Already uses RegisterKeyMapping |
| **Cross Arms** | Z | ✅ Mapped | Z | ❌ No | N/A | Consider making configurable |
| **Voice Range** | F6 | ✅ Config | F6 | ✅ Yes | N/A | **Best practice example** |
| **HUD Drag** | N/A | ❌ Missing | None | ❌ No | N/A | **Implement F2 toggle** |
| **Menu Drag** | Working | ⚠️ Local only | None | ✅ Yes | N/A | **CRITICAL: Add NUI focus toggle** |
| **Menu Positions** | localStorage | ✅ Working | N/A | ✅ Yes | Auto | Good pattern |

---

## Critical Issue: Menu Dragging While Other Menus Open

### The Problem

Currently, when user tries to drag HUD while Banking Menu is open:
1. Banking Menu has `SetNuiFocus(true, true)`
2. This captures all mouse/keyboard input
3. HUD drag handlers (`startDrag`, `handleDrag`, `stopDrag`) never receive mouse events
4. User clicks HUD but banking menu captures the input
5. **Result**: HUD cannot be dragged while any focused menu is open

### Why This Matters

The HUD is described as "always active / behind other windows" but is actually **unreachable** when other windows are focused.

### Solutions

**Option A**: Implement "Peek Focus" - allow dragging without capturing full input
```lua
SetNuiFocusKeepInput(false)  -- Keep game input while NUI has cursor
```

**Option B**: Implement HUD Focus Toggle (Recommended)
```lua
-- Press F2 to "pop" HUD to top and enable dragging
SetNuiFocus(true, true)  -- When dragging HUD
-- ...drag...
SetNuiFocus(false, false)  -- When done
```

**Option C**: Allow right-click on menus to pass-through to HUD
- More complex, requires input filtering

---

## FiveM Native Functions Reference

### Key Binding
```lua
RegisterKeyMapping(
    commandName,      -- string
    description,      -- string  
    inputType,       -- "keyboard", "mouse", "gamepad"
    defaultKey       -- "I", "F2", "ENTER", etc.
)

RegisterCommand(command, handler, allowConsole)
```

### NUI Focus
```lua
SetNuiFocus(hasFocus, hasCursor)
-- hasFocus: true = captures input
-- hasCursor: true = shows mouse cursor

SetNuiFocusKeepInput(state)
-- true = NUI has focus but game input still works
```

### Control Checking (Legacy - for hardcoded keys)
```lua
IsControlPressed(inputGroup, inputControl)
IsControlJustReleased(inputGroup, inputControl)
IsDisabledControlJustPressed(inputGroup, inputControl)
```

---

## Implementation Checklist

- [ ] Create `conf.inventory` section in config
- [ ] Create `conf.hud` section in config  
- [ ] Convert inventory key from `IsControlJustReleased` to `RegisterKeyMapping`
- [ ] Implement HUD focus toggle with elevated z-index
- [ ] Create `/nui/lua/hud.lua` for HUD-specific controls
- [ ] Update HUD.vue to respond to focus toggle message
- [ ] Add visual indicator when HUD is focused (border/highlight)
- [ ] Test HUD dragging while Banking menu is open
- [ ] Document in README/CONTRIBUTING.md
- [ ] Create user-facing documentation on key customization

---

## Files That Need Updates

1. **`_config/defaults.lua`** - Add inventory and HUD configs
2. **`nui/lua/inventory.lua`** - Convert to RegisterKeyMapping
3. **`nui/lua/hud.lua`** - Create new file for HUD controls
4. **`nui/src/components/HUD.vue`** - Add focus state and z-index handling
5. **`nui/ARCHITECTURE.md`** - Document control mappings
6. **`README.md`** or **`CONTRIBUTING.md`** - User-facing key customization guide

---

## Conclusion

The Ingenium framework has a partially implemented control and focus system. While newer features (Banking, Inventory, Menus) properly use NUI focus and localStorage persistence, they lack key customization. The HUD is the most critical issue - it needs a dedicated focus toggle to become accessible while other menus are active.

**Recommended priority**: 
1. **Critical**: Implement HUD focus toggle (F2) for drag accessibility
2. **High**: Make inventory hotkey configurable
3. **Medium**: Standardize all keybinds using RegisterKeyMapping
4. **Low**: Add menu-specific keybinding options
