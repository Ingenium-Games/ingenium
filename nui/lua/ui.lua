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
-- NUI Callbacks for Vue System
-- ====================================================================================--

-- Menu callbacks
-- Menu callbacks
local function menuSelectHandler(data, cb)
    -- Trigger legacy and directional events for compatibility
    TriggerEvent("Client:Menu:Select", data.action, data.data)
    TriggerEvent("Client:NUI:MenuSelect", data.action, data.data)
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:MenuSelect", menuSelectHandler)

local function menuCloseHandler(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent("Client:Menu:Close")
    TriggerEvent("Client:NUI:MenuClose")
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:MenuClose", menuCloseHandler)

-- Input callbacks
local function inputSubmitHandler(data, cb)
    TriggerEvent("Client:Input:Submit", data.value)
    TriggerEvent("Client:NUI:InputSubmit", data.value)
    SetNuiFocus(false, false)
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:InputSubmit", inputSubmitHandler)

local function inputCloseHandler(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent("Client:Input:Close")
    TriggerEvent("Client:NUI:InputClose")
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:InputClose", inputCloseHandler)

-- Context menu callbacks
local function contextSelectHandler(data, cb)
    TriggerEvent("Client:Context:Select", data.action, data.data)
    TriggerEvent("Client:NUI:ContextSelect", data.action, data.data)
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:ContextSelect", contextSelectHandler)

local function contextCloseHandler(data, cb)
    SetNuiFocus(false, false)
    TriggerEvent("Client:Context:Close")
    TriggerEvent("Client:NUI:ContextClose")
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:ContextClose", contextCloseHandler)

-- Character callbacks
local function characterCreateHandler(data, cb)
    TriggerEvent("Client:Character:Create", data.firstName, data.lastName)
    TriggerEvent("Client:NUI:CharacterCreate", data.firstName, data.lastName)
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:CharacterCreate", characterCreateHandler)

local function characterPlayHandler(data, cb)
    TriggerEvent("Client:Character:Play", data.id)
    TriggerEvent("Client:NUI:CharacterPlay", data.id)
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:CharacterPlay", characterPlayHandler)

local function characterDeleteHandler(data, cb)
    TriggerEvent("Client:Character:Delete", data.id)
    TriggerEvent("Client:NUI:CharacterDelete", data.id)
    cb({ message = "ok" })
end

RegisterNUICallback("NUI:Client:CharacterDelete", characterDeleteHandler)
