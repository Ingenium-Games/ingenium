# Migration Guide: Old NUI → Vue 3 NUI

This guide helps you migrate from the old jQuery-based NUI to the new Vue 3 system.

## Overview

The new Vue 3 NUI system is **backwards compatible** with the old notification system, so you can migrate gradually.

## Quick Reference

### Notifications

#### Old Way ✓ Still Works
```lua
-- Event-based (still works)
TriggerEvent("Client:Notify", "Hello!", "green", 5000)

-- Direct SendNUIMessage (still works)
SendNUIMessage({
    message = "notification",
    data = {
        text = "Hello!",
        colour = "green",
        fade = 5000
    }
})
```

#### New Way ✓ Recommended
```lua
-- Using exports
exports['ig.core']:Notify("Hello!", "green", 5000)
```

**Benefits of new way:**
- Cleaner API
- Better autocomplete in editors
- Easier to discover available functions
- Type checking (if using TypeScript in other resources)

### Menus

#### Old Way ❌ Manual Implementation Required
```lua
-- You had to create your own menu system
SendNUIMessage({
    message = "showCustomMenu",
    data = {...}
})

-- And handle callbacks manually
RegisterNUICallback("menuSelect", function(data, cb)
    -- Handle selection
    cb("ok")
end)
```

#### New Way ✓ Built-in
```lua
-- Show menu
exports['ig.core']:ShowMenu({
    title = "My Menu",
    items = {
        { label = "Option 1", action = "opt1", data = {} },
        { label = "Option 2", action = "opt2" }
    }
})

-- Listen for selection
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action, data)
    if action == "opt1" then
        -- Handle option 1
    end
end)
```

### Input Dialogs

#### Old Way ❌ Manual Implementation
```lua
-- Custom NUI message
SendNUIMessage({
    message = "showInput",
    data = { title = "Enter name" }
})

-- Manual callback
RegisterNUICallback("inputSubmit", function(data, cb)
    local value = data.value
    -- Process value
    cb("ok")
end)
```

#### New Way ✓ Built-in
```lua
-- Show input
exports['ig.core']:ShowInput({
    title = "Enter your name",
    placeholder = "John Doe",
    maxLength = 50
})

-- Listen for submission
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    -- Process value
    print("User entered:", value)
end)
```

### HUD

#### Old Way ❌ Manual Implementation
```lua
-- You had to create and update your own HUD
-- Different implementations in different resources
```

#### New Way ✓ Centralized
```lua
-- Show HUD
exports['ig.core']:ShowHUD()

-- Update data
exports['ig.core']:UpdateHUD({
    health = 100,
    armor = 50,
    hunger = 75,
    thirst = 80,
    cash = 5000,
    bank = 25000,
    job = "Police",
    jobGrade = "Officer"
})

-- Hide HUD
exports['ig.core']:HideHUD()
```

## Migration Checklist

### For ig.core Developers

- [ ] Keep old NUI files during transition period
- [ ] Test all notification calls work with new system
- [ ] Gradually move character select to Vue
- [ ] Migrate any custom UI components to Vue
- [ ] Update documentation

### For Resource Developers (using ig.core)

- [ ] Update notification calls to use exports (optional, old way still works)
- [ ] Replace custom menu systems with `ShowMenu()`
- [ ] Replace custom input dialogs with `ShowInput()`
- [ ] Use centralized HUD instead of custom HUD
- [ ] Test all UI interactions
- [ ] Update documentation

## Step-by-Step Migration

### Step 1: Ensure New System Works

1. Build the new NUI:
```bash
cd nui
npm install
npm run build
```

2. Restart ig.core:
```
/restart ig.core
```

3. Test notifications:
```lua
TriggerEvent("Client:Notify", "Test", "green", 5000)
```

If this works, the new system is running!

### Step 2: Add Test Commands (Optional)

Add to your test resource:
```lua
RegisterCommand("test-new-ui", function()
    -- Test menu
    exports['ig.core']:ShowMenu({
        title = "Test Menu",
        items = {
            { label = "Option 1", action = "test1" },
            { label = "Option 2", action = "test2" }
        }
    })
end, false)
```

### Step 3: Migrate Notifications

**Before:**
```lua
-- Throughout your resources
TriggerEvent("Client:Notify", "Message", "green", 5000)
```

**After (optional, but recommended):**
```lua
-- Use exports for new code
exports['ig.core']:Notify("Message", "green", 5000)

-- OR create a helper function
function Notify(msg, color, fade)
    exports['ig.core']:Notify(msg, color or "black", fade or 5000)
end

-- Then use
Notify("Message", "green")
```

### Step 4: Migrate Custom Menus

**Before:**
```lua
-- Custom menu implementation in your resource
-- Different for each resource
```

**After:**
```lua
-- Unified menu system
local function ShowJobMenu()
    exports['ig.core']:ShowMenu({
        title = "Job Actions",
        items = {
            { label = "Clock In", action = "clockin" },
            { label = "Clock Out", action = "clockout" },
            { label = "Access Storage", action = "storage" }
        }
    })
end

-- Handle selections
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action, data)
    if action == "clockin" then
        -- Handle clock in
    elseif action == "clockout" then
        -- Handle clock out
    elseif action == "storage" then
        -- Handle storage
    end
end)
```

