-- ====================================================================================--
-- QUICK REFERENCE: USING NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- This guide explains how to use the wrapper functions in your code
-- ====================================================================================--

## WRAPPER FUNCTION LOCATIONS

All wrapper functions are in: nui/lua/Client-NUI-Wrappers/

Available systems:
  - _character.lua  → ig.nui.character.*
  - _menu.lua       → ig.nui.menu.*
  - _input.lua      → ig.nui.input.*
  - _context.lua    → ig.nui.context.*
  - _chat.lua       → ig.nui.chat.*
  - _banking.lua    → ig.nui.banking.*
  - _inventory.lua  → ig.nui.inventory.*
  - _garage.lua     → ig.nui.garage.*
  - _target.lua     → ig.nui.target.*
  - _hud.lua        → ig.nui.hud.*
  - _notification.lua → ig.nui.notify.*

---

## SHOWING UI

### Menu
```lua
ig.nui.menu.Show({
    {label = "Start Job", value = "start_job"},
    {label = "End Job", value = "end_job"},
    {label = "Cancel", value = "cancel"}
}, {
    title = "Job Menu",
    focus = true  -- Give focus to player
})
```

### Input Dialog
```lua
ig.nui.input.Show(
    "Enter amount to deposit:",
    "0",
    {maxLength = 10, focus = true}
)
```

### Context Menu
```lua
ig.nui.context.Show({
    x = 100,
    y = 100,
    focus = true
}, {
    {label = "Option 1", action = "opt1"},
    {label = "Option 2", action = "opt2"}
})
```

### Chat
```lua
ig.nui.chat.Show({placeholder = "Say something..."})
```

### Banking
```lua
ig.nui.banking.Show({
    balance = 50000,
    cash = 2500,
    accountType = "personal",
    favorites = {},
    transactions = {}
})
```

### Inventory
```lua
ig.nui.inventory.Show({
    player = playerInventoryData,
    external = dualInventoryData,
    maxSlots = 20
}, {
    dualMode = true,
    focus = true
})
```

### Garage
```lua
ig.nui.garage.Show({
    vehicles = vehicleList,
    garageId = 1,
    garageName = "Downtown Garage",
    garageType = "personal"
})
```

### Target
```lua
ig.nui.target.Show({
    entity = targetEntity,
    entityType = "npc",
    label = "Talk to NPC",
    focus = true
}, {
    {label = "Talk", action = "talk"},
    {label = "Rob", action = "rob"}
})
```

### HUD
```lua
ig.nui.hud.Show({position = "bottom-left", scale = 1.0})
```

### Notifications
```lua
local notifId = ig.nui.notify.Show(
    "Welcome to the server!",
    "info",
    {duration = 5000}
)

-- Later dismiss it:
ig.nui.notify.Hide(notifId)
```

---

## UPDATING UI DATA

### HUD Updates
```lua
-- Update all HUD elements
ig.nui.hud.Update({
    health = currentHealth,
    armor = currentArmor,
    hunger = currentHunger,
    cash = currentCash
})

-- Update single element
ig.nui.hud.UpdateElement("health", 95)
ig.nui.hud.UpdateElement("cash", 5000)
```

### Inventory Updates
```lua
ig.nui.inventory.Update({
    player = updatedPlayerInventory,
    external = updatedExternalInventory
})
```

### Chat Messages
```lua
ig.nui.chat.AddMessage(
    "John Doe",
    "Hello everyone!",
    {255, 0, 0}  -- Red text
)

-- Clear all messages
ig.nui.chat.Clear()
```

---

## HIDING UI

### All systems follow same pattern:
```lua
ig.nui.menu.Hide()
ig.nui.input.Hide()
ig.nui.context.Hide()
ig.nui.chat.Hide()
ig.nui.banking.Hide()
ig.nui.inventory.Hide()
ig.nui.garage.Hide()
ig.nui.target.Hide()
ig.nui.hud.Hide()
ig.nui.notify.Hide(notificationId)
```

---

## FOCUS MANAGEMENT

### Focus Parameter
Most Show() functions accept focus in options:
```lua
-- Give focus (player can click/type)
ig.nui.menu.Show(items, {focus = true})

-- No focus (just display)
ig.nui.menu.Show(items, {focus = false})
```

### When Focus is Released
Focus is automatically released (SetNuiFocus(false, false)):
1. When user presses ESC (Close button clicked)
2. When user selects an option (in callbacks)
3. When you call Hide()

---

## HANDLING RESPONSES

### Callbacks are in nui/lua/NUI-Client/

When user interacts, callbacks are triggered:

**Menu Selection**:
```lua
-- In nui/lua/NUI-Client/_menu.lua:
RegisterNUICallback('NUI:Client:MenuSelect', function(data, cb)
    TriggerEvent("Client:Menu:Select", data)
    SetNuiFocus(false, false)
    cb({ok = true})
end)
```

**Input Submission**:
```lua
-- In nui/lua/NUI-Client/_input.lua:
RegisterNUICallback('NUI:Client:InputSubmit', function(data, cb)
    TriggerEvent("Client:Input:Submit", data.value)
    SetNuiFocus(false, false)
    cb({ok = true})
end)
```

---

## COMMON PATTERNS

### Opening Menu from Event
```lua
RegisterNetEvent("Client:Job:OpenMenu")
AddEventHandler("Client:Job:OpenMenu", function()
    ig.nui.menu.Show(jobMenuItems, {
        title = "Job Menu",
        focus = true
    })
end)

-- Somewhere in nui/lua/NUI-Client/_menu.lua:
RegisterNUICallback('NUI:Client:MenuSelect', function(data, cb)
    if data.action == "start_job" then
        TriggerServerEvent("Server:Job:Start")
    end
    SetNuiFocus(false, false)
    cb({ok = true})
end)
```

