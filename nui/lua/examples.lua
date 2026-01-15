-- ====================================================================================--
-- Example Integration for Vue 3 NUI System
-- This file demonstrates how to use the new export API
-- ====================================================================================--

-- Example 1: Using notifications (backwards compatible)
RegisterCommand("test-notify", function()
    -- Old way (still works)
    TriggerEvent("Client:Notify", "This is a test notification!", "green", 5000)
    
    -- New way (using exports)
    exports['ingenium']:Notify("This is another notification!", "blue", 5000)
end, false)

-- Example 2: Using menus
RegisterCommand("test-menu", function()
    exports['ingenium']:ShowMenu({
        title = "Test Menu",
        items = {
            {
                label = "Option 1",
                description = "This is the first option",
                action = "option1",
                data = { id = 1 }
            },
            {
                label = "Option 2",
                description = "This is the second option",
                action = "option2",
                data = { id = 2 }
            },
            {
                label = "Disabled Option",
                description = "This option is disabled",
                action = "disabled",
                disabled = true
            }
        }
    })
end, false)

-- Listen for menu selection
RegisterNetEvent("Client:Menu:Select")
AddEventHandler("Client:Menu:Select", function(action, data)
    print("Menu selection:", action, json.encode(data))
    
    if action == "option1" then
        TriggerEvent("Client:Notify", "You selected Option 1!", "green", 3000)
    elseif action == "option2" then
        TriggerEvent("Client:Notify", "You selected Option 2!", "blue", 3000)
    end
end)

-- Example 3: Using input dialogs
RegisterCommand("test-input", function()
    exports['ingenium']:ShowInput({
        title = "Enter Your Name",
        placeholder = "John Doe",
        maxLength = 50
    })
end, false)

-- Listen for input submission
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    print("User entered:", value)
    TriggerEvent("Client:Notify", "You entered: " .. value, "green", 3000)
end)

-- Example 4: Using context menus
RegisterCommand("test-context", function()
    exports['ingenium']:ShowContextMenu({
        title = "Actions",
        items = {
            { label = "Repair Vehicle", icon = "🔧", action = "repair" },
            { label = "Lock Vehicle", icon = "🔒", action = "lock" },
            { label = "Delete Vehicle", icon = "🗑️", action = "delete" }
        },
        position = { x = 500, y = 300 }
    })
end, false)

-- Listen for context menu selection
RegisterNetEvent("Client:Context:Select")
AddEventHandler("Client:Context:Select", function(action, data)
    print("Context menu selection:", action)
    TriggerEvent("Client:Notify", "Action: " .. action, "purple", 3000)
end)

-- Example 5: Using HUD
RegisterCommand("test-hud-show", function()
    exports['ingenium']:ShowHUD()
    
    -- Update HUD with sample data
    exports['ingenium']:UpdateHUD({
        health = 100,
        armor = 50,
        hunger = 75,
        thirst = 80,
        stress = 15,
        cash = 5000,
        bank = 25000,
        job = "Police",
        jobGrade = "Officer"
    })
end, false)

RegisterCommand("test-hud-hide", function()
    exports['ingenium']:HideHUD()
end, false)

-- Example 6: Simulating HUD updates (like in a game loop)
RegisterCommand("test-hud-update", function()
    local health = GetEntityHealth(PlayerPedId())
    local armor = GetPedArmour(PlayerPedId())
    
    exports['ingenium']:UpdateHUD({
        health = math.floor((health - 100) / 100 * 100),
        armor = armor
    })
    
    TriggerEvent("Client:Notify", "HUD updated with current stats", "blue", 3000)
end, false)

-- Example 7: Character select integration (this would typically be triggered by the server)
RegisterCommand("test-character-select", function()
    SendNUIMessage({
        message = "Client:NUI:CharacterSelectShow",
        data = {
            characters = {
                {
                    id = 1,
                    name = "John Doe",
                    created = "2023-01-15",
                    lastSeen = "2024-12-14",
                    cityId = "12345",
                    phone = "555-0123"
                },
                {
                    id = 2,
                    name = "Jane Smith",
                    created = "2023-06-20",
                    lastSeen = "2024-12-13",
                    cityId = "67890",
                    phone = "555-0456"
                }
            }
        }
    })
end, false)

-- Listen for character events
RegisterNetEvent("Client:Character:Play")
AddEventHandler("Client:Character:Play", function(id)
        -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    print("Playing character:", id)
    TriggerEvent("Client:Notify", "Loading character...", "green", 3000)
    
    -- Hide character select
    SendNUIMessage({
        message = "Client:NUI:CharacterSelectHide",
        data = {}
    })
end)

RegisterNetEvent("Client:Character:Create")
AddEventHandler("Client:Character:Create", function(firstName, lastName)
        -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    print("Creating character:", firstName, lastName)
    TriggerEvent("Client:Notify", "Creating character: " .. firstName .. " " .. lastName, "green", 3000)
end)

RegisterNetEvent("Client:Character:Delete")
AddEventHandler("Client:Character:Delete", function(id)
        -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    print("Deleting character:", id)
    TriggerEvent("Client:Notify", "Character deleted", "red", 3000)
end)

-- Print help message
Citizen.CreateThread(function()
    Wait(5000)
    ig.log.Info("NUI", "========================================")
    ig.log.Info("NUI", "Vue 3 NUI Test Commands:")
    ig.log.Info("NUI", "/test-notify - Test notifications")
    ig.log.Info("NUI", "/test-menu - Test menu system")
    ig.log.Info("NUI", "/test-input - Test input dialog")
    ig.log.Info("NUI", "/test-context - Test context menu")
    ig.log.Info("NUI", "/test-hud-show - Show HUD")
    ig.log.Info("NUI", "/test-hud-hide - Hide HUD")
    ig.log.Info("NUI", "/test-hud-update - Update HUD with current stats")
    ig.log.Info("NUI", "/test-character-select - Test character select")
    ig.log.Info("NUI", "========================================")
end)
