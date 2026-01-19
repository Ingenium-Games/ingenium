-- ====================================================================================--
-- Server-Side Error Logging
-- ====================================================================================--

if not IsDuplicityVersion() then return end

-- Create logger instance using shared file logging utility
local logger = ig.fileLog.Create({
    logDirectory = "logs",
    filePattern = function(level)
        local date = os.date("%Y-%m-%d")
        local filename = string.format("ingenium_%s_%s.log", level:lower(), date)
        return "logs/" .. filename
    end,
    batchSize = 100,
    flushDelay = 500,
    periodicFlush = true,
    periodicFlushInterval = 5000
})

-- Event handler for logging
RegisterNetEvent("Ingenium:Log:ToFile", function(message, level)
    logger.QueueEntry(message, level)
end)

-- Export logging function
exports("LogToFile", function(message, level)
    logger.QueueEntry(message, level or "INFO")
end)

-- ====================================================================================--
