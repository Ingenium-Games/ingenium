---
# NUI Folder Structure: Client-NUI vs NUI-Client
## Organization Guide & Expected Messages

**Version**: 1.0  
**Last Updated**: 2026-01-16  
**Purpose**: Document the NUI folder organization and message flow

---

## Quick Reference

```
nui/lua/
├── Client-NUI-Wrappers/          ← Functions that SEND to NUI
│   ├── _character.lua            ← ig.nui.character.*()
│   ├── _menu.lua                 ← ig.nui.menu.*()
│   ├── _inventory.lua            ← ig.nui.inventory.*()
│   ├── _notification.lua         ← ig.nui.notification.*()
│   ├── _hud.lua                  ← ig.nui.hud.*()
│   ├── _chat.lua                 ← ig.nui.chat.*()
│   └── _banking.lua              ← ig.nui.banking.*()
│
├── NUI-Client/                   ← Handlers for NUI → Client callbacks
│   ├── _character.lua            ← RegisterNUICallback("NUI:Client:Character*")
│   ├── _menu.lua                 ← RegisterNUICallback("NUI:Client:Menu*")
│   ├── _inventory.lua            ← RegisterNUICallback("NUI:Client:Inventory*")
│   ├── _chat.lua                 ← RegisterNUICallback("NUI:Client:Chat*")
│   ├── _banking.lua              ← RegisterNUICallback("NUI:Client:Banking*")
│   └── _garage.lua               ← RegisterNUICallback("NUI:Client:GUI*")
│
└── ui.lua                        ← Base SendNUIMessage() wrapper
```

---

## FOLDER 1: Client-NUI-Wrappers/

**Purpose**: Contains functions that SEND messages TO the NUI  
**Pattern**: `function ig.nui.<system>.<action>(data)`  
**Message Type**: `Client:NUI:*`

### File: _character.lua
**Exports**: `ig.nui.character.*`

#### Expected Functions (To Create)
```lua
-- Show character select
ig.nui.character.ShowSelect(characters, slots)
  Sends: "Client:NUI:CharacterSelectShow"
  Data: {characters = {...}, slots = number}

-- Hide character select
ig.nui.character.HideSelect()
  Sends: "Client:NUI:CharacterSelectHide"
  Data: {}

-- Show character creator
ig.nui.character.ShowCreator(appearance)
  Sends: "Client:NUI:CharacterCreateShow"
  Data: {appearance = {...}}

-- Hide character creator
ig.nui.character.HideCreator()
  Sends: "Client:NUI:CharacterCreateHide"
  Data: {}
```

### File: _menu.lua
**Exports**: `ig.nui.menu.*`

#### Expected Functions
```lua
-- Show menu
ig.nui.menu.Show(title, items)
  Sends: "Client:NUI:MenuShow"
  Data: {title = string, items = {...}}

-- Hide menu
ig.nui.menu.Hide()
  Sends: "Client:NUI:MenuHide"
  Data: {}
```

### File: _inventory.lua
**Exports**: `ig.nui.inventory.*`

#### Expected Functions
```lua
-- Show inventory
ig.nui.inventory.Show(inventory)
  Sends: "Client:NUI:InventoryShow"
  Data: {inventory = {...}}

-- Hide inventory
ig.nui.inventory.Hide()
  Sends: "Client:NUI:InventoryHide"
  Data: {}

-- Update inventory
ig.nui.inventory.Update(inventory)
  Sends: "Client:NUI:InventoryUpdate"
  Data: {inventory = {...}}
```

### File: _notification.lua
**Exports**: `ig.nui.notification.*`

#### Expected Functions
```lua
-- Show notification
ig.nui.notification.Show(text, color, duration)
  Sends: "Client:NUI:Notification"
  Data: {text = string, colour = string, fade = number}

-- Show loading spinner
ig.nui.notification.ShowLoadingSpinner(text)
  Sends: "Client:NUI:LoadingSpinner"
  Data: {text = string, show = true}

-- Hide loading spinner
ig.nui.notification.HideLoadingSpinner()
  Sends: "Client:NUI:LoadingSpinner"
  Data: {show = false}
```

