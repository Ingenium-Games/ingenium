-- ====================================================================================--
-- Phone Data Management Module
-- Handles phone data lifecycle and integration with inventory system
-- ====================================================================================--

if not ig.phone then
    ig.phone = {}
end

-- ====================================================================================--
-- Phone Number Generation
-- ====================================================================================--

--- Generate a unique phone number for a new phone device
--- Generates a 6-7 digit number and verifies uniqueness in database
---@return string|nil Phone number or nil if unable to generate unique number
function ig.phone.GeneratePhoneNumber()
    local maxAttempts = 10
    local attempts = 0
    
    repeat
        attempts = attempts + 1
        
        -- Generate a 6 or 7 digit phone number
        local length = math.random(6, 7)
        local phoneNumber = ig.rng.nums(length)
        
        -- Check if this number already exists
        local existing = ig.sql.phone.GetByNumber(phoneNumber)
        if not existing then
            ig.log.Debug("Phone", "Generated unique phone number: " .. phoneNumber)
            return phoneNumber
        end
        
        ig.log.Debug("Phone", "Phone number collision, retrying... (" .. attempts .. "/" .. maxAttempts .. ")")
    until attempts >= maxAttempts
    
    ig.log.Error("Phone", "Failed to generate unique phone number after " .. maxAttempts .. " attempts")
    return nil
end

-- ====================================================================================--
-- Phone Data Retrieval
-- ====================================================================================--

--- Get phone data from inventory item
--- Checks if item in player's inventory has phone data (IMEI) in Meta
---@param xPlayer table Player object
---@param position number Inventory position
---@return table|nil Phone data or nil if not found
function ig.phone.GetFromInventory(xPlayer, position)
    local item = xPlayer.GetItemFromPosition(position)
    if not item or item.Item ~= "Phone" then
        return nil
    end
    
    -- Check if phone has IMEI in meta
    if item.Meta and item.Meta.IMEI then
        local phoneData = ig.sql.phone.Get(item.Meta.IMEI)
        return phoneData
    end
    
    return nil
end

--- Get or create phone data for inventory item
--- If phone doesn't have IMEI, creates new phone record with generated phone number
---@param xPlayer table Player object
---@param position number Inventory position
---@return table|nil Phone data or nil on error
function ig.phone.GetOrCreate(xPlayer, position)
    local item = xPlayer.GetItemFromPosition(position)
    if not item or item.Item ~= "Phone" then
        ig.log.Error("Phone", "GetOrCreate: Item is not a phone")
        return nil
    end
    
    -- Check if phone already has IMEI
    if item.Meta and item.Meta.IMEI then
        local phoneData = ig.sql.phone.Get(item.Meta.IMEI)
        if phoneData then
            -- Update last used timestamp
            ig.sql.phone.UpdateLastUsed(item.Meta.IMEI)
            return phoneData
        end
        
        -- Phone IMEI exists but no database record - recreate
        ig.log.Warn("Phone", "Phone has IMEI but no database record, recreating")
    end
    
    -- Generate a unique phone number for this device
    local phoneNumber = ig.phone.GeneratePhoneNumber()
    if not phoneNumber then
        ig.log.Error("Phone", "Failed to generate phone number")
        return nil
    end
    
    -- Create new phone record with generated phone number
    local success, imei = ig.sql.phone.Create({
        Phone_Number = phoneNumber,
        Character_ID = xPlayer.Character_ID
    })
    
    if not success then
        ig.log.Error("Phone", "Failed to create phone record")
        return nil
    end
    
    -- Update inventory item meta with IMEI
    item.Meta = item.Meta or {}
    item.Meta.IMEI = imei
    item.Meta.About = "iFruit X - IMEI: " .. imei
    
    -- Update inventory (trigger dirty flag)
    xPlayer.UpdateInventoryItem(position, item)
    
    -- Retrieve and return the created phone data
    local phoneData = ig.sql.phone.Get(imei)
    
    ig.log.Info("Phone", "Created phone device with number " .. phoneNumber .. " for character " .. xPlayer.Character_ID)
    
    return phoneData
end

-- ====================================================================================--
-- Phone Settings Management
-- ====================================================================================--

--- Update phone settings
---@param imei string Phone IMEI
---@param settings table Settings object
---@return boolean Success status
function ig.phone.UpdateSettings(imei, settings)
    return ig.sql.phone.UpdateSettings(imei, settings)
end

--- Get phone settings
---@param imei string Phone IMEI
---@return table|nil Settings or nil
function ig.phone.GetSettings(imei)
    local phoneData = ig.sql.phone.Get(imei)
    if phoneData then
        return phoneData.Settings
    end
    return nil
