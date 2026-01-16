-- ====================================================================================--
-- NUI-CLIENT HANDLER FILES DIRECTORY
-- ====================================================================================--
-- All NUI→Client callbacks are centralized in nui/lua/NUI-Client/ folder
-- This directory listing shows what exists, what's loaded, and what each does
-- ====================================================================================--

## DIRECTORY STRUCTURE: nui/lua/NUI-Client/

All NUI callbacks (NUI sending messages TO client) are registered in files here.
Each system has ONE file containing ALL callbacks for that system.

---

## FILE INVENTORY (12 FILES TOTAL)

### ✅ CORE CHARACTER SYSTEM

**File**: character-select.lua
**Purpose**: Character selection and creation callbacks
**Callbacks**:
  - NUI:Client:CharacterList      → Receive character list
  - NUI:Client:CharacterPlay      → Player selected existing character
  - NUI:Client:CharacterCreate    → Player started new character creation
  - NUI:Client:CharacterDelete    → Player deleted a character
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\character-select.lua
**Lines**: 120 | Status: ✅ ACTIVE

**File**: _appearance.lua
**Purpose**: Appearance customization callbacks
**Callbacks**:
  - NUI:Client:AppearanceComplete → Player finished appearance customization
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_appearance.lua
**Lines**: 44 | Status: ✅ ACTIVE (NEW - moved from client/_character.lua)

---

### ✅ UI SYSTEM CALLBACKS

**File**: _menu.lua
**Purpose**: Menu system callbacks
**Callbacks**:
  - NUI:Client:MenuClose          → Player closed menu
  - NUI:Client:MenuSelect         → Player selected menu option
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_menu.lua
**Lines**: 43 | Status: ✅ ACTIVE

**File**: _input.lua
**Purpose**: Input dialog callbacks
**Callbacks**:
  - NUI:Client:InputClose         → Player closed input dialog
  - NUI:Client:InputSubmit        → Player submitted input value
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_input.lua
**Lines**: 44 | Status: ✅ ACTIVE

**File**: _context.lua
**Purpose**: Context menu callbacks
**Callbacks**:
  - NUI:Client:ContextClose       → Player closed context menu
  - NUI:Client:ContextSelect      → Player selected context option
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_context.lua
**Lines**: 43 | Status: ✅ ACTIVE

**File**: _chat.lua
**Purpose**: Chat system callbacks
**Callbacks**:
  - NUI:Client:ChatSubmit         → Player submitted message
  - NUI:Client:ChatClose          → Player closed chat UI
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_chat.lua
**Lines**: 50 | Status: ✅ ACTIVE

---

### ✅ GAMEPLAY SYSTEM CALLBACKS

**File**: _banking.lua
**Purpose**: Banking/financial callbacks
**Callbacks**:
  - NUI:Client:BankingClose       → Player closed banking menu
  - NUI:Client:BankingTransfer    → Player initiated transfer
  - NUI:Client:BankingDeposit     → Player deposited cash
  - NUI:Client:BankingWithdraw    → Player withdrew cash
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_banking.lua
**Lines**: 88 | Status: ✅ ACTIVE

**File**: _inventory.lua
**Purpose**: Inventory management callbacks
**Callbacks**:
  - NUI:Client:InventoryClose     → Player closed inventory
  - NUI:Client:InventoryUseItem   → Player used item
  - NUI:Client:InventoryDropItem  → Player dropped item
  - NUI:Client:InventorySwap      → Player swapped items
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_inventory.lua
**Lines**: 90 | Status: ✅ ACTIVE

**File**: _garage.lua
**Purpose**: Vehicle garage callbacks
**Callbacks**:
  - NUI:Client:GarageClose        → Player closed garage
  - NUI:Client:GarageSelectVehicle→ Player selected vehicle
  - NUI:Client:GarageDeleteVehicle→ Player deleted vehicle
  - NUI:Client:GarageTuneVehicle  → Player tuned vehicle
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_garage.lua
**Lines**: 92 | Status: ✅ ACTIVE

