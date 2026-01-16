---
# Character Lifecycle: Server vs Client Comparison
## Issue #107: Complete Architecture Review

**Date**: 2026-01-16  
**Analysis**: Full stack comparison identifying disconnects

---

## Architecture Mismatch Overview

```
┌──────────────────────────────────────┐    ┌──────────────────────────────────────┐
│        SERVER-SIDE (Consolidated)    │    │        CLIENT-SIDE (Broken)          │
├──────────────────────────────────────┤    ├──────────────────────────────────────┤
│ ✅ Clear 6-stage lifecycle            │    │ ❌ Chaotic multi-event chains        │
│ ✅ Event names organized              │    │ ❌ Missing communication               │
│ ✅ Data loading logic sound           │    │ ❌ Callback mismatches                │
│ ✅ Job/ACL management clear           │    │ ❌ Redundant NUI requests             │
│ ✅ State synchronization planned      │    │ ❌ No state sync verification         │
│                                       │    │ ❌ Hardcoded delays                   │
│ But: Doesn't send data back to client │    │ But: Ready to receive IF server sent │
└──────────────────────────────────────┘    └──────────────────────────────────────┘
```

---

## Flow Comparison: What Server Does vs What Client Expects

### Step 1: Character List Request

**Server Does** (in `_character_lifecycle.lua`):
```lua
RegisterServerCallback({
    eventName = "Server:Character:List",
    eventCallback = function(source)
        local src = tonumber(source)
        local Primary_ID = ig.func.identifier(src)
        local Slots = ig.sql.user.GetSlots(Primary_ID)
        local Characters = ig.sql.char.GetAllPermited(Primary_ID, Slots)
        ig.inst.SetPlayer(src)
        
        -- ✅ Callback returns data
        return {
            Characters = Characters,
            Slots = Slots
        }
    end
})
```

**Client Expects** (in `client/[Events]/_character.lua`):
```lua
-- ❌ WRONG: This fires an event, not a callback
RegisterNetEvent("Client:Character:OpeningMenu")
AddEventHandler("Client:Character:OpeningMenu", function()
    -- ...setup camera...
    
    -- ❌ WRONG: Uses TriggerServerEvent (no callback handler)
    TriggerServerEvent("Server:Character:List")
end)

-- ❌ This event never fires (server never triggers it)
RegisterNetEvent("Client:Character:ReceiveCharacterList")
AddEventHandler("Client:Character:ReceiveCharacterList", function(data)
    -- Never called!
end)
```

**Result**: 🔴 MISMATCH - Server returns data but has no way to send it to client

---

### Step 2: Character Join

**Server Does**:
```lua
RegisterNetEvent("Server:Character:Join")
AddEventHandler("Server:Character:Join", function(Character_ID)
    local src = source
    if Character_ID == "New" then
        TriggerClientEvent("Client:Character:Create", src)
    elseif Character_ID ~= nil then
        local Coords = ig.sql.char.GetCoords(Character_ID)
        ig.data.LoadPlayer(src, Character_ID)
        TriggerClientEvent("Client:Character:ReSpawn", src, Coords)
    end
end)
```

**Client Expects** (from NUI):
```lua
-- In nui/lua/NUI-Client/character-select.lua:
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    if not ig.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        TriggerServerCallback({
            eventName = "Server:Character:Join",
            args = {data.ID},
            callback = function(result)
                -- ✅ This expects a callback response
                if result and result.success then
                    SetFollowPedCamViewMode(0)
                end
            end
        })
        cb({message = "ok", data = nil})
    end
end)
```

**Problem**: 
- Server uses `TriggerClientEvent()` not `RegisterServerCallback()`
- NUI expects `TriggerServerCallback()` 
- Server sends client events but NUI doesn't wait for them

**Result**: 🟡 PARTIAL - Works but not elegant, callback pattern inconsistent

---

### Step 3: Respawn After Join

**Server Does**:
```lua
elseif Character_ID ~= nil then
    local Coords = ig.sql.char.GetCoords(Character_ID)
    ig.data.LoadPlayer(src, Character_ID)
    TriggerClientEvent("Client:Character:ReSpawn", src, Coords)
end
```

**Client Expects**:
```lua
RegisterNetEvent("Client:Character:ReSpawn")
AddEventHandler("Client:Character:ReSpawn", function(Coords)
    ig.func.FadeOut(1000)
    SetFollowPedCamViewMode(0)
    SetEntityCoords(GetPlayerPed(-1), Coords.x, Coords.y, Coords.z)
    SetEntityHeading(GetPlayerPed(-1), Coords.h)
    
    -- ❌ Client requests skin from server...
    TriggerServerEvent("Server:Character:LoadSkin")
    -- ...but server never sends it back!
    
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    ig.ui.Send("Client:NUI:CharacterSelectHide", {}, false)
    ig.func.FadeIn(2000)
end)
```

