-- ====================================================================================--
-- UI Export API for ig.core Vue 3 NUI System
-- ====================================================================================--

--- Show a menu with custom items
--- @param data table Menu configuration with title and items
--- Example:
--- exports['ig.core']:ShowMenu({
---   title = "Example Menu",
---   items = {
---     { label = "Option 1", action = "action1", data = {} },
---     { label = "Option 2", action = "action2", description = "This is a description" }
---   }
--- })
exports('ShowMenu', function(data)
    SendNUIMessage({
        message = "menu:show",
        data = data
    })
    SetNuiFocus(true, true)
end)

--- Show an input dialog
--- @param data table Input configuration with title, placeholder, and maxLength
--- Example:
--- exports['ig.core']:ShowInput({
---   title = "Enter your name",
---   placeholder = "John Doe",
---   maxLength = 50
--- })
exports('ShowInput', function(data)
    SendNUIMessage({
        message = "input:show",
        data = data
    })
    SetNuiFocus(true, true)
end)

--- Show a context menu at a specific position
--- @param data table Context menu configuration with title, items, and position
--- Example:
--- exports['ig.core']:ShowContextMenu({
---   title = "Actions",
---   items = {
---     { label = "Action 1", icon = "🔧", action = "repair" },
---     { label = "Action 2", icon = "🗑️", action = "delete", disabled = false }
---   },
---   position = { x = 100, y = 100 }
--- })
exports('ShowContextMenu', function(data)
    SendNUIMessage({
        message = "context:show",
        data = data
    })
    SetNuiFocus(true, true)
end)

--- Show a notification (backwards compatible with old system)
--- @param text string Notification text
--- @param colour string Notification color (black, blue, orange, red, green, pink, purple, yellow)
--- @param fade number Fade duration in milliseconds
exports('Notify', function(text, colour, fade)
    TriggerEvent("Client:Notify", text, colour, fade)
end)

--- Hide the menu
exports('HideMenu', function()
    SendNUIMessage({
        message = "menu:hide",
        data = {}
    })
    SetNuiFocus(false, false)
end)

--- Hide the input dialog
exports('HideInput', function()
    SendNUIMessage({
        message = "input:hide",
        data = {}
    })
    SetNuiFocus(false, false)
end)

--- Hide the context menu
exports('HideContextMenu', function()
    SendNUIMessage({
        message = "context:hide",
        data = {}
    })
    SetNuiFocus(false, false)
end)

--- Show the HUD
exports('ShowHUD', function()
    SendNUIMessage({
        message = "hud:show",
        data = {}
    })
end)

--- Hide the HUD
exports('HideHUD', function()
    SendNUIMessage({
        message = "hud:hide",
        data = {}
    })
end)

--- Update HUD data
--- @param data table HUD data to update (health, armor, hunger, thirst, stress, cash, bank, job, jobGrade)
exports('UpdateHUD', function(data)
    SendNUIMessage({
        message = "hud:update",
        data = data
    })
end)

-- ====================================================================================--
-- NUI Callbacks for Vue System
-- ====================================================================================--

-- Menu callbacks
RegisterNUICallback("menu:select", function(data, cb)
    -- Trigger event for menu selection
    TriggerEvent("Client:Menu:Select", data.action, data.data)
    cb({ message = "ok" })
end)

RegisterNUICallback("menu:close", function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent("Client:Menu:Close")
    cb({ message = "ok" })
end)

-- Input callbacks
RegisterNUICallback("input:submit", function(data, cb)
    -- Trigger event for input submission
    TriggerEvent("Client:Input:Submit", data.value)
    SetNuiFocus(false, false)
    cb({ message = "ok" })
end)

RegisterNUICallback("input:close", function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent("Client:Input:Close")
    cb({ message = "ok" })
end)

-- Context menu callbacks
RegisterNUICallback("context:select", function(data, cb)
    -- Trigger event for context menu selection
    TriggerEvent("Client:Context:Select", data.action, data.data)
    cb({ message = "ok" })
end)

RegisterNUICallback("context:close", function(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent("Client:Context:Close")
    cb({ message = "ok" })
end)

-- Character callbacks
RegisterNUICallback("character:create", function(data, cb)
    -- Trigger event for character creation
    TriggerEvent("Client:Character:Create", data.firstName, data.lastName)
    cb({ message = "ok" })
end)

RegisterNUICallback("character:play", function(data, cb)
    -- Trigger event to play character
    TriggerEvent("Client:Character:Play", data.id)
    cb({ message = "ok" })
end)

RegisterNUICallback("character:delete", function(data, cb)
    -- Trigger event to delete character
    TriggerEvent("Client:Character:Delete", data.id)
    cb({ message = "ok" })
end)
