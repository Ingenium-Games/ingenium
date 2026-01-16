---
# Client-Side Character Lifecycle Review & Analysis
## Issue #107: Character Loading Architecture

**Date**: 2026-01-16  
**Status**: Analysis Complete  
**Scope**: Client-side character events and joining logic

---

## Current Client-Side Flow (With Issues Identified)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    CLIENT CHARACTER LIFECYCLE (Current)                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  1. client.lua: NetworkIsSessionStarted()                                  │
│     └─> TriggerServerEvent("Server:Queue:ConfirmedPlayer")                 │
│     └─> ig.data.Initialize() → loads items, doors, objects, tattoos      │
│                                                                             │
│  2. [MISSING] Character:OpeningMenu event should fire here                │
│     └─> Currently NO TRIGGER from server to client                        │
│     └─> Should initialize character select camera + UI                    │
│                                                                             │
│  3. Client:Character:OpeningMenu                                           │
│     ├─> ShutdownLoadingScreenNui()                                        │
│     ├─> SetFollowPedCamViewMode(4) - Character select camera             │
│     ├─> Position ped at character select location                         │
│     ├─> FreezeEntityPosition(ped, true)                                   │
│     ├─> TriggerServerEvent("Server:Character:List")                       │
│     │   [ISSUE 1: Callback event, but no callback handler on client]     │
│     │                                                                       │
│     └─> [DEADLOCK] Waiting for Server:Character:List response             │
│                                                                             │
│  4. Client:Character:ReceiveCharacterList                                  │
│     └─> ig.ui.Send("Client:NUI:CharacterSelectShow", ...)                │
│     │   [ISSUE 2: This event NEVER fires - no Server→Client trigger]     │
│     │                                                                       │
│     └─> [DEADLOCK] NUI never receives character list                      │
│                                                                             │
│  5. NUI: Client:Request:CharacterList callback                            │
│     └─> TriggerServerEvent("Server:Character:List") again                │
│     │   [ISSUE 3: Redundant, duplicate request]                          │
│     │                                                                       │
│     └─> [LOOP] Back to step 3                                             │
│                                                                             │
│  6. Player Selects Character (NUI → NUI-Client callback)                 │
│     └─> NUI:Client:CharacterPlay                                         │
│         └─> TriggerServerCallback("Server:Character:Join", ...)           │
│         └─> Server spawns character at coords                             │
│         └─> Server triggers Client:Character:ReSpawn                      │
│                                                                             │
│  7. Client:Character:ReSpawn                                               │
│     ├─> Fade out 1000ms                                                   │
│     ├─> SetFollowPedCamViewMode(0) - Normal camera                       │
│     ├─> SetEntityCoords() to saved position                              │
│     ├─> TriggerServerEvent("Server:Character:LoadSkin")                  │
│     │   [ISSUE 4: Client requests skin, but server doesn't send back]    │
│     │                                                                       │
│     └─> [MISSING] Client:Character:LoadSkin event from server             │
│                                                                             │
│  8. Client:Character:Loaded (manual call or missing?)                      │
│     ├─> ig.func.IsBusyPleaseWait(5000) - Hard 5 sec wait!                │
│     │   [ISSUE 5: Arbitrary hardcoded wait, no state sync check]         │
│     │                                                                       │
│     ├─> ig.data.SetLoadedStatus(true)                                    │
│     ├─> ig.chat.AddSuggestions()                                         │
│     ├─> ig.skill.SetSkills()                                             │
│     ├─> ig.status.SetPlayer()                                            │
│     ├─> ig.modifier.SetModifiers()                                       │
│     └─> TriggerEvent("Client:Character:Ready")                           │
│                                                                             │
│  9. Client:Character:Ready                                                │
│     ├─> exports.spawnmanager:setAutoSpawn(false)                         │
│     ├─> TriggerServerEvent("Server:Character:Ready")                     │
│     ├─> Set RP-specific natives (max wanted, no auto-reload, etc)       │
│     └─> ✓ CHARACTER READY                                                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Issues Identified

### Issue 1: Missing Character List Flow (CRITICAL)
**Problem**: `TriggerServerEvent("Server:Character:List")` is called, but:
- Server-side has `RegisterServerCallback` for "Server:Character:List"
- Client has NO callback handler for the response
- Client only has `RegisterNetEvent("Client:Character:ReceiveCharacterList")` which never fires

**Current**: Event fired but no response received  
**Result**: Character select screen never shows, player stuck

**Root Cause**: 
- Server uses `RegisterServerCallback` (needs response)
- Client uses `TriggerServerEvent` (no callback handler)
- Mismatch between server callback pattern and client event pattern

---

### Issue 2: Server Never Sends Character List to Client
**Problem**: Server has the data but never sends it back to client

**Current Code Flow**:
```lua
-- Server (works as callback)
RegisterServerCallback({
    eventName = "Server:Character:List",
    eventCallback = function(source)
        return { Characters = Characters, Slots = Slots }
    end
})

-- Client (expects event trigger)
RegisterNetEvent("Client:Character:ReceiveCharacterList")
AddEventHandler("Client:Character:ReceiveCharacterList", function(data)
    -- This never fires!
end)
```

**Result**: Data is retrieved on server but never delivered to client

---

### Issue 3: Redundant NUI Callback (UNNECESSARY)
**Problem**: `Client:Request:CharacterList` NUI callback is redundant

**Current**:
```lua
RegisterNUICallback('Client:Request:CharacterList', function(data, cb)
    -- Request character data from server (duplicate of step 3)
    TriggerServerEvent("Server:Character:List")
    cb({ok = true})
end)
```

**Issue**: This fires the SAME request again, creating a loop  
**Result**: Wasted network calls, confusing flow

---

### Issue 4: Character Skin Not Returned from Server
**Problem**: Client requests skin with `TriggerServerEvent("Server:Character:LoadSkin")`

**Current**:
```lua
-- Client
TriggerServerEvent("Server:Character:LoadSkin")

-- Server (no such event!)
RegisterNetEvent("Server:Character:LoadSkin")
-- This event doesn't exist or doesn't send data back
```

**Result**: Client doesn't know when skin is loaded  
**Impact**: Skin may not apply before player becomes visible

---

### Issue 5: Arbitrary 5-Second Wait (BAD UX)
**Problem**: `ig.func.IsBusyPleaseWait(5000)` is hardcoded

```lua
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function()
    ig.func.IsBusyPleaseWait(5000)  -- ← Always 5 seconds!
    ig.data.SetLoadedStatus(true)
    -- ...
end)
```

**Issues**:
- If player already loaded: Forces 5 second delay
- If network slow: 5 seconds not enough
- No state synchronization check

**Better**: Wait for actual state sync instead of arbitrary time

---

### Issue 6: Client:Character:Loaded Never Triggered (MISSING)
**Problem**: There's a handler for `Client:Character:Loaded` but nothing calls it from server

**Current**:
```lua
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function()
    -- This is defined but NEVER triggered from server
end)
```

**Missing from server**: `TriggerClientEvent("Client:Character:Loaded", src)`

**Result**: Initial character setup never runs, player in limbo state

---

## Comparison: What SHOULD Happen (vs Current)

| Step | Current | Should Be |
|------|---------|-----------|
| 1 | `TriggerServerEvent("Server:Character:List")` | Use `TriggerServerCallback` for bidirectional |
| 2 | No callback handler | Server callback returns data → client receives |
| 3 | `RegisterNetEvent("Client:Character:ReceiveCharacterList")` never fires | `TriggerClientEvent("Client:Character:ReceiveCharacterList", src, data)` from server |
| 4 | NUI makes redundant request | NUI receives data from step 3 |
| 5 | `TriggerServerEvent("Server:Character:LoadSkin")` (request) | Server proactively sends skin after spawn |
| 6 | No `Client:Character:LoadSkin` trigger | Server: `TriggerClientEvent("Client:Character:LoadSkin", src, appearance)` |
| 7 | Wait 5 seconds arbitrarily | Wait for `Entity(ped).state.loaded` or callback |
| 8 | `Client:Character:Loaded` undefined | Server must trigger after all data synced |

---

## Missing Server-to-Client Triggers

The server has NO triggers to send data back to client:

```lua
-- ❌ MISSING from server code:
TriggerClientEvent("Client:Character:ReceiveCharacterList", src, {Characters, Slots})
TriggerClientEvent("Client:Character:LoadSkin", src, appearance)
TriggerClientEvent("Client:Character:Loaded", src)
```

---

## Reorganized Client-Side Lifecycle (Proposed)

```lua
-- ═══════════════════════════════════════════════════════════════════════════
-- CLIENT CHARACTER LIFECYCLE (UNIFIED)
-- ═══════════════════════════════════════════════════════════════════════════

-- STAGE 1: Player authenticated, ready for character select
RegisterNetEvent("Client:Character:Initialize")
AddEventHandler("Client:Character:Initialize", function()
    -- Setup character select environment
    local ped = PlayerPedId()
    ig.data.SetLoadedStatus(false)
    FreezeEntityPosition(ped, true)
    SetFollowPedCamViewMode(4)
    SetEntityCoords(ped, -43.14, 822.04, 231.33)
    SetEntityHeading(ped, 288.78)
    SetGameplayCamRelativeRotation(4.03, 0.054, -71.305)
    
    -- Show loading spinner (waiting for character list)
    ig.nui.notification.ShowLoadingSpinner("Loading characters...")
    
    -- Request character list from server
    TriggerServerCallback({
        eventName = "Server:Character:List",
        args = {},
        callback = function(data)
            if data then
                -- Hide spinner
                ig.nui.notification.HideLoadingSpinner()
                -- Show character select with data
                ig.nui.character.ShowSelect(data.characters, data.slots)
            end
        end
    })
end)

-- STAGE 2: Player selected character
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    TriggerServerCallback({
        eventName = "Server:Character:Join",
        args = {data.ID},
        callback = function(result)
            if result.success then
                TriggerEvent("Client:Character:Prepare", result)
            end
        end
    })
    cb({message = "ok"})
end)

-- STAGE 3: Server sends all data and tells client to respawn
RegisterNetEvent("Client:Character:Prepare")
AddEventHandler("Client:Character:Prepare", function(charData)
    -- Fade out
    ig.func.FadeOut(1000)
    
    -- Hide character select UI
    ig.nui.character.HideSelect()
    
    -- Apply appearance
    ig.appearance.SetAppearance(charData.appearance)
    
    -- Position player
    SetFollowPedCamViewMode(0)
    SetEntityCoords(PlayerPedId(), charData.coords.x, charData.coords.y, charData.coords.z)
    SetEntityHeading(PlayerPedId(), charData.coords.h)
    
    -- Freeze (until ready)
    FreezeEntityPosition(PlayerPedId(), true)
    
    -- Signal server: client ready for state sync
    TriggerServerCallback({
        eventName = "Server:Character:ClientReady",
        args = {},
        callback = function(result)
            TriggerEvent("Client:Character:Finalize", result)
        end
    })
end)

-- STAGE 4: All state synced, initialize game
RegisterNetEvent("Client:Character:Finalize")
AddEventHandler("Client:Character:Finalize", function(charData)
    -- Initialize character systems
    ig.data.SetLoadedStatus(true)
    ig.chat.AddSuggestions()
    ig.data.SetLocale()
    ig.skill.SetSkills()
    ig.status.SetPlayer()
    ig.modifier.SetModifiers()
    
    -- Unfreeze player
    FreezeEntityPosition(PlayerPedId(), false)
    
    -- Fade in
    ig.func.FadeIn(2000)
    
    -- Signal ready to server
    TriggerServerEvent("Server:Character:Ready")
end)

-- STAGE 5: Character switch
RegisterNetEvent("Client:Character:Switch")
AddEventHandler("Client:Character:Switch", function()
    ig.data.SetLoadedStatus(false)
    TriggerEvent("Client:Character:Initialize")  -- Start over
end)
```

---

## Summary of Changes Needed

### Server-Side (Already consolidated in `_character_lifecycle.lua`)
✅ Server structure is good, just needs client communication

### Client-Side (Needs Refactor)
- ❌ Remove duplicate `Server:Character:List` call from NUI callback
- ❌ Replace `TriggerServerEvent` with `TriggerServerCallback` for bidirectional communication
- ❌ Add callback handler for character list response
- ❌ Remove arbitrary 5-second wait
- ❌ Add proper state sync waiting (StateBag ready check)
- ❌ Consolidate event names and flows into 4 clear stages
- ❌ Add loading spinner management
- ❌ Add NUI wrapper functions (Client-NUI-Wrappers/)

### NUI-Client Handlers (Keep as-is, just ensure they trigger proper events)
✅ `NUI:Client:CharacterPlay`
✅ `NUI:Client:CharacterDelete`
✅ `NUI:Client:CharacterCreate`

---

## Recommended Next Steps

1. **Update Server** (from consolidated `_character_lifecycle.lua`):
   - Ensure all `TriggerClientEvent` calls are made at right time
   - Add missing client triggers (LoadSkin, Loaded)

2. **Refactor Client Character Events** (`client/[Events]/_character.lua`):
   - Consolidate into 4-stage lifecycle
   - Replace events with callbacks where needed
   - Remove redundancy

3. **Create Client-NUI Wrappers** (`nui/lua/Client-NUI-Wrappers/`):
   - `ig.nui.character.ShowSelect()`
   - `ig.nui.character.HideSelect()`
   - Loading spinner functions

4. **Test End-to-End**:
   - Character selection
   - Character join
   - Appearance loading
   - Ready state

---

**Priority**: HIGH  
**Complexity**: MEDIUM  
**Time Estimate**: 3-4 hours
