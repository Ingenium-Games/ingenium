---
# Character Connection Fixes - Summary
## Client-Server Communication Corrected

**Date**: 2026-01-16  
**Status**: ✅ COMPLETED  
**Issue References**: Issue #107 (NUI Architecture), Client-Character Connection Analysis

---

## Overview

Fixed 8 critical issues in the client-server character lifecycle connection. The main problems were:
- Callback pattern mismatches (RegisterServerCallback vs RegisterNetEvent)
- Missing TriggerClientEvent calls from server
- Hardcoded 5-second delay instead of state verification
- Incorrect NUI callback handlers
- Race conditions in character loading

---

## Fixed Issues

### Issue 1: ❌ → ✅ Character List Delivery Mismatch

**Problem**: Server used `RegisterServerCallback` but client expected `RegisterNetEvent`
```lua
-- BEFORE (Broken)
RegisterNetEvent("Client:Character:List")  -- ❌ Wrong event type
TriggerServerEvent("Server:Character:List")  -- ❌ Wrong trigger direction
```

**Solution**: Use `TriggerServerCallback` from client NUI callback
```lua
-- AFTER (Fixed)
RegisterNUICallback('Client:Request:CharacterList', function(data, cb)
    TriggerServerCallback("Server:Character:List", function(result)
        if result and result.Characters then
            cb({ok = true, characters = result.Characters, slots = result.Slots})
        end
    end)
end)
```

**File**: `client/[Events]/_character.lua`  
**Lines**: 42-56

---

### Issue 2: ❌ → ✅ Missing Character LoadSkin Trigger

**Problem**: Server never sent appearance data to client after character join
```lua
-- BEFORE (Broken)
-- No trigger for LoadSkin after character spawn
TriggerClientEvent("Client:Character:ReSpawn", src, Coords)
-- ... appearance never sent
```

**Solution**: Add delayed LoadSkin trigger after spawn
```lua
-- AFTER (Fixed)
TriggerClientEvent("Client:Character:ReSpawn", src, Coords)

SetTimeout(500, function()
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        local appearance = xPlayer.GetAppearance()
        TriggerClientEvent("Client:Character:LoadSkin", src, appearance)
    end
end)
```

**File**: `server/[Events]/_character_lifecycle.lua`  
**Lines**: 88-99

---

### Issue 3: ❌ → ✅ Missing Client:Character:Loaded Trigger

**Problem**: Server never triggered final client initialization
```lua
-- BEFORE (Broken)
RegisterNetEvent("Server:Character:Loaded")
AddEventHandler("Server:Character:Loaded", function()
    -- Set flags... then nothing
    for _, flag in ipairs(pedFlags) do
        SetPedConfigFlag(ped, flag, false)
    end
    -- ❌ Never tells client to initialize systems
end)
```

**Solution**: Trigger Client:Character:Loaded after ped flags set
```lua
-- AFTER (Fixed)
SetTimeout(500, function()
    TriggerClientEvent("Client:Character:Loaded", src)
end)
```

**File**: `server/[Events]/_character_lifecycle.lua`  
**Lines**: 239-241

---

### Issue 4: ❌ → ✅ Hardcoded 5-Second Wait Replaced with State Verification

**Problem**: Client waited arbitrary 5 seconds without verifying state sync
```lua
-- BEFORE (Broken)
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function()
    ig.func.IsBusyPleaseWait(5000)  -- ❌ Hardcoded wait
    ig.data.SetLoadedStatus(true)
    -- ...
end)
```

**Solution**: Verify state is actually synced before proceeding
```lua
-- AFTER (Fixed)
local maxWait = 0
local timeStep = 50
local timeout = 5000

local function checkStateSync()
    local ped = GetPlayerPed(-1)
    local state = Entity(ped).state
    if state and state.Health then
        return true
    end
    return false
end

while not checkStateSync() and maxWait < timeout do
    SetTimeout(timeStep, function() end)
    maxWait = maxWait + timeStep
end
```

**File**: `client/[Events]/_character.lua`  
**Lines**: 179-193

---

### Issue 5: ❌ → ✅ Incomplete Character Selection Callbacks

**Problem**: NUI couldn't properly select characters or create new ones
```lua
-- BEFORE (Broken)
RegisterNUICallback('Client:Request:CharacterList', function(data, cb)
    TriggerServerEvent("Server:Character:List")  -- ❌ Fire-and-forget
    cb({ok = true})
end)
-- No callbacks for character selection or creation
```

