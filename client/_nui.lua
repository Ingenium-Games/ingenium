-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --
math.randomseed(c.Seed)
-- ====================================================================================--
-- Character Selections

local cam, cam2, cam3

RegisterNetEvent('Client:Character:Open')
AddEventHandler('Client:Character:Open', function(Command, Data)
    c.IsBusyPleaseWait(1000)
    SetNuiFocus(false, false)
    SetNuiFocus(true, true)
    SendNUIMessage({
        message = Command,
        packet = Data
    })
end)

RegisterNUICallback('Client:Character:Join', function(Data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('Server:Character:Join', Data.ID)
    cb("ok")
end)

-- Not currently in use...
RegisterNUICallback('Client:Character:Delete', function(Data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('Server:Character:Delete', Data.ID)
    cb("ok")
end)

RegisterNUICallback('Client:Character:Create', function(Data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('Server:Character:Create', Data.First_Name, Data.Last_Name, Data.Height, Data.Birth_Date)
    SetCamActive(cam,false)
    SetCamActive(cam2,false)
    SetCamActive(cam3,false)
    cb("ok")
end)

-- [C+S]
RegisterNetEvent('Client:Character:OpeningMenu')
AddEventHandler('Client:Character:OpeningMenu', function()
    -- Set false for switch command.
    c.data.SetLoadedStatus(false)
    SetEntityCoords(GetPlayerPed(-1), 0, 0, 0)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = c.camera.Basic(313.78, -1403.07, 189.53, 0.00, 0.00, 45.00, 100.00)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
end)

-- Respawn in on last saved coords.
-- [S]
RegisterNetEvent('Client:Character:ReSpawn')
AddEventHandler('Client:Character:ReSpawn', function(Character_ID, Coords)
    c.IsBusyPleaseWait(1500)
    SetEntityCoords(GetPlayerPed(-1), Coords.x, Coords.y, Coords.z)
    cam2 = c.camera.Basic(313.78, -1403.07, 189.53, 0.00, 0.00, 45.00, 100.00)
    PointCamAtCoord(cam2, Coords.x, Coords.y, Coords.z + 200)
    SetCamActiveWithInterp(cam2, cam, 900, 1, 1)
    c.IsBusyPleaseWait(900)
    cam3 = c.camera.Basic(Coords.x, Coords.y, Coords.z + 200, 300.00, 0.00, 0.00, 100.00)
    PointCamAtCoord(cam, Coords.x, Coords.y, Coords.z + 2)
    SetCamActiveWithInterp(cam3, cam2, 3700, 1, 1)
    c.IsBusyPleaseWait(3700)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, 1, 1)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    c.IsBusyPleaseWait(500)
    TriggerEvent("Client:LoadSkinFromSelf")
    SetCamActive(cam,false)
    SetCamActive(cam2,false)
    SetCamActive(cam3,false)
end)

-- ====================================================================================--
-- Notifications 

-- Send Update to HTML NUI Notification - Still to make.
-- [C+S]
RegisterNetEvent("Client:Notify")
AddEventHandler("Client:Notify", function(text,style,fade)
    if not style then style = 'normal' end
    if not fade then fade = 13500 end
    local noty = {text = text, style = style, fade = fade}
    SendNUIMessage({
        message = "OnNotify",
        notify = noty
    })
end)