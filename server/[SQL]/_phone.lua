-- ====================================================================================--
-- Phone SQL Module
-- Manages phone data persistence in database
-- ====================================================================================--

if not ig.sql.phone then
    ig.sql.phone = {}
end

-- ====================================================================================--
-- Phone Data Retrieval
-- ====================================================================================--

--- Get phone data by IMEI
---@param imei string Phone IMEI (UUID)
---@return table|nil Phone data or nil if not found
function ig.sql.phone.Get(imei)
    local result = MySQL.query.await([[
        SELECT * FROM phones WHERE IMEI = ?
    ]], {imei})
    
    if result and result[1] then
        local phone = result[1]
        -- Parse JSON fields
        phone.Contacts = json.decode(phone.Contacts) or {}
        phone.CallHistory = json.decode(phone.CallHistory) or {}
        phone.Settings = json.decode(phone.Settings) or {
            planeMode = false,
            emergencyAlerts = true,
            provider = "Warstock"
        }
        return phone
    end
    
    return nil
end

--- Get phone data by phone number
---@param phoneNumber string Phone number
---@return table|nil Phone data or nil if not found
function ig.sql.phone.GetByNumber(phoneNumber)
    local result = MySQL.query.await([[
        SELECT * FROM phones WHERE Phone_Number = ?
    ]], {phoneNumber})
    
    if result and result[1] then
        local phone = result[1]
        -- Parse JSON fields
        phone.Contacts = json.decode(phone.Contacts) or {}
        phone.CallHistory = json.decode(phone.CallHistory) or {}
        phone.Settings = json.decode(phone.Settings) or {
            planeMode = false,
            emergencyAlerts = true,
            provider = "Warstock"
        }
        return phone
    end
    
    return nil
end

--- Get all phones owned by a character
---@param characterId string Character ID
---@return table Array of phone data
function ig.sql.phone.GetByCharacter(characterId)
    local result = MySQL.query.await([[
        SELECT * FROM phones WHERE Character_ID = ?
    ]], {characterId})
    
    if result then
        for i, phone in ipairs(result) do
            -- Parse JSON fields
            phone.Contacts = json.decode(phone.Contacts) or {}
            phone.CallHistory = json.decode(phone.CallHistory) or {}
            phone.Settings = json.decode(phone.Settings) or {
                planeMode = false,
                emergencyAlerts = true,
                provider = "Warstock"
            }
        end
        return result
    end
    
    return {}
end

-- ====================================================================================--
-- Phone Data Creation
-- ====================================================================================--

--- Create a new phone record
---@param data table Phone data {IMEI, Phone_Number, Character_ID}
---@return boolean, string Success status and IMEI
function ig.sql.phone.Create(data)
    local imei = data.IMEI or ig.rng.UUID()
    local phoneNumber = data.Phone_Number
    local characterId = data.Character_ID
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
    local defaultContacts = json.encode({})
    local defaultSettings = json.encode({
        planeMode = false,
        emergencyAlerts = true,
        provider = "Warstock"
    })
    
    local result = MySQL.insert.await([[
        INSERT INTO phones (IMEI, Phone_Number, Character_ID, Contacts, Settings, Created, Last_Used)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    ]], {
        imei,
        phoneNumber,
        characterId,
        defaultContacts,
        defaultSettings,
        timestamp,
        timestamp
    })
    
    if result then
        ig.log.Info("Phone", "Created phone with IMEI: " .. imei .. " for character: " .. characterId)
        return true, imei
    else
        ig.log.Error("Phone", "Failed to create phone for character: " .. characterId)
        return false, nil
    end
end

-- ====================================================================================--
-- Phone Data Updates
-- ====================================================================================--

--- Update phone contacts
---@param imei string Phone IMEI
---@param contacts table Array of contact objects
---@return boolean Success status
function ig.sql.phone.UpdateContacts(imei, contacts)
    local contactsJson = json.encode(contacts)
    
    local result = MySQL.update.await([[
        UPDATE phones SET Contacts = ?, Last_Used = ? WHERE IMEI = ?
    ]], {
        contactsJson,
        os.date("%Y-%m-%d %H:%M:%S"),
        imei
    })
    
    if result then
        ig.log.Debug("Phone", "Updated contacts for IMEI: " .. imei)
        return true
    else
        ig.log.Error("Phone", "Failed to update contacts for IMEI: " .. imei)
        return false
    end
