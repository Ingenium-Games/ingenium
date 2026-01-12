-- ====================================================================================--
-- Server-Side Error Logging
-- ====================================================================================--

if not IsDuplicityVersion() then return end

local logDirectory = "logs"
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
    local resourceName = GetCurrentResourceName()

    -- Read existing contents (if any) then append and save. Use SaveResourceFile so FiveM creates directories.
    local existing = LoadResourceFile(resourceName, filePath) or ""
    local newContents = existing .. message .. "\n"
    local ok, err = pcall(function()
        SaveResourceFile(resourceName, filePath, newContents, -1)
    end)

    if not ok then
        -- Avoid using ig.log here to prevent recursive logging via ig:debug:logToFile
        print(('[Logging] Failed to write to log file: %s - %s'):format(filePath, tostring(err)))
    end
end

-- Process log queue
local function ProcessLogQueue()
    if isWriting or #logQueue == 0 then
        return
    end

    isWriting = true

    -- Process a limited number of entries per invocation to avoid blocking the server
    local BATCH_SIZE = 25
    local processed = 0
    while processed < BATCH_SIZE and #logQueue > 0 do
        local entry = table.remove(logQueue, 1)
        WriteLogEntry(entry.message, entry.level)
        processed = processed + 1
    end

    isWriting = false

    -- If there are more entries, schedule the next batch on the next tick
    if #logQueue > 0 then
        SetTimeout(0, ProcessLogQueue)
    end
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
-- Use standard Citizen thread for reliability
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        ProcessLogQueue()
    end
end)

-- ====================================================================================--
