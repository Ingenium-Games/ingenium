-- ====================================================================================--


--[[
    Animations with Keybinding

    Example
    RegisterCommand("+cross", function() TriggerEvent("Client:Animation:CrossedArms", true, GetPlayerPed(-1)) end, false)
    RegisterCommand("-cross", function() TriggerEvent("Client:Animation:CrossedArms", false, GetPlayerPed(-1)) end, false)
    RegisterKeyMapping("+cross", "Cross arms", "keyboard", "z")
]]--

RegisterCommand("crossarms", function(source, args, rawCommand)
    TriggerEvent("Client:Animation:CrossedArms", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/crossarms")
RegisterKeyMapping("crossarms", "Cross arms", "keyboard", "NumPad1")

-- ====================================================================================--

RegisterCommand("handsup", function(source, args, rawCommand)
    TriggerEvent("Client:Animation:HandsUp", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/handsup")
RegisterKeyMapping("handsup", "Hands Up", "keyboard", "NumPad2")

-- ====================================================================================--

RegisterCommand("armhold", function(source, args, rawCommand)
    TriggerEvent("Client:Animation:ArmHold", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/armhold")
RegisterKeyMapping("armhold", "Arm Hold", "keyboard", "NumPad3")

-- ====================================================================================--

RegisterCommand("printcam", function(source, args, rawCommand)
    local pos = GetEntityCoords(PlayerPedId())
    local x,y,z = table.unpack(pos)
    local head = GetEntityHeading(PlayerPedId())
    local rx,ry,rz = table.unpack(GetGameplayCamCoord())
    local pitchx, pitchy, pitchz = table.unpack(GetGameplayCamRot(0))
    local rollx, rolly, rollz = table.unpack(GetGameplayCamRot(1))
    local yawx, yawy, yawz = table.unpack(GetGameplayCamRot(2))
    print('\n PLAYER \n GetEntityCoords() \n : '..x..','..y..','..z..' \n GetEntityHeading() \n :'..head)
    print('\n GAMECAM \n GetGameplayCamCoord() \n : '..rx..','..ry..','..rz..' \n GetGameplayCamRelativeHeading() \n : '..GetGameplayCamRelativeHeading()..' \n GetGameplayCamRelativePitch() \n : '..GetGameplayCamRelativePitch()..' \n GetGameplayCamFov() \n : '..GetGameplayCamFov()..'\n GetGameplayCamRot(0) \n : '..pitchx..','..pitchy..','..pitchz)
end, false)