### File: _hud.lua
**Exports**: `ig.nui.hud.*`

#### Expected Functions
```lua
-- Show HUD
ig.nui.hud.Show()
  Sends: "Client:NUI:HUDShow"
  Data: {}

-- Hide HUD
ig.nui.hud.Hide()
  Sends: "Client:NUI:HUDHide"
  Data: {}

-- Update HUD data
ig.nui.hud.Update(data)
  Sends: "Client:NUI:HUDUpdate"
  Data: {health, armor, hunger, thirst, stress, cash, bank, job, jobGrade}
```

### File: _chat.lua
**Exports**: `ig.nui.chat.*`

#### Expected Functions
```lua
-- Add chat message
ig.nui.chat.AddMessage(message, author)
  Sends: "Client:NUI:ChatAddMessage"
  Data: {message = string, author = string}

-- Show chat
ig.nui.chat.Show()
  Sends: "Client:NUI:ChatShow"
  Data: {}

-- Hide chat
ig.nui.chat.Hide()
  Sends: "Client:NUI:ChatHide"
  Data: {}

-- Set chat suggestions
ig.nui.chat.SetSuggestions(suggestions)
  Sends: "Client:NUI:ChatSetSuggestions"
  Data: {suggestions = {...}}
```

### File: _banking.lua
**Exports**: `ig.nui.banking.*`

#### Expected Functions
```lua
-- Show banking UI
ig.nui.banking.Show(balance, cash)
  Sends: "Client:NUI:BankingOpen"
  Data: {balance = number, cash = number}

-- Hide banking UI
ig.nui.banking.Hide()
  Sends: "Client:NUI:BankingClose"
  Data: {}

-- Update balance
ig.nui.banking.UpdateBalance(balance)
  Sends: "Client:NUI:BankingUpdateBalance"
  Data: {balance = number}

-- Update cash
ig.nui.banking.UpdateCash(cash)
  Sends: "Client:NUI:BankingUpdateCash"
  Data: {cash = number}

-- Add transaction
ig.nui.banking.AddTransaction(amount, type, description)
  Sends: "Client:NUI:BankingAddTransaction"
  Data: {amount = number, type = string, description = string}
```

---

## FOLDER 2: NUI-Client/

**Purpose**: Contains handlers for messages FROM the NUI  
**Pattern**: `RegisterNUICallback("NUI:Client:*", function(data, cb) ... end)`  
**Message Type**: `NUI:Client:*`

### File: _character.lua
**Handlers**: Character-related callbacks from NUI

#### Expected Callbacks

```lua
-- Player selected character to play
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    -- data = {ID = characterID}
    -- Server: Character:Join with this ID
    cb({message = "ok"})
end)

-- Player deleted character
RegisterNUICallback("NUI:Client:CharacterDelete", function(data, cb)
    -- data = {ID = characterID}
    -- Server: Character:Delete with this ID
    cb({message = "ok"})
end)

-- Player created new character
RegisterNUICallback("NUI:Client:CharacterCreate", function(data, cb)
    -- data = {First_Name = string, Last_Name = string, appearance = {...}}
    -- Server: Character:Register with name and appearance
    cb({message = "ok"})
end)
```

### File: _menu.lua
**Handlers**: Menu callbacks from NUI

#### Expected Callbacks

```lua
-- Player selected menu item
RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    -- data = {action = string, data = {...}}
    -- Trigger: Client:Menu:Select event
    cb({message = "ok"})
end)

-- Player closed menu (ESC)
RegisterNUICallback("NUI:Client:MenuClose", function(data, cb)
    -- data = {}
    -- Trigger: Client:Menu:Close event
    cb({message = "ok"})
end)
```

### File: _inventory.lua
**Handlers**: Inventory callbacks from NUI

#### Expected Callbacks

```lua
-- Player closed inventory
RegisterNUICallback("NUI:Client:InventoryClose", function(data, cb)
    -- data = {}
    cb({message = "ok"})
end)

-- Player performed inventory action
RegisterNUICallback("NUI:Client:InventoryAction", function(data, cb)
    -- data = {action = string, item = string, quantity = number}
    -- action = "use", "drop", "give", "split", etc.
    cb({message = "ok"})
end)
```