**File**: _target.lua
**Purpose**: Targeting/interaction callbacks
**Callbacks**:
  - NUI:Client:TargetClose        → Player closed target menu
  - NUI:Client:TargetSelect       → Player selected target action
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_target.lua
**Lines**: 38 | Status: ✅ ACTIVE

---

### ✅ HUD & NOTIFICATION CALLBACKS

**File**: _hud.lua
**Purpose**: HUD (Heads-Up Display) callbacks
**Callbacks**:
  - NUI:Client:HUDClose           → Player closed HUD
  - NUI:Client:HUDUpdate          → HUD element updated
  - NUI:Client:HUDInteraction     → Player interacted with HUD
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_hud.lua
**Lines**: 64 | Status: ✅ ACTIVE

**File**: _notification.lua
**Purpose**: Notification callbacks
**Callbacks**:
  - NUI:Client:NotificationClose  → Player dismissed notification
  - NUI:Client:NotificationAction → Player clicked notification action
**Location**: c:\5M\repo\ingenium\nui\lua\NUI-Client\_notification.lua
**Lines**: 45 | Status: ✅ ACTIVE

---

## ORGANIZATION PRINCIPLES

### Function-Specific Organization
Each file contains ALL callbacks for ONE function:
- _appearance.lua → All appearance-related callbacks
- _menu.lua → All menu-related callbacks
- _garage.lua → All garage-related callbacks
- etc.

**NOT** response-specific (NOT all responses in one file)

### Consistent Pattern
All files follow this structure:
1. Header documentation
2. List of NUI messages this file handles
3. RegisterNUICallback for each message
4. Validation & error checking
5. Logging
6. Server/internal event triggers
7. Focus management for Close events
8. Callback response

### Example Structure:
```lua
-- ====================================================================================--
-- [SYSTEM] NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
RegisterNUICallback('NUI:Client:[System]Action', function(data, cb)
    if not data or not data.required_field then
        ig.log.Error("[System]", "Missing required_field")
        cb({ok = false, error = "Missing field"})
        return
    end
    
    ig.log.Trace("[System]", "Action triggered")
    TriggerServerEvent("Server:[System]:[Action]", data)
    SetNuiFocus(false, false)  -- For Close events
    cb({ok = true})
end)
```

---

## CALLBACK STATISTICS

**Total Files**: 12
**Total Callbacks**: 38
**Total Lines**: 568
**Average File Size**: 47 lines

**Callbacks by System**:
- Character: 5 callbacks (select, create, delete, play, appearance complete)
- Menu: 2 callbacks
- Input: 2 callbacks
- Context: 2 callbacks
- Chat: 2 callbacks
- Banking: 4 callbacks
- Inventory: 4 callbacks
- Garage: 4 callbacks
- Target: 2 callbacks
- HUD: 3 callbacks
- Notification: 2 callbacks

**Close Events with Focus Management**: 12
**Action Events**: 26

---

## LOAD ORDER REQUIREMENT

For proper initialization, nui/lua/NUI-Client/ files should be loaded as:
```lua
-- In fxmanifest.lua
client_scripts {
    'nui/lua/NUI-Client/character-select.lua',
    'nui/lua/NUI-Client/_appearance.lua',
    'nui/lua/NUI-Client/_menu.lua',
    'nui/lua/NUI-Client/_input.lua',
    'nui/lua/NUI-Client/_context.lua',
    'nui/lua/NUI-Client/_chat.lua',
    'nui/lua/NUI-Client/_banking.lua',
    'nui/lua/NUI-Client/_inventory.lua',
    'nui/lua/NUI-Client/_garage.lua',
    'nui/lua/NUI-Client/_target.lua',
    'nui/lua/NUI-Client/_hud.lua',
    'nui/lua/NUI-Client/_notification.lua',
}
```

Order doesn't matter between files, but all should load AFTER:
1. ig library initialization
2. Client core files
3. Client-NUI-Wrappers (because they send messages that callbacks handle)

---

## COUNTERPART: CLIENT-NUI-WRAPPERS