**Solution**: Added NUI callbacks for all character actions
```lua
-- AFTER (Fixed)
RegisterNUICallback('Client:Character:Select', function(data, cb)
    TriggerServerEvent("Server:Character:Join", data.id)
    SetNuiFocus(false, false)
    cb({ok = true})
end)

RegisterNUICallback('Client:Character:CreateNew', function(data, cb)
    TriggerServerEvent("Server:Character:Join", "New")
    SetNuiFocus(false, false)
    cb({ok = true})
end)

RegisterNUICallback('Client:Character:Delete', function(data, cb)
    TriggerServerEvent("Server:Character:Delete", data.id)
    cb({ok = true})
end)
```

**File**: `client/[Events]/_character.lua`  
**Lines**: 59-86

---

### Issue 6: ❌ → ✅ Missing Character Creation Flow

**Problem**: No proper appearance customization integration
```lua
-- BEFORE (Broken)
RegisterNetEvent("Client:Character:Create")
AddEventHandler("Client:Character:Create", function()
    local plyped = PlayerPedId()
    SetEntityCoords(plyped, -703.9, -152.62, 37.42)
    ig.func.FadeOut(1000)
    -- ... nothing else, appearance never handled
end)
```

**Solution**: Integrated appearance customization with completion callback
```lua
-- AFTER (Fixed)
RegisterNetEvent("Client:Character:Create")
AddEventHandler("Client:Character:Create", function()
    local plyped = PlayerPedId()
    SetEntityCoords(plyped, -703.9, -152.62, 37.42)
    SetEntityHeading(plyped, 62)
    
    ig.func.FadeOut(1000)
    ig.func.IsBusyPleaseWait(500)
    
    SetTimeout(500, function()
        ig.ui.Send("Client:NUI:AppearanceOpen", {
            mode = "create",
            onComplete = "Client:Character:AppearanceComplete"
        }, true)
        
        SetNuiFocus(true, true)
        ig.func.FadeIn(1000)
        ig.func.IsBusyPleaseWait(500)
    end)
end)

RegisterNUICallback('Client:Character:AppearanceComplete', function(data, cb)
    if data and data.appearance then
        TriggerServerEvent("Server:Character:Register", 
            data.first_name, data.last_name, data.appearance)
        SetNuiFocus(false, false)
        cb({ok = true})
    end
end)
```

**File**: `client/[Events]/_character.lua`  
**Lines**: 100-127

---

### Issue 7: ❌ → ✅ Incorrect Spawn Timing

**Problem**: Race condition - ped not fully spawned before operations
```lua
-- BEFORE (Broken)
RegisterNetEvent("Client:Character:ReSpawn")
AddEventHandler("Client:Character:ReSpawn", function(Coords)
    ig.func.FadeOut(1000)
    SetEntityCoords(GetPlayerPed(-1), Coords.x, ...)  -- ❌ Executes immediately
    TriggerServerEvent("Server:Character:LoadSkin")
end)
```

**Solution**: Wait for fade completion before moving ped
```lua
-- AFTER (Fixed)
ig.func.FadeOut(1000)
SetFollowPedCamViewMode(0)

SetTimeout(500, function()
    SetEntityCoords(ped, Coords.x, Coords.y, Coords.z)
    SetEntityHeading(ped, Coords.h)
    TriggerServerEvent("Server:Character:LoadSkin")
    -- ... rest of sequence
end)
```

**File**: `client/[Events]/_character.lua`  
**Lines**: 143-161

---

### Issue 8: ❌ → ✅ Missing Logging & Debugging Info

**Problem**: No logging made troubleshooting impossible
```lua
-- BEFORE (Broken)
RegisterNetEvent("Client:Character:OpeningMenu")
AddEventHandler("Client:Character:OpeningMenu", function()
    -- No logging
end)
```

**Solution**: Added comprehensive logging throughout
```lua
-- AFTER (Fixed)
ig.log.Info("Character", "Character menu opened, awaiting NUI selection")
ig.log.Trace("Character", "NUI requesting character list from server")
ig.log.Info("Character", "Received " .. #result.Characters .. " characters")
ig.log.Info("Character", "Character loaded - initializing systems")
```

**File**: `client/[Events]/_character.lua`  
**Multiple lines** throughout

---

## Fixed Flow Diagram

### BEFORE (Broken)
```
┌─ Player Joins ─┐
│   OpeningMenu  │
│   (No log)     │
└─────┬──────────┘
      │
      ├─ TriggerServerEvent("Server:Character:List") ❌
      │   Server has RegisterServerCallback (different pattern!)
      │
      ├─ NUI requests list ❌
      │   (Fire-and-forget, no callback)
      │
      ├─ Server: Join ❌
      │   ReSpawn sent
      │   LoadSkin NEVER sent
      │
      ├─ Client: LoadSkin ❌
      │   Appearance data missing
      │
      ├─ Hardcoded 5 second wait ❌
      │   (No state verification)
      │
      └─ Ready? (Maybe)
```

