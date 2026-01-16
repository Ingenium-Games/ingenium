---
# NUI Implementation Status & Expected Messages
## Current Implementation vs Required

**Version**: 1.0  
**Last Updated**: 2026-01-16  
**Purpose**: Track what's implemented and what needs to be created

---

## 📊 Implementation Status Overview

```
CURRENT STATE:
├── ✅ IMPLEMENTED (Working)
│   ├── Chat system messages
│   ├── Menu system (basic)
│   ├── Input dialogs
│   ├── Context menus
│   ├── Character select callbacks
│   ├── HUD system
│   ├── Banking system
│   ├── Inventory (partial)
│   └── Notifications
│
├── ⚠️ PARTIAL (Needs cleanup)
│   ├── Character select (duplicates in multiple files)
│   ├── Banking callbacks (spread across files)
│   └── Menu/Input/Context (generic handlers only)
│
└── ❌ MISSING (Needs creation)
    ├── Client-NUI-Wrappers/ folder
    ├── ig.nui.* wrapper functions
    ├── Consolidated NUI-Client handlers
    └── Organized folder structure
```

---

## ✅ CURRENTLY IMPLEMENTED

### Chat System
**Status**: ✅ WORKING  
**Location**: `nui/lua/chat.lua` + `nui/src/utils/nui.js`

**Messages**:
```lua
-- Client → NUI ✅
"Client:NUI:ChatAddMessage"
"Client:NUI:ChatShow"
"Client:NUI:ChatHide"
"Client:NUI:ChatClear"
"Client:NUI:ChatSetSuggestions"

-- NUI → Client ✅
"NUI:Client:ChatSubmit"
"NUI:Client:ChatClose"
```

**Handlers**: `nui/lua/chat.lua`

---

### Menu System
**Status**: ⚠️ PARTIAL (Generic, needs wrapper functions)  
**Location**: `nui/lua/ui.lua` + `nui/src/utils/nui.js`

**Messages**:
```lua
-- Client → NUI ✅
"Client:NUI:MenuShow"
"Client:NUI:MenuHide"

-- NUI → Client ✅
"NUI:Client:MenuSelect"
"NUI:Client:MenuClose"
```

**Needs**: `ig.nui.menu.*()` wrapper functions

---

### Input Dialog System
**Status**: ⚠️ PARTIAL (Generic, needs wrapper functions)  
**Location**: `nui/lua/ui.lua` + `nui/src/utils/nui.js`

**Messages**:
```lua
-- Client → NUI ✅
"Client:NUI:InputShow"
"Client:NUI:InputHide"

-- NUI → Client ✅
"NUI:Client:InputSubmit"
"NUI:Client:InputClose"
```

**Needs**: `ig.nui.input.*()` wrapper functions

---

### Context Menu System
**Status**: ⚠️ PARTIAL (Generic, needs wrapper functions)  
**Location**: `nui/lua/ui.lua` + `nui/src/utils/nui.js`

**Messages**:
```lua
-- Client → NUI ✅
"Client:NUI:ContextShow"
"Client:NUI:ContextHide"

-- NUI → Client ✅
"NUI:Client:ContextSelect"
"NUI:Client:ContextClose"
```

**Needs**: `ig.nui.context.*()` wrapper functions

---

### Character Select System
**Status**: ⚠️ PARTIAL (Multiple implementations)  
**Locations**: `nui/lua/NUI-Client/character-select.lua` + `client/[Callbacks]/_character.lua` (duplicate!)

**Messages**:
```lua
-- Client → NUI ✅
"Client:NUI:CharacterSelectShow"
"Client:NUI:CharacterSelectHide"

-- NUI → Client ✅
"NUI:Client:CharacterPlay"
"NUI:Client:CharacterDelete"
"NUI:Client:CharacterCreate"
```

**Issues**: 
- ⚠️ Duplicate handlers in `client/[Callbacks]/_character.lua`
- ⚠️ Callback pattern inconsistent
- ✅ Primary implementation in `nui/lua/NUI-Client/character-select.lua`

**Needs**: `ig.nui.character.*()` wrapper functions

---

### HUD System
**Status**: ✅ WORKING  
**Location**: `nui/lua/hud.lua` + `nui/src/utils/nui.js`

**Messages**:
```lua
-- Client → NUI ✅
"Client:NUI:HUDShow"
"Client:NUI:HUDHide"
"Client:NUI:HUDUpdate"

-- NUI → Client ✅
"NUI:Client:HUDPositionUpdate"
```

**Needs**: `ig.nui.hud.*()` wrapper functions

---

### Banking System
**Status**: ✅ WORKING  
**Location**: `nui/lua/notification.lua` + `client/[Callbacks]/_banking.lua`

**Messages**:
```lua
-- Client → NUI ✅
"Client:NUI:BankingOpen"
"Client:NUI:BankingClose"
"Client:NUI:BankingUpdateBalance"
"Client:NUI:BankingUpdateCash"
"Client:NUI:BankingAddTransaction"
"Client:NUI:BankingUpdateFavorites"

-- NUI → Client ✅
"NUI:Client:BankingClose"
"NUI:Client:BankingTransfer"
"NUI:Client:BankingWithdraw"
"NUI:Client:BankingDeposit"
"NUI:Client:BankingAddFavorite"
"NUI:Client:BankingRemoveFavorite"
```