Complement to this directory:

**Location**: nui/lua/Client-NUI-Wrappers/
**Purpose**: Functions that SEND messages TO NUI (Client→NUI)
**Example Files** (existing):
  - _character.lua → ig.nui.character.ShowSelect() etc.

**Pending** (Phase 3.5):
  - _menu.lua, _input.lua, _context.lua, _chat.lua
  - _banking.lua, _inventory.lua, _garage.lua, _target.lua
  - _hud.lua, _notification.lua

**Flow**:
```
Client Code
    ↓
ig.nui.character.ShowSelect()  ← Client-NUI-Wrapper
    ↓
ig.ui.Send("Client:NUI:...", data)
    ↓
NUI Receives Message
    ↓
NUI Shows Component
    ↓
Player Interacts
    ↓
NUI sends back: "NUI:Client:..."
    ↓
RegisterNUICallback() ← NUI-Client Handler (this folder)
    ↓
Client Logic (TriggerServerEvent, etc.)
```

---

## ADDING NEW CALLBACKS

To add a new NUI→Client callback:

1. Identify which system it belongs to (_menu.lua, _chat.lua, etc.)
2. Add RegisterNUICallback entry in that file
3. Follow the pattern (validation, logging, event trigger, response)
4. Include SetNuiFocus(false, false) for Close events
5. Update fxmanifest.lua if adding new file
6. Test callback is triggered correctly

**Example Addition** (to _menu.lua):
```lua
-- Player clicked menu settings
RegisterNUICallback('NUI:Client:MenuSettings', function(data, cb)
    if not data or not data.settingKey then
        ig.log.Error("Menu", "NUI:Client:MenuSettings: missing settingKey")
        cb({ok = false, error = "Missing settingKey"})
        return
    end
    
    ig.log.Trace("Menu", "Settings changed: " .. data.settingKey)
    TriggerServerEvent("Server:Menu:SaveSetting", data.settingKey, data.value)
    cb({ok = true})
end)
```

---

## FILE STATUS SUMMARY

| System | File | Callbacks | Lines | Status |
|--------|------|-----------|-------|--------|
| Character | character-select.lua | 4 | 120 | ✅ |
| Appearance | _appearance.lua | 1 | 44 | ✅ NEW |
| Menu | _menu.lua | 2 | 43 | ✅ |
| Input | _input.lua | 2 | 44 | ✅ |
| Context | _context.lua | 2 | 43 | ✅ |
| Chat | _chat.lua | 2 | 50 | ✅ |
| Banking | _banking.lua | 4 | 88 | ✅ |
| Inventory | _inventory.lua | 4 | 90 | ✅ |
| Garage | _garage.lua | 4 | 92 | ✅ |
| Target | _target.lua | 2 | 38 | ✅ |
| HUD | _hud.lua | 3 | 64 | ✅ |
| Notification | _notification.lua | 2 | 45 | ✅ |
| **TOTAL** | **12 files** | **38 callbacks** | **568 lines** | **✅ ALL ACTIVE** |

---

## TROUBLESHOOTING

**Issue**: Callback not being triggered
**Solution**: 
1. Check file is loaded in fxmanifest.lua
2. Check callback name matches exactly (case-sensitive)
3. Check console for registration log: "NUI-Client: [System] callbacks registered"
4. Verify NUI is sending the correct message name

**Issue**: Focus not releasing after Close event
**Solution**:
1. Check SetNuiFocus(false, false) exists in Close callback
2. Check callback is actually being called (add ig.log.Trace)
3. Verify cb({ok = true}) is called

**Issue**: Data validation errors
**Solution**:
1. Check data presence validation (if not data)
2. Check required field presence (if not data.field)
3. Verify error logging shows which field is missing
4. Check NUI is sending required fields

---

## NEXT PHASES

**Phase 3.5**: Create Client-NUI-Wrappers for all 11 systems
**Phase 4**: Update fxmanifest.lua with proper load order
**Phase 5**: End-to-end testing and validation
**Phase 6**: Documentation for developers adding new callbacks