### File: _chat.lua
**Handlers**: Chat callbacks from NUI

#### Expected Callbacks

```lua
-- Player submitted chat message
RegisterNUICallback("NUI:Client:ChatSubmit", function(data, cb)
    -- data = {message = string}
    -- Trigger: Client:Chat:MessageSubmitted event
    cb({message = "ok"})
end)

-- Player closed chat
RegisterNUICallback("NUI:Client:ChatClose", function(data, cb)
    -- data = {}
    cb({message = "ok"})
end)
```

### File: _banking.lua
**Handlers**: Banking callbacks from NUI

#### Expected Callbacks

```lua
-- Player closed banking UI
RegisterNUICallback("NUI:Client:BankingClose", function(data, cb)
    -- data = {}
    cb({message = "ok"})
end)

-- Player transferred money
RegisterNUICallback("NUI:Client:BankingTransfer", function(data, cb)
    -- data = {amount = number, targetAccount = string}
    -- Server: Banking:Transfer
    cb({message = "ok"})
end)

-- Player withdrew money
RegisterNUICallback("NUI:Client:BankingWithdraw", function(data, cb)
    -- data = {amount = number}
    -- Server: Banking:Withdraw
    cb({message = "ok"})
end)

-- Player deposited money
RegisterNUICallback("NUI:Client:BankingDeposit", function(data, cb)
    -- data = {amount = number}
    -- Server: Banking:Deposit
    cb({message = "ok"})
end)

-- Player added favorite
RegisterNUICallback("NUI:Client:BankingAddFavorite", function(data, cb)
    -- data = {account = string}
    cb({message = "ok"})
end)

-- Player removed favorite
RegisterNUICallback("NUI:Client:BankingRemoveFavorite", function(data, cb)
    -- data = {account = string}
    cb({message = "ok"})
end)
```

### File: _input.lua (NEW)
**Handlers**: Input dialog callbacks from NUI

#### Expected Callbacks

```lua
-- Player submitted input
RegisterNUICallback("NUI:Client:InputSubmit", function(data, cb)
    -- data = {value = string}
    cb({message = "ok"})
end)

-- Player closed input (ESC)
RegisterNUICallback("NUI:Client:InputClose", function(data, cb)
    -- data = {}
    cb({message = "ok"})
end)
```

### File: _context.lua (NEW)
**Handlers**: Context menu callbacks from NUI

#### Expected Callbacks

```lua
-- Player selected context action
RegisterNUICallback("NUI:Client:ContextSelect", function(data, cb)
    -- data = {action = string, data = {...}}
    cb({message = "ok"})
end)

-- Player closed context menu (ESC)
RegisterNUICallback("NUI:Client:ContextClose", function(data, cb)
    -- data = {}
    cb({message = "ok"})
end)
```

### File: _garage.lua
**Handlers**: Garage callbacks from NUI

#### Expected Callbacks

```lua
-- Player closed garage UI
RegisterNUICallback("NUI:Client:GUIClose", function(data, cb)
    -- data = {}
    cb({message = "ok"})
end)

-- Player selected vehicle
RegisterNUICallback("NUI:Client:GUISelectVehicle", function(data, cb)
    -- data = {vehicleID = string}
    cb({message = "ok"})
end)
```

---

