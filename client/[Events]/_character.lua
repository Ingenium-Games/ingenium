-- ====================================================================================--



-- ====================================================================================--

-- [C+S]
RegisterNetEvent("Client:Character:OpeningMenu")
AddEventHandler("Client:Character:OpeningMenu", function()
    ShutdownLoadingScreenNui()
    -- Set false for switch command
    local ped = GetPlayerPed(-1)
    ig.data.SetLoadedStatus(false)
    FreezeEntityPosition(ped, true)
    SetFollowPedCamViewMode(4)
    SetEntityCoords(ped, -43.143894195557, 822.04595947266, 231.33236694336)
    SetEntityHeading(ped, 288.78283691406)
    SetGameplayCamRelativeRotation(4.0307750701904,0.054180480539799,-71.305198669434)
    SetGameplayCamRelativeHeading(-0.091852381825447 )
    SetGameplayCamRelativePitch(4.0307726860046, 1.0)
end)

--[[
[    303234] [b2372_GTAProce]             MainThrd/  PLAYER 
[    303234] [b2372_GTAProce]             MainThrd/  GetEntityCoords() 
[    303234] [b2372_GTAProce]             MainThrd/  : -43.143894195557,822.04595947266,231.33236694336 
[    303234] [b2372_GTAProce]             MainThrd/  GetEntityHeading() 
[    303250] [b2372_GTAProce]             MainThrd/  :288.78283691406
[    303250] [b2372_GTAProce]             MainThrd/ 
[    303250] [b2372_GTAProce]             MainThrd/  GAMECAM 
[    303250] [b2372_GTAProce]             MainThrd/  GetGameplayCamCoord() 
[    303250] [b2372_GTAProce]             MainThrd/  : -43.096748352051,822.05139160156,231.98075866699 
[    303250] [b2372_GTAProce]             MainThrd/  GetGameplayCamRelativeHeading() 
[    303250] [b2372_GTAProce]             MainThrd/  : -0.091852381825447 
[    303250] [b2372_GTAProce]             MainThrd/  GetGameplayCamRelativePitch() 
[    303250] [b2372_GTAProce]             MainThrd/  : 4.0307726860046 
[    303250] [b2372_GTAProce]             MainThrd/  GetGameplayCamFov() 
[    303250] [b2372_GTAProce]             MainThrd/  : 50.0
[    303250] [b2372_GTAProce]             MainThrd/  GetGameplayCamRot(0) 
[    303250] [b2372_GTAProce]             MainThrd/  : 4.0307750701904,0.054180480539799,-71.305198669434
]]--

-- [C+S]
RegisterNetEvent("Client:Character:Create")
AddEventHandler("Client:Character:Create", function()
    local plyped = PlayerPedId()
    SetEntityCoords(plyped, -703.9, -152.62, 37.42)
    SetEntityHeading(plyped, 62)
    ig.func.FadeOut(1000)
    ig.func.IsBusyPleaseWait(1000)
    
    -- Use native appearance system
    local config = {
        allowModelChange = true,
        allowTattoos = true,
        isCharacterCreation = true,
        title = "Create Your Character"
    }
    
    -- Open appearance customization via callback
    ig.callback.TriggerCallback('Client:Appearance:Open', config)
    
    ig.func.FadeIn(1000)
    ig.func.IsBusyPleaseWait(1000)
end)

-- Respawn in on last saved coords.
-- [S]
RegisterNetEvent("Client:Character:ReSpawn")
AddEventHandler("Client:Character:ReSpawn", function(Coords)
    ig.func.FadeOut(1000)
    SetFollowPedCamViewMode(0)
    SetEntityCoords(GetPlayerPed(-1), Coords.x, Coords.y, Coords.z)
    SetEntityHeading(GetPlayerPed(-1), Coords.h)
    -- Use callback to load skin securely
    TriggerServerCallback({
        eventName = "Server:Character:LoadSkin",
        args = {},
        callback = function(result)
            if result and result.success and result.appearance then
                TriggerEvent("Client:Character:LoadSkin", result.appearance)
            end
        end
    })
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    ig.func.FadeIn(2000)
end)

