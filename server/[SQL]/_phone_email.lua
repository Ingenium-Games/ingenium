-- ====================================================================================--
-- Phone Email SQL Module
-- Manages email account and message persistence in database
-- ====================================================================================--

if not ig.sql.email then
    ig.sql.email = {}
end

-- ====================================================================================--
-- Email Account Management
-- ====================================================================================--

--- Create new email account
---@param characterId string Character ID
---@param emailAddress string Email address
---@param passwordHash string Hashed password
---@return boolean Success status
function ig.sql.email.CreateAccount(characterId, emailAddress, passwordHash)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
    local result = MySQL.insert.await([[
        INSERT INTO phone_email_accounts (Character_ID, Email_Address, Password_Hash, Created_At)
        VALUES (?, ?, ?, ?)
    ]], {
        characterId,
        emailAddress,
        passwordHash,
        timestamp
    })
    
    if result then
        ig.log.Info("Email", "Created email account: " .. emailAddress .. " for character: " .. characterId)
        return true
    else
        ig.log.Error("Email", "Failed to create email account for: " .. emailAddress)
        return false
    end
end

--- Get email account by email address
---@param emailAddress string Email address
---@return table|nil Account data or nil if not found
function ig.sql.email.GetAccount(emailAddress)
    local result = MySQL.query.await([[
        SELECT * FROM phone_email_accounts WHERE Email_Address = ?
    ]], {emailAddress})
    
    if result and result[1] then
        return result[1]
    end
    
    return nil
end

--- Get email account by character ID
---@param characterId string Character ID
---@return table|nil Account data or nil if not found
function ig.sql.email.GetAccountByCharacter(characterId)
    local result = MySQL.query.await([[
        SELECT * FROM phone_email_accounts WHERE Character_ID = ?
    ]], {characterId})
    
    if result and result[1] then
        return result[1]
    end
    
    return nil
end

--- Check if email address exists
---@param emailAddress string Email address
---@return boolean Exists
function ig.sql.email.AccountExists(emailAddress)
    local result = MySQL.scalar.await([[
        SELECT COUNT(*) FROM phone_email_accounts WHERE Email_Address = ?
    ]], {emailAddress})
    
    return result and result > 0
end

-- ====================================================================================--
-- Email Message Management
-- ====================================================================================--

--- Send an email
---@param sender string Sender email address
---@param recipient string Recipient email address
---@param subject string Email subject
---@param message string Email message body
---@return boolean Success status
function ig.sql.email.SendEmail(sender, recipient, subject, message)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    
    local result = MySQL.insert.await([[
        INSERT INTO phone_emails (Sender, Recipient, Subject, Message, Sent_At, Read_Status)
        VALUES (?, ?, ?, ?, ?, 0)
    ]], {
        sender,
        recipient,
        subject or "",
        message,
        timestamp
    })
    
    if result then
        ig.log.Info("Email", "Email sent from " .. sender .. " to " .. recipient)
        return true
    else
        ig.log.Error("Email", "Failed to send email from " .. sender .. " to " .. recipient)
        return false
    end
end

--- Get inbox emails for an email address
---@param emailAddress string Email address
---@return table Array of email objects
function ig.sql.email.GetInbox(emailAddress)
    local result = MySQL.query.await([[
        SELECT ID, Sender, Recipient, Subject, Message, Sent_At, Read_Status
        FROM phone_emails 
        WHERE Recipient = ? 
        ORDER BY Sent_At DESC
        LIMIT 100
    ]], {emailAddress})
    
    if result then
        return result
    end
    
    return {}
end

--- Get sent emails for an email address
---@param emailAddress string Email address
---@return table Array of email objects
function ig.sql.email.GetSent(emailAddress)
    local result = MySQL.query.await([[
        SELECT ID, Sender, Recipient, Subject, Message, Sent_At, Read_Status
        FROM phone_emails 
        WHERE Sender = ? 
        ORDER BY Sent_At DESC
        LIMIT 100
    ]], {emailAddress})
    
    if result then
        return result
    end
    
    return {}
end

--- Mark email as read
---@param emailId number Email ID
---@return boolean Success status
function ig.sql.email.MarkAsRead(emailId)
    local result = MySQL.update.await([[
        UPDATE phone_emails SET Read_Status = 1 WHERE ID = ?
    ]], {emailId})
    
    if result then
        ig.log.Debug("Email", "Email marked as read: " .. emailId)
        return true
    else
        ig.log.Error("Email", "Failed to mark email as read: " .. emailId)
        return false
    end
end

--- Get unread count for email address
---@param emailAddress string Email address
---@return number Unread count
function ig.sql.email.GetUnreadCount(emailAddress)
    local result = MySQL.scalar.await([[
        SELECT COUNT(*) FROM phone_emails 
        WHERE Recipient = ? AND Read_Status = 0
    ]], {emailAddress})
    
    return result or 0
end

--- Delete an email (if needed for future features)
---@param emailId number Email ID
---@return boolean Success status
function ig.sql.email.DeleteEmail(emailId)
    local result = MySQL.query.await([[
        DELETE FROM phone_emails WHERE ID = ?
    ]], {emailId})
    
    if result then
        ig.log.Info("Email", "Email deleted: " .. emailId)
        return true
    else
        ig.log.Error("Email", "Failed to delete email: " .. emailId)
        return false
    end
end

ig.log.Info("SQL", "Phone Email SQL module loaded")
