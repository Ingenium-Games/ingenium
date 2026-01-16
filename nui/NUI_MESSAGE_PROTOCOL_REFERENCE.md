---
# NUI Message Protocol Reference
## Complete Client↔NUI Communication Specification

**Version**: 1.0  
**Last Updated**: 2026-01-16  
**Scope**: All messages exchanged between Client (Lua) and NUI (Vue.js)

---

## ⚠️ CRITICAL IMPLEMENTATION NOTES

### 1. Timing: Wait Before Firing Events

**Problem**: Vue and Pinia stores are still initializing when NUI first loads. If you fire events too quickly, they may not be received or processed.

**Solution**: Add a small delay (100-500ms) before firing off any events upon connection/launch:

```lua
-- ❌ WRONG - Event fires before Vue is ready
SendNUIMessage({ message = "Client:NUI:ChatShow", data = {} })

-- ✅ CORRECT - Wait for Vue initialization
SetTimeout(function()
    SendNUIMessage({ message = "Client:NUI:ChatShow", data = {} })
end, 250)
```

**Best Practice**: Use a "NUI:Client:Ready" callback from NUI to signal when it's safe to send messages.

---

### 2. Message Structure: Event Data Wrapping

**Critical**: All messages sent from NUI are wrapped in the `event.data` table. You must extract both `message` and `data` correctly in your NUI handlers.

**In Vue/JavaScript** (nui/src/utils/nui.js):

```javascript
// ❌ WRONG - Accessing event directly
window.addEventListener('message', (event) => {
    const message = event.message  // ❌ UNDEFINED
    const data = event.data        // ⚠️ Wrong - this IS the wrapper
})

// ✅ CORRECT - Extract from event.data
window.addEventListener('message', (event) => {
    const message = event.data.message  // ✅ Gets the message type
    const data = event.data.data        // ✅ Gets the message payload
})

// Practical example:
window.addEventListener('message', (e) => {
    const message = e.data.message
    const data = e.data.data
    
    switch(message) {
        case 'Client:NUI:ChatAddMessage':
            chatStore.addMessage(data.message, data.author)
            break
        case 'Client:NUI:Notification':
            notificationStore.show(data.text, data.duration)
            break
    }
})
```

**Message Wrapper Format**:
```lua
-- Sent from Lua (Client)
SendNUIMessage({
    message = "Client:NUI:ChatAddMessage",  -- Message type
    data = {                                 -- Payload
        message = "Hello",
        author = "Player"
    }
})

-- Received in JavaScript as:
event.data = {
    message = "Client:NUI:ChatAddMessage",
    data = { message = "Hello", author = "Player" }
}

-- Extract it correctly:
let message = event.data.message
let data = event.data.data
```

**Why This Matters**: 
- `event.data` is the entire message object from PostMessage
- `.data` property contains the actual payload
- Forgetting this causes "Cannot read property of undefined" errors
- The message handler won't match if you can't read the message type correctly

---

## Overview

The NUI system uses a two-directional message protocol:

```
┌─────────────────────────────────────────────────────────────────┐
│                   CLIENT ↔ NUI COMMUNICATION                    │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  CLIENT (Lua)                        NUI (Vue.js)              │
│  ═════════════                       ══════════════             │
│                                                                 │
│  SendNUIMessage()  ────────────→  window.postMessage()        │
│  │                                 │                           │
│  │ (Client→NUI)                    │ Handler receives          │
│  │                                 │ message in setupNuiHandlers
│  │                                 └─→ Pinia Store update     │
│  │                                                              │
│  RegisterNUICallback()  ←─────────  sendNuiMessage()          │
│  │                                 │                           │
│  └─ NUI:Client:* callbacks         └─ fetch("NUI:Client:*")   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Message Direction

### CLIENT → NUI (SendNUIMessage)
**Direction**: Client sends a message to NUI  
**Pattern**: `SendNUIMessage({ message = "Client:NUI:*", data = {...} })`  
**Receiver**: `nui/src/utils/nui.js` → `handleMessage()`

**Note**: Wait 200-500ms after NUI loads before sending initial messages to allow Vue/Pinia initialization.

### NUI → CLIENT (RegisterNUICallback)
**Direction**: NUI sends a message back to Client  
**Pattern**: `sendNuiMessage("NUI:Client:*", {...})`  
**Receiver**: `RegisterNUICallback("NUI:Client:*")`

---

## Message Format & Data Extraction

### Lua → NUI Message Structure

When sending from Lua to NUI:

```lua
SendNUIMessage({
    message = "Client:NUI:OperationName",  -- Message identifier
    data = {                                 -- Actual payload
        key1 = "value1",
        key2 = 123
    }
})
```

### JavaScript → Lua Callback Structure

When receiving in JavaScript from PostMessage event:

```javascript
window.addEventListener('message', (e) => {
    // ⚠️ CRITICAL: Extract both from e.data
    let message = e.data.message  // Get the message type
    let data = e.data.data        // Get the payload
    
    // Now you can process:
    if (message === 'Client:NUI:ChatAddMessage') {
        let msg = data.message
        let author = data.author
        // ... handle message
    }
})
```

### Lua ← NUI Callback Structure  

When receiving in Lua from NUI callback:

```lua
RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    -- data is ALREADY the payload (NOT wrapped)
    local selectedItem = data.index
    local itemName = data.name
    
    -- Send callback response
    cb({
        success = true,
        result = selectedItem
    })
