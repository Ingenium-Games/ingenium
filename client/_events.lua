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
RegisterNetEvent("Client:Character:Death")
AddEventHandler("Client:Character:Death", function(data)
    if (data.PlayerKill == true) then
        
    else
        
    end
end)

-- Event to receive the data of the chosen character for the client.
RegisterNetEvent('Client:Character:Loaded')
AddEventHandler('Client:Character:Loaded', function()
    local xPlayer = c.data.GetPlayer()
    c.data.SetLoadedStatus(true)
    --
    c.chat.AddSuggestions(xPlayer)
    c.status.SetPlayer(xPlayer)
    c.modifier.SetModifiers(xPlayer)
    --
    -- Trigger any events after the Ready State.
    TriggerEvent('Client:Character:Ready')
end)

-- Event to trigger other resources once the client has received the chosen characters data from the server.
RegisterNetEvent('Client:Character:Ready')
AddEventHandler('Client:Character:Ready', function()
    local ped = PlayerPedId()
    local ply = PlayerId()
    --
    SetMaxWantedLevel(0)
    SetPedMinGroundTimeForStungun(ped, 12500)
    SetCanAttackFriendly(ped, true, false)
    NetworkSetFriendlyFireOption(true)
    --
    TriggerServerEvent("Server:Character:Ready")
end)

-- Use this to remove any things connected to Characters like police blips etc.
RegisterNetEvent("Client:Character:Switch")
AddEventHandler("Client:Character:Switch", function()
    

end)

RegisterNetEvent("Client:Character:OffDuty")
AddEventHandler("Client:Character:OffDuty", function()
    if conf.enableduty then
        -- Add Functions or Hooks here!

    else
        c.debug("Ability to go off duty has ben disabled.")
    end
end)

RegisterNetEvent("Client:Character:OnDuty")
AddEventHandler("Client:Character:OnDuty", function()
    if conf.enableduty then
        -- Add Functions or Hooks here!
    
    else
        c.debug("Ability to go on duty has ben disabled.")
    end
end)