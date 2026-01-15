-- ====================================================================================--
-- Transaction Logging and Rate Limiting System (ig.security initialized in server/_var.lua)
-- Provides audit trail and anti-spam protection for financial transactions
-- ====================================================================================--

-- Transaction log storage (in production, this should write to database)
local transactionLog = {}

-- Rate limiting cooldowns
local transactionCooldowns = {}

-- Fraud detection: player transaction history
local playerTransactionHistory = {}

-- ====================================================================================--
-- Transaction Logging
-- ====================================================================================--

--- Log a financial transaction
---@param player table Player object
---@param transactionType string Type of transaction (e.g., "add_cash", "remove_cash", "set_bank")
---@param amount number Transaction amount
---@param reason string Reason for transaction
function ig.security.LogTransaction(player, transactionType, amount, reason)
    if not player then
        ig.log.Warn("SECURITY", "LogTransaction called with nil player")
        return
    end
    
    local log = {
        timestamp = os.time(),
        player_id = player.GetCharacter_ID and player.GetCharacter_ID() or "no_character_id",
        source = player.ID or "no_source_id",
        type = transactionType,
        amount = amount,
        reason = reason or "API call",
        before_cash = transactionType:match("cash") and player.GetCash and player.GetCash() or nil,
        before_bank = transactionType:match("bank") and player.GetBank and player.GetBank() or nil
    }
    
    -- Validate critical fields
    if log.player_id == "no_character_id" or log.source == "no_source_id" then
        ig.log.Warn("SECURITY", "Transaction logged with missing player info: %s from source %s", log.player_id, log.source)
    end
    
    -- Store in memory (in production, write to database)
    table.insert(transactionLog, log)
    
    -- Trigger event for external logging systems
    TriggerEvent("txaLogger:LogTransaction", log)
    
    -- Detect suspicious activity
    ig.security.DetectSuspiciousActivity(player, transactionType, amount)
end

-- ====================================================================================--
-- Rate Limiting
-- ====================================================================================--

--- Check if transaction is rate limited
---@param playerId number Player source ID
---@param transactionType string Type of transaction
---@return boolean isLimited True if rate limit is active
function ig.security.CheckRateLimit(playerId, transactionType)
    local cooldownKey = playerId .. "_" .. transactionType
    local currentTime = os.time()
    
    -- Check if player is on cooldown (1 second between transactions)
    if transactionCooldowns[cooldownKey] then
        local timeSinceLastTransaction = currentTime - transactionCooldowns[cooldownKey]
        if timeSinceLastTransaction < 1 then
            ig.log.Debug(("Transaction rate limit hit for player %d on %s"):format(playerId, transactionType))
            return true
        end
    end
    
    -- Update cooldown
    transactionCooldowns[cooldownKey] = currentTime
    return false
end

--- Wrapper: Check transaction rate limit and notify player if limited
---@param player table Player object
---@param transactionType string Type of transaction
---@return boolean isLimited True if rate limit is active
function ig.security.CheckTransactionRateLimit(player, transactionType)
    if not player or not player.ID then
        return false
    end
    
    if ig.security.CheckRateLimit(player.ID, transactionType) then
        if player.Notify then
            player.Notify("Transaction too fast. Please wait.")
        end
        return true
    end
    return false
end

--- Wrapper: Log a transaction with player object
---@param player table Player object
---@param transactionType string Type of transaction
---@param amount number Transaction amount
---@param reason string Reason for transaction
function ig.security.LogPlayerTransaction(player, transactionType, amount, reason)
    if player then
        ig.security.LogTransaction(player, transactionType, amount, reason)
    end
end

-- ====================================================================================--
-- Fraud Detection
-- ====================================================================================--

--- Detect suspicious transaction patterns
---@param player table Player object
---@param actionType string Type of action
---@param amount number Transaction amount
---@return boolean isSuspicious True if pattern is suspicious
function ig.security.DetectSuspiciousActivity(player, actionType, amount)
    if not player or not player.GetCharacter_ID then
        return false
    end
    
    local playerId = player.GetCharacter_ID()
    
    -- Initialize history for this player if needed
    if not playerTransactionHistory[playerId] then
        playerTransactionHistory[playerId] = {
            actions = {},
            lastReset = os.time()
        }
    end
    
    local history = playerTransactionHistory[playerId]
    local currentTime = os.time()
    
    -- Reset history every 60 seconds
    if currentTime - history.lastReset > 60 then
        history.actions = {}
        history.lastReset = currentTime
    end
    
    -- Record this action
    table.insert(history.actions, {
        type = actionType,
        amount = amount,
        time = currentTime
    })
    
    -- Flag if more than 20 transactions in 60 seconds
    if #history.actions > 20 then
        local alertData = {
            player = playerId,
            source = player.ID,
            count = #history.actions,
            actions = history.actions,
            timestamp = currentTime
        }
        
        ig.log.Error("SECURITY", "Suspicious transaction pattern detected for player %s (%d transactions in 60s)", playerId, #history.actions)
        
        TriggerEvent("txaLogger:FraudAlert", alertData)
        
        return true
    end
    
    return false
end

-- ====================================================================================--
-- Cleanup old data periodically
-- ====================================================================================--

CreateThread(function()
    while true do
        Wait(300000) -- Every 5 minutes
        
        local currentTime = os.time()
        
        -- Clean up old transaction cooldowns (older than 2 minutes)
        for key, timestamp in pairs(transactionCooldowns) do
            if currentTime - timestamp > 120 then
                transactionCooldowns[key] = nil
            end
        end
        
        -- Clean up old transaction history (older than 5 minutes)
        for playerId, history in pairs(playerTransactionHistory) do
            if currentTime - history.lastReset > 300 then
                playerTransactionHistory[playerId] = nil
            end
        end
        
        -- Clean up old transaction logs (keep last 1000 entries)
        if #transactionLog > 1000 then
            -- Efficient cleanup: Create new table with last 1000 entries
            -- This is O(1000) vs table.remove in loop which would be O(n*n) 
            -- due to shifting elements on each removal
            local newLog = {}
            local startIdx = #transactionLog - 999
            for i = startIdx, #transactionLog do
                newLog[i - startIdx + 1] = transactionLog[i]
            end
            transactionLog = newLog
        end
    end
end)

ig.log.Info("SECURITY", "Transaction logging and fraud detection enabled")
