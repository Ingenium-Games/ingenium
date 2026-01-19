-- ====================================================================================--
-- Chat System - Server Side Logging
-- ====================================================================================--

-- Create chat logger instance using shared file logging utility
local chatLogger = ig.fileLog.Create({
    logDirectory = "logs/chat",
    filePattern = function()
        local date = os.date("%Y-%m-%d")
        return (conf.chat.logging.logDirectory or "logs/chat") .. "/" .. string.format("chat_%s.log", date)
    end,
    batchSize = 100,
    flushDelay = 0,  -- Process immediately for chat logs
    periodicFlush = true,
    periodicFlushInterval = 5000
})

-- Function to format chat log entry
function ig.chat.FormatLogEntry(source, playerName, message, isCommand)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local identifiers = ""
    local coords = ""
    
    if conf.chat.logging.includeIdentifiers and source > 0 then
        local ids = ig.func.GetPlayerIdentifiers(source)
        if ids then
            identifiers = string.format(" [%s]", ids.steam or ids.license or "unknown")
        end
    end
    
    if conf.chat.logging.includeCoordinates and source > 0 then
        local ped = GetPlayerPed(source)
        if ped and ped > 0 then
            local playerCoords = GetEntityCoords(ped)
            coords = string.format(" @(%.1f, %.1f, %.1f)", playerCoords.x, playerCoords.y, playerCoords.z)
        end
    end
    
    local messageType = isCommand and "COMMAND" or "MESSAGE"
    return string.format("[%s] [%s] %s (ID: %d)%s%s: %s", 
        timestamp, 
        messageType,
        playerName, 
        source,
        identifiers,
        coords,
        message
    )
end

-- Log chat message
function ig.chat.LogMessage(source, playerName, message, isCommand)
    if not conf.chat or not conf.chat.logging or not conf.chat.logging.enabled then
        return
    end
    
    -- Check if we should log this type of message
    if isCommand and not conf.chat.logging.logCommands then
        return
    end
    
    if not isCommand and not conf.chat.logging.logMessages then
        return
    end
    
    -- Format log entry
    local logEntry = ig.chat.FormatLogEntry(source, playerName, message, isCommand)
    
    -- Log to file
    if conf.chat.logging.logToFile then
        chatLogger.QueueEntry(logEntry, "chat")
    end
    
    -- Log to txAdmin
    if conf.chat.logging.logToTxAdmin then
        local txAdminMessage
        if isCommand then
            txAdminMessage = string.format("Command executed: %s by %s (ID: %d)", message, playerName, source)
        else
            txAdminMessage = string.format("Chat: [%s]: %s", playerName, message)
        end
        TriggerEvent("txaLogger:ChatMessage", txAdminMessage)
    end
end

-- Handle chat messages from clients
RegisterNetEvent('chat:addMessage')
AddEventHandler('chat:addMessage', function(message)
    -- This is a broadcast event - log it if it came from a player
    if source and source > 0 then
        local playerName = GetPlayerName(source)
        if playerName then
            local msg = message.message or message.text or ""
            if type(message) == 'table' and message.args and message.args[2] then
                msg = message.args[2]
            end
            
            -- Check if it's a command or regular message
            local isCommand = string.sub(msg, 1, 1) == "/"
            
            ig.chat.LogMessage(source, playerName, msg, isCommand)
        end
    end
end)

-- Handle server chat messages (for logging)
RegisterServerEvent('ig:chat:serverMessage')
AddEventHandler('ig:chat:serverMessage', function(message)
    local source = source
    local playerName = GetPlayerName(source)
    
    if not playerName then
        return
    end
    
    -- Check if it's a command or regular message
    local isCommand = string.sub(message, 1, 1) == "/"
    
    -- Log the message
    ig.chat.LogMessage(source, playerName, message, isCommand)
    
    -- If it's a regular message, broadcast it to all players
    if not isCommand then
        TriggerClientEvent('chat:addMessage', -1, {
            author = playerName,
            message = message,
            color = {255, 255, 255}
        })
    else
        -- If it's a command, execute it
        local command = string.sub(message, 2)
        -- The client will handle command execution
    end
end)

-- Export logging function
exports('LogChatMessage', function(source, playerName, message, isCommand)
    ig.chat.LogMessage(source, playerName, message, isCommand)
end)

-- Clean up old chat logs based on maxLogDays setting
local function CleanupOldLogs()
    if not conf.chat or not conf.chat.logging or not conf.chat.logging.enabled then
        return
    end
    
    local maxDays = conf.chat.logging.maxLogDays
    if maxDays == 0 then
        return -- Keep logs forever
    end
    
    -- This is a placeholder - actual file cleanup would require additional filesystem operations
    -- In production, you might want to use a separate cleanup script
    ig.log.Info("IG Chat", "Chat Log: Would delete chat logs older than %d days", maxDays)
end

-- Periodic cleanup check (once per day) - registered with cron system
local chatLogCleanupRegistered = false
AddEventHandler("onServerResourceStart", function()
    if not chatLogCleanupRegistered then
        -- Run cleanup at 3:00 AM daily (common maintenance time)
        ig.cron.RunAt(3, 0, CleanupOldLogs)
        chatLogCleanupRegistered = true
        ig.log.Info('IG Chat', 'Registered daily log cleanup with cron (3:00 AM)')
    end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    -- Delay one tick to allow config loading order to settle
    SetTimeout(0, function()
        local logToFile = conf and conf.chat and conf.chat.logging and conf.chat.logging.logToFile or false
        local logToTxAdmin = conf and conf.chat and conf.chat.logging and conf.chat.logging.logToTxAdmin or false
        ig.log.Info('IG Chat', 'Chat logging system loaded')
        ig.log.Info('IG Chat', 'Logging to file: %s, Logging to txAdmin: %s', tostring(logToFile), tostring(logToTxAdmin))
    end)
end)