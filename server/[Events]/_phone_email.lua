-- ====================================================================================--
-- Phone Email Server Event Handlers
-- Handles server-side email events from client
-- ====================================================================================--

--- Validate email address format
---@param email string Email address
---@return boolean, string Valid status and error message
local function ValidateEmailFormat(email)
    if not email or type(email) ~= "string" then
        return false, "Email is required"
    end
    
    -- Check for @ symbol
    if not email:find("@") then
        return false, "Email must contain @"
    end
    
    -- Split by @
    local parts = {}
    for part in email:gmatch("[^@]+") do
        table.insert(parts, part)
    end
    
    if #parts ~= 2 then
        return false, "Email must contain exactly one @"
    end
    
    local username = parts[1]
    local domain = parts[2]
    
    -- Check username length (min 3 chars)
    if #username < 3 then
        return false, "Username must be at least 3 characters"
    end
    
    -- Check for invalid characters (only alphanumeric and dot allowed)
    if not username:match("^[a-zA-Z0-9%.]+$") then
        return false, "Invalid characters in username. Only letters, numbers, and . allowed"
    end
    
    -- Check domain has at least one dot
    if not domain:find("%.") then
        return false, "Domain must contain at least one ."
    end
    
    -- Check domain format
    if not domain:match("^[a-zA-Z0-9%.]+$") then
        return false, "Invalid characters in domain. Only letters, numbers, and . allowed"
    end
    
    return true, ""
end

--- Hash password (simple hash for game purposes)
---@param password string Plain text password
---@return string Hashed password
local function HashPassword(password)
    -- In production, use a proper hashing algorithm
    -- For FiveM game purposes, we'll use a simple hash
    local hash = 0
    for i = 1, #password do
        hash = hash + password:byte(i) * (i * 31)
    end
    return tostring(hash)
end

--- Verify password
---@param password string Plain text password
---@param hash string Stored password hash
---@return boolean Match status
local function VerifyPassword(password, hash)
    return HashPassword(password) == hash
end

-- ====================================================================================--
-- Email Account Registration
-- ====================================================================================--

RegisterNetEvent("Server:Email:Register", function(email, password)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Email", "Player not found for registration")
        return
    end
    
    -- Validate email format
    local valid, error = ValidateEmailFormat(email)
    if not valid then
        ig.log.Warn("Email", "Invalid email format from player: " .. xPlayer.Name .. " - " .. error)
        TriggerClientEvent("Client:Email:RegisterError", src, error)
        return
    end
    
    -- Validate password
    if not password or #password < 4 then
        TriggerClientEvent("Client:Email:RegisterError", src, "Password must be at least 4 characters")
        return
    end
    
    -- Check if email already exists
    if ig.sql.email.AccountExists(email) then
        ig.log.Warn("Email", "Email already exists: " .. email)
        TriggerClientEvent("Client:Email:RegisterError", src, "Email address already registered")
        return
    end
    
    -- Check if character already has an email account
    local existingAccount = ig.sql.email.GetAccountByCharacter(xPlayer.Character_ID)
    if existingAccount then
        ig.log.Warn("Email", "Character already has email account: " .. xPlayer.Character_ID)
        TriggerClientEvent("Client:Email:RegisterError", src, "You already have an email account: " .. existingAccount.Email_Address)
        return
    end
    
    -- Hash password
    local passwordHash = HashPassword(password)
    
    -- Create account
    local success = ig.sql.email.CreateAccount(xPlayer.Character_ID, email, passwordHash)
    
    if success then
        ig.log.Info("Email", "Email account registered: " .. email .. " for character: " .. xPlayer.Character_ID)
        
        -- Send success to client with empty inbox/sent
        TriggerClientEvent("Client:Email:RegisterSuccess", src, {
            email = email,
            inbox = {},
            sent = {}
        })
        
        xPlayer.Notify("Email account created successfully", "green", 3000)
    else
        ig.log.Error("Email", "Failed to create email account: " .. email)
        TriggerClientEvent("Client:Email:RegisterError", src, "Failed to create email account")
        xPlayer.Notify("Failed to create email account", "red", 3000)
    end
end)

-- ====================================================================================--
-- Email Account Login
-- ====================================================================================--

