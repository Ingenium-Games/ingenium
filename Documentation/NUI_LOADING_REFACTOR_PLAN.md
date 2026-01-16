---
# NUI Loading Architecture Refactor - Implementation Plan
## Issue #107: Organize NUI Loading Flow & Code Structure

**Status**: Planning  
**Priority**: High  
**Created**: 2026-01-16

---

## Executive Summary

The current character loading flow involves multiple loose events and lacks a cohesive structure. This refactor will:

1. **Consolidate multi-event chains** into structured wrapper functions
2. **Reorganize NUI folder structure** for clarity and maintainability
3. **Implement loading cameras and UI hiding** until stores are ready
4. **Use `ig.callback.Await` for blocking operations** and Async for immediate operations
5. **Replace volatile event-driven code** with stable function-based patterns

---

## Current Issues

### 1. Multi-Event Volatile Chains
**Problem**: Character loading involves multiple sequential events that can break easily:
```
Server:Character:List 
  → Client:Character:ReceiveCharacterList 
    → Client:Request:CharacterList (NUI callback)
      → TriggerServerEvent (Server:Character:List again)
        → Server:Character:Join
          → Client:Character:ReSpawn
            → Server:Character:LoadSkin
              → Server:Character:Loaded
                → Server:Character:Ready
```

**Risk**: Any missed event breaks the entire chain.

### 2. Folder Structure Confusion
**Current**: All NUI Lua files in `nui/lua/` with partial `NUI-Client/` folder
- `nui/lua/ui.lua` - Generic exports
- `nui/lua/NUI-Client/character-select.lua` - Only character callbacks
- Missing: Organized Client→NUI wrapper functions

**Goal**: Clear separation:
```
nui/lua/
  Client-NUI/          ← Functions that SEND to NUI (exports and wrappers)
    _character.lua
    _menu.lua
    _inventory.lua
    _notification.lua
    ...
  NUI-Client/          ← Handlers for NUI → Client/Server callbacks
    _character.lua
    _menu.lua
    _inventory.lua
    ...
```

### 3. Missing Loading Flow Control
**Issue**: No explicit loading camera or UI hiding until stores load

**Goal**: 
- Set loading camera immediately on connect
- Show loading spinner
- Wait for Vue stores to hydrate (character, ui, notifications)
- Then show character select UI
- Hide loading spinner

### 4. No Function Wrappers
**Current**: Direct `SendNUIMessage()` calls scattered across codebase  
**Goal**: Use wrapper functions:
```lua
-- ✅ Instead of:
SendNUIMessage({message = "Client:NUI:CharacterSelectShow", data = {...}})

-- ✅ Use wrapper:
ig.nui.character.ShowSelect(characterList, slots)
```

---

## Implementation Plan

### Phase 1: Folder Reorganization

#### Create `Client-NUI/` Functions (Functions that SEND NUI messages)
```
nui/lua/Client-NUI/
  _character.lua      ← ig.nui.character.* functions
  _menu.lua           ← ig.nui.menu.* functions
  _inventory.lua      ← ig.nui.inventory.* functions
  _notification.lua   ← ig.nui.notification.* functions
  _hud.lua            ← ig.nui.hud.* functions
```

**Example**: `_character.lua`
```lua
-- nui/lua/Client-NUI/_character.lua
function ig.nui.character.ShowSelect(characters, slots)
    ig.ui.Send("Client:NUI:CharacterSelectShow", {
        characters = characters,
        slots = slots
    }, true)
    SetFollowPedCamViewMode(4)  -- Character select camera
end

function ig.nui.character.HideSelect()
    ig.ui.Send("Client:NUI:CharacterSelectHide", {}, false)
    SetFollowPedCamViewMode(0)  -- Normal camera
end

function ig.nui.character.ShowCreator(appearance)
    ig.ui.Send("Client:NUI:CharacterCreateShow", {
        appearance = appearance
    }, true)
end
```

#### Keep `NUI-Client/` as Callback Handlers
```
nui/lua/NUI-Client/
  _character.lua      ← RegisterNUICallback("NUI:Client:*")
  _menu.lua
  _inventory.lua
```

**Stays as-is**: These receive NUI events and trigger server operations.

---

### Phase 2: Character Loading Flow Consolidation

#### Server-Side (`server/[Events]/_character_lifecycle.lua`)

**Current Flow (BROKEN)**:
```
Server:Character:List (callback)
  ← Client needs to request again
    → TriggerServerEvent("Server:Character:List") 
      → SendNUIMessage() in client
```

**New Flow (UNIFIED)**:
```lua
-- Wrapper function with Await
function LoadCharacterList(src)
    local Primary_ID = ig.func.identifier(src)
    local Slots = ig.sql.user.GetSlots(Primary_ID)
    local Characters = ig.sql.char.GetAllPermited(Primary_ID, Slots)
    
    -- Place in isolated instance
    ig.inst.SetPlayer(src)
    
    -- Set up character select camera/UI
    TriggerClientEvent("Client:NUI:CharacterSelectLoad", src, {
        characters = Characters,
        slots = Slots
    })
    
    return {
        Characters = Characters,
        Slots = Slots
    }
end
```

#### Client-Side (`client/[Events]/_character.lua`)

**Simplified Flow**:
```lua
-- On first connect:
RegisterNetEvent("Client:NUI:CharacterSelectLoad")
AddEventHandler("Client:NUI:CharacterSelectLoad", function(data)
    -- Wait for Vue stores to load
    ig.callback.Await("NUI:Ready", 5000, function()
        ig.nui.character.ShowSelect(data.characters, data.slots)
        SetFollowPedCamViewMode(4)
    end)
end)

-- On character selection (NUI callback in NUI-Client/):
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    TriggerServerCallback({
        eventName = "Server:Character:Join",
        args = {data.ID},
        callback = function(result)
            if result.success then
                ig.nui.character.HideSelect()
                TriggerEvent("Client:Character:ReSpawn", result.coords)
            end
        end
    })
    cb({message = "ok"})
end)
```

