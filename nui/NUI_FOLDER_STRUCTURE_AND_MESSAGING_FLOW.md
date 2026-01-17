---
# NUI Folder Structure: Client-NUI-Wrappers & NUI-Client
## Clarification of Message Flow and File Organization

**Date**: 2026-01-16  
**Status**: ✅ Implemented  
**Scope**: Character system (Phase 1), other systems to follow

---

## Architecture Overview

The NUI system is split into two distinct folders:

```
nui/lua/
├── Client-NUI-Wrappers/        ← CLIENT INITIATES (Lua sends TO NUI)
│   └── _character.lua          ← Wrapper functions like ig.nui.character.ShowSelect()
│
└── NUI-Client/                 ← NUI RESPONDS (Callbacks FROM NUI TO Lua)
    └── character-select.lua    ← RegisterNUICallback handlers
```

---

## Client → NUI Flow (Client-NUI-Wrappers)

### Purpose
These are **wrapper functions** that Lua calls to send messages to the NUI (Vue.js) interface.

### Location
`nui/lua/Client-NUI-Wrappers/_character.lua`

### Functions
```lua
ig.nui.character.ShowSelect()       -- Shows character selection screen
ig.nui.character.HideSelect()       -- Hides character selection screen
ig.nui.character.ShowCreate()       -- Shows appearance customizer (create mode)
ig.nui.character.ShowCustomize()    -- Shows appearance customizer (edit mode)
ig.nui.character.HideAppearance()   -- Hides appearance customizer
```

### Actual Messages Sent
```lua
"Client:NUI:CharacterSelectShow"   -- ShowSelect()
"Client:NUI:CharacterSelectHide"   -- HideSelect()
"Client:NUI:AppearanceOpen"        -- ShowCreate()/ShowCustomize()
"Client:NUI:AppearanceClose"       -- HideAppearance()
```

### How Called
```lua
-- From client/[Events]/_character.lua
RegisterNetEvent("Client:Character:OpeningMenu")
AddEventHandler("Client:Character:OpeningMenu", function()
    -- Use wrapper function to show select
    ig.nui.character.ShowSelect()  -- Sends "Client:NUI:CharacterSelectShow" to NUI
end)
```

### Where They Send
These functions call `ig.ui.Send("Client:NUI:*", data, nui_focus)` which sends messages to `nui/src/utils/nui.js` → `handleMessage()` switch case

---

## NUI → Client Flow (NUI-Client)

### Purpose
These are **callback handlers** that process responses FROM the NUI when the user interacts with the interface.

### Location
`nui/lua/NUI-Client/character-select.lua`

### Handlers
```lua
RegisterNUICallback("NUI:Client:CharacterPlay", ...)     -- User selected character
RegisterNUICallback("NUI:Client:CharacterDelete", ...)   -- User deleted character
RegisterNUICallback("NUI:Client:CharacterCreate", ...)   -- User confirmed creation
```

### What They Do
When NUI detects user action (click select, click delete, confirm create), it sends:
```javascript
// From Vue component
fetch(`https://${GetParentResourceName()}/NUI:Client:CharacterPlay`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
})
```

This is received by the `RegisterNUICallback` handlers, which then:
1. Validate the data
2. Call `TriggerServerEvent("Server:Character:Join", data.ID)` or similar

### Who Calls Them
The Vue.js component in `nui/src/components/CharacterSelect.vue` calls these when the user interacts with buttons/selections

---

## Complete Flow Example

### User Selects a Character

```
┌─ Client Lua (client/[Events]/_character.lua)
│   RegisterNetEvent("Client:Character:OpeningMenu")
│   └─> ig.nui.character.ShowSelect()
│       ↓ (uses wrapper from Client-NUI-Wrappers/_character.lua)
│       ↓ ig.ui.Send("Client:NUI:CharacterSelectShow", {}, true)
│
├─ NUI JavaScript (nui/src/utils/nui.js)
│   └─> handleMessage() case "Client:NUI:CharacterSelectShow"
│       ↓ uiStore.openCharacterSelect()
│
├─ Vue Component (nui/src/components/CharacterSelect.vue)
│   └─> User clicks "Play Character"
│       ↓ fetch("NUI:Client:CharacterPlay", {data.ID})
│
├─ NUI-Client Lua (nui/lua/NUI-Client/character-select.lua)
│   RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
│   ├─> Validates player not already loaded
│   ├─> SetNuiFocus(false, false)
│   └─> TriggerServerEvent("Server:Character:Join", data.ID)
│       ↓
│
└─ Server Lua (server/[Events]/_character_lifecycle.lua)
    RegisterNetEvent("Server:Character:Join")
    ├─> ig.data.LoadPlayer(src, Character_ID)
    ├─> TriggerClientEvent("Client:Character:ReSpawn", src, Coords)
    └─> SetTimeout(500)
        └─> TriggerClientEvent("Client:Character:LoadSkin", src, appearance)
```

---

## Naming Convention

### Wrapper Functions (Client-NUI-Wrappers)
```lua
ig.nui.{system}.{action}()

Examples:
ig.nui.character.ShowSelect()
ig.nui.menu.Show(title, items)
ig.nui.chat.AddMessage(msg, author)
ig.nui.inventory.Show(inventory)
```

### Messages (Client → NUI)
```lua
"Client:NUI:{System}:{Action}"

