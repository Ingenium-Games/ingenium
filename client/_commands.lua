-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--

--[[
    Animations with Keybinding

    Example
    RegisterCommand('+cross', function() TriggerEvent("Client:Animation:CrossedArms", true, GetPlayerPed(-1)) end, false)
    RegisterCommand('-cross', function() TriggerEvent("Client:Animation:CrossedArms", false, GetPlayerPed(-1)) end, false)
    RegisterKeyMapping('+cross', 'Cross arms', 'keyboard', 'z')
]]--

RegisterCommand('crossarms', function(source, args, rawCommand)
    TriggerEvent("Client:Animation:CrossedArms", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/crossarms")
RegisterKeyMapping('crossarms', 'Cross arms', 'keyboard', 'NumPad1')

-- ====================================================================================--

RegisterCommand('handsup', function(source, args, rawCommand)
    TriggerEvent("Client:Animation:HandsUp", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/handsup")
RegisterKeyMapping('handsup', 'Hands Up', 'keyboard', 'NumPad2')

-- ====================================================================================--

RegisterCommand('armhold', function(source, args, rawCommand)
    TriggerEvent("Client:Animation:ArmHold", true, GetPlayerPed(-1))
end, false)
TriggerEvent("chat:removeSuggestion", "/armhold")
RegisterKeyMapping('armhold', 'Arm Hold', 'keyboard', 'NumPad3')

-- ====================================================================================--

RegisterCommand('car', function(source, args, rawCommand)
    local car = args[1]
    local pos = GetEntityCoords(PlayerPedId())
    local head = GetEntityHeading(PlayerPedId())
    local entity, net = c.CreateVehicle(car, pos.x, pos.y, pos.z, head)
end, false)


RegisterCommand('hp', function(source, args, rawCommand)
    local hp = GetEntityHealth(GetPlayerPed(-1))
    local otherhp = GetEntityHealth(PlayerPedId())
    local maxhpped1 = GetPedMaxHealth(GetPlayerPed(-1))
    local maxhpped2 = GetPedMaxHealth(PlayerPedId())  
    local maxhpped3 = GetEntityMaxHealth(GetPlayerPed(-1))
    local maxhpped4 = GetEntityMaxHealth(PlayerPedId())  
    print(hp)
    print(otherhp)
    print(maxhpped1)
    print(maxhpped2)
    print(maxhpped3)
    print(maxhpped4)

end, false)