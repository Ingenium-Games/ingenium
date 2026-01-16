---
# NUI Messages Quick Reference (Cheat Sheet)
## Fast lookup for all Client ↔ NUI messages

**Version**: 1.0  
**Last Updated**: 2026-01-16

---

## 📨 CLIENT → NUI (SendNUIMessage)

### CHAT
```lua
SendNUIMessage({message = "Client:NUI:ChatAddMessage", data = {message, author}})
SendNUIMessage({message = "Client:NUI:ChatShow", data = {}})
SendNUIMessage({message = "Client:NUI:ChatHide", data = {}})
SendNUIMessage({message = "Client:NUI:ChatClear", data = {}})
SendNUIMessage({message = "Client:NUI:ChatSetSuggestions", data = {suggestions}})
```

### CHARACTER
```lua
SendNUIMessage({message = "Client:NUI:CharacterSelectShow", data = {characters, slots}})
SendNUIMessage({message = "Client:NUI:CharacterSelectHide", data = {}})
```

### HUD
```lua
SendNUIMessage({message = "Client:NUI:HUDShow", data = {}})
SendNUIMessage({message = "Client:NUI:HUDHide", data = {}})
SendNUIMessage({message = "Client:NUI:HUDUpdate", data = {health, armor, hunger, thirst, stress, cash, bank, job, jobGrade}})
```

### MENU
```lua
SendNUIMessage({message = "Client:NUI:MenuShow", data = {title, items}})
SendNUIMessage({message = "Client:NUI:MenuHide", data = {}})
```

### INPUT
```lua
SendNUIMessage({message = "Client:NUI:InputShow", data = {title, placeholder, maxLength}})
SendNUIMessage({message = "Client:NUI:InputHide", data = {}})
```

### CONTEXT MENU
```lua
SendNUIMessage({message = "Client:NUI:ContextShow", data = {title, items, position}})
SendNUIMessage({message = "Client:NUI:ContextHide", data = {}})
```

### APPEARANCE
```lua
SendNUIMessage({message = "Client:NUI:AppearanceOpen", data = {appearance}})
SendNUIMessage({message = "Client:NUI:AppearanceClose", data = {}})
```

### BANKING
```lua
SendNUIMessage({message = "Client:NUI:BankingOpen", data = {balance, cash}})
SendNUIMessage({message = "Client:NUI:BankingClose", data = {}})
SendNUIMessage({message = "Client:NUI:BankingUpdateBalance", data = {balance}})
SendNUIMessage({message = "Client:NUI:BankingUpdateCash", data = {cash}})
SendNUIMessage({message = "Client:NUI:BankingAddTransaction", data = {amount, type, description}})
SendNUIMessage({message = "Client:NUI:BankingUpdateFavorites", data = {favorites}})
```

### INVENTORY
```lua
SendNUIMessage({message = "Client:NUI:InventoryShow", data = {inventory}})
SendNUIMessage({message = "Client:NUI:InventoryHide", data = {}})
SendNUIMessage({message = "Client:NUI:InventoryUpdate", data = {inventory}})
```

### NOTIFICATION
```lua
SendNUIMessage({message = "Client:NUI:Notification", data = {text, colour, fade}})
```

---

## 📬 NUI → CLIENT (RegisterNUICallback)

### CHAT
```lua
RegisterNUICallback("NUI:Client:ChatSubmit", function(data, cb)
    -- data.message = string
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:ChatClose", function(data, cb)
    -- data = {}
    cb({ok = true})
end)
```

### CHARACTER
```lua
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    -- data.ID = characterID
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:CharacterDelete", function(data, cb)
    -- data.ID = characterID
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:CharacterCreate", function(data, cb)
    -- data.First_Name = string
    -- data.Last_Name = string
    -- data.appearance = {...}
    cb({ok = true})
end)
```

### MENU
```lua
RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    -- data.action = string
    -- data.data = {...}
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:MenuClose", function(data, cb)
    -- data = {}
    cb({ok = true})
end)
```

### INPUT
```lua
RegisterNUICallback("NUI:Client:InputSubmit", function(data, cb)
    -- data.value = string (player input)
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:InputClose", function(data, cb)
    -- data = {}
    cb({ok = true})
end)
```

### CONTEXT MENU
```lua
RegisterNUICallback("NUI:Client:ContextSelect", function(data, cb)
    -- data.action = string
    -- data.data = {...}
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:ContextClose", function(data, cb)
    -- data = {}
    cb({ok = true})
end)
```

### BANKING
```lua
RegisterNUICallback("NUI:Client:BankingClose", function(data, cb)
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:BankingTransfer", function(data, cb)
    -- data.amount = number
    -- data.targetAccount = string
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:BankingWithdraw", function(data, cb)
    -- data.amount = number
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:BankingDeposit", function(data, cb)
    -- data.amount = number
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:BankingAddFavorite", function(data, cb)
    -- data.account = string
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:BankingRemoveFavorite", function(data, cb)
    -- data.account = string
    cb({ok = true})
end)
```

