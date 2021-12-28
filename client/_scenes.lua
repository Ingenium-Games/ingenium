local Scenes, Hidden, SettingScene = {}, false, false

Keys = {
    ["ESC"] = 200, --Esc/Backspace
}

RegisterNetEvent("Client:Scenes:Update", function(sent)
    Scenes = sent
end)

SceneTarget = function()
    local Cam = GetGameplayCamCoord()
    local handle = StartExpensiveSynchronousShapeTestLosProbe(Cam, GetCoordsFromCam(10.0, Cam), -1, PlayerPedId(), 4)
    local _, Hit, Coords, _, Entity = GetShapeTestResult(handle)
    return Coords
end

GetCoordsFromCam = function(distance, coords)
    local rotation = GetGameplayCamRot()
    local adjustedRotation = vector3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y, (math.pi / 180) * rotation.z)
    local direction = vector3(-math.sin(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.cos(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.sin(adjustedRotation[1]))
    return vector3(coords[1] + direction[1] * distance, coords[2] + direction[2] * distance, coords[3] + direction[3] * distance)
end

DrawScene = function(x, y, z, text, color)
    if not text or not x or not y or not z then return end
    local color = color or {r=211, g=211, b=211}
    local onScreen, gx, gy = GetScreenCoordFromWorldCoord(x, y, z)
    local dist = #(GetGameplayCamCoord() - vector3(x, y, z))
    
    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 55
    
        if onScreen then
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringKeyboardDisplay(text)
            SetTextColour(color.r, color.g, color.b, 255)
            SetTextScale(0.0 * scale, 0.50 * scale)
            SetTextFont(0)
            SetTextCentre(1)
            SetTextDropshadow(1, 0, 0, 0, 155)
            EndTextCommandDisplayText(gx, gy)
            
            local height = GetTextScaleHeight(1 * scale, 0) - 0.005
            local length = string.len(text)
            local limiter = 120
            if length > 98 then
                length = 98
                limiter = 200
            end
            local width = (length + 1) / limiter * scale
            DrawRect(gx, (gy + scale / 50), width, height, 0, 0, 0, 90)
        end
end

ClosestScene = function()
    local closestscene = 1000.0
    local ped = PlayerPedId()
    for i=1, #Scenes do
        local distance = #(GetOffsetFromEntityGivenWorldCoords(ped, vector3(Scenes[i].Coords.x, Scenes[i].Coords.y, Scenes[i].Coords.z)))
        if (distance < closestscene) then
            closestscene = distance
        end
    end
    return closestscene
end

ClosestSceneLooking = function()
    local closestscene = 1000.0
    local scanid = nil
    local coords = SceneTarget()
    for i=1, #Scenes do
        local distance = #(vector3(Scenes[i].Coords.x, Scenes[i].Coords.y, Scenes[i].Coords.z) - coords)
        if (distance < closestscene and distance < 8.5) then
            scanid = i
            closestscene = distance
        end
    end
    return scanid
end

CreateScene = function()
    if SettingScene then SettingScene = false return end
    local boss = LocalPlayer.state["Boss"]
    CreateThread(function()
        local x, y, z
        SettingScene = true
        while SettingScene do
            Wait(0)
            DisableControlAction(2, Keys["ESC"], true)
            x, y, z = table.unpack(SceneTarget())
            DrawMarker(28, x, y, z, 0, 0, 0, 0, 0, 0, 0.02, 0.02, 0.02, 15, 15, 15, 210, false, false)
            if IsDisabledControlJustReleased(2, Keys["ESC"]) then
                SettingScene = false
                return
            end
        end
        if x == nil or y == nil or z == nil then return end
        local keyboard, message, color, bool
        if boss then
            keyboard, message, color, bool = exports["ig.keyboard"]:Keyboard({
            header = "Add Scene",
            rows = {
                {"Message","text"},
                {"Colour","color"},
                {"Make Permanent?","checkbox"}
            }
        })
        else
            keyboard, message, color = exports["ig.keyboard"]:Keyboard({
                header = "Add Scene",
                rows = {
                    {"Message","text"},
                    {"Colour","color"},
                }
            })
        end
        if not keyboard then return end
        if not color then color = {r=211,g=211,b=211} end
        if not bool or bool == nil then bool = 0 else bool = 1 end
        TriggerServerEvent("Server:Scenes:Add", x, y, z, message, color, bool)
    end)
end

HideScenes = function()
    Hidden = not Hidden
    if Hidden then
        TriggerEvent("Client:Notify","Scenes Disabled")
    else
        TriggerEvent("Client:Notify","Scenes Enabled")
    end
end

DeleteScene = function()
    local scene = ClosestSceneLooking()
    if scene then
        TriggerServerEvent("Server:Scenes:Delete", scene)
    end
end

RegisterCommand("+scenecreate", function() end)
RegisterCommand("-scenecreate", CreateScene)
RegisterCommand("+scenehide", HideScenes)
RegisterCommand("-scenehide", function() end)
RegisterCommand("+scenedelete", DeleteScene)
RegisterCommand("-scenedelete", function() end)
RegisterKeyMapping("+scenecreate", "(scenes): Place Scene", "keyboard", "")
RegisterKeyMapping("+scenehide", "(scenes): Toggle Scenes", "keyboard", "")
RegisterKeyMapping("+scenedelete", "(scenes): Delete Scene", "keyboard", "")

Citizen.CreateThread(function()
    TriggerServerEvent("Server:Scenes:Fetch")
    while true do
        local wait = 0
        if #Scenes > 0 then
            if not Hidden then
                local closest = ClosestScene()
                if closest > 8.6 then
                    wait = 250
                else
                    for i=1, #Scenes do
                        local distance = #(GetOffsetFromEntityGivenWorldCoords(PlayerPedId(), vector3(Scenes[i].Coords.x, Scenes[i].Coords.y, Scenes[i].Coords.z)))
                        if distance <= 8.5 then
                            local success, err = pcall(function()
                                return DrawScene(Scenes[i].Coords.x, Scenes[i].Coords.y, Scenes[i].Coords.z, Scenes[i].Message, Scenes[i].Colour)
                            end)
                            if not success then
                                print(err)
                            end
                        end
                    end
                end
            else
                wait = 250
            end
        else
            wait = 250
        end
        Wait(wait)
    end
end)
