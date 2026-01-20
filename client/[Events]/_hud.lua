-- ====================================================================================--
-- HUD Management
-- ====================================================================================--

local hudVisible = false
local hudDragMode = false

-- Show HUD when character is loaded
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function()
    -- Show the HUD
    ig.ui.ShowHUD()
    hudVisible = true
    
    -- Initial HUD update with default values
    ig.ui.UpdateHUD({
        health = 100,
        armor = 0,
        hunger = 100,
        thirst = 100,
        stress = 0
    })
end)

-- Hide HUD when character is unloaded
RegisterNetEvent("Client:Character:Unloaded")
AddEventHandler("Client:Character:Unloaded", function()
    ig.ui.HideHUD()
    hudVisible = false
    hudDragMode = false
end)

-- Toggle HUD drag mode with F2
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if hudVisible and IsControlJustPressed(0, 289) then -- F2 key
            hudDragMode = not hudDragMode
            
            print("^3[HUD] F2 pressed, hudDragMode:", hudDragMode, "^7")
            
            ig.ui.Send("Client:NUI:HUDFocus", {}, hudDragMode)
            
            print("^3[HUD] Sent HUDFocus message to NUI^7")
            
            if hudDragMode then
                ig.ui.Notify("HUD drag mode enabled. Click and drag to reposition.", "green", 3000)
            else
                ig.ui.Notify("HUD drag mode disabled. Position saved.", "blue", 3000)
            end
        end
    end
end)

-- Continuously update HUD with player stats
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) -- Update every second
        
        if hudVisible and LocalPlayer.state.Character_ID then
            local ped = PlayerPedId()
            local state = LocalPlayer.state
            
            -- Get player data from statebag
            local health = state.Health or 0
            local armor = GetPedArmour(ped) or 0
            local hunger = state.Hunger or 100
            local thirst = state.Thirst or 100
            local stress = state.Stress or 0
            
            -- Update HUD
            ig.ui.UpdateHUD({
                health = health,
                armor = armor,
                hunger = hunger,
                thirst = thirst,
                stress = stress
            })
        end
    end
end)

-- Command to reset HUD position
RegisterCommand("hudreset", function()
    if hudVisible then
        SendNUIMessage({
            message = "Client:NUI:HUDResetPosition",
            data = {}
        })
        ig.ui.Notify("HUD position reset to default", "green", 3000)
    else
        ig.ui.Notify("HUD is not visible", "red", 3000)
    end
end, false)
