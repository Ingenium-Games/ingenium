---
# Quick Reference: Character System Files
## Where Everything Is & What It Does

**Quick Navigation Guide**

---

## File Locations

### Server-Side
```
server/[Events]/_character_lifecycle.lua
├─ Stage 1: Character List & Selection
│  └─ RegisterServerCallback("Server:Character:List")
│  └─ RegisterNetEvent("Server:Character:Join")
│
├─ Stage 2: Character Creation
│  └─ RegisterNetEvent("Server:Character:Register")
│  └─ RegisterNetEvent("Server:Character:Spawn")
│
├─ Stage 3: Character Loading
│  └─ RegisterNetEvent("Server:Character:Loaded") [sets ped flags]
│
├─ Stage 4: Character Ready
│  └─ RegisterNetEvent("Server:Character:Ready") [final setup]
│
└─ Additional Events
   ├─ Server:Character:Switch
   ├─ Server:Character:Delete
   ├─ Server:Character:LoadSkin
   ├─ Server:Character:SaveSkin
   └─ ... etc
```

### Client-Side Events
```
client/[Events]/_character.lua
├─ Stage 1: Menu Opening
│  └─ Client:Character:OpeningMenu
│     └─ Calls: ig.nui.character.ShowSelect()
│
├─ Stage 1B: Character List (Notes only)
│  └─ Client:Character:ReceiveCharacterList [legacy]
│
├─ Stage 2: Selection (Notes only)
│  └─ Centralized in NUI-Client/character-select.lua
│
├─ Stage 3: Creation
│  ├─ Client:Character:Create
│  │  └─ Shows: Appearance customizer
│  └─ RegisterNUICallback("Client:Character:AppearanceComplete")
│
├─ Stage 4: Spawning
│  ├─ Client:Character:ReSpawn
│  ├─ Client:Character:NewSpawn
│  └─ Client:Character:LoadSkin
│
├─ Stage 5: Initialization
│  └─ Client:Character:Loaded
│     └─ State verification → Initialize systems
│
├─ Stage 6: Ready
│  └─ Client:Character:Ready
│     └─ TriggerServerEvent("Server:Character:Ready")
│
└─ Stage 7: Management
   ├─ Client:Character:Pre-Switch
   ├─ Client:Character:Switch
   ├─ Client:Character:OffDuty
   ├─ Client:Character:OnDuty
   ├─ Client:Character:SetJob
   └─ Client:Character:Death
```

### NUI Wrappers (Client → NUI)
```
nui/lua/Client-NUI-Wrappers/_character.lua (NEW)
├─ ig.nui.character.ShowSelect()
│  └─ Sends: "Client:NUI:CharacterSelectShow"
│
├─ ig.nui.character.HideSelect()
│  └─ Sends: "Client:NUI:CharacterSelectHide"
│
├─ ig.nui.character.ShowCreate()
│  └─ Sends: "Client:NUI:AppearanceOpen" {mode: "create"}
│
├─ ig.nui.character.ShowCustomize()
│  └─ Sends: "Client:NUI:AppearanceOpen" {mode: "customize"}
│
└─ ig.nui.character.HideAppearance()
   └─ Sends: "Client:NUI:AppearanceClose"
```

### NUI Callbacks (NUI → Client)
```
nui/lua/NUI-Client/character-select.lua (UPDATED)
├─ RegisterNUICallback("NUI:Client:CharacterPlay")
│  └─ Sends: TriggerServerEvent("Server:Character:Join", ID)
│
├─ RegisterNUICallback("NUI:Client:CharacterDelete")
│  └─ Sends: TriggerServerEvent("Server:Character:Delete", ID)
│
└─ RegisterNUICallback("NUI:Client:CharacterCreate")
   └─ Sends: TriggerServerEvent("Server:Character:Register", ...)
```

---

## Message Flow Diagram

### User Selects Character
```
Client Lua                          NUI Lua
│                                   │
├─ Client:Character:OpeningMenu     │
│  ├─ ig.nui.character.ShowSelect() │
│  │                                │
│  ├─ "Client:NUI:CharacterSelectShow" ──→ NUI Vue
│  │                                │      │
│  │                                │      ├─ CharacterSelect.vue loads
│  │                                │      │  └─ Displays characters
│  │                                │      │
│  │←─ fetch("NUI:Client:CharacterPlay") ─┤
│  │                                │      │
│  ├─ RegisterNUICallback ─────────────────┤
│  │  ("Client:Character:...")             │
│  │  TriggerServerEvent                   │
│  │  ("Server:Character:Join")            │
│  │                                │      │
└──→ Server Lua                      │      │
    (processes character join)       │      │
    ├─ LoadPlayer                   │      │
    ├─ TriggerClientEvent           │      │
    │  ("Client:Character:ReSpawn")  │      │
    └─ SetTimeout(500)              │      │
       └─ TriggerClientEvent        │      │
          ("Client:Character:LoadSkin")    │
```

---

## Implementation Pattern

### To Add a New System (Example: Menu)

**1. Create Wrapper Functions**
```lua
-- nui/lua/Client-NUI-Wrappers/_menu.lua
if not ig.nui then ig.nui = {} end
if not ig.nui.menu then ig.nui.menu = {} end

function ig.nui.menu.Show(title, items)
    ig.ui.Send("Client:NUI:MenuShow", {title = title, items = items}, true)
end

function ig.nui.menu.Hide()
    ig.ui.Send("Client:NUI:MenuHide", {}, false)
end
```

**2. Create Callback Handlers**
```lua
-- nui/lua/NUI-Client/menu.lua
RegisterNUICallback("NUI:Client:MenuSelect", function(data, cb)
    -- NOTE: Receives user selection from Vue
    TriggerServerEvent("Server:Menu:Select", data.index)
    cb({ok = true})
end)
```