### Step 5: Migrate Input Dialogs

**Before:**
```lua
-- Custom input implementation
```

**After:**
```lua
-- Show input
local function AskForName()
    exports['ig.core']:ShowInput({
        title = "Enter Player Name",
        placeholder = "John Doe",
        maxLength = 50
    })
end

-- Handle input
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    -- Process the input
    TriggerServerEvent("server:setName", value)
end)
```

### Step 6: Add HUD Integration

**Before:**
```lua
-- Custom HUD in your resource
-- Or no HUD at all
```

**After:**
```lua
-- Show HUD
exports['ig.core']:ShowHUD()

-- Update on player data change
RegisterNetEvent("playerDataUpdated")
AddEventHandler("playerDataUpdated", function(data)
    exports['ig.core']:UpdateHUD({
        health = data.health,
        armor = data.armor,
        hunger = data.hunger,
        thirst = data.thirst,
        cash = data.money,
        bank = data.bank,
        job = data.job.name,
        jobGrade = data.job.grade_name
    })
end)
```

## Common Patterns

### Pattern: Interactive Menu with Submenu

```lua
local function ShowMainMenu()
    exports['ig.core']:ShowMenu({
        title = "Main Menu",
        items = {
            { label = "Inventory", action = "inventory" },
            { label = "Settings", action = "settings" },
            { label = "Help", action = "help" }
        }
    })
end

local function ShowSettingsMenu()
    exports['ig.core']:ShowMenu({
        title = "Settings",
        items = {
            { label = "Toggle HUD", action = "toggle_hud" },
            { label = "Toggle Notifications", action = "toggle_notif" },
            { label = "Back", action = "back" }
        }
    })
end

RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action, data)
    if action == "settings" then
        ShowSettingsMenu()
    elseif action == "back" then
        ShowMainMenu()
    elseif action == "toggle_hud" then
        -- Toggle HUD logic
        exports['ig.core']:HideMenu()
    end
    -- ... handle other actions
end)
```

### Pattern: Input with Validation

```lua
local function AskForAmount()
    exports['ig.core']:ShowInput({
        title = "Enter Amount",
        placeholder = "100",
        maxLength = 10
    })
end

RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    local amount = tonumber(value)
    
    if not amount or amount <= 0 then
        exports['ig.core']:Notify("Invalid amount!", "red", 3000)
        return
    end
    
    if amount > 1000000 then
        exports['ig.core']:Notify("Amount too large!", "red", 3000)
        return
    end
    
    -- Process valid amount
    TriggerServerEvent("server:processAmount", amount)
    exports['ig.core']:Notify("Processing $" .. amount, "green", 3000)
end)
```

### Pattern: Context Menu for Targeting

```lua
-- For use with ig.target or similar
local function ShowVehicleMenu(vehicle)
    local coords = GetEntityCoords(PlayerPedId())
    
    exports['ig.core']:ShowContextMenu({
        title = "Vehicle",
        items = {
            { label = "Enter Vehicle", icon = "🚗", action = "enter" },
            { label = "Lock/Unlock", icon = "🔒", action = "lock" },
            { label = "Open Trunk", icon = "📦", action = "trunk" }
        },
        position = { x = 500, y = 300 } -- Or calculate from screen coords
    })
end

RegisterNetEvent("Client:Context:Select")
AddEventHandler("Client:Context:Select", function(action, data)
    if action == "enter" then
        -- Enter vehicle
    elseif action == "lock" then
        -- Toggle lock
    elseif action == "trunk" then
        -- Open trunk
    end
end)
```

## Troubleshooting

### Issue: Old code breaks with new system

**Solution:** The old notification system is backwards compatible. If something breaks:

1. Check F8 console for errors
2. Verify the new NUI is built: `ls nui/dist/`
3. Temporarily switch back to old NUI in `fxmanifest.lua`:
```lua
-- Comment out new system
-- ui_page "nui/dist/index.html"

-- Uncomment old system
ui_page "nui/index.html"
```

### Issue: Exports not working

**Solution:**
1. Verify ig.core is started before your resource
2. Check resource name is correct: `exports['ig.core']:...`
3. Restart your resource after updating

### Issue: UI appears but doesn't respond

**Solution:**
1. Check that NUI focus is set correctly
2. Look for JavaScript errors in browser console (F8 → NUI DevTools)
3. Verify callbacks are registered

## Best Practices

1. **Use exports for new code** - They're cleaner and easier to maintain
2. **Handle close events** - Listen for close events if you need cleanup
3. **Validate input** - Always validate user input from dialogs
4. **Provide feedback** - Use notifications to confirm actions
5. **Test thoroughly** - Test all UI flows after migration
6. **Document your code** - Comment complex menu structures

## Support

If you encounter issues during migration:

1. Check the [README.md](README.md) for API documentation
2. Review the [TESTING.md](TESTING.md) for test procedures
3. Check [examples.lua](lua/examples.lua) for working code samples
4. Open an issue on GitHub with reproduction steps
