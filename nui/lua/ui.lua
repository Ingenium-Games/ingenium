-- ====================================================================================--
-- UI Export API for ingenium Vue 3 NUI System
-- ====================================================================================--

--- Show a menu with custom items
--- @param data table Menu configuration with title and items
--- Example:
--- exports['ingenium']:ShowMenu({
---   title = "Example Menu",
---   items = {
---     { label = "Option 1", action = "action1", data = {} },
---     { label = "Option 2", action = "action2", description = "This is a description" }
---   }
--- })
exports('ShowMenu', function(data)
    SendNUIMessage({
        message = "Client:NUI:MenuShow",
        data = data
    })
    SetNuiFocus(true, true)
end)

--- Show an input dialog
--- @param data table Input configuration with title, placeholder, and maxLength
--- Example:
--- exports['ingenium']:ShowInput({
---   title = "Enter your name",
---   placeholder = "John Doe",
---   maxLength = 50
--- })
exports('ShowInput', function(data)
    SendNUIMessage({
        message = "Client:NUI:InputShow",
        data = data
    })
    SetNuiFocus(true, true)
end)

--- Show a context menu at a specific position
--- @param data table Context menu configuration with title, items, and position
--- Example:
--- exports['ingenium']:ShowContextMenu({
---   title = "Actions",
---   items = {
---     { label = "Action 1", icon = "🔧", action = "repair" },
---     { label = "Action 2", icon = "🗑️", action = "delete", disabled = false }
---   },
---   position = { x = 100, y = 100 }
--- })
exports('ShowContextMenu', function(data)
    SendNUIMessage({
        message = "Client:NUI:ContextShow",
        data = data
    })
    SetNuiFocus(true, true)
end)

--- Show a notification (backwards compatible with old system)
--- @param text string Notification text
--- @param colour string Notification color (black, blue, orange, red, green, pink, purple, yellow)
--- @param fade number Fade duration in milliseconds
exports('Notify', function(text, colour, fade)
    TriggerClientCallback({ eventName = "Client:Notify", args = { text, colour, fade } })
end)

--- Hide the menu
exports('HideMenu', function()
    SendNUIMessage({
        message = "Client:NUI:MenuHide",
        data = {}
    })
    SetNuiFocus(false, false)
end)

--- Hide the input dialog
exports('HideInput', function()
    SendNUIMessage({
        message = "Client:NUI:InputHide",
        data = {}
    })
    SetNuiFocus(false, false)
end)

--- Hide the context menu
exports('HideContextMenu', function()
    SendNUIMessage({
        message = "Client:NUI:ContextHide",
        data = {}
    })
    SetNuiFocus(false, false)
end)

--- Show the HUD
exports('ShowHUD', function()
    SendNUIMessage({
        message = "Client:NUI:HUDShow",
        data = {}
    })
end)

--- Hide the HUD
exports('HideHUD', function()
    SendNUIMessage({
        message = "Client:NUI:HUDHide",
        data = {}
    })
end)

--- Update HUD data
--- @param data table HUD data to update (health, armor, hunger, thirst, stress, cash, bank, job, jobGrade)
exports('UpdateHUD', function(data)
    SendNUIMessage({
        message = "Client:NUI:HUDUpdate",
        data = data
    })
end)

--- Generic message sender for external resources
--- Note: external resources should use exports only; internal code should use `ig.ui`
exports('SendMessage', function(message, data, focus)
    SendNUIMessage({
        message = message,
        data = data or {}
    })
    if focus ~= nil then
        SetNuiFocus((focus and true) or false, (focus and true) or false)
    end
end)

-- ====================================================================================--
-- NUI Callbacks - CONSOLIDATED IN NUI-Client FOLDER
-- ====================================================================================--
-- All NUI callbacks have been moved to their function-specific locations:
--   - nui/lua/NUI-Client/_menu.lua (MenuSelect, MenuClose)
--   - nui/lua/NUI-Client/_input.lua (InputSubmit, InputClose)
--   - nui/lua/NUI-Client/_context.lua (ContextSelect, ContextClose)
--   - nui/lua/NUI-Client/character-select.lua (Character callbacks)
--
-- DO NOT register callbacks here - they are centralized in NUI-Client/
-- ====================================================================================--

-- Character callbacks have been moved to character-select.lua
-- DO NOT register character-related NUI callbacks here as they duplicate character-select.lua
-- and override the correct server callback implementation
-- See character-select.lua for the proper implementation using TriggerServerCallback
