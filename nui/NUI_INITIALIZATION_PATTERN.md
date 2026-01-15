# NUI Initialization Pattern: Awaiting Vue Mount Before Message Delivery

## Problem

When Lua code sends NUI messages via `SendNUIMessage()` during early game initialization, those messages may arrive **before the Vue.js NUI application is fully mounted and ready to receive them**. This causes messages to be silently lost.

### Technical Root Cause

1. **Server/Client code execution** is fast and executes immediately on player connection
2. **NUI page load and Vue mount** involves browser initialization, JavaScript parsing, and Vue component mounting (100-300ms typically)
3. **Message event listeners** in the NUI are not attached until after Vue mounts
4. **Result**: Lua sends messages before `window.addEventListener('message', handler)` is registered, so messages are lost

### Symptoms

- Lua logs show `SendNUIMessage()` being called with correct payload
- NUI page loads and renders
- But no message handlers fire, state doesn't update, UI doesn't respond

## Solution: Pull vs Push Pattern

Instead of Lua **pushing** data to NUI immediately, have NUI **request** data when it's ready.

### Implementation

**1. NUI requests data on mount** (`App.vue`):
```javascript
onMounted(() => {
  // NUI is now ready - request data from server
  sendNuiMessage('Client:Request:CharacterList')
  setupNuiHandlers()
})
```

**2. Client receives request callback** (`client/_character.lua`):
```lua
RegisterNUICallback('Client:Request:CharacterList', function(data, cb)
  -- NUI is ready, now request server data
  TriggerServerEvent("Server:Character:GetList")
  cb({ok = true})
end)
```

**3. Server sends data back to client**, which then sends to NUI:
```lua
RegisterNetEvent("Client:Character:ReceiveCharacterList")
AddEventHandler("Client:Character:ReceiveCharacterList", function(data)
  -- Now NUI listener is guaranteed to be ready
  ig.ui.Send("Client:NUI:CharacterSelectShow", {
    characters = data.characters,
    slots = data.slots
  }, true)
end)
```

## Why This Works

1. ✅ NUI is fully initialized before making callback request
2. ✅ Client callback executes after NUI is ready
3. ✅ Server sends data after NUI explicitly requests it
4. ✅ Message listener is guaranteed to be attached before `SendNUIMessage()` is called

## Key Insights

- **Don't rely on timing**: Never assume NUI is ready when server/client code runs
- **Use callbacks for handshake**: Have NUI signal readiness via callback
- **RegisterNUICallback is reliable**: Callbacks are part of FiveM's core NUI system and work consistently
- **SendNUIMessage works after setup**: Only call `SendNUIMessage()` after confirmed NUI readiness (via callback response or explicit event)

## Anti-Pattern ❌

```lua
-- BAD: Lua immediately sends to NUI on player spawn
RegisterNetEvent("playerSpawned")
AddEventHandler("playerSpawned", function()
  SendNUIMessage({message = "test", data = {}})  -- NUI might not be ready!
end)
```

## Good Pattern ✅

```lua
-- GOOD: NUI requests data when ready
-- In NUI: onMounted(() => sendNuiMessage('Client:Request:Data'))
-- In Lua: RegisterNUICallback('Client:Request:Data', ...)
-- Then Lua sends via SendNUIMessage() only after callback fires
```

## Practical Checklist

- [ ] NUI has `setupNuiHandlers()` called in `onMounted()`
- [ ] `window.addEventListener('message', handler)` is attached in setupNuiHandlers
- [ ] NUI makes a `sendNuiMessage()` callback request on mount
- [ ] Client has `RegisterNUICallback()` for that request
- [ ] Client confirms NUI readiness before calling `SendNUIMessage()`
- [ ] All message listeners are set up before any messages are sent