**3. Use in Client Code**
```lua
-- client/[something]/_menu.lua
function OpenMenu(title, items)
    -- NOTE: Shows menu via wrapper
    -- Message: "Client:NUI:MenuShow"
    -- Response: NUI:Client:MenuSelect callback
    ig.nui.menu.Show(title, items)
end
```

---

## Naming Conventions Reference

### Client → NUI Messages (Wrappers)
```
Pattern: ig.nui.{system}.{action}()
Sends:   "Client:NUI:{System}:{Action}"

Examples:
  ig.nui.character.ShowSelect()      → "Client:NUI:CharacterSelectShow"
  ig.nui.menu.Show()                 → "Client:NUI:MenuShow"
  ig.nui.chat.AddMessage()           → "Client:NUI:ChatAddMessage"
  ig.nui.inventory.Show()            → "Client:NUI:InventoryShow"
  ig.nui.banking.Show()              → "Client:NUI:BankingOpen"
```

### NUI → Client Callbacks
```
Pattern: RegisterNUICallback("NUI:Client:{System}:{Action}")

Examples:
  NUI:Client:CharacterPlay           (user selected character)
  NUI:Client:MenuSelect              (user selected menu item)
  NUI:Client:ChatSubmit              (user submitted chat)
  NUI:Client:InventoryAction         (user did inventory action)
  NUI:Client:BankingTransaction      (user did banking action)
```

### Server → Client Events
```
Pattern: RegisterNetEvent("Client:{System}:{Action}")

Examples:
  Client:Character:OpeningMenu       (server tells client to open menu)
  Client:Character:ReSpawn           (server tells client to spawn)
  Client:Character:Loaded            (server confirms ped ready)
  Client:Character:Ready             (server confirms all systems ready)
```

### Client → Server Events
```
Pattern: RegisterNetEvent("Server:{System}:{Action}")

Examples:
  Server:Character:Join              (client selects character)
  Server:Character:Register          (client creates character)
  Server:Character:Delete            (client deletes character)
  Server:Character:Loaded            (client confirms ped initialized)
  Server:Character:Ready             (client confirms systems ready)
```

---

## Status Summary

### ✅ Complete (Character System)
- [x] Wrapper functions created
- [x] Callback handlers organized
- [x] Client lifecycle refactored
- [x] No duplicate events
- [x] Documentation complete
- [x] Testing ready

### ⏳ To Do (Other Systems)
- [ ] Menu system (wrapper + callbacks)
- [ ] Chat system (wrapper + callbacks)
- [ ] Inventory (wrapper + callbacks)
- [ ] Banking (wrapper + callbacks)
- [ ] Appearance (wrapper + callbacks)
- [ ] Garage (wrapper + callbacks)
- [ ] Target (wrapper + callbacks)
- [ ] HUD (wrapper + callbacks)
- [ ] Input (wrapper + callbacks)
- [ ] Context (wrapper + callbacks)
- [ ] Notification (wrapper + callbacks)

---

## Quick Lookup

| System | Wrapper Location | Callback Location | Status |
|--------|------------------|-------------------|--------|
| Character | Client-NUI-Wrappers/_character.lua | NUI-Client/character-select.lua | ✅ Done |
| Menu | Client-NUI-Wrappers/_menu.lua | NUI-Client/menu.lua | ⏳ TODO |
| Chat | Client-NUI-Wrappers/_chat.lua | NUI-Client/chat.lua | ⏳ TODO |
| Input | Client-NUI-Wrappers/_input.lua | NUI-Client/input.lua | ⏳ TODO |
| Context | Client-NUI-Wrappers/_context.lua | NUI-Client/context.lua | ⏳ TODO |
| Inventory | Client-NUI-Wrappers/_inventory.lua | NUI-Client/inventory.lua | ⏳ TODO |
| Banking | Client-NUI-Wrappers/_banking.lua | NUI-Client/banking.lua | ⏳ TODO |
| Appearance | Client-NUI-Wrappers/_appearance.lua | NUI-Client/appearance.lua | ⏳ TODO |
| Garage | Client-NUI-Wrappers/_garage.lua | NUI-Client/garage.lua | ⏳ TODO |
| HUD | Client-NUI-Wrappers/_hud.lua | NUI-Client/hud.lua | ⏳ TODO |
| Notification | Client-NUI-Wrappers/_notification.lua | NUI-Client/notification.lua | ⏳ TODO |
| Target | Client-NUI-Wrappers/_target.lua | NUI-Client/target.lua | ⏳ TODO |

---

## Key Files for Testing

### Files to Test
1. `server/[Events]/_character_lifecycle.lua` - Server character handler
2. `client/[Events]/_character.lua` - Client character events
3. `nui/lua/Client-NUI-Wrappers/_character.lua` - Wrapper functions
4. `nui/lua/NUI-Client/character-select.lua` - Callback handlers

### Log What to Look For
```
✅ Character menu opened, awaiting NUI selection
✅ Received X characters from server
✅ Player selected character: ID
✅ Spawning character at saved location
✅ Loading character appearance
✅ Character loaded - initializing systems
✅ State synced in Xms
✅ Character fully ready - initializing gameplay
✅ All systems initialized
```

### Errors to Avoid
```
❌ Duplicate RegisterNUICallback
❌ State sync timeout
❌ Character list undefined
❌ Missing appearance data
❌ Callback mismatch
❌ Hardcoded delays
```

---

*Last Updated: 2026-01-16*  
*Character System: Complete & Ready for Testing*
