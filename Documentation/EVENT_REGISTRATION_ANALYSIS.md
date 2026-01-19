# Event Registration Analysis & Cleanup

## Overview

This document provides an analysis of event registration patterns across the Ingenium codebase, identifying orphaned events and documenting proper event usage patterns.

## Event Audit Summary

### Well-Structured Events ✅

The majority of events in Ingenium follow proper patterns:

#### Character Lifecycle Events
```lua
-- Server registration
RegisterNetEvent("Server:Character:Ready")
RegisterNetEvent("Server:Character:Switch")
RegisterNetEvent("Server:Character:Delete")

-- Client registration
RegisterNetEvent("Client:Character:Loaded")
RegisterNetEvent("Client:Character:Ready")
RegisterNetEvent("Client:Character:OnDuty")
RegisterNetEvent("Client:Character:OffDuty")
```

All character events have:
- ✅ Proper `RegisterNetEvent()` calls
- ✅ Corresponding `AddEventHandler()` implementations
- ✅ Clear trigger points

#### Vehicle Events
```lua
-- Client triggers
TriggerEvent("Client:EnteredVehicle", vehicle, seat, name, netId)
TriggerEvent("Client:LeftVehicle", vehicle, seat, name, netId)

-- Server receives
RegisterServerEvent("Server:Vehicle:PlayerEntered")
RegisterServerEvent("Server:Vehicle:PlayerLeft")
```

All vehicle events properly pair triggers with handlers.

### Orphaned Events ⚠️

Events that are **triggered** but have **no registered handlers**:

#### 1. HUD Focus Events (nui/lua/hud.lua)

**Event:** `Client:HUD:FocusToggled`
- **Triggered:** Line 42 in `nui/lua/hud.lua`
- **Handler:** None found
- **Purpose:** Notify other systems when HUD enters/exits focus/drag mode
- **Status:** ⚠️ **DOCUMENTED FOR FUTURE USE**

```lua
-- Current: Triggered but not consumed
TriggerEvent("Client:HUD:FocusToggled", hudFocused)

-- Future: Add handler if needed
RegisterNetEvent("Client:HUD:FocusToggled")
AddEventHandler("Client:HUD:FocusToggled", function(isFocused)
    -- React to HUD focus state changes
end)
```

**Event:** `Client:HUD:PositionReset`
- **Triggered:** Line 78 in `nui/lua/hud.lua`
- **Handler:** None found
- **Purpose:** Notify when HUD position is reset to defaults
- **Status:** ⚠️ **DOCUMENTED FOR FUTURE USE**

```lua
-- Current: Triggered but not consumed
TriggerEvent("Client:HUD:PositionReset", hudPosition)

-- Future: Add handler if needed
RegisterNetEvent("Client:HUD:PositionReset")
AddEventHandler("Client:HUD:PositionReset", function(position)
    -- React to HUD position reset
end)
```

#### 2. Drop Inventory Event (client/[Drops]/_drop_integration.lua)

**Event:** `Client:Drop:InventoryUpdated`
- **Triggered:** Line 122 in `client/[Drops]/_drop_integration.lua` (StateBag handler)
- **Handler:** Registered at line 176 in same file
- **Purpose:** Notify when a drop's inventory changes via StateBag replication
- **Status:** ✅ **PROPERLY PAIRED** (trigger and handler in same file)

```lua
-- StateBag change triggers event
AddStateBagChangeHandler('Inventory', nil, function(bagName, key, value, ...)
    -- ...
    TriggerEvent("Client:Drop:InventoryUpdated", netId, value)
end)

-- Handler registered below
RegisterNetEvent('Client:Drop:InventoryUpdated')
AddEventHandler('Client:Drop:InventoryUpdated', function(netId, inventory)
    -- Handle inventory updates
end)
```

**Note:** This event is **NOT orphaned**. Initial analysis was incorrect - the handler exists in the same file.

### NUI Message Naming Patterns

NUI messages use a different pattern from Lua events:

```lua
-- Lua → NUI: SendNUIMessage
SendNUIMessage({
    message = "Client:NUI:InventoryOpenDual",  -- NUI message name
    data = { ... }
})

-- Vue handles via nui.js listener
window.addEventListener('message', (event) => {
    if (event.data.message === "Client:NUI:InventoryOpenDual") {
        // Handle in Vue
    }
})

-- NUI → Lua: RegisterNUICallback
RegisterNUICallback("inventoryAction", function(data, cb)
    -- Handle action from Vue
end)
```

**Key Difference:** NUI messages don't use `RegisterNetEvent` - they use `SendNUIMessage` and `RegisterNUICallback`.

## Event Usage Patterns

### Pattern 1: Local Client Events

```lua
-- Trigger within client
TriggerEvent("Client:LocalEvent", data)

-- Handle within client
AddEventHandler("Client:LocalEvent", function(data)
    -- Process locally
end)
```

**When to use:** Events that stay within the client side (no server communication)

### Pattern 2: Server → Client Events

```lua
-- Server side
RegisterNetEvent("Client:UpdateData")
TriggerClientEvent("Client:UpdateData", source, data)

-- Client side
RegisterNetEvent("Client:UpdateData")
AddEventHandler("Client:UpdateData", function(data)
    -- Process server data
end)
```

