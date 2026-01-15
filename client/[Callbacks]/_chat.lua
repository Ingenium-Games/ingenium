-- ====================================================================================--
-- NUI Close Event Handlers
-- ====================================================================================--

-- Handle chat submit from NUI
RegisterNUICallback("chatSubmit", function(data, cb)
    cb("ok")
    if data and data.message then
        TriggerServerEvent("chat:message", data.message)
    end
end)

-- Handle chat close from NUI
RegisterNUICallback("chatClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)

-- Handle menu close from NUI
RegisterNUICallback("NUI:Client:MenuClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)

-- Handle input close from NUI
RegisterNUICallback("NUI:Client:InputClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)

-- Handle context close from NUI
RegisterNUICallback("NUI:Client:ContextClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)

-- Handle banking close from NUI
RegisterNUICallback("NUI:Client:BankingClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)

-- Handle appearance close from NUI
RegisterNUICallback("NUI:Client:AppearanceClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)

-- Handle target close from NUI
RegisterNUICallback("NUI:Client:TargetClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)

-- Handle garage close from NUI
RegisterNUICallback("NUI:Client:GarageClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)

-- Handle character select close from NUI
RegisterNUICallback("NUI:Client:CharacterSelectClose", function(data, cb)
    cb("ok")
    SetNuiFocus(false, false)
end)