**Handlers**: `client/[Callbacks]/_banking.lua`

**Needs**: `ig.nui.banking.*()` wrapper functions

---

### Inventory System
**Status**: ⚠️ PARTIAL  
**Location**: `nui/lua/inventory.lua`

**Messages**:
```lua
-- Client → NUI ⚠️
"Client:NUI:InventoryShow"
"Client:NUI:InventoryHide"
"Client:NUI:InventoryUpdate"

-- NUI → Client ⚠️
"NUI:Client:InventoryClose"
"NUI:Client:InventoryAction"
```

**Needs**: 
- Proper `ig.nui.inventory.*()` wrapper functions
- Organize callbacks

---

### Notification System
**Status**: ✅ WORKING  
**Location**: `nui/lua/notification.lua` + `nui/src/utils/nui.js`

**Messages**:
```lua
-- Client → NUI ✅
"Client:NUI:Notification"
```

**Needs**: `ig.nui.notification.*()` wrapper functions

---

### Appearance System
**Status**: ⚠️ PARTIAL  
**Location**: `nui/src/utils/nui.js` (handler only)

**Messages**:
```lua
-- Client → NUI ⚠️
"Client:NUI:AppearanceOpen"
"Client:NUI:AppearanceClose"

-- NUI → Client ❌
(No callbacks defined)
```

**Needs**: 
- `ig.nui.appearance.*()` wrapper functions
- Appearance callback handlers

---

### Garage/Garage System
**Status**: ⚠️ PARTIAL  
**Location**: `client/[Garage]/_machine.lua`

**Messages**:
```lua
-- Client → NUI ⚠️
(Direct NUI rendering)

-- NUI → Client ✅
"NUI:Client:GUIClose"
"NUI:Client:GUISelectVehicle"
```

**Needs**: 
- Organized wrapper functions
- Better structure

---

### Target System
**Status**: ⚠️ PARTIAL  
**Location**: `client/[Target]/_main.lua`

**Messages**:
```lua
-- Client → NUI ⚠️
(Direct JSON messages)

-- NUI → Client ✅
"NUI:Client:TargetSelect"
```

**Needs**: 
- Wrapper functions
- Better organization

---

## ❌ MISSING / NEEDS CREATION

### Folder Structure
**Status**: ❌ MISSING

**Needed**:
```
nui/lua/
├── Client-NUI-Wrappers/          ← CREATE THIS
│   ├── _character.lua            ← ig.nui.character.*
│   ├── _menu.lua                 ← ig.nui.menu.*
│   ├── _input.lua                ← ig.nui.input.*
│   ├── _context.lua              ← ig.nui.context.*
│   ├── _hud.lua                  ← ig.nui.hud.*
│   ├── _chat.lua                 ← ig.nui.chat.*
│   ├── _notification.lua         ← ig.nui.notification.*
│   ├── _banking.lua              ← ig.nui.banking.*
│   ├── _inventory.lua            ← ig.nui.inventory.*
│   ├── _appearance.lua           ← ig.nui.appearance.*
│   └── _garage.lua               ← ig.nui.garage.*
│
└── NUI-Client/                   ← ORGANIZE THIS
    ├── _character.lua            ← character callbacks
    ├── _menu.lua                 ← menu callbacks
    ├── _input.lua                ← input callbacks
    ├── _context.lua              ← context callbacks
    ├── _hud.lua                  ← hud callbacks
    ├── _chat.lua                 ← chat callbacks (move from root)
    ├── _banking.lua              ← banking callbacks (move from client/)
    ├── _inventory.lua            ← inventory callbacks
    ├── _appearance.lua           ← appearance callbacks
    └── _garage.lua               ← garage callbacks (move from client/)
```

---

### Wrapper Functions

#### ig.nui.character.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_character.lua` (CREATE)

```lua
function ig.nui.character.ShowSelect(characters, slots)
function ig.nui.character.HideSelect()
function ig.nui.character.ShowCreator(appearance)
function ig.nui.character.HideCreator()
```

---

#### ig.nui.menu.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_menu.lua` (CREATE)

```lua
function ig.nui.menu.Show(title, items)
function ig.nui.menu.Hide()
```

---

#### ig.nui.input.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_input.lua` (CREATE)

```lua
function ig.nui.input.Show(title, placeholder, maxLength)
function ig.nui.input.Hide()
```

---

#### ig.nui.context.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_context.lua` (CREATE)

```lua
function ig.nui.context.Show(title, items, position)
function ig.nui.context.Hide()
```

---

#### ig.nui.hud.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_hud.lua` (CREATE)

```lua
function ig.nui.hud.Show()
function ig.nui.hud.Hide()
function ig.nui.hud.Update(data)
```

---

#### ig.nui.chat.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_chat.lua` (CREATE)

```lua
function ig.nui.chat.AddMessage(message, author)
function ig.nui.chat.Show()
function ig.nui.chat.Hide()
function ig.nui.chat.SetSuggestions(suggestions)
```

