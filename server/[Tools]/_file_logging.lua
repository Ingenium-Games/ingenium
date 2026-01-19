-- ====================================================================================--
-- Shared File Logging Utility
-- Provides queue-based batch writing for log files
-- Used by general logging (_logging.lua) and chat logging (_chat.lua)
-- ====================================================================================--

if not IsDuplicityVersion() then return end

-- ====================================================================================--
-- Module Export
-- ====================================================================================--

ig.fileLog = ig.fileLog or {}

--- Create a new file logger instance with its own queue and state
--- @param config table Configuration for the logger
---   - logDirectory: string - Base directory for logs
---   - filePattern: function(level) - Returns filename for given level
---   - batchSize: number - Maximum entries to process per batch (default: 100)
---   - flushDelay: number - Delay before processing queue (default: 500ms)
---   - periodicFlush: boolean - Enable periodic flush thread (default: true)
---   - periodicFlushInterval: number - Interval for periodic flush in ms (default: 5000)
--- @return table Logger instance with queue methods
function ig.fileLog.Create(config)
    local logger = {
        queue = {},
        isWriting = false,
        config = config or {}
    }
    
    -- Set defaults
    logger.config.logDirectory = logger.config.logDirectory or "logs"
    logger.config.batchSize = logger.config.batchSize or 100
    logger.config.flushDelay = logger.config.flushDelay or 500
    logger.config.periodicFlush = logger.config.periodicFlush ~= false
    logger.config.periodicFlushInterval = logger.config.periodicFlushInterval or 5000
    
    --- Ensure log directory exists (FiveM creates it on first write)
    logger.EnsureDirectory = function()
        return true
    end
    
    --- Get file path for a given level/category
    --- @param level string The log level or category
    --- @return string File path
    logger.GetFilePath = function(level)
        if logger.config.filePattern then
            return logger.config.filePattern(level)
        end
        
        local date = os.date("%Y-%m-%d")
        local filename = string.format("log_%s_%s.log", level:lower(), date)
        return logger.config.logDirectory .. "/" .. filename
    end
    
    --- Write a batch of messages for a single level to disk
    --- @param level string The log level or category
    --- @param messagesConcat string Concatenated messages
    logger.WriteBatchForLevel = function(level, messagesConcat)
        local filePath = logger.GetFilePath(level)
        local resourceName = GetCurrentResourceName()
        
        local existing = LoadResourceFile(resourceName, filePath) or ""
        local newContents = existing .. messagesConcat .. "\n"
        local ok, err = pcall(function()
            SaveResourceFile(resourceName, filePath, newContents, -1)
        end)
        
        if not ok then
            -- Avoid recursive logging - print directly
            print(('[FileLog] Failed to write to log file: %s - %s'):format(filePath, tostring(err)))
        end
    end
    
    --- Process the log queue
    logger.ProcessQueue = function()
        if logger.isWriting or #logger.queue == 0 then
            return
        end
        
        logger.isWriting = true
        
        local processed = 0
        local batches = {}
        
        -- Process up to batchSize entries
        while processed < logger.config.batchSize and #logger.queue > 0 do
            local entry = table.remove(logger.queue, 1)
            if entry and entry.level and entry.message then
                batches[entry.level] = batches[entry.level] or {}
                batches[entry.level][#batches[entry.level] + 1] = entry.message
            end
            processed = processed + 1
        end
        
        -- Write all batches
        for level, msgs in pairs(batches) do
            local concat = table.concat(msgs, "\n")
            logger.WriteBatchForLevel(level, concat)
        end
        
        logger.isWriting = false
        
        -- If there are more entries, schedule the next batch
        if #logger.queue > 0 then
            SetTimeout(logger.config.flushDelay, logger.ProcessQueue)
        end
    end
    
    --- Queue a log entry
    --- @param message string The message to log
    --- @param level string The log level or category
    logger.QueueEntry = function(message, level)
        table.insert(logger.queue, {
            message = message,
            level = level,
            timestamp = os.time()
        })
        
        -- Process queue after delay to batch writes
        SetTimeout(logger.config.flushDelay, logger.ProcessQueue)
    end
    
    --- Force flush the queue immediately
    logger.Flush = function()
        logger.ProcessQueue()
    end
    
    --- Get queue statistics
    --- @return table Stats with queueSize and isWriting
    logger.GetStats = function()
        return {
            queueSize = #logger.queue,
            isWriting = logger.isWriting
        }
    end
    
    -- Initialize
    logger.EnsureDirectory()
    
    -- Start periodic flush thread if enabled
    if logger.config.periodicFlush then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(logger.config.periodicFlushInterval)
                logger.ProcessQueue()
            end
        end)
    end
    
    return logger
end

--- Create a simple single-file logger (convenience wrapper)
--- @param logDirectory string Directory for log file
--- @param filename string Name of log file
--- @param options table Optional configuration overrides
--- @return table Logger instance
function ig.fileLog.CreateSimple(logDirectory, filename, options)
    options = options or {}
    
    local config = {
        logDirectory = logDirectory,
        filePattern = function()
            return logDirectory .. "/" .. filename
        end,
        batchSize = options.batchSize,
        flushDelay = options.flushDelay,
        periodicFlush = options.periodicFlush,
        periodicFlushInterval = options.periodicFlushInterval
    }
    
    return ig.fileLog.Create(config)
end

-- ====================================================================================--