end

--- Update phone settings
---@param imei string Phone IMEI
---@param settings table Settings object {planeMode, emergencyAlerts, provider}
---@return boolean Success status
function ig.sql.phone.UpdateSettings(imei, settings)
    local settingsJson = json.encode(settings)
    
    local result = MySQL.update.await([[
        UPDATE phones SET Settings = ?, Last_Used = ? WHERE IMEI = ?
    ]], {
        settingsJson,
        os.date("%Y-%m-%d %H:%M:%S"),
        imei
    })
    
    if result then
        ig.log.Debug("Phone", "Updated settings for IMEI: " .. imei)
        return true
    else
        ig.log.Error("Phone", "Failed to update settings for IMEI: " .. imei)
        return false
    end
end

--- Update phone owner
---@param imei string Phone IMEI
---@param characterId string New character ID
---@param phoneNumber string New phone number (optional)
---@return boolean Success status
function ig.sql.phone.UpdateOwner(imei, characterId, phoneNumber)
    local query = [[
        UPDATE phones SET Character_ID = ?, Phone_Number = ?, Last_Used = ? WHERE IMEI = ?
    ]]
    
    local result = MySQL.update.await(query, {
        characterId,
        phoneNumber,
        os.date("%Y-%m-%d %H:%M:%S"),
        imei
    })
    
    if result then
        ig.log.Info("Phone", "Updated owner for IMEI: " .. imei .. " to character: " .. characterId)
        return true
    else
        ig.log.Error("Phone", "Failed to update owner for IMEI: " .. imei)
        return false
    end
end

--- Update last used timestamp
---@param imei string Phone IMEI
---@return boolean Success status
function ig.sql.phone.UpdateLastUsed(imei)
    local result = MySQL.update.await([[
        UPDATE phones SET Last_Used = ? WHERE IMEI = ?
    ]], {
        os.date("%Y-%m-%d %H:%M:%S"),
        imei
    })
    
    return result ~= nil
end

--- Update phone call history
---@param imei string Phone IMEI
---@param callHistory table Array of call history objects
---@return boolean Success status
function ig.sql.phone.UpdateCallHistory(imei, callHistory)
    local callHistoryJson = json.encode(callHistory)
    
    local result = MySQL.update.await([[
        UPDATE phones SET CallHistory = ?, Last_Used = ? WHERE IMEI = ?
    ]], {
        callHistoryJson,
        os.date("%Y-%m-%d %H:%M:%S"),
        imei
    })
    
    if result then
        ig.log.Debug("Phone", "Updated call history for IMEI: " .. imei)
        return true
    else
        ig.log.Error("Phone", "Failed to update call history for IMEI: " .. imei)
        return false
    end
end

-- ====================================================================================--
-- Phone Data Deletion
-- ====================================================================================--

--- Delete a phone record
---@param imei string Phone IMEI
---@return boolean Success status
function ig.sql.phone.Delete(imei)
    local result = MySQL.query.await([[
        DELETE FROM phones WHERE IMEI = ?
    ]], {imei})
    
    if result then
        ig.log.Info("Phone", "Deleted phone with IMEI: " .. imei)
        return true
    else
        ig.log.Error("Phone", "Failed to delete phone with IMEI: " .. imei)
        return false
    end
end

-- ====================================================================================--
-- Utility Functions
-- ====================================================================================--

--- Check if a phone exists by IMEI
---@param imei string Phone IMEI
---@return boolean Exists
function ig.sql.phone.Exists(imei)
    local result = MySQL.scalar.await([[
        SELECT COUNT(*) FROM phones WHERE IMEI = ?
    ]], {imei})
    
    return result and result > 0
end

--- Get total phone count
---@return number Total phones
function ig.sql.phone.GetTotalCount()
    local result = MySQL.scalar.await([[
        SELECT COUNT(*) FROM phones
    ]])
    
    return result or 0
end

ig.log.Info("SQL", "Phone SQL module loaded")
