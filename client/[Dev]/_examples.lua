-- ====================================================================================--
-- Example Integration for Vue 3 NUI System
-- This file demonstrates how to use the client UI functions directly
-- ====================================================================================--

-- Example 1: Using notifications
RegisterCommand("test-notify", function()
    ig.ui.Send("Client:NUI:Notification", {
        text = "This is a test notification!",
        color = "green",
        fade = 5000
    })
end, false)

-- Example 2: Using menus
RegisterCommand("test-menu", function()
    ig.ui.ShowMenu({
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
        ig.ui.Send("Client:NUI:Notification", {
            text = "You selected Option 1!",
            color = "green",
            fade = 3000
        })
    elseif action == "option2" then
        ig.ui.Send("Client:NUI:Notification", {
            text = "You selected Option 2!",
            color = "blue",
            fade = 3000
        })
    end
end)

-- Example 3: Using input dialogs
RegisterCommand("test-input", function()
    ig.ui.ShowInput({
        title = "Enter Your Name",
        placeholder = "John Doe",
        maxLength = 50
    })
end, false)

-- Listen for input submission
RegisterNetEvent("Client:Input:Submit")
AddEventHandler("Client:Input:Submit", function(value)
    print("User entered:", value)
    ig.ui.Send("Client:NUI:Notification", {
        text = "You entered: " .. value,
        color = "green",
        fade = 3000
    })
end)

-- Example 4: Using context menus
RegisterCommand("test-context", function()
    ig.ui.ShowContext({
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
    ig.ui.Send("Client:NUI:Notification", {
        text = "Action: " .. action,
        color = "purple",
        fade = 3000
    })
end)

-- Example 5: Using HUD
RegisterCommand("test-hud-show", function()
    ig.ui.Send("Client:NUI:HUDShow", {})
    
    -- Update HUD with sample data
    ig.ui.Send("Client:NUI:HUDUpdate", {
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
    ig.ui.Send("Client:NUI:HUDHide", {})
end, false)

-- Example 6: Simulating HUD updates (like in a game loop)
RegisterCommand("test-hud-update", function()
    local health = GetEntityHealth(PlayerPedId())
    local armor = GetPedArmour(PlayerPedId())
    
    ig.ui.Send("Client:NUI:HUDUpdate", {
        health = math.floor((health - 100) / 100 * 100),
        armor = armor
    })
    
    ig.ui.Send("Client:NUI:Notification", {
        text = "HUD updated with current stats",
        color = "blue",
        fade = 3000
    })
end, false)

-- Example 7: Character select integration
RegisterCommand("test-character-select", function()
    ig.ui.Send("Client:NUI:CharacterSelectShow", {
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
    })
end, false)

-- Print help message
Citizen.CreateThread(function()
    Wait(5000)
    ig.log.Info("DEV", "========================================")
    ig.log.Info("DEV", "Vue 3 NUI Test Commands:")
    ig.log.Info("DEV", "/test-notify - Test notifications")
    ig.log.Info("DEV", "/test-menu - Test menu system")
    ig.log.Info("DEV", "/test-input - Test input dialog")
    ig.log.Info("DEV", "/test-context - Test context menu")
    ig.log.Info("DEV", "/test-hud-show - Show HUD")
    ig.log.Info("DEV", "/test-hud-hide - Hide HUD")
    ig.log.Info("DEV", "/test-hud-update - Update HUD with current stats")
    ig.log.Info("DEV", "/test-character-select - Test character select")
    ig.log.Info("DEV", "========================================")
end)