### Banking Transaction Flow
```lua
-- Show banking UI
RegisterNetEvent("Client:Bank:Open")
AddEventHandler("Client:Bank:Open", function(bankData)
    ig.nui.banking.Show(bankData, {focus = true})
end)

-- Handle transfer (in nui/lua/NUI-Client/_banking.lua)
RegisterNUICallback('NUI:Client:BankingTransfer', function(data, cb)
    TriggerServerEvent("Server:Banking:Transfer", 
        data.recipient, 
        data.amount)
    TriggerEvent("Client:Banking:Close")
    cb({ok = true})
end)
```

### HUD Real-Time Updates
```lua
-- In client code, update HUD periodically:
CreateThread(function()
    while true do
        Wait(1000)  -- Update every second
        
        local ped = PlayerPedId()
        ig.nui.hud.Update({
            health = GetEntityHealth(ped),
            armor = GetPedArmour(ped),
            hunger = GetPlayerHunger(),
            cash = GetPlayerCash()
        })
    end
end)
```

---

## OPTIONS REFERENCE

### Show() Options Pattern
```lua
{
    title = "Menu Title",        -- Display name
    focus = true,                -- Give focus? (default: true)
    placeholder = "Enter...",    -- Input placeholder
    position = "center",         -- Position: "center", "top", "bottom"
    x = 100, y = 100,           -- Coordinates
    scale = 1.0,                -- Scale multiplier
    maxLength = 50,             -- Max input length
    dualMode = true,            -- Dual inventory mode
}
```

### Data Structure Reference
```lua
-- Menu data
{label = "Option Text", value = "internal_id"}

-- Banking data
{balance = 5000, cash = 1000, accountType = "personal"}

-- Inventory data
{player = {...}, external = {...}, maxSlots = 20}

-- Garage data
{vehicles = {...}, garageId = 1, garageType = "personal"}

-- Target data
{entity = entityHandle, entityType = "npc", label = "Label"}

-- HUD data
{health = 100, armor = 50, hunger = 80, cash = 5000}
```

---

## ERROR HANDLING

### Input Validation
All wrapper functions include defaults:
```lua
-- All of these work:
ig.nui.menu.Show(nil, nil)  -- Uses defaults
ig.nui.menu.Show(items)     -- No options
ig.nui.menu.Show(items, {}) -- Empty options
ig.nui.menu.Show(items, {focus = true}) -- With options
```

### Callback Error Handling
All NUI-Client callbacks check data:
```lua
if not data or not data.required_field then
    ig.log.Error("System", "Missing required_field")
    cb({ok = false, error = "Missing data"})
    return
end
```

---

## DEBUGGING TIPS

### Check if Wrapper Loaded
```lua
if ig.nui and ig.nui.menu then
    print("Menu wrapper loaded!")
else
    print("ERROR: Menu wrapper not loaded")
end
```

### Monitor Wrapper Calls
Console should show:
```
[Client-NUI-Wrappers] Menu wrapper functions loaded
[Client-NUI-Wrappers] Input wrapper functions loaded
... etc
```

### Test Wrapper Function
```lua
-- In console:
ig.nui.menu.Show({
    {label = "Test Option", value = "test"}
}, {title = "Test"})
```

### Check Callback Registration
Console should show:
```
[NUI-Client] Menu callbacks registered
[NUI-Client] Input callbacks registered
... etc
```

---

## COMPLETE WORKFLOW EXAMPLE

```lua
-- 1. Listen for open menu event
RegisterNetEvent("Client:Shop:OpenMenu")
AddEventHandler("Client:Shop:OpenMenu", function(shopData)
    -- 2. Show menu using wrapper
    ig.nui.menu.Show(shopData.items, {
        title = "Shop",
        focus = true
    })
end)

-- 3. Handle selection in callback (nui/lua/NUI-Client/_menu.lua)
RegisterNUICallback('NUI:Client:MenuSelect', function(data, cb)
    if data.action == "buy_item" then
        -- 4. Send to server
        TriggerServerEvent("Server:Shop:BuyItem", data.itemId, data.quantity)
    end
    SetNuiFocus(false, false)
    cb({ok = true})
end)

-- 5. Server processes and responds
RegisterServerEvent("Server:Shop:BuyItem")
AddEventHandler("Server:Shop:BuyItem", function(itemId, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    -- Process purchase...
    TriggerClientEvent("Client:Shop:ItemBought", source, itemId)
end)

-- 6. Client receives response
RegisterNetEvent("Client:Shop:ItemBought")
AddEventHandler("Client:Shop:ItemBought", function(itemId)
    -- 7. Show notification
    ig.nui.notify.Show(
        "Item purchased!",
        "success",
        {duration = 3000}
    )
    
    -- 8. Update HUD/inventory if needed
    ig.nui.inventory.Update(GetUpdatedInventory())
end)
```

---

## SUMMARY

✅ **Wrapper Location**: nui/lua/Client-NUI-Wrappers/
✅ **Callback Location**: nui/lua/NUI-Client/
✅ **Pattern**: ig.nui.SYSTEM.ACTION(data, options)
✅ **Focus**: Automatically managed
✅ **Error Handling**: Built-in defaults and validation
✅ **Logging**: All operations logged

For more details, see:
- PHASE3_5_CLIENT_NUI_WRAPPERS_SUMMARY.md (technical details)
- NUI_MESSAGE_PROTOCOL_REFERENCE.md (message formats)
- ARCHITECTURE_VERIFICATION_CHECKLIST.md (quality checklist)