## Message Flow Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│              CLIENT → NUI → CLIENT MESSAGE FLOW                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Step 1: Client Sends Message                                   │
│  ────────────────────────────────                                │
│  ig.nui.character.ShowSelect(characters, slots)                 │
│    └─> Client-NUI-Wrappers/_character.lua                       │
│         └─> SendNUIMessage({                                    │
│              message = "Client:NUI:CharacterSelectShow",        │
│              data = {characters, slots}                         │
│            })                                                    │
│                                                                  │
│  Step 2: NUI Receives & Processes                               │
│  ──────────────────────────────────                              │
│  nui/src/utils/nui.js → handleMessage()                         │
│    └─> switch (message)                                         │
│         └─> case "Client:NUI:CharacterSelectShow"               │
│              └─> characterStore.setCharacters(...)              │
│                   uiStore.showCharacterSelect = true            │
│                                                                  │
│  Step 3: Player Interacts with NUI                              │
│  ──────────────────────────────────                              │
│  Vue Component → sendNuiMessage("NUI:Client:*")                │
│    └─> fetch("https://ingenium/NUI:Client:CharacterPlay")      │
│                                                                  │
│  Step 4: NUI-Client Handler Receives Callback                   │
│  ────────────────────────────────────────────                   │
│  nui/lua/NUI-Client/_character.lua                              │
│    └─> RegisterNUICallback("NUI:Client:CharacterPlay",          │
│         function(data, cb)                                      │
│           TriggerServerCallback(...)                            │
│           cb({message = "ok"})                                  │
│         end)                                                    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Data Flow Examples

### Example 1: Show & Select Character
```
CLIENT SIDE:
  ig.nui.character.ShowSelect({chars}, slots)
    ↓
  SendNUIMessage("Client:NUI:CharacterSelectShow", {...})
    ↓
NUI SIDE:
  handleMessage() → case "Client:NUI:CharacterSelectShow"
    ↓
  characterStore.setCharacters(...)
    ↓
  <CharacterSelect/> renders with data
    ↓
  Player clicks character
    ↓
  sendNuiMessage("NUI:Client:CharacterPlay", {ID: 1})
    ↓
CLIENT SIDE:
  RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    ↓
  TriggerServerCallback("Server:Character:Join", ...)
    ↓
  cb({ok = true})
```

### Example 2: Show Menu & Get Selection
```
CLIENT SIDE:
  ig.nui.menu.Show("Store", items)
    ↓
  SendNUIMessage("Client:NUI:MenuShow", {...})
    ↓
NUI SIDE:
  handleMessage() → case "Client:NUI:MenuShow"
    ↓
  uiStore.openMenu(data)
    ↓
  <Menu/> renders with items
    ↓
  Player clicks item
    ↓
  sendNuiMessage("NUI:Client:MenuSelect", {action: "buy_item"})
    ↓
CLIENT SIDE:
  RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    ↓
  TriggerEvent("Store:ItemSelected", data.action)
    ↓
  cb({ok = true})
```

---

## Checklist: Implementing New Feature

When adding a new NUI feature, follow this checklist:

### 1. Client-NUI-Wrappers
- [ ] Create function in appropriate file
- [ ] Function name follows `ig.nui.<system>.<action>()` pattern
- [ ] Function sends message with `Client:NUI:*` prefix
- [ ] Message includes relevant data

### 2. NUI Vue Component
- [ ] Component listens for message in `setupNuiHandlers()`
- [ ] Message handler updates appropriate Pinia store
- [ ] Component displays data correctly

### 3. NUI-Client Handlers
- [ ] Create handler file if new system
- [ ] Use `RegisterNUICallback("NUI:Client:*")`
- [ ] Handler receives data from NUI
- [ ] Handler triggers appropriate event or server callback
- [ ] Always respond with `cb({message = "ok"})`

### 4. Documentation
- [ ] Add to NUI_MESSAGE_PROTOCOL_REFERENCE.md
- [ ] List in this file under appropriate section
- [ ] Include example usage

---

## Common Mistakes to Avoid

❌ **Wrong**: `SendNUIMessage({message = "MenuShow", ...})`  
✅ **Correct**: `SendNUIMessage({message = "Client:NUI:MenuShow", ...})`

❌ **Wrong**: `RegisterNUICallback("MenuSelect", function(data) ... end)`  
✅ **Correct**: `RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb) cb({ok=true}) end)`

❌ **Wrong**: Direct `SendNUIMessage()` calls scattered in code  
✅ **Correct**: Use wrapper functions in Client-NUI-Wrappers

❌ **Wrong**: No data validation in NUI callbacks  
✅ **Correct**: Validate `data` parameter before using

---

**Last Updated**: 2026-01-16  
**Maintained By**: Development Team
