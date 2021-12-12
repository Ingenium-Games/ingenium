-- ====================================================================================--

--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--

-- [C+S]
RegisterNetEvent("Client:Character:OpeningMenu")
AddEventHandler("Client:Character:OpeningMenu", function()
    -- Set false for switch command.
    c.data.SetLoadedStatus(false)
    SetFollowPedCamViewMode(4)
    SetEntityCoords(GetPlayerPed(-1), -43.57, 821.86, 231.33)
    SetGameplayCamRelativeRotation(8.1538953781128, 0.054131388664246, -70.471687316895)
    SetGameplayCamRelativeHeading(-0.092091433703899)
    SetGameplayCamRelativePitch(3.5341143608093 , 1.0)
    FreezeEntityPosition(GetPlayerPed(-1), true)
end)

-- [C+S]
RegisterNetEvent("Client:Character:Create")
AddEventHandler("Client:Character:Create", function()
    local plyped = PlayerPedId()
    SetEntityCoords(plyped, -703.9, -152.62, 37.42)
    SetEntityHeading(plyped, 62)
    DoScreenFadeOut(250)
    Wait(250)
    c.IsBusyPleaseWait(1000)
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
      }
      exports["fivem-appearance"]:startPlayerCustomization(function(appearance)
        if (appearance) then
            DoScreenFadeOut(250)
            Wait(250)
            SetEntityCoords(PlayerPedId(), 0, 0, 0)
            TriggerEvent("Client:Character:OpeningMenu")
            c.IsBusyPleaseWait(1000)
            DoScreenFadeIn(3000)
            c.IsBusyPleaseWait(2000)
            TriggerEvent("Client:Core:UI", "Register")
            c.IsBusyPleaseWait(1000)
        else
            TriggerServerEvent("Server:Character:Failed")
        end
      end, config)
      DoScreenFadeIn(3000)
      c.IsBusyPleaseWait(2000)
end)

-- Respawn in on last saved coords.
-- [S]
RegisterNetEvent("Client:Character:ReSpawn")
AddEventHandler("Client:Character:ReSpawn", function(Coords)
    SetFollowPedCamViewMode(0)
    SetEntityCoords(GetPlayerPed(-1), Coords.x, Coords.y, Coords.z)
    TriggerServerEvent("Server:Character:LoadSkin")
    DoScreenFadeIn(2000)
    c.IsBusyPleaseWait(1000)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    c.IsBusyPleaseWait(1000)
    FreezeEntityPosition(GetPlayerPed(-1), false)
end)

RegisterNetEvent("Client:Character:LoadSkin")
AddEventHandler("Client:Character:LoadSkin", function(appearance)
    exports["fivem-appearance"]:setPlayerAppearance(appearance)
end)

RegisterNetEvent("Client:Character:SaveSkin")
AddEventHandler("Client:Character:SaveSkin", function(bool)
    local appearance = exports["fivem-appearance"]:getPedAppearance(PlayerPedId())
    TriggerServerEvent("Server:Character:SaveSkin", appearance, bool)
end)

-- Event to receive the data of the chosen character for the client.
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function()
    local xPlayer = c.data.GetLocalPlayer()
    c.data.SetLoadedStatus(true)
    --
    c.chat.AddSuggestions(xPlayer)
    c.status.SetPlayer(xPlayer)
    c.modifier.SetModifiers(xPlayer)
    -- 
    TriggerEvent("Client:Character:Ready")
end)

-- Event to trigger other resources once the client has received the chosen characters data from the server.
RegisterNetEvent("Client:Character:Ready")
AddEventHandler("Client:Character:Ready", function()
    -- Character has loaded in, no need to respawn any more.
    exports.spawnmanager:setAutoSpawn(false)
    TriggerServerEvent("Server:Character:Ready")
end)

RegisterNetEvent("Client:Character:Pre-Switch")
AddEventHandler("Client:Character:Pre-Switch", function()
    --
    DoScreenFadeOut(500)
    c.IsBusyPleaseWait((c.sec * 5))
    DoScreenFadeIn(500)
    --    
end)

-- Use this to remove any things connected to Characters like police blips etc.
RegisterNetEvent("Client:Character:Switch")
AddEventHandler("Client:Character:Switch", function()
    --
    c.data.SetLoadedStatus(false)
    --
end)

RegisterNetEvent("Client:Character:OffDuty")
AddEventHandler("Client:Character:OffDuty", function()
    if conf.enableduty then
        -- Add Functions or Hooks here!

    else
        c.debug_3("Ability to go off duty has ben disabled.")
    end
end)

RegisterNetEvent("Client:Character:OnDuty")
AddEventHandler("Client:Character:OnDuty", function()
    if conf.enableduty then
        -- Add Functions or Hooks here!
    
    else
        c.debug_3("Ability to go on duty has ben disabled.")
    end
end)

RegisterNetEvent("Client:Character:SetJob")
AddEventHandler("Client:Character:SetJob", function(data)

end)

RegisterNetEvent("Client:Character:Death")
AddEventHandler("Client:Character:Death", function(data)
    if data.Log then
        -- agro = source id or -1 for server.
        local agro = data.Log.Source
        if data.Cause == "Weapon" then
            
        elseif data.Cause == "Vehicle" then

        elseif data.Cause == "Obejct" then

        end
    else
        
    end
end)