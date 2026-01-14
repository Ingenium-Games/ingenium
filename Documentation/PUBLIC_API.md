# PUBLIC API - External Integration Guide

**Ingenium Framework - Public API Documentation**  
**Version**: 1.0  
**Total Public Exports**: 62+  
**Support**: For external resources using Ingenium's public API

---

## Quick Navigation

### Most Common Uses (Start Here!)
1. **[Send Notifications](wiki/core-api-notifications.md)** - `Notify(text, color, duration)`
2. **[Show UI Menus](wiki/core-api-menus.md)** - `ShowMenu()`, `ShowInput()`
3. **[Manage Inventory](wiki/core-api-inventory.md)** - `OpenDualInventory()`, `OpenSingleInventory()`
4. **[Control HUD](wiki/core-api-hud.md)** - `IsHudFocused()`, `ToggleHudFocus()`
5. **[Get Framework](wiki/core-api-framework.md)** - `GetIngenium()`, `GetLocale()`

---

## Complete API Reference by Category

### 🎮 **Core Framework** (3 exports)
```lua
GetIngenium()      -- Get main framework object
GetLocale()        -- Get current locale setting
_L(key, ...)       -- Get localized/translated string
```

### 🎨 **UI System** (13+ exports)
```lua
ShowMenu(data)          -- Display menu dialog
ShowInput(data)         -- Display input dialog
ShowContextMenu(data)   -- Display context menu
Notify(text, color, duration)  -- Send notification
HideMenu()             -- Hide menu
HideInput()            -- Hide input
HideContextMenu()      -- Hide context menu
UpdateHUD(data)        -- Update HUD display
SendMessage(msg, data) -- Send NUI message
```

### 📊 **HUD System** (4 exports)
```lua
IsHudFocused()         -- Check if HUD has focus
ToggleHudFocus()       -- Toggle HUD focus state
GetHudPosition()       -- Get HUD position {x, y}
SetHudPosition(x, y)   -- Set HUD position
```

### 📦 **Inventory System** (3 exports)
```lua
GetCurrentExternalInventory()  -- Get open external inventory
OpenDualInventory(netId, title) -- Open player + target inventory
OpenSingleInventory()          -- Open player inventory only
```

### 💬 **Chat System** (5 exports)
```lua
AddChatMessage(args)       -- Add message to chat
ShowChatInput(placeholder) -- Show chat input box
HideChat()                 -- Hide chat window
ClearChat()                -- Clear all messages
SetChatSuggestions(list)   -- Set command suggestions
```

### 🎤 **Voice/Radio System** (8 exports - Client)
```lua
VoiceGetMode()              -- Get current voice mode
VoiceSetMode(index)         -- Set voice mode
VoiceNextMode()             -- Cycle to next mode
VoiceJoinRadio(channel)     -- Join radio channel
VoiceLeaveRadio()           -- Leave radio
VoiceSetRadioTransmit(bool) -- Enable/disable transmit
VoiceIsTalking()            -- Check if currently talking
```

### 🎯 **Targeting System** (15+ exports - Client)
```lua
-- Zone-based targeting
AddPolyZone(data)   -- Add polygon zone targets
AddBoxZone(data)    -- Add box zone targets
AddSphereZone(data) -- Add sphere zone targets
removeZone(zoneId)  -- Remove zone

-- Global targets
AddGlobalPed(data)      -- Target all peds
AddGlobalVehicle(data)  -- Target all vehicles
AddGlobalObject(data)   -- Target all objects
AddGlobalPlayer(data)   -- Target all players
removeGlobalPed()       -- Remove ped targeting
removeGlobalVehicle()   -- Remove vehicle targeting
removeGlobalObject()    -- Remove object targeting
removeGlobalPlayer()    -- Remove player targeting

-- Model/Entity targeting
AddModel(data)          -- Target specific model
AddEntity(data)         -- Target entity
AddEntityZone(data)     -- Target entity zone
removeModel(model)      -- Remove model targeting
removeEntity(entity)    -- Remove entity targeting

-- Control
disableTargeting(state) -- Enable/disable all targeting
```

### 🏦 **Banking System** (1 export - Client)
```lua
OpenBanking()  -- Open banking menu
```

### 📸 **Screenshots** (1 export - Client)
```lua
TakeScreenshot()  -- Take and save screenshot
```

### 🎙️ **Voice Management** (8+ exports - Server)
```lua
VoiceInitializePlayer(playerId)
VoiceSetMode(playerId, mode)
VoiceJoinRadio(playerId, channel)
VoiceLeaveRadio(playerId, channel)
VoiceStartCall(callerId, targetId)
VoiceEndCall(playerId)
VoiceStartConnection(playerId, connectionId)
VoiceEndConnection(playerId)
VoiceStartAdminCall(adminId, targetId)
VoiceEndAdminCall(adminId, targetId)
```

### 📝 **Logging** (2 exports - Server)
```lua
LogToFile(message, level)  -- Log message to file
LogChatMessage(source, playerName, message, isCommand)  -- Log chat
```

---

## Basic Usage Examples

### Example 1: Simple Notification
```lua
exports['ingenium']:Notify("Hello World!", "green", 3000)
```

### Example 2: Show Menu
```lua
exports['ingenium']:ShowMenu({
    title = "My Custom Menu",
    options = {
        {label = "Option 1", action = "select_1"},
        {label = "Option 2", action = "select_2"},
        {label = "Close", action = "close"}
    }
})

-- Handle selection via event
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action)
    if action == "select_1" then
        exports['ingenium']:Notify("You selected option 1!", "blue", 3000)
    end
end)
```