Examples:
"Client:NUI:CharacterSelectShow"
"Client:NUI:MenuShow"
"Client:NUI:ChatAddMessage"
```

### Callbacks (NUI → Client)
```lua
"NUI:Client:{System}:{Action}"

Examples:
"NUI:Client:CharacterPlay"
"NUI:Client:MenuSelect"
"NUI:Client:ChatSubmit"
```

### Event Handlers (Client ← Server)
```lua
"Client:{System}:{Action}"

Examples:
"Client:Character:OpeningMenu"
"Client:Character:ReSpawn"
"Client:Character:Loaded"
```

### Server Event Handlers (Server ← Client)
```lua
"Server:{System}:{Action}"

Examples:
"Server:Character:Join"
"Server:Character:Register"
"Server:Character:Loaded"
```

---

## Prevention of Duplicate Handlers

### ✅ CORRECT Structure
```
client/[Events]/_character.lua
├─ RegisterNetEvent("Client:Character:*")  ← Receive FROM server
├─ ig.nui.character.*() calls             ← Call wrapper functions
└─ RegisterNUICallback("Client:Character:AppearanceComplete") ← NUI response specific to character creation

nui/lua/Client-NUI-Wrappers/_character.lua
└─ ig.nui.character.ShowSelect()          ← Send TO Nui

nui/lua/NUI-Client/character-select.lua
└─ RegisterNUICallback("NUI:Client:Character*") ← Respond to NUI
```

### ❌ WRONG Structure (What We Fixed)
```
client/[Events]/_character.lua
├─ RegisterNUICallback("Client:Request:OnJoinGetCharactersFromServer") ← DUPLICATE
├─ RegisterNUICallback('Client:Character:Select')     ← DUPLICATE
├─ RegisterNUICallback('Client:Character:CreateNew')  ← DUPLICATE
├─ RegisterNUICallback('Client:Character:Delete')     ← DUPLICATE
└─ ig.ui.Send("Client:NUI:CharacterSelectShow")

nui/lua/NUI-Client/character-select.lua
└─ RegisterNUICallback("NUI:Client:Character*")       ← DIFFERENT callbacks
```

---

## Key Rules

1. **Client-NUI-Wrappers are functions, not handlers**
   - They should only contain wrapper functions
   - No RegisterNUICallback or RegisterNetEvent in this folder
   - All wrappers call `ig.ui.Send()` to send messages

2. **NUI-Client contains only callbacks**
   - RegisterNUICallback only
   - Processes responses from NUI
   - Sends events to server

3. **Client Events handle server communication**
   - RegisterNetEvent for server → client messages
   - TriggerServerEvent for client → server messages
   - Call wrapper functions to update NUI
   - Minimal NUI callback duplication (only specific actions like AppearanceComplete)

4. **No Duplicate Callbacks**
   - If a handler exists in NUI-Client, don't create duplicate in client Events
   - Reference in comments instead of duplicating code
   - Use wrapper functions to trigger NUI updates

---

## Current Implementation Status

### ✅ Implemented
- Client-NUI-Wrappers/_character.lua (wrapper functions)
- NUI-Client/character-select.lua (callback handlers - updated)
- client/[Events]/_character.lua (refactored, no duplicates)

### Notes Added (Not Duplicated)
- Character lifecycle references wrapper function usage
- Flow documented with notes showing exact message names
- NUI callbacks referenced but not duplicated in client code

---

## Next Steps: Other Systems

When implementing other systems, follow this pattern:

```
nui/lua/Client-NUI-Wrappers/
├── _character.lua       ✅ Done
├── _menu.lua            [ ] TODO
├── _input.lua           [ ] TODO
├── _context.lua         [ ] TODO
├── _chat.lua            [ ] TODO
├── _notification.lua    [ ] TODO
├── _banking.lua         [ ] TODO
├── _inventory.lua       [ ] TODO
├── _appearance.lua      [ ] TODO
├── _garage.lua          [ ] TODO
└── _target.lua          [ ] TODO

nui/lua/NUI-Client/
├── character-select.lua ✅ Done
├── menu.lua             [ ] TODO (consolidate handlers)
├── input.lua            [ ] TODO
├── context.lua          [ ] TODO
├── chat.lua             [ ] TODO
├── notification.lua     [ ] TODO
├── banking.lua          [ ] TODO
├── inventory.lua        [ ] TODO
├── appearance.lua       [ ] TODO
├── garage.lua           [ ] TODO
└── target.lua           [ ] TODO
```

---

## References

- [CHARACTER_CONNECTION_FIXES.md](../Documentation/CHARACTER_CONNECTION_FIXES.md) - What was fixed
- [NUI_MESSAGE_PROTOCOL_REFERENCE.md](./NUI_MESSAGE_PROTOCOL_REFERENCE.md) - Complete message reference
- [NUI_IMPLEMENTATION_STATUS.md](./NUI_IMPLEMENTATION_STATUS.md) - Overall implementation status

---

**Status**: ✅ COMPLETE FOR CHARACTER SYSTEM  
**Testing**: Ready  
**Next**: Implement other systems following same pattern