RegisterNetEvent("Server:Email:Login", function(email, password)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Email", "Player not found for login")
        return
    end
    
    -- Validate email format
    local valid, error = ValidateEmailFormat(email)
    if not valid then
        ig.log.Warn("Email", "Invalid email format from player: " .. xPlayer.Name .. " - " .. error)
        TriggerClientEvent("Client:Email:LoginError", src, error)
        return
    end
    
    -- Get account
    local account = ig.sql.email.GetAccount(email)
    if not account then
        ig.log.Warn("Email", "Email account not found: " .. email)
        TriggerClientEvent("Client:Email:LoginError", src, "Email or password incorrect")
        return
    end
    
    -- Verify password
    if not VerifyPassword(password, account.Password_Hash) then
        ig.log.Warn("Email", "Incorrect password for email: " .. email)
        TriggerClientEvent("Client:Email:LoginError", src, "Email or password incorrect")
        return
    end
    
    -- Get inbox and sent emails
    local inbox = ig.sql.email.GetInbox(email)
    local sent = ig.sql.email.GetSent(email)
    
    ig.log.Info("Email", "Email login successful: " .. email .. " (Character: " .. xPlayer.Character_ID .. ")")
    
    -- Send success to client
    TriggerClientEvent("Client:Email:LoginSuccess", src, {
        email = email,
        inbox = inbox,
        sent = sent
    })
end)

-- ====================================================================================--
-- Send Email
-- ====================================================================================--

RegisterNetEvent("Server:Email:Send", function(sender, recipient, subject, message)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Email", "Player not found for send email")
        return
    end
    
    -- Validate sender email format
    local valid, error = ValidateEmailFormat(sender)
    if not valid then
        ig.log.Warn("Email", "Invalid sender email format: " .. error)
        xPlayer.Notify("Invalid sender email", "red", 3000)
        return
    end
    
    -- Validate recipient email format
    valid, error = ValidateEmailFormat(recipient)
    if not valid then
        ig.log.Warn("Email", "Invalid recipient email format: " .. error)
        xPlayer.Notify("Invalid recipient email: " .. error, "red", 3000)
        return
    end
    
    -- Validate sender owns this email
    local senderAccount = ig.sql.email.GetAccount(sender)
    if not senderAccount or senderAccount.Character_ID ~= xPlayer.Character_ID then
        ig.log.Warn("Email", "Player trying to send from email they don't own: " .. sender)
        xPlayer.Notify("You don't own this email account", "red", 3000)
        return
    end
    
    -- Check if recipient exists
    if not ig.sql.email.AccountExists(recipient) then
        ig.log.Warn("Email", "Recipient email doesn't exist: " .. recipient)
        xPlayer.Notify("Recipient email address not found", "red", 3000)
        return
    end
    
    -- Validate message
    message = ig.check.String(message, 1, 5000)
    if not message then
        xPlayer.Notify("Message is required", "red", 3000)
        return
    end
    
    -- Validate subject (optional)
    subject = ig.check.String(subject, 0, 200) or ""
    
    -- Send email
    local success = ig.sql.email.SendEmail(sender, recipient, subject, message)
    
    if success then
        ig.log.Info("Email", "Email sent from " .. sender .. " to " .. recipient)
        
        -- Update sender's sent list
        local sent = ig.sql.email.GetSent(sender)
        TriggerClientEvent("Client:Email:SentUpdated", src, sent)
        
        -- Notify recipient if online
        local recipientAccount = ig.sql.email.GetAccount(recipient)
        if recipientAccount then
            -- Find online player with this character
            for _, playerId in ipairs(GetPlayers()) do
                local recipientPlayer = ig.data.GetPlayer(tonumber(playerId))
                if recipientPlayer and recipientPlayer.Character_ID == recipientAccount.Character_ID then
                    -- Update recipient's inbox
                    local inbox = ig.sql.email.GetInbox(recipient)
                    TriggerClientEvent("Client:Email:InboxUpdated", tonumber(playerId), inbox)
                    recipientPlayer.Notify("New email from " .. sender, "blue", 3000)
                    break
                end
            end
        end
        
        xPlayer.Notify("Email sent successfully", "green", 3000)
    else
        ig.log.Error("Email", "Failed to send email from " .. sender .. " to " .. recipient)
        xPlayer.Notify("Failed to send email", "red", 3000)
    end
end)

-- ====================================================================================--
-- Mark Email as Read
-- ====================================================================================--

RegisterNetEvent("Server:Email:MarkRead", function(emailId)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("Email", "Player not found for mark read")
        return
    end
    
    -- Validate email ID
    emailId = ig.check.Number(emailId, 1, 999999999)
    if not emailId then
        ig.log.Warn("Email", "Invalid email ID from player: " .. xPlayer.Name)
        return
    end
    
    -- Mark as read
    local success = ig.sql.email.MarkAsRead(emailId)
    
    if success then
        ig.log.Debug("Email", "Email marked as read: " .. emailId .. " by character: " .. xPlayer.Character_ID)
    else
        ig.log.Error("Email", "Failed to mark email as read: " .. emailId)
    end
end)

-- ====================================================================================--
-- Email Logout
-- ====================================================================================--

RegisterNetEvent("Server:Email:Logout", function()
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    ig.log.Debug("Email", "Email logout for character: " .. xPlayer.Character_ID)
end)

ig.log.Info("Email", "Phone Email server event handlers loaded")