### Example 3: Add Target to Interact
```lua
-- Server-side or client-side
exports['ingenium']:AddGlobalObject({
    {
        name = "my_object",
        icon = "🎯",
        label = "Interact",
        model = `prop_money_bag_01`,
        distance = 2.0,
        onSelect = function()
            exports['ingenium']:Notify("You interacted!", "green", 3000)
        end
    }
})
```

### Example 4: Get Framework & Data
```lua
local ig = exports['ingenium']:GetIngenium()

-- Access inventory
local inventory = ig.inventory.GetInventory()
local hasItem = ig.inventory.HasItem("itemname")
local weight = ig.inventory.GetWeight()

-- Access current data
print(ig._character)
print(ig.data.GetLocalPlayer())
```

### Example 5: Voice Control (Server)
```lua
-- Initialize player voice
exports['ingenium']:VoiceInitializePlayer(playerId)

-- Add to radio
exports['ingenium']:VoiceJoinRadio(playerId, 1)

-- Set voice mode
exports['ingenium']:VoiceSetMode(playerId, 2)
```

---

## Security & Rate Limiting

### Automatic Protections
- ✅ **Rate Limiting**: 100 requests/second per client
- ✅ **Ticket Validation**: 30-second ticket expiry
- ✅ **Source Verification**: Server callbacks validate source
- ✅ **Input Sanitization**: Server validates all inputs

### What You Should Do
- ✅ Check for nil returns
- ✅ Implement error handling
- ✅ Debounce rapid requests
- ✅ Validate user input locally

### What NOT To Do
- ❌ Don't spam rapid requests
- ❌ Don't expose sensitive logic to client
- ❌ Don't trust client calculations
- ❌ Don't modify internal framework data

---

## Common Errors & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `nil` return | Ingenium not loaded | Wait for client/server initialization |
| Rate limited | Too many requests/sec | Add debounce/cooldown between calls |
| Invalid IBAN | Account doesn't exist | Verify account exists before transfer |
| Insufficient funds | Not enough balance | Check balance first with GetBank() |
| NUI not visible | NUI focus issue | Call `ToggleHudFocus()` to elevate |

---

## Event System

### Client Events (PUBLIC - Can be triggered from any resource)
```lua
-- Exposed events (truly public, no security check)
TriggerEvent("Client:Menu:Select", action)
TriggerEvent("Client:Input:Submit", value)
TriggerEvent("Client:Context:Select", action)
```

### Client Events (PROTECTED - Internal only, NOT for external use)
```lua
-- Protected events with GetInvokingResource() security check
-- These events reject calls from external resources
RegisterNetEvent("Client:Notify")           -- Protected: Only ingenium can trigger
RegisterNetEvent("Client:Character:Play")   -- Protected: Only ingenium can trigger
RegisterNetEvent("Client:Character:Create") -- Protected: Only ingenium can trigger
RegisterNetEvent("Client:Character:Delete") -- Protected: Only ingenium can trigger

-- Why protected?
-- - Prevents external resources from spoofing notifications and character changes
-- - Ensures data integrity and notification system reliability
-- - Only internal framework code should trigger these
```

### Server Events (Request-Response Pattern)
```lua
-- Use TriggerServerCallback instead
TriggerServerCallback({
    eventName = "Server:Bank:Open",
    args = {},
    callback = function(result)
        -- Handle server response
    end
})
```

---

## Framework Features Available to External Resources

### ✅ Fully Accessible
- All exported functions
- Notification system
- UI menus and dialogs
- Targeting system
- Voice/radio communication
- HUD controls
- Inventory viewing (read-only)

### ⚠️ Limited Access
- Database operations (server-side)
- Player data (through callbacks)
- Job system (server-side)
- Banking (through callbacks)

### ❌ Not Accessible
- Internal class methods
- Private data structures
- Admin commands
- Developer tools
- Database direct access

---

## Performance Tips

1. **Cache Framework Reference**
   ```lua
   local ig = exports['ingenium']:GetIngenium()
   -- Reuse 'ig' instead of calling export repeatedly
   ```

2. **Debounce User Actions**
   ```lua
   local lastCall = 0
   local function Debounce()
       local now = GetGameTimer()
       if (now - lastCall) < 500 then return end
       lastCall = now
       -- Your code here
   end
   ```

3. **Check Before Operations**
   ```lua
   if not exports['ingenium']:IsHudFocused() then
       exports['ingenium']:ToggleHudFocus()
   end
   ```

---

## Version Compatibility

| Version | Status | Notes |
|---------|--------|-------|
| 1.0 | ✅ Current | All 62+ exports available |
| 0.9 | ⚠️ Legacy | Control mapping system |
| 0.8 | ⚠️ Old | NUI migration period |

---

## Support & Documentation

- **Quick Start**: See examples above
- **Detailed Docs**: Check individual wiki files
- **API Reference**: Complete export listing in this file
- **Source Code**: Framework is open-source

---

## Contributing

Found an issue or want to improve documentation?

1. Check the main [Ingenium Repository](../README.md)
2. Review [Contributing Guide](../CONTRIBUTING.md)
3. Submit changes following the framework conventions

---

## License

This public API documentation and framework is provided as-is.  
See [LICENSE](../LICENSE) for full legal terms.

---

**Last Generated**: 2024  
**Framework**: Ingenium  
**Public API Version**: 1.0  
**Status**: ✅ Ready for Production
