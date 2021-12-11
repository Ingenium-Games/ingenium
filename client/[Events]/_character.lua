-- ====================================================================================--

--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--
local cam, cam2, cam3

-- [C+S]
RegisterNetEvent("Client:Character:OpeningMenu")
AddEventHandler("Client:Character:OpeningMenu", function()
    -- Set false for switch command.
    c.data.SetLoadedStatus(false)
    SetEntityCoords(GetPlayerPed(-1), 0, 0, 0)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    if cam == nil then
        cam = c.camera.Basic(313.78, -1403.07, 189.53, 0.00, 0.00, 45.00, 100.00)
    end
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end)


-- [C+S]
RegisterNetEvent("Client:Character:Create")
AddEventHandler("Client:Character:Create", function()
    DoScreenFadeOut(2000)
    c.IsBusyPleaseWait(2000)
    local plyped = PlayerPedId()
    SetEntityCoords(plyped, -703.9, -152.62, 37.42)
    SetEntityHeading(plyped, 62)
    DoScreenFadeIn(2000)
    c.IsBusyPleaseWait(2000)
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
            DoScreenFadeOut(2000)
            c.IsBusyPleaseWait(2000)
            TriggerEvent("Client:Character:OpeningMenu")
            SetEntityCoords(plyped, 0, 0, 0)
            DoScreenFadeIn(3000)
            c.IsBusyPleaseWait(2000)
            TriggerEvent("Client:Core:UI", "Register")
        else
            TriggerServerEvent("Server:Character:Failed")
        end
      end, config)
end)

-- Respawn in on last saved coords.
-- [S]
RegisterNetEvent("Client:Character:ReSpawn")
AddEventHandler("Client:Character:ReSpawn", function(Coords)
    c.IsBusyPleaseWait(1500)
    SetEntityCoords(GetPlayerPed(-1), Coords.x, Coords.y, Coords.z)
    cam2 = c.camera.Basic(313.78, -1403.07, 189.53, 0.00, 0.00, 45.00, 100.00)
    PointCamAtCoord(cam2, Coords.x, Coords.y, Coords.z + 200)
    SetCamActiveWithInterp(cam2, cam, 900, 1, 1)
    c.IsBusyPleaseWait(900)
    cam3 = c.camera.Basic(Coords.x, Coords.y, Coords.z + 200, 300.00, 0.00, 0.00, 100.00)
    PointCamAtCoord(cam, Coords.x, Coords.y, Coords.z + 2)
    SetCamActiveWithInterp(cam3, cam2, 3700, 1, 1)
    c.IsBusyPleaseWait(2700)
    --[[
            ADD YOUR RESPAWN SHIT BELOW
    ]]--
    
    TriggerServerEvent("Server:Character:LoadSkin")
    
    --[[
            ADD YOUR RESPAWN SHIT ABOVE
    ]]--
    c.IsBusyPleaseWait(1000)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, 1, 1)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    c.camera.CleanUp(cam)
    c.camera.CleanUp(cam2)
    c.camera.CleanUp(cam3)
    c.IsBusyPleaseWait(500)
end)

RegisterNetEvent("Client:Character:LoadSkin")
AddEventHandler("Client:Character:LoadSkin", function(appearance)
    exports["fivem-appearance"]:setPlayerAppearance(appearance)
end)

RegisterNetEvent("Client:Character:SaveSkin")
AddEventHandler("Client:Character:SaveSkin", function(appearance)
    local appearance = exports["fivem-appearance"]:getPedAppearance(PlayerPedId())
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