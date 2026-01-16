-- ====================================================================================--
-- Chat System Configuration
-- ====================================================================================--

conf.chat = {
    -- Enable/disable chat logging
    logging = {
        enabled = true,
        
        -- Log to daily chat history files
        logToFile = true,
        logDirectory = "logs/chat", -- Directory for chat logs
        
        -- Log to txAdmin
        logToTxAdmin = true,
        
        -- Log both messages and commands, or just commands
        logMessages = true, -- Regular chat messages
        logCommands = true, -- Commands (starting with /)
        
        -- Include metadata in logs
        includeCoordinates = false,
        includeIdentifiers = false,
        
        -- Maximum days to keep chat logs (0 = keep forever)
        maxLogDays = 30
    },
    
    -- Chat message settings
    messageSettings = {
        maxLength = 2056, -- Maximum message length
        allowEmptyMessages = false,
        filterProfanity = false -- Future feature
    }
}

-- Example configuration - copy this to your server's config
--[[
-- Enable chat logging with all options
conf.chat.logging.enabled = true
conf.chat.logging.logToFile = true
conf.chat.logging.logToTxAdmin = true
conf.chat.logging.logMessages = true
conf.chat.logging.logCommands = true

-- Or use convars
local chatLogging = GetConvar('ig_chat_logging', 'true')
if chatLogging == 'true' then
    conf.chat.logging.enabled = true
end
]]--