---

### Phase 3: Loading Spinner & Camera Control

#### Loading Flow
```lua
-- Server: On player connect
playerConnecting
  → Setup loading spinner (client)
  → Set character select camera
  → Load character list from database
  → Send to client with wrapper function
  
-- Client: 
  → Show loading camera
  → Wait for Vue store "NUI:Ready"
  → Hide spinner
  → Show character select with smooth transition
```

**Implementation**:

**Client-side** (`client/client.lua` or `client/[Events]/_character.lua`):
```lua
-- Function to setup loading state
function SetupCharacterSelectLoading()
    -- Freeze player
    FreezeEntityPosition(PlayerPedId(), true)
    
    -- Setup loading camera
    SetFollowPedCamViewMode(4)  -- Fixed POV on character
    SetEntityCoords(PlayerPedId(), -43.14, 822.04, 231.33)
    SetEntityHeading(PlayerPedId(), 288.78)
    SetGameplayCamRelativeRotation(4.03, 0.054, -71.305)
    
    -- Show loading spinner
    ig.nui.notification.ShowLoadingSpinner("Loading characters...")
end

-- Vue Store Event (from NUI)
RegisterNetEvent("NUI:StoresReady")
AddEventHandler("NUI:StoresReady", function()
    ig.nui.notification.HideLoadingSpinner()
    -- Characters already shown by now
end)
```

---

### Phase 4: Callback.Await Pattern Usage

#### Pattern 1: Wait for Data Before Sending to NUI
```lua
-- Server: Wait for data, then send to client
function GetPlayerDataWithWait(src)
    local xPlayer = ig.data.GetPlayer(src)
    
    -- Wait for player to be fully loaded before sending to NUI
    if not xPlayer then
        return nil, "Player not loaded"
    end
    
    return {
        id = xPlayer.GetCharacter_ID(),
        name = xPlayer.GetName(),
        -- ... other data
    }
end

-- Client: Use Await to get data before showing NUI
RegisterNetEvent("Client:ShowPlayerData")
AddEventHandler("Client:ShowPlayerData", function()
    ig.callback.Await("Server:GetPlayerData", 3000, function(data)
        if not data then
            ig.log.Error("UI", "Failed to load player data")
            return
        end
        ig.nui.hud.Update(data)
    end)
end)
```

#### Pattern 2: Async for Immediate Operations
```lua
-- Send to NUI immediately, server handles sync
function UpdateHUDAsync(data)
    -- Send immediately to NUI
    ig.ui.Send("Client:NUI:HUDUpdate", data, false)
    
    -- Notify server async (fire and forget)
    TriggerServerEvent("Server:Stat:Update", data)
end
```

---

## File Structure After Refactor

```
ingenium/
  client/
    [Events]/
      _character.lua          ← Simplified, uses wrappers
      _nui.lua                ← NUI-related events
  nui/
    lua/
      Client-NUI/             ← ✅ NUI callback handlers
        _character.lua
        _menu.lua
        _inventory.lua
        _notification.lua
        _hud.lua
      Client-NUI-Wrappers/    ← ✅ NEW: Functions to send NUI messages
        _character.lua        ← ig.nui.character.*
        _menu.lua             ← ig.nui.menu.*
        _inventory.lua        ← ig.nui.inventory.*
        _notification.lua     ← ig.nui.notification.*
        _hud.lua              ← ig.nui.hud.*
      ui.lua                  ← Base SendNUIMessage wrapper
      chat.lua
      notification.lua
      ...
```

---

## Migration Checklist

- [ ] **Phase 1: Folder Reorganization**
  - [ ] Create `Client-NUI-Wrappers/` folder
  - [ ] Extract wrapper functions from `_ui.lua`
  - [ ] Create `_character.lua`, `_menu.lua`, `_inventory.lua`, etc.
  - [ ] Update NUI callback handlers to use new paths

- [ ] **Phase 2: Character Loading Consolidation**
  - [ ] Create `LoadCharacterList()` wrapper function
  - [ ] Simplify server character events
  - [ ] Update client character event handlers
  - [ ] Remove duplicate event chains

- [ ] **Phase 3: Loading Flow & Camera Control**
  - [ ] Implement `SetupCharacterSelectLoading()`
  - [ ] Add camera positioning logic
  - [ ] Implement loading spinner display
  - [ ] Add "NUI:StoresReady" event from Vue

- [ ] **Phase 4: Testing**
  - [ ] Test character selection flow
  - [ ] Verify loading camera displays
  - [ ] Verify NUI shows after stores load
  - [ ] Test character creation
  - [ ] Test character joining

---

## Benefits

✅ **Cleaner Code**: Function-based instead of event-chain based  
✅ **Less Volatile**: Fewer loose events means fewer breaking points  
✅ **Better UX**: Loading states and cameras properly managed  
✅ **Easier Maintenance**: Wrapper functions centralize NUI logic  
✅ **Consistent Patterns**: Uses `ig.callback.Await` and Async consistently  

---

## Next Steps

1. Review this plan with team
2. Approve folder structure changes
3. Begin Phase 1 implementation
4. Test each phase before moving to next
5. Update related documentation

---

**Owner**: Development Team  
**Timeline**: 3-5 days  
**Complexity**: Medium
