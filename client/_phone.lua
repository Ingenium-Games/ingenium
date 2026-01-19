-- ====================================================================================--
-- Phone Client Module
-- Handles client-side phone interactions, animations, and props
-- ====================================================================================--

if not ig.phone then
    ig.phone = {}
end

-- Phone state
ig.phone.isOpen = false
ig.phone.currentPhoneData = nil
ig.phone.phoneProp = nil
ig.phone.phoneAnim = nil

-- ====================================================================================--
-- Phone Animation and Prop Management
-- ====================================================================================--

--- Load animation dictionary
---@param dict string Animation dictionary name
local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
    end
end

--- Load phone prop model
local function LoadPhoneProp()
    local model = `prop_phone_ing`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    return model
end

--- Attach phone prop to player hand
local function AttachPhoneProp()
    local ped = PlayerPedId()
    
    -- Remove existing prop if any
    if ig.phone.phoneProp and DoesEntityExist(ig.phone.phoneProp) then
        DeleteEntity(ig.phone.phoneProp)
    end
    
    -- Create phone prop
    local model = LoadPhoneProp()
    local coords = GetEntityCoords(ped)
    ig.phone.phoneProp = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
    
    -- Attach to hand
    local boneIndex = GetPedBoneIndex(ped, 28422) -- Right hand bone
    AttachEntityToEntity(
        ig.phone.phoneProp,
        ped,
        boneIndex,
        0.0, 0.0, 0.0,     -- Position offset
        0.0, 0.0, 0.0,      -- Rotation offset
        true,               -- Soft pinning
        true,               -- Collision
        false,              -- Is ped
        true,               -- Vertex index
        1,                  -- Fix rotation
        true                -- Keep rotation
    )
    
    SetModelAsNoLongerNeeded(model)
end

--- Remove phone prop
local function RemovePhoneProp()
    if ig.phone.phoneProp and DoesEntityExist(ig.phone.phoneProp) then
        DeleteEntity(ig.phone.phoneProp)
        ig.phone.phoneProp = nil
    end
end

--- Play phone usage animation
local function PlayPhoneAnimation()
    local ped = PlayerPedId()
    
    -- Load animation
    LoadAnimDict("cellphone@")
    
    -- Play animation
    TaskPlayAnim(ped, "cellphone@", "cellphone_text_read_base", 8.0, -8.0, -1, 49, 0, false, false, false)
    
    ig.phone.phoneAnim = "cellphone@"
end

--- Stop phone animation
local function StopPhoneAnimation()
    if ig.phone.phoneAnim then
        local ped = PlayerPedId()
        StopAnimTask(ped, ig.phone.phoneAnim, "cellphone_text_read_base", 3.0)
        ig.phone.phoneAnim = nil
    end
end

-- ====================================================================================--
-- Phone UI Management
-- ====================================================================================--

--- Open phone UI
---@param phoneData table Phone data from server
function ig.phone.Open(phoneData)
    if ig.phone.isOpen then
        ig.log.Debug("Phone", "Phone already open")
        return
    end
    
    ig.phone.isOpen = true
    ig.phone.currentPhoneData = phoneData
    
    -- Play animation and attach prop
    AttachPhoneProp()
    PlayPhoneAnimation()
    
    -- Wait for animation to start
    Wait(500)
    
    -- Send phone data to NUI
    SendNUIMessage({
        message = "Client:NUI:PhoneOpen",
        data = phoneData
    })
    
    -- Enable NUI focus
    SetNuiFocus(true, true)
    
    ig.log.Debug("Phone", "Phone opened with IMEI: " .. phoneData.imei)
end

--- Close phone UI
function ig.phone.Close()
    if not ig.phone.isOpen then
        return
    end
    
    ig.phone.isOpen = false
    ig.phone.currentPhoneData = nil
    
    -- Hide NUI
    SendNUIMessage({
        message = "Client:NUI:PhoneClose",
        data = {}
    })
    
    -- Disable NUI focus
    SetNuiFocus(false, false)
    
    -- Remove prop and animation
    RemovePhoneProp()
    StopPhoneAnimation()
    
    ig.log.Debug("Phone", "Phone closed")
end

-- ====================================================================================--
-- Event Handlers
-- ====================================================================================--

--- Handle phone use event from server
RegisterNetEvent("Client:Phone:Use", function(phoneData)
    ig.phone.Open(phoneData)
end)

--- Handle phone close from NUI
RegisterNUICallback("NUI:Client:PhoneClose", function(data, cb)
    ig.phone.Close()
    cb({ok = true})
end)

--- Handle settings update from NUI
RegisterNUICallback("NUI:Client:PhoneUpdateSettings", function(data, cb)
    if not ig.phone.currentPhoneData then
        cb({ok = false, error = "No phone data"})
        return
    end
    
    -- Send to server for validation and persistence
    TriggerServerEvent("Server:Phone:UpdateSettings", ig.phone.currentPhoneData.imei, data.settings)
    
    -- Update local cache
    if ig.phone.currentPhoneData.settings then
        ig.phone.currentPhoneData.settings = data.settings
    end
    
    cb({ok = true})
end)

--- Handle contact add from NUI
RegisterNUICallback("NUI:Client:PhoneAddContact", function(data, cb)
    if not ig.phone.currentPhoneData then
        cb({ok = false, error = "No phone data"})
        return
    end
    
    -- Send to server for validation and persistence
    TriggerServerEvent("Server:Phone:AddContact", ig.phone.currentPhoneData.imei, data.contact)
    
    cb({ok = true})
end)

--- Handle contact update from NUI
RegisterNUICallback("NUI:Client:PhoneUpdateContact", function(data, cb)
    if not ig.phone.currentPhoneData then
        cb({ok = false, error = "No phone data"})
        return
    end
    
    -- Send to server for validation and persistence
    TriggerServerEvent("Server:Phone:UpdateContact", ig.phone.currentPhoneData.imei, data.contactId, data.contact)
    
    cb({ok = true})
end)

--- Handle contact delete from NUI
RegisterNUICallback("NUI:Client:PhoneDeleteContact", function(data, cb)
    if not ig.phone.currentPhoneData then
        cb({ok = false, error = "No phone data"})
        return
    end
    
    -- Send to server for validation and persistence
    TriggerServerEvent("Server:Phone:DeleteContact", ig.phone.currentPhoneData.imei, data.contactId)
    
    cb({ok = true})
end)

-- Close phone on ESC key (handled by NUI ESC handler)

ig.log.Info("Phone", "Phone client module loaded")