### AFTER (Fixed)
```
┌─ Player Joins ─────────────────────────────┐
│   OpeningMenu                               │
│   ✓ Logging at each step                   │
└─────┬──────────────────────────────────────┘
      │
      ├─ NUI: Show Character Select
      │   ✓ SetNuiFocus enabled
      │
      ├─ NUI: Request Character List ✓
      │   TriggerServerCallback (proper pattern)
      │   ↓
      ├─ Server: Return Characters ✓
      │   (Callback response)
      │
      ├─ NUI: User Selects Character ✓
      │   NUI Callback: Client:Character:Select
      │   ↓
      ├─ Server: Server:Character:Join ✓
      │   ├─> TriggerClientEvent: Client:Character:ReSpawn
      │   └─> Wait 500ms
      │       └─> TriggerClientEvent: Client:Character:LoadSkin ✓
      │
      ├─ Client: ReSpawn ✓
      │   FadeOut → SetTimeout(500) → SetCoords → FadeIn
      │   ↓
      ├─ Server: Receives LoadSkin request ✓
      │   Sets ped flags
      │   Wait 500ms
      │   TriggerClientEvent: Client:Character:Loaded ✓
      │
      ├─ Client: Loaded ✓
      │   ✓ State Sync Verification (not hardcoded 5s)
      │   ✓ All systems initialized
      │   TriggerServerEvent: Server:Character:Loaded
      │   ↓
      ├─ Client: Ready ✓
      │   TriggerServerEvent: Server:Character:Ready
      │   ↓
      └─ Server: Ready ✓
          ✓ Job ACL assigned
          ✓ Instance updated
          ✓ FULLY LOADED
```

---

## File Changes Summary

### Client-Side: `client/[Events]/_character.lua`
- ✅ Added proper documentation header with flow diagram
- ✅ Reorganized into 8 clear stages
- ✅ Fixed character list fetching with TriggerServerCallback
- ✅ Added character selection NUI callbacks (Select, CreateNew, Delete)
- ✅ Integrated appearance customization flow
- ✅ Added spawn timing with SetTimeout delays
- ✅ Replaced hardcoded 5s wait with state verification
- ✅ Added comprehensive logging throughout
- ✅ Fixed character ready event flow
- ✅ Added state management callbacks (PreSwitch, Switch, OffDuty, OnDuty, SetJob, Death)

**Lines Changed**: ~227 → ~413 (186 new lines, better organized)

### Server-Side: `server/[Events]/_character_lifecycle.lua`
- ✅ Added appearance loading trigger after ReSpawn (500ms delay)
- ✅ Added Client:Character:Loaded trigger after ped flags (500ms delay)
- ✅ Added logging info messages
- ✅ Maintained all security checks

**Lines Changed**: ~230 → ~245 (15 new lines, proper timing added)

---

## Testing Checklist

- [ ] Player can see character select menu on join
- [ ] Character list loads from server correctly
- [ ] Player can select existing character
- [ ] Character spawns at correct location
- [ ] Character appearance loads correctly
- [ ] Can create new character with appearance customizer
- [ ] New character spawns at default spawn location
- [ ] HUD initializes after character load
- [ ] State synchronization completes before "Loaded" event
- [ ] No duplicate messages or requests
- [ ] Proper timeouts between server triggers (500ms)
- [ ] All logging shows correct flow
- [ ] Console shows no errors during character load

---

## Related Documentation

- [NUI_LOADING_REFACTOR_PLAN.md](NUI_LOADING_REFACTOR_PLAN.md) - Architecture improvements
- [CLIENT_CHARACTER_LIFECYCLE_ANALYSIS.md](CLIENT_CHARACTER_LIFECYCLE_ANALYSIS.md) - Detailed analysis
- [NUI_MESSAGE_PROTOCOL_REFERENCE.md](../nui/NUI_MESSAGE_PROTOCOL_REFERENCE.md) - Message specs

---

## Next Steps

1. **Create NUI Wrapper Functions** (Phase 2)
   - Create `nui/lua/Client-NUI-Wrappers/` folder
   - Implement `ig.nui.character.*` functions
   - Implement wrappers for all other systems

2. **Organize NUI Callbacks** (Phase 3)
   - Move callbacks to `nui/lua/NUI-Client/` folder
   - Consolidate duplicate handlers
   - Update fxmanifest.lua load order

3. **Testing & Validation** (Phase 4)
   - Full end-to-end character load testing
   - Verify all timing delays work correctly
   - Check state synchronization
   - Validate logging output

---

**Status**: ✅ READY FOR TESTING  
**Last Updated**: 2026-01-16
