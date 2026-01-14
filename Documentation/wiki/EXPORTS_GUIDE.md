# Complete Exports Guide

Comprehensive reference for all **62+ public exports** available in the Ingenium framework.

---

## Table of Contents

1. [Core Framework Exports](#core-framework-exports) (3)
2. [UI/Notifications](#uinotifications) (13)
3. [HUD Control](#hud-control) (4)
4. [Inventory System](#inventory-system) (3)
5. [Chat System](#chat-system) (4)
6. [Voice/Radio System](#voiceradio-system-client) (8)
7. [Targeting System](#targeting-system) (16)
8. [Banking](#banking) (1)
9. [Screenshot](#screenshot) (1)
10. [Server Voice Functions](#server-voice-functions) (8)
11. [Server Logging](#server-logging) (2)

---

## Core Framework Exports

These provide access to the main framework and localization:

| Export | Returns | Purpose |
|--------|---------|---------|
| `GetIngenium()` | table | Get main framework object with all functions |
| `GetLocale()` | string | Get current server locale (en, es, fr, etc.) |
| `_L(key, ...)` | string | Get localized/translated string |

**Usage**:
```lua
local ig = exports["ingenium"]:GetIngenium()
local locale = exports["ingenium"]:GetLocale()
local translated = exports["ingenium"]:_L("key.name")
```

---

## UI/Notifications

All user interface and notification functions:

| Export | Parameters | Returns | Purpose |
|--------|-----------|---------|---------|
| `Notify(text, color, fade)` | string, string, number | void | Send notification to player |
| `ShowMenu(data)` | {title, options} | void | Display menu with options |
| `HideMenu()` | - | void | Close menu |
| `ShowInput(data)` | {title, placeholder, max} | void | Show text input dialog |
| `HideInput()` | - | void | Close input dialog |
| `ShowContextMenu(data)` | {actions} | void | Show context menu |
| `HideContextMenu()` | - | void | Close context menu |
| `UpdateHUD(data)` | {cash, bank, hunger, ...} | void | Update HUD values |
| `ShowHUD()` | - | void | Display HUD |
| `HideHUD()` | - | void | Hide HUD |
| `SendMessage(message, data, focus)` | string, table, boolean | void | Send NUI message |

**Examples**:
```lua
-- Notification
exports["ingenium"]:Notify("Success!", "green", 3000)

-- Menu
exports["ingenium"]:ShowMenu({
    title = "Select",
    options = {
        {label = "Option 1", action = "opt1"},
        {label = "Option 2", action = "opt2"}
    }
})

-- Input
exports["ingenium"]:ShowInput({
    title = "Amount",
    placeholder = "0",
    max = 10
})

-- Context Menu
exports["ingenium"]:ShowContextMenu({
    actions = {
        {label = "Take", action = "take"},
        {label = "Leave", action = "leave"}
    }
})

-- HUD Update
exports["ingenium"]:UpdateHUD({
    cash = 5000,
    bank = 50000
})
```

---

## HUD Control

Functions to control HUD state and position:

| Export | Returns | Purpose |
|--------|---------|---------|
| `IsHudFocused()` | boolean | Check if HUD has focus |
| `ToggleHudFocus()` | void | Toggle HUD focus state |
| `GetHudPosition()` | {x, y} | Get HUD position |
| `SetHudPosition(x, y)` | void | Set HUD position |

**Examples**:
```lua
-- Check focus
if exports["ingenium"]:IsHudFocused() then
    print("HUD has focus")
end

-- Toggle focus
exports["ingenium"]:ToggleHudFocus()

-- Get position
local pos = exports["ingenium"]:GetHudPosition()
print("X:", pos.x, "Y:", pos.y)

-- Set position (0-100%)
exports["ingenium"]:SetHudPosition(50, 50)  -- Center
```

---

## Inventory System

Functions to manage inventory interface:

| Export | Parameters | Purpose |
|--------|-----------|---------|
| `GetCurrentExternalInventory()` | - | Get open external inventory |
| `OpenDualInventory(netId, title)` | number, string | Open dual inventory view |
| `OpenSingleInventory()` | - | Open player inventory |

**Examples**:
```lua
-- Get external inventory
local extInv = exports["ingenium"]:GetCurrentExternalInventory()

-- Open dual inventory
exports["ingenium"]:OpenDualInventory(vehicleNetId, "Vehicle Trunk")

-- Open player inventory
exports["ingenium"]:OpenSingleInventory()
```

---

## Chat System

Functions to manage chat interface:

| Export | Parameters | Purpose |
|--------|-----------|---------|
| `AddChatMessage(args)` | {color, message, author} | Add message to chat |
| `ShowChatInput(placeholder)` | string | Show chat input |
| `HideChat()` | - | Hide chat window |
| `ClearChat()` | - | Clear all messages |

**Examples**:
```lua
-- Add message
exports["ingenium"]:AddChatMessage({
    color = {255, 0, 0},
    message = "Hello!",
    author = "System"
})

-- Show input
exports["ingenium"]:ShowChatInput("Type here...")

-- Hide and clear
exports["ingenium"]:HideChat()
exports["ingenium"]:ClearChat()
```

---

## Voice/Radio System (Client)

Client-side voice communication functions:

| Export | Returns | Purpose |
|--------|---------|---------|
| `VoiceGetMode()` | number | Get current voice mode |
| `VoiceSetMode(modeIndex)` | void | Set voice mode |
| `VoiceNextMode()` | void | Cycle to next mode |
| `VoicePreviousMode()` | void | Cycle to previous mode |
| `VoiceJoinRadio(channel)` | void | Join radio channel |
| `VoiceLeaveRadio()` | void | Leave radio channel |
| `VoiceSetRadioTransmit(transmitting)` | void | Control transmit state |
| `VoiceIsTalking()` | boolean | Check if player is talking |

**Examples**:
```lua
-- Get and set mode
local mode = exports["ingenium"]:VoiceGetMode()
exports["ingenium"]:VoiceSetMode(2)

-- Cycle modes
exports["ingenium"]:VoiceNextMode()
exports["ingenium"]:VoicePreviousMode()

-- Radio control
exports["ingenium"]:VoiceJoinRadio(1)
exports["ingenium"]:VoiceSetRadioTransmit(true)
exports["ingenium"]:VoiceLeaveRadio()

-- Check talking
if exports["ingenium"]:VoiceIsTalking() then
    print("Player is talking")
end
```

---

## Targeting System

Functions to add interaction targets:

| Export | Parameters | Purpose |
|--------|-----------|---------|
| `AddPolyZone(data)` | {name, points, options} | Add polygon zone with targets |
| `AddBoxZone(data)` | {name, coords, width, length, options} | Add box zone with targets |
| `AddSphereZone(data)` | {name, coords, radius, options} | Add sphere zone with targets |
| `removeZone(zoneId)` | string | Remove zone |
| `AddGlobalPed(data)` | {options} | Add target for all peds |
| `removeGlobalPed(pedHash)` | number | Remove ped target |
| `AddGlobalVehicle(data)` | {options} | Add target for all vehicles |
| `removeGlobalVehicle(model)` | string/number | Remove vehicle target |
| `AddGlobalObject(data)` | {options} | Add target for all objects |
| `removeGlobalObject(model)` | string/number | Remove object target |
| `AddGlobalPlayer(data)` | {options} | Add target for all players |
| `removeGlobalPlayer()` | - | Remove player target |
| `AddModel(data)` | {model, options} | Add target for specific model |
| `removeModel(model)` | string/number | Remove model target |
| `AddEntity(data)` | {entity, options} | Add target for entity |
| `removeEntity(entity)` | number | Remove entity target |

**Examples**:
```lua
-- Add polygon zone
exports["ingenium"]:AddPolyZone({
    name = "bankzone",
    points = {
        vector3(100, 100, 50),
        vector3(150, 100, 50),
        vector3(150, 150, 50),
        vector3(100, 150, 50)
    },
    options = {
        {label = "Rob Bank", action = "rob_bank"},
        {label = "Leave", action = "leave"}
    }
})

-- Add global ped target
exports["ingenium"]:AddGlobalPed({
    options = {
        {label = "Talk", action = "talk"},
        {label = "Rob", action = "rob"}
    }
})

-- Add global vehicle target
exports["ingenium"]:AddGlobalVehicle({
    options = {
        {label = "Enter", action = "enter"},
        {label = "Hotwire", action = "hotwire"}
    }
})

-- Add target for specific model
exports["ingenium"]:AddModel({
    model = "prop_safe_01",
    options = {
        {label = "Crack", action = "crack"}
    }
})

-- Remove targets
exports["ingenium"]:removeZone("bankzone")
exports["ingenium"]:removeGlobalPed(0x9C4O87D)
exports["ingenium"]:removeModel("prop_safe_01")
```

### Disable Targeting
| Export | Parameters | Purpose |
|--------|-----------|---------|
| `disableTargeting(state)` | boolean | Enable/disable targeting system |

```lua
exports["ingenium"]:disableTargeting(true)   -- Disable
exports["ingenium"]:disableTargeting(false)  -- Enable
```

---

## Banking

Functions for banking system:

| Export | Purpose |
|--------|---------|
| `OpenBanking()` | Open banking menu |

**Example**:
```lua
exports["ingenium"]:OpenBanking()
```

---

## Screenshot

Functions for screenshot system:

| Export | Purpose |
|--------|---------|
| `TakeScreenshot()` | Capture and save screenshot |

**Example**:
```lua
exports["ingenium"]:TakeScreenshot()
```

---

## Server Voice Functions

Server-side voice management functions:

| Export | Parameters | Purpose |
|--------|-----------|---------|
| `VoiceInitializePlayer(playerId)` | number | Initialize player voice |
| `VoiceSetMode(playerId, modeIndex)` | number, number | Set player's voice mode |
| `VoiceJoinRadio(playerId, channel)` | number, number | Add player to radio |
| `VoiceLeaveRadio(playerId, channel)` | number, number | Remove from radio |
| `VoiceStartCall(callerId, targetId)` | number, number | Start call between players |
| `VoiceEndCall(playerId)` | number | End player's call |
| `VoiceStartConnection(playerId, connId)` | number, string | Start connection |
| `VoiceEndConnection(playerId)` | number | End connection |

---

## Server Logging

Server-side logging functions:

| Export | Parameters | Purpose |
|--------|-----------|---------|
| `LogToFile(message, level)` | string, string | Log message to file |
| `LogChatMessage(source, name, message, isCmd)` | number, string, string, boolean | Log chat message |

---

## TriggerServerCallback

Special callback system for server communication:

**Parameters**:
```lua
{
    eventName = "Server:Event:Name",
    args = {arg1, arg2, ...},
    source = GetPlayerServerId(PlayerId()),  -- Optional
    callback = function(result) end          -- Callback function
}
```

**Example**:
```lua
TriggerServerCallback({
    eventName = "Server:Bank:GetBalance",
    args = {characterId},
    callback = function(balance)
        exports["ingenium"]:Notify("Balance: $" .. balance, "blue")
    end
})
```

**Features**:
- ✅ Automatic source validation
- ✅ 30-second ticket expiration
- ✅ Rate limiting (100 req/sec default)
- ✅ Secure response handling

---

## Export Organization Summary

| Category | Count | Notes |
|----------|-------|-------|
| Core Framework | 3 | GetIngenium, GetLocale, _L |
| UI/Notifications | 13 | Menus, inputs, notifications |
| HUD Control | 4 | Position, focus, state |
| Inventory | 3 | Dual/single, management |
| Chat | 4 | Messages, input, control |
| Voice/Radio (Client) | 8 | Voice modes, radio, transmit |
| Targeting | 16 | Zones, entities, models, control |
| Banking | 1 | Open menu |
| Screenshot | 1 | Capture |
| Server Voice | 8 | Voice management |
| Server Logging | 2 | File and chat logging |
| **Total** | **63+** | **All public exports** |

---

## Quick Reference by Use Case

### Building a Shop Script
```lua
local ig = exports["ingenium"]:GetIngenium()

-- Show shop menu
exports["ingenium"]:ShowMenu({
    title = "Shop",
    options = {
        {label = "Buy Item 1", action = "buy1"},
        {label = "Buy Item 2", action = "buy2"}
    }
})

-- Get input for quantity
exports["ingenium"]:ShowInput({
    title = "How many?",
    placeholder = "1",
    max = 5
})

-- Server callback for purchase
TriggerServerCallback({
    eventName = "Server:Shop:Purchase",
    args = {itemId, quantity},
    callback = function(success)
        if success then
            exports["ingenium"]:Notify("Purchase successful!", "green")
        else
            exports["ingenium"]:Notify("Not enough money", "red")
        end
    end
})
```

### Adding Interaction Targets
```lua
-- Add zone for ATM
exports["ingenium"]:AddPolyZone({
    name = "atmzone",
    points = {vector3(100,100,50), vector3(120,100,50), vector3(120,120,50), vector3(100,120,50)},
    options = {{label = "Use ATM", action = "use_atm"}}
})

-- Add global object target
exports["ingenium"]:AddGlobalObject({
    options = {{label = "Use", action = "use"}}
})
```

### Voice Communication
```lua
-- Join radio channel
exports["ingenium"]:VoiceJoinRadio(1)

-- Check if talking
if exports["ingenium"]:VoiceIsTalking() then
    print("Currently speaking")
end

-- Disable transmit
exports["ingenium"]:VoiceSetRadioTransmit(false)
```

---

## Security Notes

✅ All listed exports are safe to use from external resources

⚠️ Do NOT attempt to bypass security on protected events

🔒 Protected events have GetInvokingResource() checks and cannot be triggered externally

---

## Documentation Links

- [PUBLIC_API.md](PUBLIC_API.md) - Overview of public API with examples
- [EVENTS_REFERENCE.md](EVENTS_REFERENCE.md) - Complete event documentation
- [../CODE_REVIEW_STAGE_3A_EXPORTS.md](../CODE_REVIEW_STAGE_3A_EXPORTS.md) - Detailed exports analysis

---

**Last Updated**: 2024  
**Total Exports Documented**: 63+  
**Status**: ✅ Complete
