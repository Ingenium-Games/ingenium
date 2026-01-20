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
-- HUD drag mode state (managed by nui/lua/hud.lua command)
-- This file only handles the NUI callback for SetNuiFocus

-- Handle NUI callback to set focus (NUI can't call natives directly)
RegisterNUICallback('NUI:Client:HUDSetFocus', function(data, cb)
    cb(1)
    local timestamp = GetGameTimer()
    print(string.format("^3[HUD @ %d] NUI Callback received, focused=%s^7", timestamp, tostring(data.focused)))
    
    if data.focused then
        SetNuiFocus(true, true)
        print(string.format("^3[HUD @ %d] SetNuiFocus(true, true) called, IsNuiFocused()=%s^7", timestamp, tostring(IsNuiFocused())))
    else
        SetNuiFocus(false, false)
        print(string.format("^3[HUD @ %d] SetNuiFocus(false, false) called, IsNuiFocused()=%s^7", timestamp, tostring(IsNuiFocused())))
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