### INVENTORY
```lua
RegisterNUICallback("NUI:Client:InventoryClose", function(data, cb)
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:InventoryAction", function(data, cb)
    -- data.action = string ("use", "drop", "give", "split", etc)
    -- data.item = string
    -- data.quantity = number
    cb({ok = true})
end)
```

### GARAGE
```lua
RegisterNUICallback("NUI:Client:GUIClose", function(data, cb)
    cb({ok = true})
end)

RegisterNUICallback("NUI:Client:GUISelectVehicle", function(data, cb)
    -- data.vehicleID = string
    cb({ok = true})
end)
```

### HUD
```lua
RegisterNUICallback("NUI:Client:HUDPositionUpdate", function(data, cb)
    -- data.position = {x, y}
    cb({ok = true})
end)
```

### TARGET
```lua
RegisterNUICallback("NUI:Client:TargetSelect", function(data, cb)
    -- data.action = string
    cb({ok = true})
end)
```

---

## 🔄 Complete Flow Template

### Sending to NUI
```lua
-- 1. Send message TO NUI
SendNUIMessage({
    message = "Client:NUI:MenuShow",
    data = {title = "Shop", items = {...}}
})
SetNuiFocus(true, true)

-- 2. Wait for callback FROM NUI
RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    -- 3. Handle selection
    local action = data.action
    print("Selected: " .. action)
    
    -- 4. Close menu
    SetNuiFocus(false, false)
    
    -- 5. Send response
    cb({ok = true})
end)
```

---

## 📍 Message Location Map

| System | Client→NUI | NUI→Client | Location |
|--------|-----------|-----------|----------|
| **Chat** | ChatAddMessage, ChatShow, etc | ChatSubmit, ChatClose | nui/lua/chat.lua |
| **Menu** | MenuShow, MenuHide | MenuSelect, MenuClose | nui/lua/ui.lua |
| **Input** | InputShow, InputHide | InputSubmit, InputClose | nui/lua/ui.lua |
| **Context** | ContextShow, ContextHide | ContextSelect, ContextClose | nui/lua/ui.lua |
| **Character** | CharacterSelectShow | CharacterPlay, CharacterDelete, CharacterCreate | nui/lua/NUI-Client/character-select.lua |
| **HUD** | HUDShow, HUDHide, HUDUpdate | HUDPositionUpdate | nui/lua/hud.lua |
| **Banking** | BankingOpen, BankingUpdateBalance, etc | BankingClose, BankingTransfer, etc | nui/lua/notification.lua & client/[Callbacks]/_banking.lua |
| **Inventory** | InventoryShow, InventoryHide, InventoryUpdate | InventoryClose, InventoryAction | nui/lua/inventory.lua |
| **Garage** | (Direct NUI) | GUIClose, GUISelectVehicle | client/[Garage]/_machine.lua |
| **Target** | (Target system) | TargetSelect | client/[Target]/_main.lua |

---

## ⚠️ Common Issues & Solutions

| Issue | Cause | Fix |
|-------|-------|-----|
| NUI doesn't receive message | Message not `Client:NUI:*` | Check message name prefix |
| Callback never fires | NUI focus not set | Use `SetNuiFocus(true, true)` |
| Error in NUI console | No callback response | Always call `cb({ok = true})` |
| UI freezes after close | Focus not released | Call `SetNuiFocus(false, false)` |
| Message data is nil | Sent `nil` instead of table | Always send `{}` for empty data |
| Message lost | NUI not loaded | Wait for `NetworkIsSessionStarted()` |

---

## 🎯 Best Practice Template

```lua
-- Send to NUI with clear structure
function ShowMyUI(data)
    SendNUIMessage({
        message = "Client:NUI:MySystemShow",
        data = {
            title = data.title or "Default",
            items = data.items or {},
            position = data.position or {x = 0, y = 0}
        }
    })
    SetNuiFocus(true, true)
end

-- Receive from NUI with validation
RegisterNUICallback("NUI:Client:MySystemAction", function(data, cb)
    if not data or not data.action then
        cb({error = "Invalid data"})
        return
    end
    
    local action = data.action
    local itemData = data.data or {}
    
    -- Process action
    TriggerEvent("MySystem:Action", action, itemData)
    
    -- Always respond
    cb({message = "ok"})
end)

-- Close UI handler
RegisterNUICallback("NUI:Client:MySystemClose", function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent("MySystem:Closed")
    cb({ok = true})
end)
```

---

## 📚 See Also

- [NUI_MESSAGE_PROTOCOL_REFERENCE.md](NUI_MESSAGE_PROTOCOL_REFERENCE.md) - Complete reference with details
- [NUI_FOLDER_STRUCTURE_GUIDE.md](NUI_FOLDER_STRUCTURE_GUIDE.md) - Folder organization & expected functions
- nui/src/utils/nui.js - Message handler implementation
- nui/lua/NUI-Client/ - Callback handlers
- client/_ui.lua - Client UI wrapper

---

**Print this page for quick reference!**  
**Last Updated**: 2026-01-16