**Issue**: 
- Client calls `TriggerServerEvent("Server:Character:LoadSkin")`
- Server event exists but doesn't send appearance back
- Client never receives `Client:Character:LoadSkin` event

**Result**: 🔴 BROKEN - Skin not applied before player visible

---

### Step 4: Loaded & Ready

**Server Does**:
```lua
RegisterNetEvent("Server:Character:Loaded")
AddEventHandler("Server:Character:Loaded", function()
    local src = source
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return end
    
    -- Set ped config flags
    local pedFlags = {42, 155, 156, 157, 430, 434}
    for _, flag in ipairs(pedFlags) do
        SetPedConfigFlag(ped, flag, false)
    end
end)

RegisterNetEvent("Server:Character:Ready")
AddEventHandler("Server:Character:Ready", function()
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    if not xPlayer then return end
    
    ig.inst.SetPlayer(src, xPlayer.GetInstance())
    ExecuteCommand(("remove_principal identifier.%s job.%s"):format(
        xPlayer.GetIdentifier(), xPlayer.GetJob().Name))
    local job = xPlayer.GetJob()
    xPlayer.SetJob(job.Name, job.Grade)
    xPlayer.GetCash()
    xPlayer.GetBank()
end)
```

**Client Expects**:
```lua
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function()
    ig.func.IsBusyPleaseWait(5000)  -- ❌ Arbitrary hardcoded wait!
    
    ig.data.SetLoadedStatus(true)
    ig.chat.AddSuggestions()
    ig.data.SetLocale()
    ig.skill.SetSkills()
    ig.status.SetPlayer()
    ig.modifier.SetModifiers()
    
    TriggerEvent("Client:Character:Ready")
end)

RegisterNetEvent("Client:Character:Ready")
AddEventHandler("Client:Character:Ready", function()
    exports.spawnmanager:setAutoSpawn(false)
    TriggerServerEvent("Server:Character:Ready")
    
    if conf.gamemode == "RP" then
        -- Set RP natives
    end
end)
```

**Issues**:
- Client waits 5 seconds with NO state verification
- `Client:Character:Loaded` is never triggered by server
- Client can't detect when StateBags are synchronized
- Client doesn't know when server has finished setup

**Result**: 🔴 BROKEN - Race condition, arbitrary timing

---

## Event Sequence: Expected vs Actual

### Expected Flow (What Should Happen)

```
Time  Server                          Client/NUI                Network
─────────────────────────────────────────────────────────────────────────
 0.0  PlayerConnecting               
 0.5                                 → Server:Character:List (callback)
 1.0  ← Retrieve data from DB
 1.5  ↓ Return {Characters, Slots}
 2.0                                 ← Receive response
 2.5                                 Show character select NUI
 3.0  (Player selects character)
 3.5  NUI:Client:CharacterPlay       → TriggerServerCallback
 4.0  ← Server:Character:Join
 4.5  Load player from DB
 5.0  ig.data.LoadPlayer() → StateBags sync
 5.5  → Client:Character:ReSpawn {Coords}
 6.0                                 ← Receive coords
 6.5                                 Position ped, fade out
 7.0  → Client:Character:LoadSkin {Appearance}
 7.5                                 ← Receive appearance
 8.0                                 Apply appearance
 8.5  → Client:Character:Loaded
 9.0                                 ← Start initialization
 9.5                                 Wait for StateBag sync...
10.0                                 (State synced via ig.data)
10.5  → Client:Character:Ready
11.0                                 ← Finalize setup
11.5  Trigger Server:Character:Ready
12.0  Set job ACL, instance, etc
12.5  ✓ CHARACTER FULLY LOADED
```

### Actual Flow (What's Happening)

```
Time  Server                          Client/NUI                Status
────────────────────────────────────────────────────────────────────────
 0.0  PlayerConnecting               
 0.5                                 NetworkIsSessionStarted
 1.0                                 → Server:Queue:ConfirmedPlayer
 1.5  [Process queue]
 2.0                                 [Queue check]
 2.5                                 Client:Character:OpeningMenu (WHERE?)
 3.0  ❌ NO TRIGGER from server        Setup camera
 3.5  [Waiting]                       → TriggerServerEvent("Server:Character:List")
 4.0  RegisterServerCallback received (expects callback)
 4.5  ← Return {Characters, Slots}   ❌ Client has no callback handler!
 5.0  [Dead data - nowhere to go]     [Waiting for event]
 5.5  [Timeout]                       Still waiting...
 6.0                                  NUI Callback: Client:Request:CharacterList
 6.5                                  → TriggerServerEvent("Server:Character:List") (AGAIN)
 7.0  [Duplicate request]
 7.5                                  ❌ STUCK - No response delivered
 8.0  [Player frustrated]             [Nothing shows up]
 9.0                                  ✗ CHARACTER SELECT NEVER APPEARS
```

