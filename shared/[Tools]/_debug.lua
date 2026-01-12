-- ====================================================================================--
-- Enhanced Debugging System
-- ====================================================================================--

if not ig then ig = {} end
if not ig.debug then ig.debug = {} end

-- Debug levels (in order of severity)
ig.debug.levels = {
    ERROR = 1,   -- Critical errors
    WARN = 2,    -- Warnings
    INFO = 3,    -- Informational messages (same as debug_1)
    DEBUG = 4,   -- Debug messages (same as debug_2)
    TRACE = 5    -- Detailed trace messages (same as debug_3)
}

-- Color codes for console output
ig.debug.colors = {
    ERROR = "^1",   -- Red
    WARN = "^3",    -- Yellow
    INFO = "^6",    -- Cyan
    DEBUG = "^5",   -- Purple
    TRACE = "^2",   -- Green
    RESET = "^7"    -- White
}

-- Get the current debug level based on config
function ig.debug.GetLevel()
    if conf.debug_3 then return ig.debug.levels.TRACE end
    if conf.debug_2 then return ig.debug.levels.DEBUG end
    if conf.debug_1 then return ig.debug.levels.INFO end
    if conf.error then return ig.debug.levels.ERROR end
    return 0 -- No debug output
end

-- Stack level constants for context extraction
local STACK_LEVEL_DEFAULT = 3  -- Default level for most debug calls
local STACK_LEVEL_WRAPPED = 4  -- Additional level when called from wrapper

-- Get resource and line information from debug stack
function ig.debug.GetContext(stackLevel)
    stackLevel = stackLevel or STACK_LEVEL_DEFAULT
    local info = debug.getinfo(stackLevel, "Sln")
    
    if info then
        return {
            resource = GetCurrentResourceName(),
            source = info.source and info.source:gsub("^@", "") or "unknown",
            line = info.currentline or 0,
            name = info.name or "anonymous",
            func = info.what or "Lua"
        }
    end
    
    return {
        resource = GetCurrentResourceName(),
        source = "unknown",
        line = 0,
        name = "unknown",
        func = "Lua"
    }
end

-- Format a log message with context
function ig.debug.FormatMessage(level, message, context)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local color = ig.debug.colors[level] or ig.debug.colors.RESET
    local reset = ig.debug.colors.RESET
    
    -- Console format (with colors)
    local consoleMsg = string.format(
        "%s[%s]%s [%s] %s:%d in %s() - %s",
        color,
        level,
        reset,
        context.resource,
        context.source,
        context.line,
        context.name,
        message
    )
    
    -- File format (without colors)
    local fileMsg = string.format(
        "[%s] [%s] [%s] %s:%d in %s() - %s",
        timestamp,
        level,
        context.resource,
        context.source,
        context.line,
        context.name,
        message
    )
    
    return consoleMsg, fileMsg
end

-- Log a message at a specific level
function ig.debug.Log(level, message, stackLevel)
    local currentLevel = ig.debug.GetLevel()
    local messageLevel = ig.debug.levels[level] or ig.debug.levels.INFO

    -- Only log if the message level is at or below the current debug level
    if messageLevel > currentLevel then
        return
    end

    stackLevel = (stackLevel or 2) + 1
    local context = ig.debug.GetContext(stackLevel)
    local consoleMsg, fileMsg = ig.debug.FormatMessage(level, message, context)

    -- If centralized logger exists, use it (preserves file logging behaviour)
    if ig and ig.log and ig.log.Log then
        -- ig.log expects level names like "error","warn","info","debug","trace"
        local lvl = string.lower(level)
        -- Tag with resource for clarity
        ig.log.Log(lvl, context.resource, fileMsg)
        return
    end

    -- Fallback: Always print to console
    print(consoleMsg)

    -- Server-side file logging for errors and warnings (fallback)
    if IsDuplicityVersion() and (level == "ERROR" or level == "WARN") then
        TriggerEvent("ig:debug:logToFile", fileMsg, level)
    end
end

-- Convenience functions for each log level
function ig.debug.Error(message)
    ig.debug.Log("ERROR", tostring(message), 2)
end

function ig.debug.Warn(message)
    ig.debug.Log("WARN", tostring(message), 2)
end

function ig.debug.Info(message)
    ig.debug.Log("INFO", tostring(message), 2)
end

function ig.debug.Debug(message)
    ig.debug.Log("DEBUG", tostring(message), 2)
end

function ig.debug.Trace(message)
    ig.debug.Log("TRACE", tostring(message), 2)
end

-- Enhanced error handler with full context
function ig.debug.ErrorHandler(err)
    local context = ig.debug.GetContext(3)
    local stackTrace = debug.traceback("", 3)
    
    local fullMessage = string.format(
        "Error: %s\n  Resource: %s\n  File: %s:%d\n  Function: %s()\n\nStack trace:\n%s",
        tostring(err),
        context.resource,
        context.source,
        context.line,
        context.name,
        stackTrace
    )
    
    ig.debug.Error(fullMessage)
    
    return err
end

-- Wrap a function with error handling
function ig.debug.Wrap(func, funcName)
    funcName = funcName or "anonymous"
    
    return function(...)
        local success, result = xpcall(func, ig.debug.ErrorHandler, ...)
        
        if not success then
            -- Error already logged by ErrorHandler, just return nil
            return nil
        end
        
        return result
    end
end

-- ====================================================================================--
-- Backward compatibility with existing debug functions
-- ====================================================================================--

-- Map old functions to new system
if not ig.func then ig.func = {} end

ig.func.Debug_1 = ig.debug.Info
ig.func.Debug_2 = ig.debug.Debug
ig.func.Debug_3 = ig.debug.Trace
ig.func.Alert = ig.debug.Warn

-- Enhanced error function with context
function ig.func.Error(err)
    if conf.error then
        ig.debug.Error(tostring(err))
    end
end

-- ====================================================================================--
