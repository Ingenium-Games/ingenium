-- ====================================================================================--
-- Server-Side Error Logging
-- ====================================================================================--

if not IsDuplicityVersion() then return end

local logDirectory = "logs"
local maxLogSize = 10 * 1024 * 1024 -- 10MB
local logQueue = {}
local isWriting = false

-- Ensure log directory exists
local function EnsureLogDirectory()
    -- FiveM will create the directory when we write to it
    return true
end

-- Get current log file path
local function GetLogFilePath(level)
    local date = os.date("%Y-%m-%d")
    local filename = string.format("ingenium_%s_%s.log", level:lower(), date)
    return logDirectory .. "/" .. filename
end

-- Write log entry to file
local function WriteLogEntry(message, level)
    local filePath = GetLogFilePath(level)
    
    -- Open file in append mode
    local file = io.open(filePath, "a")
    if file then
        file:write(message .. "\n")
        file:close()
    else
        print("^1[ERROR] Failed to write to log file: " .. filePath .. "^7")
    end
end

-- Process log queue
local function ProcessLogQueue()
    if isWriting or #logQueue == 0 then
        return
    end
    
    isWriting = true
    
    while #logQueue > 0 do
        local entry = table.remove(logQueue, 1)
        WriteLogEntry(entry.message, entry.level)
    end
    
    isWriting = false
end

-- Queue a log entry
local function QueueLogEntry(message, level)
    table.insert(logQueue, {
        message = message,
        level = level,
        timestamp = os.time()
    })
    
    -- Process queue on next tick to batch writes
    SetTimeout(0, ProcessLogQueue)
end

-- Event handler for logging
RegisterNetEvent("ig:debug:logToFile", function(message, level)
    QueueLogEntry(message, level)
end)

-- Initialize
EnsureLogDirectory()

-- Export logging function
exports("LogToFile", function(message, level)
    QueueLogEntry(message, level or "INFO")
end)

-- Periodic queue flush (every 5 seconds)
if ig and ig.func and ig.func.SetInterval then
    ig.func.SetInterval(ProcessLogQueue, 5000)
end

-- ====================================================================================--