end

--- Check if phone is in plane mode
---@param imei string Phone IMEI
---@return boolean Plane mode status
function ig.phone.IsPlaneMode(imei)
    local settings = ig.phone.GetSettings(imei)
    if settings then
        return settings.planeMode == true
    end
    return false
end

--- Check if emergency alerts are enabled
---@param imei string Phone IMEI
---@return boolean Emergency alerts status
function ig.phone.EmergencyAlertsEnabled(imei)
    local settings = ig.phone.GetSettings(imei)
    if settings then
        return settings.emergencyAlerts == true
    end
    return true -- Default to enabled
end

-- ====================================================================================--
-- Phone Contacts Management
-- ====================================================================================--

--- Update phone contacts
---@param imei string Phone IMEI
---@param contacts table Array of contact objects
---@return boolean Success status
function ig.phone.UpdateContacts(imei, contacts)
    return ig.sql.phone.UpdateContacts(imei, contacts)
end

--- Get phone contacts
---@param imei string Phone IMEI
---@return table|nil Contacts array or nil
function ig.phone.GetContacts(imei)
    local phoneData = ig.sql.phone.Get(imei)
    if phoneData then
        return phoneData.Contacts
    end
    return nil
end

--- Add a contact
---@param imei string Phone IMEI
---@param contact table Contact object {name, number, type, email}
---@return boolean Success status
function ig.phone.AddContact(imei, contact)
    local contacts = ig.phone.GetContacts(imei) or {}
    
    -- Validate contact
    if not contact.name or not contact.number then
        ig.log.Error("Phone", "Invalid contact data")
        return false
    end
    
    -- Add contact ID if not present
    contact.id = contact.id or ig.rng.UUID()
    contact.type = contact.type or "personal"
    contact.email = contact.email or ""
    
    table.insert(contacts, contact)
    return ig.phone.UpdateContacts(imei, contacts)
end

--- Remove a contact
---@param imei string Phone IMEI
---@param contactId string Contact ID
---@return boolean Success status
function ig.phone.RemoveContact(imei, contactId)
    local contacts = ig.phone.GetContacts(imei) or {}
    
    for i, contact in ipairs(contacts) do
        if contact.id == contactId then
            table.remove(contacts, i)
            return ig.phone.UpdateContacts(imei, contacts)
        end
    end
    
    ig.log.Warn("Phone", "Contact not found: " .. contactId)
    return false
end

--- Update a contact
---@param imei string Phone IMEI
---@param contactId string Contact ID
---@param updatedContact table Updated contact data
---@return boolean Success status
function ig.phone.UpdateContact(imei, contactId, updatedContact)
    local contacts = ig.phone.GetContacts(imei) or {}
    
    for i, contact in ipairs(contacts) do
        if contact.id == contactId then
            -- Keep the ID, update other fields
            contacts[i] = {
                id = contactId,
                name = updatedContact.name or contact.name,
                number = updatedContact.number or contact.number,
                type = updatedContact.type or contact.type,
                email = updatedContact.email or contact.email
            }
            return ig.phone.UpdateContacts(imei, contacts)
        end
    end
    
    ig.log.Warn("Phone", "Contact not found: " .. contactId)
    return false
end

-- ====================================================================================--
-- Phone Usage Event Handler
-- ====================================================================================--

--- Handle phone item usage
--- Called when player uses phone item from inventory
---@param source number Player source
---@param position number Inventory position
function ig.phone.Use(source, position)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        ig.log.Error("Phone", "Player not found")
        return
    end
    
    -- Get or create phone data
    local phoneData = ig.phone.GetOrCreate(xPlayer, position)
    if not phoneData then
        xPlayer.Notify("Failed to initialize phone", "red", 5000)
        return
    end
    
    -- Trigger client to show phone animation and prop
    -- Always use Phone_Number from database (device-tied)
    TriggerClientEvent("Client:Phone:Use", source, {
        imei = phoneData.IMEI,
        phoneNumber = phoneData.Phone_Number,
        contacts = phoneData.Contacts,
        settings = phoneData.Settings
    })
    
    ig.log.Debug("Phone", "Phone used by " .. xPlayer.Name .. " (IMEI: " .. phoneData.IMEI .. ", Number: " .. phoneData.Phone_Number .. ")")
end

-- ====================================================================================--
-- Initialize Phone Consumption Handler
-- ====================================================================================--

AddEventHandler("Inventory:Consume:Phone", function(source, position, quantity)
    ig.phone.Use(source, position)
end)

ig.log.Info("Phone", "Phone management module loaded")