**When to use:** Server pushing data to clients

### Pattern 3: Client → Server Events

```lua
-- Client side
RegisterServerEvent("Server:RequestData")
TriggerServerEvent("Server:RequestData", params)

-- Server side
RegisterServerEvent("Server:RequestData")
AddEventHandler("Server:RequestData", function(params)
    local source = source
    -- Process request
end)
```

**When to use:** Client requesting server action

## Documentation Added

### Code Comments

Added TODO comments for orphaned events:

#### nui/lua/hud.lua
```lua
-- NOTE: This event is currently triggered but has no registered handlers
-- TODO: If HUD focus state needs to be consumed by other systems, add handlers
TriggerEvent("Client:HUD:FocusToggled", hudFocused)
```

```lua
-- NOTE: This event is currently triggered but has no registered handlers
-- TODO: If HUD position reset needs to be consumed by other systems, add handlers
TriggerEvent("Client:HUD:PositionReset", hudPosition)
```

#### client/[Drops]/_drop_integration.lua
```lua
-- NOTE: This event is triggered but currently has a handler registered below (line 176)
-- The event system properly pairs trigger and handler for inventory updates
TriggerEvent("Client:Drop:InventoryUpdated", netId, value)
```

## Recommendations

### For HUD Events

**Option 1: Remove Events** (if no future use planned)
```lua
-- Remove TriggerEvent calls
-- ig.log.Info("HUD", "HUD focus toggled") -- Log only
```

**Option 2: Keep for Future Use** (if other resources may hook in)
```lua
-- Keep events, mark as extension points
-- Document in exports for third-party resources
```

**Decision:** ✅ **Keep with documentation** (chosen approach)
- Events serve as extension points for custom resources
- Third-party resources can hook HUD state changes
- No performance impact (events are cheap)

### For Drop Inventory Event

**Status:** ✅ **No action needed**
- Event is properly paired with handler
- Works as designed for StateBag-driven inventory updates

## Event Security

All events include security checks:

```lua
RegisterNetEvent('Client:Inventory:OpenDual')
AddEventHandler('Client:Inventory:OpenDual', function(...)
    -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    -- ... handle event
end)
```

**Best Practice:** Always validate invoking resource for sensitive events.

## Testing Event Flows

### Manual Testing Checklist

- [ ] Character lifecycle events (load/unload)
- [ ] Vehicle enter/exit events
- [ ] Inventory open/close events
- [ ] HUD focus toggle (visual feedback)
- [ ] HUD position reset (visual feedback)
- [ ] Drop inventory updates (StateBag changes)

### Verification Commands

```lua
-- Test event triggering
TriggerEvent("EventName", testData)

-- Monitor event handlers
AddEventHandler("EventName", function(...)
    print("Event triggered:", json.encode({...}))
end)

-- Check StateBag replication
print(Entity(entityId).state.PropertyName)
```

## Future Work

### Event Monitoring System

Consider implementing centralized event monitoring:

```lua
-- Log all event triggers in dev mode
if conf.dev.logEvents then
    local originalTriggerEvent = TriggerEvent
    TriggerEvent = function(eventName, ...)
        ig.log.Debug("Events", "Triggered: " .. eventName)
        return originalTriggerEvent(eventName, ...)
    end
end
```

### Event Documentation Generator

Automatically generate event documentation from code:

```lua
--- @event Client:Character:Loaded
--- @param characterData table Character data from database
--- @description Triggered when a character finishes loading
```

### Event Type Checking

Add runtime validation for event parameters:

```lua
RegisterNetEvent("Client:UpdateHealth")
AddEventHandler("Client:UpdateHealth", function(health)
    health = ig.check.Number(health, 0, 100)
    -- ... process
end)
```

## Related Files

- `nui/lua/hud.lua` - HUD events (DOCUMENTED)
- `client/[Drops]/_drop_integration.lua` - Drop events (VERIFIED)
- `nui/lua/inventory.lua` - Inventory NUI messages
- `client/[Events]/_vehicle.lua` - Vehicle event triggers
- `client/[Events]/_character.lua` - Character event handlers

## Event Inventory (Top 20 Most Used)

| Event Name | Type | Triggers | Handlers | Status |
|------------|------|----------|----------|--------|
| `Client:Character:Loaded` | Client | 1 | 3 | ✅ Paired |
| `Server:Character:Ready` | Server | 1 | 1 | ✅ Paired |
| `Client:EnteredVehicle` | Client | 2 | 6 | ✅ Paired |
| `Client:LeftVehicle` | Client | 2 | 6 | ✅ Paired |
| `Client:Inventory:OpenDual` | Client | 1 | 1 | ✅ Paired |
| `Client:HUD:FocusToggled` | Client | 1 | 0 | ⚠️ Orphaned |
| `Client:HUD:PositionReset` | Client | 1 | 0 | ⚠️ Orphaned |
| `Client:Drop:InventoryUpdated` | Client | 1 | 1 | ✅ Paired |
| `Server:Vehicle:PlayerEntered` | Server | 2 | 1 | ✅ Paired |
| `Server:Vehicle:PlayerLeft` | Server | 2 | 1 | ✅ Paired |

## Contributors

- Event analysis by GitHub Copilot (2026-01)

---

**Last Updated**: 2026-01-19
