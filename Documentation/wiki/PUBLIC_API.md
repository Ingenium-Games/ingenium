# Public API Reference

This page documents all publicly accessible exports and events that external resources can utilize within the Ingenium framework.

**Last Updated**: 2024  
**Total Exports**: 62+  
**Total Public Events**: 11+  
**Protected Events**: 14+

---

## Quick Navigation

- [Accessing Exports](#accessing-exports)
- [Core Framework](#core-framework-exports)
- [UI/Notifications System](#uinotifications-system)
- [HUD Control](#hud-control)
- [Inventory System](#inventory-system)
- [Chat System](#chat-system)
- [Voice/Radio System](#voiceradio-system)
- [Targeting System](#targeting-system)
- [Banking System](#banking-system)
- [Public Events](#public-events)
- [Protected Events](#protected-events-internal-only)

---

## Accessing Exports

All framework exports are accessed via the standard FiveM export system:

```lua
-- Get the framework
local ig = exports["ingenium"]:GetIngenium()

-- Or access individual exports
local locale = exports["ingenium"]:GetLocale()

-- All exports return values that can be used across your resource
```

---

## Core Framework Exports

### 1. `GetIngenium()`
**Returns**: `table` - Global `ig` object  
**Security**: ✅ Public (no GetInvokingResource check)

Get access to the main framework object containing all core functions.

```lua
local ig = exports["ingenium"]:GetIngenium()

-- Now use framework functions:
ig.func.GetPlayers()
ig.inventory.GetInventory()
```

### 2. `GetLocale()`
**Returns**: `string` - Current locale code  
**Security**: ✅ Public

Get the current server locale (e.g., "en", "es", "fr").

```lua
local locale = exports["ingenium"]:GetLocale()
print("Current locale: " .. locale)
```

### 3. `_L(key, ...)`
**Returns**: `string` - Translated text  
**Security**: ✅ Public

Get localized strings for your resource's messages.

```lua
local greeting = exports["ingenium"]:_L("greeting.hello", playerName)
local errorMsg = exports["ingenium"]:_L("error.not_enough_funds")
```

### 4. `TriggerServerCallback(args)`
**Returns**: `void` (calls callback with response)  
**Security**: ✅ Public (rate-limited, ticket-validated)

Make request-response calls to the server with automatic validation.

```lua
TriggerServerCallback({
    eventName = "Server:Bank:GetBalance",
    args = {characterId},
    source = GetPlayerServerId(PlayerId()),
    callback = function(balance)
        print("Your balance: $" .. balance)
    end
})
```

---

## UI/Notifications System

### 5. `Notify(text, colour, fade)`
**Parameters**:
- `text` (string): Message to display
- `colour` (string): Color name (red, green, blue, orange, etc.)
- `fade` (number): Duration in milliseconds

```lua
exports["ingenium"]:Notify("Transaction successful!", "green", 3000)
exports["ingenium"]:Notify("Insufficient funds", "red", 2000)
```

### 6. `ShowMenu(data)`
**Parameters**:
- `data.title` (string): Menu title
- `data.options` (table[]): Array of {label, action} items

```lua
exports["ingenium"]:ShowMenu({
    title = "Select Option",
    options = {
        {label = "Option 1", action = "action1"},
        {label = "Option 2", action = "action2"},
        {label = "Close", action = "close"}
    }
})
```

### 7. `HideMenu()`

Close the currently open menu.

```lua
exports["ingenium"]:HideMenu()
```

### 8. `ShowInput(data)`
**Parameters**:
- `data.title` (string): Input prompt
- `data.placeholder` (string): Placeholder text
- `data.max` (number): Maximum characters

```lua
exports["ingenium"]:ShowInput({
    title = "Enter Amount",
    placeholder = "0",
    max = 10
})
```

### 9. `HideInput()`

Close the input dialog.

```lua
exports["ingenium"]:HideInput()
```

### 10. `ShowContextMenu(data)`
**Parameters**:
- `data.actions` (table[]): Array of {label, action} items

```lua
exports["ingenium"]:ShowContextMenu({
    actions = {
        {label = "Take", action = "take"},
        {label = "Examine", action = "examine"},
        {label = "Cancel", action = "cancel"}
    }
})
```

### 11. `HideContextMenu()`

Close the context menu.

```lua
exports["ingenium"]:HideContextMenu()
```

### 12. `UpdateHUD(data)`
**Parameters**:
- `data` (table): HUD fields to update

```lua
exports["ingenium"]:UpdateHUD({
    cash = 5000,
    bank = 50000,
    hunger = 75,
    thirst = 60
})
```

### 13. `ShowHUD()`

Display the HUD.

```lua
exports["ingenium"]:ShowHUD()
```

### 14. `HideHUD()`

Hide the HUD.

```lua
exports["ingenium"]:HideHUD()
```

### 15. `SendMessage(message, data, focus)`
**Parameters**:
- `message` (string): Message type
- `data` (table): Payload
- `focus` (boolean): Set NUI focus (optional)

```lua
exports["ingenium"]:SendMessage("customEvent", {key = "value"})
```

---

## HUD Control

### 16. `IsHudFocused()`
**Returns**: `boolean`

Check if HUD currently has focus.

```lua
local isFocused = exports["ingenium"]:IsHudFocused()
```

### 17. `ToggleHudFocus()`

Toggle HUD focus state (elevates z-index when focused).

```lua
exports["ingenium"]:ToggleHudFocus()
```

### 18. `GetHudPosition()`
**Returns**: `{x, y}` - Position percentages

Get current HUD position.

```lua
local pos = exports["ingenium"]:GetHudPosition()
print(pos.x, pos.y)
```

### 19. `SetHudPosition(x, y)`
**Parameters**:
- `x` (number): X position (0-100%)
- `y` (number): Y position (0-100%)

Set HUD position.

```lua
exports["ingenium"]:SetHudPosition(50, 50)  -- Center
```

---

## Inventory System

### 20. `GetCurrentExternalInventory()`
**Returns**: `table | nil` - External inventory data or nil

Get the currently open external inventory.

```lua
local extInv = exports["ingenium"]:GetCurrentExternalInventory()
if extInv then
    print("External inventory open")
end
```

### 21. `OpenDualInventory(netId, title)`
**Parameters**:
- `netId` (number): Network ID of target entity
- `title` (string): Display title

Open comparison inventory view.

```lua
exports["ingenium"]:OpenDualInventory(vehicleNetId, "Vehicle Trunk")
```

### 22. `OpenSingleInventory()`

Open player's inventory.

```lua
exports["ingenium"]:OpenSingleInventory()
```

### 23. `CloseInventory()`

Close inventory.

```lua
exports["ingenium"]:CloseInventory()
```

---

## Chat System

### 24. `AddChatMessage(args)`
**Parameters**:
- `args.color` (table): RGB color {R, G, B}
- `args.message` (string): Message text
- `args.author` (string): Message author

Add message to chat.

```lua
exports["ingenium"]:AddChatMessage({
    color = {255, 0, 0},
    message = "Hello World",
    author = "System"
})
```

### 25. `ShowChatInput(placeholder)`
**Parameters**:
- `placeholder` (string): Input placeholder text

Show chat input.

```lua
exports["ingenium"]:ShowChatInput("Type your message...")
```

### 26. `HideChat()`

Hide chat window.

```lua
exports["ingenium"]:HideChat()
```

### 27. `ClearChat()`

Clear all chat messages.

```lua
exports["ingenium"]:ClearChat()
```

### 28. `SetChatSuggestions(suggestions)`
**Parameters**:
- `suggestions` (table[]): Array of suggestion strings

Set command suggestions.

```lua
exports["ingenium"]:SetChatSuggestions({"/bank", "/inventory", "/job"})
```

---

## Voice/Radio System

### 29-35. **Client Voice Functions**

All client-side voice functions are accessible via export:

```lua
-- Get current voice mode
local mode = exports["ingenium"]:VoiceGetMode()

-- Set voice mode
exports["ingenium"]:VoiceSetMode(2)

-- Cycle modes
exports["ingenium"]:VoiceNextMode()

-- Join radio channel
exports["ingenium"]:VoiceJoinRadio(1)

-- Leave radio
exports["ingenium"]:VoiceLeaveRadio()

-- Control transmit
exports["ingenium"]:VoiceSetRadioTransmit(true)

-- Check if talking
local talking = exports["ingenium"]:VoiceIsTalking()
```

---

## Targeting System

### 36-50. **Targeting Functions**

Add targets for interactions:

```lua
-- Add zone with targets
exports["ingenium"]:AddPolyZone({
    name = "myzone",
    points = {vector3(0,0,0), vector3(10,0,0), vector3(10,10,0)},
    options = {
        {label = "Take", action = "take"},
        {label = "Leave", action = "leave"}
    }
})

-- Add target for all peds
exports["ingenium"]:AddGlobalPed({
    options = {{label = "Talk", action = "talk"}}
})

-- Add target for all vehicles
exports["ingenium"]:AddGlobalVehicle({
    options = {{label = "Enter", action = "enter"}}
})

-- Add target for all objects
exports["ingenium"]:AddGlobalObject({
    options = {{label = "Interact", action = "interact"}}
})

-- Add target for all players
exports["ingenium"]:AddGlobalPlayer({
    options = {{label = "Frisk", action = "frisk"}}
})

-- Add target for specific model
exports["ingenium"]:AddModel({
    model = "prop_safe_01",
    options = {{label = "Rob", action = "rob"}}
})

-- Add target for entity
exports["ingenium"]:AddEntity({
    entity = entityHandle,
    options = {{label = "Pickup", action = "pickup"}}
})

-- Remove zones and targets
exports["ingenium"]:removeZone(zoneId)
exports["ingenium"]:removeGlobalPed(pedHash)
exports["ingenium"]:removeGlobalVehicle(model)
exports["ingenium"]:removeGlobalObject(model)
exports["ingenium"]:removeGlobalPlayer()
exports["ingenium"]:removeModel(model)
exports["ingenium"]:removeEntity(entity)
```

### 51. `disableTargeting(state)`
**Parameters**:
- `state` (boolean): true to disable, false to enable

Temporarily disable all targeting system.

```lua
exports["ingenium"]:disableTargeting(true)   -- Disabled
exports["ingenium"]:disableTargeting(false)  -- Enabled
```

---

## Banking System

### 52. `OpenBanking()`

Trigger banking menu.

```lua
exports["ingenium"]:OpenBanking()
```

---

## Screenshot System

### 53. `TakeScreenshot()`

Capture and save screenshot.

```lua
exports["ingenium"]:TakeScreenshot()
```

---

## Public Events

These events can be triggered by any resource:

### `Client:Menu:Select`
Triggered when user selects menu option.

```lua
TriggerEvent("Client:Menu:Select", action)
```

### `Client:Input:Submit`
Triggered when user submits input.

```lua
TriggerEvent("Client:Input:Submit", inputValue)
```

### `Client:Context:Select`
Triggered when user selects context action.

```lua
TriggerEvent("Client:Context:Select", action)
```

### `Client:Banking:OpenMenu`
Triggered to open banking menu.

```lua
TriggerClientEvent("Client:Banking:OpenMenu", playerId, {
    characterId = charId,
    iban = iban
})
```

### `Server:Bank:*` (via callbacks)
Use TriggerServerCallback instead for banking operations.

---

## Protected Events (Internal Only)

⚠️ **Do NOT use these from external resources** - they have GetInvokingResource() checks and will be blocked.

### Character Events
- `Client:Notify` - Send notifications
- `Client:Character:Play` - Play character
- `Client:Character:Create` - Create character
- `Client:Character:Delete` - Delete character
- `Client:Character:OpeningMenu` - Open character menu

### Inventory Events
- `Client:Inventory:OpenDual` - Open dual inventory
- `Client:Inventory:OpenSingle` - Open single inventory
- `Client:Inventory:Update` - Update inventory live
- `Client:Inventory:Close` - Close inventory

### Drop System Events
- `Client:Drop:Notify` - Drop notification
- `Client:Drop:AccessDenied` - Access denied
- `Client:Drop:Removed` - Drop removed
- `Client:Inventory:UpdateLive` - Inventory update

### RunChecks Events
- `Client:RunChecks:IsWanted` - Wanted status changed
- `Client:RunChecks:IsSupporter` - Supporter status changed
- `Client:RunChecks:IsDead` - Death status changed
- `Client:RunChecks:IsCuffed` - Cuffed status changed
- `Client:RunChecks:IsEscorting` - Escorting status changed
- `Client:RunChecks:IsEscorted` - Escorted status changed
- `Client:RunChecks:IsSwimming` - Swimming status changed

### Other Protected Events
- `Client:Doors:Sync` - Door state synchronization
- `Client:Vehicle:PersistenceRegistered` - Vehicle registered
- `Client:Vehicle:Spawned` - Vehicle spawned
- `Client:Vehicle:Despawned` - Vehicle despawned
- `Client:Vehicle:CreateLocateBlips` - Create locate blips
- `ig:screenshot:takeOnReport` - Take screenshot on report
- `ig:screenshot:takeOnError` - Take screenshot on error

---

## Security Guidelines

✅ **Safe to Use**:
- All exported functions
- Public events (listed above)
- Server callbacks via TriggerServerCallback

⚠️ **Do NOT Use**:
- Protected events (will be blocked)
- GetInvokingResource() validation bypasses
- Direct database access functions
- Internal framework events

🔒 **Restricted**:
- Server-side functions (except callbacks)
- Administrative commands
- Player state manipulation (except through callbacks)

---

## Best Practices

### Error Handling

```lua
local success, result = pcall(function()
    return exports["ingenium"]:GetIngenium()
end)

if success then
    -- Use framework
else
    print("Framework not available:", result)
end
```

### Rate Limiting

Avoid spamming exports or events:

```lua
local lastCall = 0
local cooldown = 100  -- milliseconds

function SafeNotify(text, color)
    local now = GetGameTimer()
    if (now - lastCall) > cooldown then
        exports["ingenium"]:Notify(text, color, 3000)
        lastCall = now
    end
end
```

### Version Checking

Always check if the framework is available:

```lua
if GetResourceState("ingenium") == "started" then
    local ig = exports["ingenium"]:GetIngenium()
    -- Safe to use
end
```

---

## Full Export Index

See [EXPORTS_GUIDE.md](EXPORTS_GUIDE.md) for a complete list of all 62+ exports organized by category.

See [EVENTS_REFERENCE.md](EVENTS_REFERENCE.md) for detailed event documentation.

---

**Last Updated**: 2024  
**Framework**: Ingenium FiveM  
**Status**: ✅ Current
