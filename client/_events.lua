-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]] --

-- ====================================================================================--
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
    TriggerEvent("Client:LoadSkin", xPlayer.Appearance)
    TriggerEvent('Client:Character:Ready')
end)

-- Event to trigger other resources once the client has received the chosen characters data from the server.
RegisterNetEvent('Client:Character:Ready')
AddEventHandler('Client:Character:Ready', function()
    -- Character has loaded in, no need to respawn any more.
    exports.spawnmanager:setAutoSpawn(false)
    TriggerServerEvent("Server:Character:Ready")
end)

-- Use this to remove any things connected to Characters like police blips etc.
RegisterNetEvent("Client:Character:Switch")
AddEventHandler("Client:Character:Switch", function()
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