end)
```

**Key Difference**:
- **Client→NUI**: Data comes wrapped in `event.data` (must extract with `e.data.message` and `e.data.data`)
- **NUI→Client**: Data is passed directly to callback function (no wrapper)

---

## CLIENT → NUI MESSAGES (Client sends to NUI)

These are all messages the Client sends to the NUI using `SendNUIMessage()`.

### Chat System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:ChatAddMessage` | `{message, author}` | Add message to chat | `nui/src/utils/nui.js` |
| `Client:NUI:ChatShow` | `{}` | Show chat window | `nui/src/utils/nui.js` |
| `Client:NUI:ChatHide` | `{}` | Hide chat window | `nui/src/utils/nui.js` |
| `Client:NUI:ChatClear` | `{}` | Clear all chat messages | `nui/src/utils/nui.js` |
| `Client:NUI:ChatSetSuggestions` | `{suggestions: []}` | Set chat command suggestions | `nui/src/utils/nui.js` |

**Usage Example**:
```lua
SendNUIMessage({
    message = "Client:NUI:ChatAddMessage",
    data = {
        message = "Hello world",
        author = "Player"
    }
})
```

### Notification System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:Notification` | `{text, colour, fade}` | Show notification | `nui/src/utils/nui.js` |

**Usage Example**:
```lua
SendNUIMessage({
    message = "Client:NUI:Notification",
    data = {
        text = "This is a notification",
        colour = "green",
        fade = 5000
    }
})
```

### Character Select System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:CharacterSelectShow` | `{characters: [], slots: number}` | Show character select UI | `nui/src/utils/nui.js` |
| `Client:NUI:CharacterSelectHide` | `{}` | Hide character select UI | `nui/src/utils/nui.js` |

**Usage Example**:
```lua
SendNUIMessage({
    message = "Client:NUI:CharacterSelectShow",
    data = {
        characters = {
            {id = 1, name = "John Doe", level = 10},
            {id = 2, name = "Jane Doe", level = 5}
        },
        slots = 3
    }
})
```

### HUD System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:HUDShow` | `{}` | Show HUD | `nui/src/utils/nui.js` |
| `Client:NUI:HUDHide` | `{}` | Hide HUD | `nui/src/utils/nui.js` |
| `Client:NUI:HUDUpdate` | `{health, armor, hunger, thirst, stress, cash, bank, job, jobGrade}` | Update HUD data | `nui/src/utils/nui.js` |

**Usage Example**:
```lua
SendNUIMessage({
    message = "Client:NUI:HUDUpdate",
    data = {
        health = 100,
        armor = 50,
        hunger = 75,
        thirst = 60,
        stress = 20,
        cash = 5000,
        bank = 50000,
        job = "Police",
        jobGrade = "Officer"
    }
})
```

### Menu System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:MenuShow` | `{title, items: []}` | Show menu | `nui/src/utils/nui.js` |
| `Client:NUI:MenuHide` | `{}` | Hide menu | `nui/src/utils/nui.js` |

**Usage Example**:
```lua
SendNUIMessage({
    message = "Client:NUI:MenuShow",
    data = {
        title = "Main Menu",
        items = {
            {label = "Option 1", action = "action1"},
            {label = "Option 2", action = "action2"}
        }
    }
})
```

### Input Dialog System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:InputShow` | `{title, placeholder, maxLength}` | Show input dialog | `nui/src/utils/nui.js` |
| `Client:NUI:InputHide` | `{}` | Hide input dialog | `nui/src/utils/nui.js` |

**Usage Example**:
```lua
SendNUIMessage({
    message = "Client:NUI:InputShow",
    data = {
        title = "Enter your name",
        placeholder = "John Doe",
        maxLength = 50
    }
})
```

### Context Menu System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:ContextShow` | `{title, items: [], position: {x, y}}` | Show context menu | `nui/src/utils/nui.js` |
| `Client:NUI:ContextHide` | `{}` | Hide context menu | `nui/src/utils/nui.js` |

**Usage Example**:
```lua
SendNUIMessage({
    message = "Client:NUI:ContextShow",
    data = {
        title = "Actions",
        items = {
            {label = "Action 1", icon = "🔧", action = "repair"},
            {label = "Action 2", icon = "🗑️", action = "delete"}
        },
        position = {x = 100, y = 100}
    }
})
```