RegisterNetEvent("Client:Character:NewSpawn")
AddEventHandler("Client:Character:NewSpawn", function()
    ig.func.FadeOut(1000)
    SetFollowPedCamViewMode(0)
    SetEntityCoords(GetPlayerPed(-1), conf.spawn.x, conf.spawn.y, conf.spawn.z)
    SetEntityHeading(GetPlayerPed(-1), conf.spawn.h)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    ig.func.FadeIn(2000)
end)

RegisterNetEvent("Client:Character:LoadSkin")
AddEventHandler("Client:Character:LoadSkin", function(appearance)
    -- Use native appearance system
    if appearance then
        ig.appearance.SetAppearance(appearance)
    end
end)

RegisterNetEvent("Client:Character:SaveSkin")
AddEventHandler("Client:Character:SaveSkin", function(bool)
    local appearance = exports["fivem-appearance"]:getPedAppearance(GetPlayerPed(-1))
    -- Use callback for secure save
    TriggerServerCallback({
        eventName = "Server:Character:SaveSkin",
        args = {appearance, bool},
        callback = function(result)
            if result and not result.success then
                print("^1Failed to save skin: " .. (result.error or "Unknown error") .. "^0")
            end
        end
    })
end)

-- Event to receive the data of the chosen character for the client.
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function()
    -- Wait for state to be synced to local character
    ig.func.IsBusyPleaseWait(5000)
    --
    -- 
    ig.data.SetLoadedStatus(true)
    ig.chat.AddSuggestions()
    ig.data.SetLocale()
    --
    ig.skill.SetSkills()
    ig.status.SetPlayer()
    ig.modifier.SetModifiers()
    -- 
    TriggerEvent("Client:Character:Ready")
end)

-- Event to trigger other resources once the client has received the chosen characters data from the server.
RegisterNetEvent("Client:Character:Ready")
AddEventHandler("Client:Character:Ready", function()
    -- Character has loaded in, no need to respawn any more.
    exports.spawnmanager:setAutoSpawn(false)
    TriggerServerEvent("Server:Character:Ready")
    exports["AdvancedParking"]:Enable(true)
    
    -- RP Mode specific initialization (migrated from ig.base)
    if conf.gamemode == "RP" then
        local ped = PlayerPedId()
        local ply = PlayerId()
        
        -- Set RP-specific native configurations
        SetMaxWantedLevel(0)
        SetPedMinGroundTimeForStungun(ped, 12500)
        SetCanAttackFriendly(ped, true, false)
        NetworkSetFriendlyFireOption(true)
        SetWeaponsNoAutoswap(true)
        SetWeaponsNoAutoreload(true)
        RemoveMultiplayerHudCash()
        
        ig.log.Info("Character", "RP Mode character initialization complete")
    end
    --
end)

RegisterNetEvent("Client:Character:Pre-Switch")
AddEventHandler("Client:Character:Pre-Switch", function()
    --
    ig.func.FadeOut(1000)
    --
    ig.func.FadeIn(2000)
    --
end)

-- Use this to remove any things connected to Characters like police blips etig.
RegisterNetEvent("Client:Character:Switch")
AddEventHandler("Client:Character:Switch", function()
    --
    ig.data.SetLoadedStatus(false)
    --
end)

RegisterNetEvent("Client:Character:OffDuty")
AddEventHandler("Client:Character:OffDuty", function()
    if conf.enableduty then
        -- Add Functions or Hooks here!
        
    else
        ig.log.Trace("Character", "Ability to go off duty has been disabled")
    end
end)

RegisterNetEvent("Client:Character:OnDuty")
AddEventHandler("Client:Character:OnDuty", function(job)
    if conf.enableduty then
        -- Add Functions or Hooks here!
       
    else
        ig.log.Trace("Character", "Ability to go on duty has been disabled")
    end
end)

RegisterNetEvent("Client:Character:SetJob")
AddEventHandler("Client:Character:SetJob", function(name, grade)

end)

RegisterNetEvent("Client:Character:Death")
AddEventHandler("Client:Character:Death", function(data)
    --
    if data.Log then
        -- agro = source id or -1 for server.
        local agro = data.Log.Source
        if data.Cause == "Weapon" then

        elseif data.Cause == "Vehicle" then

        elseif data.Cause == "Obejct" then

        end
    end
end)