---

#### ig.nui.notification.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_notification.lua` (CREATE)

```lua
function ig.nui.notification.Show(text, color, duration)
function ig.nui.notification.ShowLoadingSpinner(text)
function ig.nui.notification.HideLoadingSpinner()
```

---

#### ig.nui.banking.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_banking.lua` (CREATE)

```lua
function ig.nui.banking.Show(balance, cash)
function ig.nui.banking.Hide()
function ig.nui.banking.UpdateBalance(balance)
function ig.nui.banking.UpdateCash(cash)
function ig.nui.banking.AddTransaction(amount, type, description)
```

---

#### ig.nui.inventory.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_inventory.lua` (CREATE)

```lua
function ig.nui.inventory.Show(inventory)
function ig.nui.inventory.Hide()
function ig.nui.inventory.Update(inventory)
```

---

#### ig.nui.appearance.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_appearance.lua` (CREATE)

```lua
function ig.nui.appearance.Show(appearance)
function ig.nui.appearance.Hide()
```

---

#### ig.nui.garage.*
**Status**: ❌ MISSING  
**File**: `nui/lua/Client-NUI-Wrappers/_garage.lua` (CREATE)

```lua
function ig.nui.garage.Show(vehicles)
function ig.nui.garage.Hide()
```

---

## 📋 Implementation Checklist

### Phase 1: Create Client-NUI-Wrappers/ Folder
- [ ] Create `nui/lua/Client-NUI-Wrappers/` folder
- [ ] Create `_character.lua` with `ig.nui.character.*` functions
- [ ] Create `_menu.lua` with `ig.nui.menu.*` functions
- [ ] Create `_input.lua` with `ig.nui.input.*` functions
- [ ] Create `_context.lua` with `ig.nui.context.*` functions
- [ ] Create `_hud.lua` with `ig.nui.hud.*` functions
- [ ] Create `_chat.lua` with `ig.nui.chat.*` functions
- [ ] Create `_notification.lua` with `ig.nui.notification.*` functions
- [ ] Create `_banking.lua` with `ig.nui.banking.*` functions
- [ ] Create `_inventory.lua` with `ig.nui.inventory.*` functions
- [ ] Create `_appearance.lua` with `ig.nui.appearance.*` functions
- [ ] Create `_garage.lua` with `ig.nui.garage.*` functions

### Phase 2: Organize NUI-Client/ Folder
- [ ] Move `nui/lua/chat.lua` callbacks to `NUI-Client/_chat.lua`
- [ ] Create `NUI-Client/_menu.lua` with menu callbacks
- [ ] Create `NUI-Client/_input.lua` with input callbacks
- [ ] Create `NUI-Client/_context.lua` with context callbacks
- [ ] Move character callbacks to `NUI-Client/_character.lua`
- [ ] Move banking callbacks to `NUI-Client/_banking.lua`
- [ ] Create `NUI-Client/_inventory.lua` with inventory callbacks
- [ ] Create `NUI-Client/_appearance.lua` with appearance callbacks
- [ ] Create `NUI-Client/_garage.lua` with garage callbacks
- [ ] Consolidate HUD callbacks to `NUI-Client/_hud.lua`

### Phase 3: Update fxmanifest.lua
- [ ] Ensure `nui/lua/Client-NUI-Wrappers/*.lua` are loaded before NUI-Client
- [ ] Remove duplicate callback registrations
- [ ] Ensure load order is correct

### Phase 4: Testing
- [ ] Test each wrapper function sends correct message
- [ ] Test each callback receives correct message
- [ ] Verify no duplicate handlers
- [ ] Test character select flow end-to-end
- [ ] Test menu/input/context flows
- [ ] Test banking operations

---

## 🎯 Summary

| System | Client→NUI | NUI→Client | Wrapper Functions | Organized Handlers | Status |
|--------|-----------|-----------|-------------------|-------------------|--------|
| Chat | ✅ | ✅ | ❌ | ❌ | ⚠️ Needs wrapper |
| Menu | ✅ | ✅ | ❌ | ❌ | ⚠️ Needs wrapper |
| Input | ✅ | ✅ | ❌ | ❌ | ⚠️ Needs wrapper |
| Context | ✅ | ✅ | ❌ | ❌ | ⚠️ Needs wrapper |
| Character | ✅ | ✅ | ❌ | ⚠️ | ⚠️ Duplicates |
| HUD | ✅ | ✅ | ❌ | ❌ | ⚠️ Needs wrapper |
| Banking | ✅ | ✅ | ❌ | ✅ | ⚠️ Needs wrapper |
| Inventory | ✅ | ✅ | ❌ | ✅ | ⚠️ Needs wrapper |
| Appearance | ⚠️ | ❌ | ❌ | ❌ | ❌ Missing |
| Garage | ⚠️ | ✅ | ❌ | ✅ | ⚠️ Needs wrapper |
| Target | ⚠️ | ✅ | ❌ | ✅ | ⚠️ Needs wrapper |

**Overall Status**: 70% Complete - Needs organization and wrapper functions

---

**Last Updated**: 2026-01-16  
**Maintained By**: Development Team
