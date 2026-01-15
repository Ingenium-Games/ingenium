-- ====================================================================================--
-- Character NUI Callbacks - Handle messages from the Character Select NUI
-- ====================================================================================--

-- Handle character creation from NUI
RegisterNUICallback("NUI:Client:CharacterCreate", function(data, cb)
    cb("ok")
    
    if data and data.firstName and data.lastName then
        -- Trigger server character registration with appearance data
        local appearance = exports["fivem-appearance"]:getPedAppearance(GetPlayerPed(-1))
        TriggerServerEvent("Server:Character:Register", data.firstName, data.lastName, appearance)
    else
        TriggerServerEvent("Server:Character:Failed")
    end
end)

-- Handle character play/join from NUI
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    cb("ok")
    
    if data and data.id then
        TriggerServerEvent("Server:Character:Join", data.id)
    else
        TriggerServerEvent("Server:Character:Failed")
    end
end)

-- Handle character delete from NUI
RegisterNUICallback("NUI:Client:CharacterDelete", function(data, cb)
    cb("ok")
    
    if data and data.id then
        TriggerServerEvent("Server:Character:Delete", data.id)
    end
end)
