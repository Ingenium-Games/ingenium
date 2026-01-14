# NUI ↔ Server Communication Map

Quick reference guide for tracing NUI events to their server handlers.

---

## Character Management Flow

### Play/Join Character

```
┌─────────────────────────────────────────────────────────────────┐
│ NUI FRONTEND (Vue/JS)                                           │
│ User clicks "Play Character" button                            │
│ emit("NUI:Client:CharacterPlay", {ID: "uuid-12345"})          │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ CLIENT SIDE (Lua)                                               │
│ File: nui/lua/character-select.lua                             │
│ RegisterNUICallback("NUI:Client:CharacterPlay", function...)   │
│   ↓                                                             │
│   Validates: data.ID exists ✓                                  │
│   Validates: Player not loaded ✓                               │
│   SetNuiFocus(false, false)                                    │
│   ↓                                                             │
│   TriggerServerCallback({                                      │
│     eventName = "Server:Character:Join",                       │
│     args = {charId},                                           │
│     callback = function(result) ... end                        │
│   })                                                            │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ SERVER SIDE (Lua)                                               │
│ File: server/[Events]/_character.lua                           │
│ ig.callback.RegisterServer("Server:Character:Join", ...)       │
│   ↓                                                             │
│   if charId == "New":                                          │
│     TriggerClientEvent("Client:Character:Create", source)      │
│   else:                                                         │
│     ig.data.LoadPlayer(source, charId)                         │
│     TriggerClientEvent("Client:Character:ReSpawn",             │
│       source, coords)                                          │
│   ↓                                                             │
│   return {success = true, coords = coords}                     │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ CLIENT CALLBACK (Lua)                                           │
│ callback(result) function in character-select.lua              │
│   if result.success then                                       │
│     SetFollowPedCamViewMode(0)                                 │
│     -- Character spawn event will follow                       │
│   else                                                          │
│     print("Failed: " .. result.error)                          │
│   end                                                           │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ CLIENT EVENT HANDLER (Lua)                                      │
│ File: client/[Events]/_character.lua                           │
│ RegisterNetEvent("Client:Character:ReSpawn")                   │
│ AddEventHandler("Client:Character:ReSpawn", function(coords)   │
│   SetEntityCoords(ped, coords.x, coords.y, coords.z)          │
│   SetEntityHeading(ped, coords.h)                              │
│   TriggerServerCallback({                                      │
│     eventName = "Server:Character:LoadSkin",                   │
│     args = {charId},                                           │
│     callback = function(appearance)                            │
│       ig.appearance.SetAppearance(appearance)                  │
│     end                                                         │
│   })                                                            │
│ end)                                                            │
└─────────────────────────────────────────────────────────────────┘
                             ↓
                        ✅ CHARACTER LOADED
```

---

### Delete Character

```
┌─────────────────────────────────────────────────────────────────┐
│ NUI FRONTEND (Vue/JS)                                           │
│ User confirms "Delete Character"                               │
│ emit("NUI:Client:CharacterDelete", {ID: "uuid-12345"})        │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ CLIENT SIDE (Lua)                                               │
│ File: nui/lua/character-select.lua                             │
│ RegisterNUICallback("NUI:Client:CharacterDelete", ...)         │
│   ↓                                                             │
│   Validates: data.ID exists ✓                                  │
│   Validates: Player not loaded ✓                               │
│   SetNuiFocus(false, false)                                    │
│   ↓                                                             │
│   TriggerServerCallback({                                      │
│     eventName = "Server:Character:Delete",                     │
│     args = {charId},                                           │
│     callback = function(result) ... end                        │
│   })                                                            │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ SERVER SIDE (Lua)                                               │
│ File: server/[Events]/_character.lua                           │
│ ig.callback.RegisterServer("Server:Character:Delete", ...)     │
│   ↓                                                             │
│   ig.sql.char.Delete(charId, function()                        │
│     DropPlayer(source, "Character deleted")                    │
│   end)                                                          │
│   ↓                                                             │
│   return {success = true, message = "Deleted"}                 │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ CLIENT CALLBACK (Lua)                                           │
│ callback(result) function in character-select.lua              │
│   if result.success then                                       │
│     -- Character removed from list (handled by NUI)            │
│   else                                                          │
│     print("Failed: " .. result.error)                          │
│   end                                                           │
└─────────────────────────────────────────────────────────────────┘
                             ↓
                        ✅ CHARACTER DELETED
```

---

### Create Character