---

## Critical Disconnects

| # | Issue | Server | Client | Impact | Severity |
|---|-------|--------|--------|--------|----------|
| 1 | Character list not delivered | `RegisterServerCallback` returns data | `TriggerServerEvent` expects event | Character select stuck | 🔴 CRITICAL |
| 2 | No trigger for OpeningMenu | Not triggered | Expects client event | Menu never shows | 🔴 CRITICAL |
| 3 | Skin not sent to client | Doesn't trigger event | Requests then waits | Appearance not applied | 🔴 CRITICAL |
| 4 | Client:Loaded never called | Not triggered | Handler exists but unused | Initialization never runs | 🔴 CRITICAL |
| 5 | Hardcoded 5-sec wait | N/A | Fixed delay, no verification | Race condition, bad UX | 🟠 HIGH |
| 6 | Duplicate NUI request | Receives twice | Sends twice | Wasted network, confusion | 🟡 MEDIUM |
| 7 | No state sync check | Sets data | Doesn't verify | Data may not be ready | 🟡 MEDIUM |
| 8 | Job setup race condition | Server sets job after Ready | Client doesn't wait | Job may not sync | 🟡 MEDIUM |

---

## What Needs to Happen

### 1. Server Must Send Character List to Client
```lua
-- In Server:Character:List callback:
local data = {Characters = Characters, Slots = Slots}

-- Option A: Use callback (NUI callback converts to callback)
-- Option B: Send via event (more direct)
TriggerClientEvent("Client:Character:ReceiveCharacterList", src, data)
```

### 2. Server Must Trigger Character Initialize on Client
```lua
-- After queue confirmed, before character menu:
TriggerClientEvent("Client:Character:Initialize", src)
```

### 3. Server Must Send Skin After Respawn
```lua
-- In Server:Character:Join after spawn:
local appearance = xPlayer.GetAppearance()
TriggerClientEvent("Client:Character:LoadSkin", src, appearance)
```

### 4. Server Must Trigger Loaded After State Sync
```lua
-- After ig.data.LoadPlayer() returns:
TriggerClientEvent("Client:Character:Loaded", src)
```

### 5. Client Must Use Callbacks Instead of Events
```lua
-- Replace event-based requests with callbacks:
TriggerServerCallback({
    eventName = "Server:Character:List",
    args = {},
    callback = function(data)
        -- Handle response
    end
})
```

### 6. Client Must Wait for State Sync, Not Time
```lua
-- Replace:
ig.func.IsBusyPleaseWait(5000)

-- With:
-- Wait for Entity(ped).state properties to sync
while not Entity(PlayerPedId()).state.Character_ID do
    Wait(50)
end
```

---

## Consolidated Architecture (Both Sides)

### Server Side ✅ (Already Done in _character_lifecycle.lua)
- 6 clear stages
- Event names organized
- Data flow documented
- **Just needs**: Client event triggers added

### Client Side ❌ (Needs Refactor)
- Consolidate into 4 stages (Initialize → Prepare → Finalize → Switch)
- Replace events with callbacks where needed
- Remove redundancy
- Add state sync verification
- Create NUI wrapper functions

### NUI Side 
- Use wrapper functions instead of direct SendNUIMessage
- Keep callback handlers simple
- Trust client to manage flow

---

## Summary: The Gap

| Area | Server | Client | Gap |
|------|--------|--------|-----|
| **Architecture** | ✅ Clear, organized | ❌ Chaotic | Server is clean, client broken |
| **Data Flow** | ✅ Planned | ❌ Missing critical triggers | Data retrieved but not sent |
| **Communication** | ✅ Events exist | ❌ No handlers | Events fire into void |
| **State Management** | ✅ Planned | ❌ Arbitrary timing | No verification |
| **Documentation** | ✅ Good comments | ❌ Confusing flow | Server documented, client is mess |

**Conclusion**: Server is 80% ready. Client needs heavy refactor to match and complete the picture.

---

**Next Actions**:
1. Review this analysis
2. Approve changes before implementation
3. Update server with missing client events
4. Refactor client to match server structure
5. Create NUI wrappers
6. Test end-to-end

**Owner**: Development Team  
**Timeline**: 4-6 hours for full fix  
**Complexity**: Medium
