-- ====================================================================================--
-- Phone Server Event Handlers
-- Handles server-side phone events from client
-- ====================================================================================--

--- Handle settings update from client
RegisterNetEvent("Server:Phone:UpdateSettings", function(imei, settings)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Phone", "Player not found for settings update")
        return
    end
    
    -- Validate IMEI format (UUID)
    if not imei or type(imei) ~= "string" or #imei < 36 then
        ig.log.Warn("Phone", "Invalid IMEI format from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate settings structure
    if type(settings) ~= "table" then
        ig.log.Warn("Phone", "Invalid settings structure from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate individual settings
    local validatedSettings = {
        planeMode = ig.check.Boolean(settings.planeMode) or false,
        emergencyAlerts = ig.check.Boolean(settings.emergencyAlerts) or true,
        provider = ig.check.String(settings.provider) or "Warstock"
    }
    
    -- Update in database
    local success = ig.phone.UpdateSettings(imei, validatedSettings)
    
    if success then
        ig.log.Debug("Phone", "Settings updated for IMEI: " .. imei)
        
        -- Send confirmation to client
        TriggerClientEvent("Client:Phone:SettingsUpdated", src, validatedSettings)
    else
        ig.log.Error("Phone", "Failed to update settings for IMEI: " .. imei)
        xPlayer.Notify("Failed to update phone settings", "red", 3000)
    end
end)

--- Handle add contact from client
RegisterNetEvent("Server:Phone:AddContact", function(imei, contact)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Phone", "Player not found for add contact")
        return
    end
    
    -- Validate IMEI
    if not imei or type(imei) ~= "string" or #imei < 36 then
        ig.log.Warn("Phone", "Invalid IMEI format from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate contact structure
    if type(contact) ~= "table" or not contact.name or not contact.number then
        ig.log.Warn("Phone", "Invalid contact data from player: " .. xPlayer.Name)
        xPlayer.Notify("Invalid contact data", "red", 3000)
        return
    end
    
    -- Validate and sanitize contact fields
    local validatedContact = {
        name = ig.check.String(contact.name, 1, 50),
        number = ig.check.String(contact.number, 6, 7), -- Phone numbers are 6-7 digits
        type = ig.check.String(contact.type) == "work" and "work" or "personal",
        email = ig.check.String(contact.email, 0, 100) or ""
    }
    
    if not validatedContact.name or not validatedContact.number then
        xPlayer.Notify("Invalid contact information", "red", 3000)
        return
    end
    
    -- Add contact
    local success = ig.phone.AddContact(imei, validatedContact)
    
    if success then
        ig.log.Debug("Phone", "Contact added for IMEI: " .. imei .. " (" .. validatedContact.name .. ")")
        
        -- Get updated contacts and send to client
        local contacts = ig.phone.GetContacts(imei)
        TriggerClientEvent("Client:Phone:ContactsUpdated", src, contacts)
        
        xPlayer.Notify("Contact added", "green", 3000)
    else
        ig.log.Error("Phone", "Failed to add contact for IMEI: " .. imei)
        xPlayer.Notify("Failed to add contact", "red", 3000)
    end
end)

--- Handle update contact from client
RegisterNetEvent("Server:Phone:UpdateContact", function(imei, contactId, contact)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Phone", "Player not found for update contact")
        return
    end
    
    -- Validate IMEI
    if not imei or type(imei) ~= "string" or #imei < 36 then
        ig.log.Warn("Phone", "Invalid IMEI format from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate contact ID
    if not contactId or type(contactId) ~= "string" then
        ig.log.Warn("Phone", "Invalid contact ID from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate contact structure
    if type(contact) ~= "table" then
        ig.log.Warn("Phone", "Invalid contact data from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate and sanitize contact fields
    local validatedContact = {
        name = ig.check.String(contact.name, 1, 50),
        number = ig.check.String(contact.number, 6, 7),
        type = ig.check.String(contact.type) == "work" and "work" or "personal",
        email = ig.check.String(contact.email, 0, 100) or ""
    }
    
    -- Update contact
    local success = ig.phone.UpdateContact(imei, contactId, validatedContact)
    
    if success then
        ig.log.Debug("Phone", "Contact updated for IMEI: " .. imei .. " (ID: " .. contactId .. ")")
        
        -- Get updated contacts and send to client
        local contacts = ig.phone.GetContacts(imei)
        TriggerClientEvent("Client:Phone:ContactsUpdated", src, contacts)
        
        xPlayer.Notify("Contact updated", "green", 3000)
    else
        ig.log.Error("Phone", "Failed to update contact for IMEI: " .. imei)
        xPlayer.Notify("Failed to update contact", "red", 3000)
    end
end)

--- Handle delete contact from client
RegisterNetEvent("Server:Phone:DeleteContact", function(imei, contactId)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Phone", "Player not found for delete contact")
        return
    end
    
    -- Validate IMEI
    if not imei or type(imei) ~= "string" or #imei < 36 then
        ig.log.Warn("Phone", "Invalid IMEI format from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate contact ID
    if not contactId or type(contactId) ~= "string" then
        ig.log.Warn("Phone", "Invalid contact ID from player: " .. xPlayer.Name)
        return
    end
    
    -- Delete contact
    local success = ig.phone.RemoveContact(imei, contactId)
    
    if success then
        ig.log.Debug("Phone", "Contact deleted for IMEI: " .. imei .. " (ID: " .. contactId .. ")")
        
        -- Get updated contacts and send to client
        local contacts = ig.phone.GetContacts(imei)
        TriggerClientEvent("Client:Phone:ContactsUpdated", src, contacts)
        
        xPlayer.Notify("Contact deleted", "green", 3000)
    else
        ig.log.Error("Phone", "Failed to delete contact for IMEI: " .. imei)
        xPlayer.Notify("Failed to delete contact", "red", 3000)
    end
end)

--- Handle initiate call from client
RegisterNetEvent("Server:Phone:InitiateCall", function(imei, targetNumber)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Phone", "Player not found for initiate call")
        return
    end
    
    -- Validate IMEI
    if not imei or type(imei) ~= "string" or #imei < 36 then
        ig.log.Warn("Phone", "Invalid IMEI format from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate target number
    if not targetNumber or type(targetNumber) ~= "string" or #targetNumber < 6 or #targetNumber > 7 then
        ig.log.Warn("Phone", "Invalid target number from player: " .. xPlayer.Name)
        xPlayer.Notify("Invalid phone number", "red", 3000)
        return
    end
    
    -- Check if phone is in plane mode
    if ig.phone.IsPlaneMode(imei) then
        xPlayer.Notify("Cannot make calls in plane mode", "red", 3000)
        return
    end
    
    -- Find target player by phone number
    local targetPhoneData = ig.sql.phone.GetByNumber(targetNumber)
    if not targetPhoneData then
        xPlayer.Notify("This number does not exist", "red", 3000)
        return
    end
    
    -- Find target player online
    local targetPlayer = nil
    for _, playerId in ipairs(GetPlayers()) do
        local tPlayer = ig.data.GetPlayer(tonumber(playerId))
        if tPlayer and tPlayer.Character_ID == targetPhoneData.Character_ID then
            targetPlayer = tPlayer
            break
        end
    end
    
    if not targetPlayer then
        xPlayer.Notify("This number is not available", "red", 3000)
        return
    end
    
    -- Check if target is in plane mode
    if ig.phone.IsPlaneMode(targetPhoneData.IMEI) then
        xPlayer.Notify("This number is not available", "red", 3000)
        return
    end
    
    -- Generate call ID
    local callId = ig.rng.UUID()
    
    -- Get caller's phone number
    local callerPhoneData = ig.sql.phone.Get(imei)
    if not callerPhoneData then
        xPlayer.Notify("Failed to initiate call", "red", 3000)
        return
    end
    
    -- Initiate call via VOIP system
    ig.voip.server.StartCall(src, targetPlayer.source, callId)
    
    -- Send call events to both parties
    TriggerClientEvent("Client:Phone:CallOutgoing", src, {
        callId = callId,
        targetNumber = targetNumber
    })
    
    TriggerClientEvent("Client:Phone:CallIncoming", targetPlayer.source, {
        callId = callId,
        callerNumber = callerPhoneData.Phone_Number
    })
    
    ig.log.Debug("Phone", "Call initiated from " .. callerPhoneData.Phone_Number .. " to " .. targetNumber)
end)

--- Handle answer call from client
RegisterNetEvent("Server:Phone:AnswerCall", function(imei, callId)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Phone", "Player not found for answer call")
        return
    end
    
    -- Validate IMEI
    if not imei or type(imei) ~= "string" or #imei < 36 then
        ig.log.Warn("Phone", "Invalid IMEI format from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate call ID
    if not callId or type(callId) ~= "string" then
        ig.log.Warn("Phone", "Invalid call ID from player: " .. xPlayer.Name)
        return
    end
    
    -- Answer call via VOIP system
    ig.voip.server.AnswerCall(src, callId)
    
    ig.log.Debug("Phone", "Call answered: " .. callId)
end)

--- Handle end call from client
RegisterNetEvent("Server:Phone:EndCall", function(imei, callId)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Phone", "Player not found for end call")
        return
    end
    
    -- Validate IMEI
    if not imei or type(imei) ~= "string" or #imei < 36 then
        ig.log.Warn("Phone", "Invalid IMEI format from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate call ID
    if not callId or type(callId) ~= "string" then
        ig.log.Warn("Phone", "Invalid call ID from player: " .. xPlayer.Name)
        return
    end
    
    -- End call via VOIP system
    ig.voip.server.EndCall(src)
    
    ig.log.Debug("Phone", "Call ended: " .. callId)
end)

--- Handle delete call history from client
RegisterNetEvent("Server:Phone:DeleteCallHistory", function(imei, callId)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Phone", "Player not found for delete call history")
        return
    end
    
    -- Validate IMEI
    if not imei or type(imei) ~= "string" or #imei < 36 then
        ig.log.Warn("Phone", "Invalid IMEI format from player: " .. xPlayer.Name)
        return
    end
    
    -- Validate call ID
    if not callId or type(callId) ~= "string" then
        ig.log.Warn("Phone", "Invalid call ID from player: " .. xPlayer.Name)
        return
    end
    
    -- Delete call history entry
    local success = ig.phone.DeleteCallHistory(imei, callId)
    
    if success then
        ig.log.Debug("Phone", "Call history deleted for IMEI: " .. imei .. " (ID: " .. callId .. ")")
        
        -- Get updated call history and send to client
        local callHistory = ig.phone.GetCallHistory(imei)
        TriggerClientEvent("Client:Phone:CallHistoryUpdated", src, callHistory)
    else
        ig.log.Error("Phone", "Failed to delete call history for IMEI: " .. imei)
    end
end)

ig.log.Info("Phone", "Phone server event handlers loaded")