```
┌─────────────────────────────────────────────────────────────────┐
│ NUI FRONTEND (Vue/JS)                                           │
│ User submits character creation form                           │
│ emit("NUI:Client:CharacterCreate",                             │
│   {First_Name: "John", Last_Name: "Doe"})                     │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ CLIENT SIDE (Lua)                                               │
│ File: nui/lua/character-select.lua                             │
│ RegisterNUICallback("NUI:Client:CharacterCreate", ...)         │
│   ↓                                                             │
│   Validates: Player not loaded ✓                               │
│   Get appearance: ig.appearance.PendingAppearance or           │
│                   ig.appearance.GetAppearance()                │
│   SetNuiFocus(false, false)                                    │
│   SetFollowPedCamViewMode(0)                                   │
│   ↓                                                             │
│   TriggerServerCallback({                                      │
│     eventName = "Server:Character:Register",                   │
│     args = {firstName, lastName, appearance},                  │
│     callback = function(result) ... end                        │
│   })                                                            │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ SERVER SIDE (Lua)                                               │
│ File: server/[Events]/_character.lua                           │
│ ig.callback.RegisterServer("Server:Character:Register", ...)   │
│   ↓                                                             │
│   Validate inputs ✓                                            │
│   Generate: charId, cityId, phoneNum, iban, accountNum         │
│   Save to DB: ig.sql.char.Add(data)                            │
│   Load player: ig.data.LoadPlayer(source, charId)              │
│   Trigger event: TriggerEvent("Server:Character:Spawn")        │
│   Add starting item: give_item("phone")                        │
│   ↓                                                             │
│   return {success = true, character_id = charId}               │
└────────────────────────────┬────────────────────────────────────┘
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│ CLIENT CALLBACK (Lua)                                           │
│ callback(result) function in character-select.lua              │
│   if result.success then                                       │
│     print("Character created: " .. result.character_id)        │
│     -- Character now loaded, appears in world                  │
│   else                                                          │
│     print("Failed: " .. result.error)                          │
│   end                                                           │
└─────────────────────────────────────────────────────────────────┘
                             ↓
                        ✅ CHARACTER CREATED & SPAWNED
```

---

## NUI → Server Event Mapping

### Current (Correct) Implementation

| NUI Callback | Client File | Server Callback | Server Handler | Purpose |
|--------------|-------------|-----------------|----------------|---------|
| `NUI:Client:CharacterPlay` | character-select.lua:3 | `Server:Character:Join` | _character.lua:42 | Play/load character |
| `NUI:Client:CharacterCreate` | character-select.lua:76 | `Server:Character:Register` | _character.lua:88 | Create new character |
| `NUI:Client:CharacterDelete` | character-select.lua:40 | `Server:Character:Delete` | _character.lua:63 | Delete character |

### Request/Response Timing

```
T=0ms   NUI emits event
        ↓
T=5ms   Client callback receives data
        ↓
T=10ms  TriggerServerCallback sent to server
        ↓
T=50ms  Server callback processes request
        ↓
T=100ms Server sends response back
        ↓
T=105ms Client callback function executes
        ↓
T=110ms Character action complete (load/create/delete)
```

---

## Debugging Checklist

### If Character Selection is Broken:

1. **Check callback registration**
   ```lua
   grep "RegisterNUICallback.*Character" nui/lua/*.lua
   -- Should only appear in character-select.lua (3 times)
   -- Should NOT appear in ui.lua
   ```

2. **Verify server callbacks exist**
   ```lua
   grep "Server:Character:Join\|Server:Character:Create\|Server:Character:Delete" server/[Events]/_character.lua
   -- All three should exist
   ```

3. **Check client event handlers**
   ```lua
   grep "RegisterNetEvent.*Character" client/[Events]/_character.lua
   -- Should have: ReSpawn, LoadSkin, SaveSkin, etc.
   ```

4. **Test the flow**
   - Click character in NUI
   - Check client console for logs
   - Check server console for errors
   - Verify character spawns in world

5. **Trace with console logs**
   ```lua
   -- Add debug to character-select.lua NUI callback
   print("^2[NUI] Character play selected: " .. data.ID .. "^0")
   
   -- Add debug to server callback
   print("^3[SERVER] Character:Join called with ID: " .. args[1] .. "^0")
   
   -- Add debug to response callback
   print("^5[CALLBACK] Got response: " .. json.encode(result) .. "^0")
   ```

---

## Common Issues & Solutions

| Issue | Cause | Fix |
|-------|-------|-----|
| "Nothing happens" on character click | Broken NUI callback not reaching server | Check for duplicate callback registration in ui.lua |
| Callback timeout | Server handler doesn't exist | Verify Server:Character:Join handler exists |
| Character doesn't spawn | Event handler missing | Check Client:Character:ReSpawn handler exists |
| Error message shown | Server validation failed | Check server logs for validation errors |
| Player kicked from server | Delete succeeded but message wrong | Check delete callback returns success = false on error |

---

## Key Files Reference

### NUI Files (Character Selection Entry Points)
- [nui/lua/character-select.lua](../../../nui/lua/character-select.lua) - ✅ Correct implementation
- [nui/lua/ui.lua](../../../nui/lua/ui.lua) - ✅ Fixed (legacy removed)

### Client Files (Event Handlers)
- [client/[Events]/_character.lua](../../../client/[Events]/_character.lua) - ✅ Character handlers
- [client/[Callbacks]/_banking.lua](../../../client/[Callbacks]/_banking.lua) - ✅ Banking callbacks

### Server Files (Callback Handlers)
- [server/[Events]/_character.lua](../../../server/[Events]/_character.lua) - ✅ Character server callbacks
- [shared/[Third Party]/_callbacks.lua](../../../shared/[Third%20Party]/_callbacks.lua) - ✅ Callback system

---

**Last Updated**: January 14, 2026  
**Status**: ✅ Event chain working correctly  
**Related**: [NUI_CHARACTER_SELECTION_FIX.md](NUI_CHARACTER_SELECTION_FIX.md)
