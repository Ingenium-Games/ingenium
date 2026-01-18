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

--- Show the job management menu
--- @param data table Job menu configuration with job and user data
--- Example:
--- exports['ingenium']:ShowJobMenu({
---   job = {
---     name = "police",
---     label = "Police Department",
---     boss = "C01:xxxxx",
---     grades = {...},
---     accounts = { safe = 1000, bank = 50000 },
---     ...
---   },
---   user = {
---     characterId = "C01:xxxxx",
---     characterName = "John Doe",
---     jobName = "police",
---     jobGrade = 5,
---     isBoss = true
---   },
---   employees = {...},
---   financials = {...}
--- })
exports('ShowJobMenu', function(data)
    SendNUIMessage({
        message = "Client:NUI:JobOpen",
        data = data
    })
    SetNuiFocus(true, true)
end)

--- Hide the job management menu
exports('HideJobMenu', function()
    SendNUIMessage({
        message = "Client:NUI:JobClose",
        data = {}
    })
    SetNuiFocus(false, false)
end)

--- Update job accounts (safe/bank balances)
--- @param accounts table Account balances { safe = number, bank = number }
exports('UpdateJobAccounts', function(accounts)
    SendNUIMessage({
        message = "Client:NUI:JobUpdateAccounts",
        data = { accounts = accounts }
    })
end)

--- Update job memos
--- @param memos table Array of memo objects
exports('UpdateJobMemos', function(memos)
    SendNUIMessage({
        message = "Client:NUI:JobUpdateMemos",
        data = { memos = memos }
    })
end)

--- Update job employee list
--- @param employees table Array of employee objects
exports('UpdateJobEmployees', function(employees)
    SendNUIMessage({
        message = "Client:NUI:JobUpdateEmployees",
        data = { employees = employees }
    })
end)

--- Update job prices
--- @param prices table Price data { item_name = price }
exports('UpdateJobPrices', function(prices)
    SendNUIMessage({
        message = "Client:NUI:JobUpdatePrices",
        data = { prices = prices }
    })
end)

--- Update job locations
--- @param locations table Location data { sales = {}, delivery = {}, safe = {} }
exports('UpdateJobLocations', function(locations)
    SendNUIMessage({
        message = "Client:NUI:JobUpdateLocations",
        data = { locations = locations }
    })
end)

--- Update job financial data
--- @param financials table Financial data { income = {}, expenses = {}, totals }
exports('UpdateJobFinancials', function(financials)
    SendNUIMessage({
        message = "Client:NUI:JobUpdateFinancials",
        data = { financials = financials }
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