### Appearance Customization System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:AppearanceOpen` | `{appearance: {}}` | Open appearance customizer | `nui/src/utils/nui.js` |
| `Client:NUI:AppearanceClose` | `{}` | Close appearance customizer | `nui/src/utils/nui.js` |

### Banking System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:BankingOpen` | `{balance, cash}` | Open banking UI | `nui/src/utils/nui.js` |
| `Client:NUI:BankingClose` | `{}` | Close banking UI | `nui/src/utils/nui.js` |
| `Client:NUI:BankingUpdateBalance` | `{balance}` | Update balance display | `nui/src/utils/nui.js` |
| `Client:NUI:BankingUpdateCash` | `{cash}` | Update cash display | `nui/src/utils/nui.js` |
| `Client:NUI:BankingAddTransaction` | `{amount, type, description}` | Add transaction to history | `nui/src/utils/nui.js` |
| `Client:NUI:BankingUpdateFavorites` | `{favorites: []}` | Update favorite accounts | `nui/src/utils/nui.js` |

### Inventory System

| Message | Data | Purpose | Handler Location |
|---------|------|---------|---|
| `Client:NUI:InventoryShow` | `{inventory: {}}` | Show inventory UI | `nui/lua/inventory.lua` |
| `Client:NUI:InventoryHide` | `{}` | Hide inventory UI | `nui/lua/inventory.lua` |
| `Client:NUI:InventoryUpdate` | `{inventory: {}}` | Update inventory display | `nui/lua/inventory.lua` |

---

## NUI → CLIENT MESSAGES (NUI sends back to Client)

These are all messages the NUI sends back to the Client using `sendNuiMessage("NUI:Client:*")`.

### Chat Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:ChatSubmit` | `{message}` | Player submitted chat message | `nui/lua/chat.lua` |
| `NUI:Client:ChatClose` | `{}` | Player closed chat | `nui/lua/chat.lua` |

**Handler Example**:
```lua
RegisterNUICallback("NUI:Client:ChatSubmit", function(data, cb)
    local message = data.message
    TriggerEvent("Client:Chat:MessageSubmitted", message)
    cb({ok = true})
end)
```

### Menu Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:MenuSelect` | `{action, data}` | Player selected menu item | `nui/lua/ui.lua` |
| `NUI:Client:MenuClose` | `{}` | Player closed menu | `nui/lua/ui.lua` |

### Input Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:InputSubmit` | `{value}` | Player submitted input | `nui/lua/ui.lua` |
| `NUI:Client:InputClose` | `{}` | Player closed input dialog | `nui/lua/ui.lua` |

### Context Menu Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:ContextSelect` | `{action, data}` | Player selected context action | `nui/lua/ui.lua` |
| `NUI:Client:ContextClose` | `{}` | Player closed context menu | `nui/lua/ui.lua` |

### Character Select Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:CharacterPlay` | `{ID}` | Player selected character to play | `nui/lua/NUI-Client/character-select.lua` |
| `NUI:Client:CharacterDelete` | `{ID}` | Player deleted a character | `nui/lua/NUI-Client/character-select.lua` |
| `NUI:Client:CharacterCreate` | `{First_Name, Last_Name, appearance}` | Player created new character | `nui/lua/NUI-Client/character-select.lua` |

**Handler Example**:
```lua
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    local characterID = data.ID
    TriggerServerCallback({
        eventName = "Server:Character:Join",
        args = {characterID},
        callback = function(result)
            cb({success = result.success})
        end
    })
end)
```

### Banking Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:BankingClose` | `{}` | Player closed banking UI | `client/[Callbacks]/_banking.lua` |
| `NUI:Client:BankingTransfer` | `{amount, targetAccount}` | Player transferred money | `client/[Callbacks]/_banking.lua` |
| `NUI:Client:BankingWithdraw` | `{amount}` | Player withdrew money | `client/[Callbacks]/_banking.lua` |
| `NUI:Client:BankingDeposit` | `{amount}` | Player deposited money | `client/[Callbacks]/_banking.lua` |
| `NUI:Client:BankingAddFavorite` | `{account}` | Player added favorite account | `client/[Callbacks]/_banking.lua` |
| `NUI:Client:BankingRemoveFavorite` | `{account}` | Player removed favorite account | `client/[Callbacks]/_banking.lua` |

### Inventory Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:InventoryClose` | `{}` | Player closed inventory | `nui/lua/inventory.lua` |
| `NUI:Client:InventoryAction` | `{action, item, quantity}` | Player performed inventory action | `nui/lua/inventory.lua` |

### Garage Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:GUIClose` | `{}` | Player closed garage UI | `client/[Garage]/_machine.lua` |
| `NUI:Client:GUISelectVehicle` | `{vehicleID}` | Player selected vehicle | `client/[Garage]/_machine.lua` |

### HUD Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:HUDPositionUpdate` | `{position}` | Player moved HUD | `nui/lua/hud.lua` |

### Target System Callbacks

| Callback | Data | Purpose | Handler Location |
|----------|------|---------|---|
| `NUI:Client:TargetSelect` | `{action}` | Player selected target | `client/[Target]/_main.lua` |

---

## Message Flow Examples

### Example 1: Show Menu and Wait for Selection
```lua
-- Server or Client sends menu to NUI
SendNUIMessage({
    message = "Client:NUI:MenuShow",
    data = {
        title = "Store Menu",
        items = {
            {label = "Buy Water", action = "buy_water", data = {item = "water", price = 10}},
            {label = "Buy Food", action = "buy_food", data = {item = "food", price = 20}}
        }
    }
})
SetNuiFocus(true, true)

-- Player selects item in NUI, triggers callback
RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    local action = data.action  -- "buy_water" or "buy_food"
    local actionData = data.data
    
    print("Player selected: " .. action)
    
    TriggerEvent("Store:BuyItem", action, actionData)
    SetNuiFocus(false, false)
    cb({ok = true})
end)
```

### Example 2: Character Select Flow
```lua
-- Server sends character list to client
SendNUIMessage({
    message = "Client:NUI:CharacterSelectShow",
    data = {
        characters = {
            {id = 1, name = "John", level = 50},
            {id = 2, name = "Jane", level = 30}
        },
        slots = 5
    }
})

-- NUI displays characters, player clicks one
-- NUI callback fires:
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    local charID = data.ID
    TriggerServerCallback({
        eventName = "Server:Character:Join",
        args = {charID},
        callback = function(result)
            if result.success then
                -- Character loaded
            end
        end
    })
    cb({ok = true})
end)
```

### Example 3: Input Dialog
```lua
-- Show input for player name
SendNUIMessage({
    message = "Client:NUI:InputShow",
    data = {
        title = "Enter Character Name",
        placeholder = "John Doe",
        maxLength = 50
    }
})
SetNuiFocus(true, true)

-- Player submits input
RegisterNUICallback("NUI:Client:InputSubmit", function(data, cb)
    local playerName = data.value
    print("Player entered: " .. playerName)
    
    SetNuiFocus(false, false)
    cb({ok = true})
end)
```

---

## Data Types & Structures

### Character Data
```lua
{
    id = 1,
    name = "John Doe",
    level = 50,
    job = "Police",
    appearance = {
        -- Appearance data structure
    }
}
```

### Inventory Item
```lua
{
    slot = 1,
    name = "water",
    label = "Bottle of Water",
    quantity = 5,
    weight = 0.5,
    image = "water.png"
}
```

### Transaction
```lua
{
    amount = 500,
    type = "deposit",
    description = "Paycheck",
    timestamp = 1234567890
}
```

---

## Best Practices

### 1. Always Provide a Callback Response
```lua
-- ❌ Wrong - no response
RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    TriggerEvent("Menu:Selected", data.action)
end)

-- ✅ Correct - always respond
RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    TriggerEvent("Menu:Selected", data.action)
    cb({ok = true})
end)
```

### 2. Set NUI Focus Appropriately
```lua
-- Show UI that needs input
SendNUIMessage({message = "Client:NUI:MenuShow", data = {...}})
SetNuiFocus(true, true)  -- true for keyboard, true for mouse

-- Hide UI
SetNuiFocus(false, false)
```

### 3. Use Consistent Message Names
- `Client:NUI:*` for messages TO NUI
- `NUI:Client:*` for messages FROM NUI

### 4. Include Context in Data
```lua
-- ❌ Vague
SendNUIMessage({message = "Client:NUI:MenuShow", data = {items = {...}}})

-- ✅ Clear
SendNUIMessage({
    message = "Client:NUI:MenuShow",
    data = {
        title = "Store",
        items = {...}
    }
})
```

---

## Troubleshooting

### Message Not Received by NUI
1. Check message name starts with `Client:NUI:`
2. Verify NUI is focused: `SetNuiFocus(true, true)`
3. Check browser console for errors
4. Ensure data is a table, not nil

### Callback Not Triggering
1. Check callback name starts with `NUI:Client:`
2. Verify RegisterNUICallback is registered
3. Check if callback response is sent: `cb({ok = true})`
4. Look for errors in Lua console

### Focus Not Working
1. Use `SetNuiFocus(true, true)` before showing interactive UI
2. Remember to call `SetNuiFocus(false, false)` after
3. Check ESC key handler doesn't interfere

---

**Last Updated**: 2026-01-16  
**Maintained By**: Development Team
