-- Simple centralized logging helper
-- Provides ig.log(level, tag, fmt, ...)
if not ig then ig = {} end
ig.log = ig.log or {}

local levels = { error = 1, warn = 2, info = 3, debug = 4, trace = 5 }

local function get_current_level()
    if conf and conf.log and conf.log.level then
        if type(conf.log.level) == "string" then
            return levels[conf.log.level] or levels.info
        end
        return tonumber(conf.log.level) or levels.info
    end

    -- Fallback to debug flags if present
    if conf and conf.debug_3 then return levels.debug end
    if conf and conf.debug_2 then return levels.debug end
    if conf and conf.debug_1 then return levels.info end
    return levels.info
end

local function should_console_log(levelName)
    -- If explicit per-level table is provided, prefer it for console decision
    if conf and conf.log and type(conf.log.levels) == "table" then
        local v = conf.log.levels[levelName]
        if v ~= nil then return v end
    end

    -- Global console enable/disable
    if conf and conf.log and conf.log.enabled == false then
        return false
    end

    -- Fallback to level threshold
    local levelNum = levels[levelName] or levels.info
    return levelNum <= get_current_level()
end

local function should_file_log(levelName)
    -- If explicit per-level table is provided, prefer it for file decision
    if conf and conf.log and type(conf.log.levels) == "table" then
        local v = conf.log.levels[levelName]
        if v ~= nil then return v end
    end

    -- Global file write switch
    if not (conf and conf.log and conf.log.writeToFile == true) then
        return false
    end

    -- Fallback to level threshold
    local levelNum = levels[levelName] or levels.info
    return levelNum <= get_current_level()
end

-- Combined decision: should we log this level at all (console or file)?
-- Determine whether console printing is enabled (backwards-compatible checks)
local function console_enabled()
    if conf and conf.log and conf.log.enabled ~= nil then
        return conf.log.enabled
    end
    return false
end

local function fmt_message(fmt, ...)
    if not fmt then return "" end
    if select("#", ...) == 0 then return tostring(fmt) end
    local ok, res = pcall(string.format, fmt, ...)
    if ok then return res end
    return tostring(fmt)
end

local function output(levelName, tag, fmt, ...)
    -- If neither console nor file logging will run for this level, skip
    if not ((console_enabled() and should_console_log(levelName)) or should_file_log(levelName)) then
        return
    end
    local ts = os.date("%Y-%m-%d %H:%M:%S")
    local message = fmt_message(fmt, ...)
    local out = string.format("[%s] [%s] [%s] %s", ts, levelName:upper(), tag or "INGENIUM", message)
    -- Console output (respect console enable + per-level toggles)
    if console_enabled() and should_console_log(levelName) then
        print(out)
    end

    -- Server-side file logging (respect file toggle + per-level toggles)
    if IsDuplicityVersion() and should_file_log(levelName) then
        TriggerEvent("ig:debug:logToFile", out, levelName:upper())
    end
end

function ig.log.Error(tag, fmt, ...) output("error", tag, fmt, ...) end
function ig.log.Warn(tag, fmt, ...) output("warn", tag, fmt, ...) end
function ig.log.Info(tag, fmt, ...) output("info", tag, fmt, ...) end
function ig.log.Debug(tag, fmt, ...) output("debug", tag, fmt, ...) end
function ig.log.Trace(tag, fmt, ...) output("trace", tag, fmt, ...) end

-- Generic helper: ig.log.Log(levelOrName, tag, fmt, ...)
function ig.log.Log(levelOrName, tag, fmt, ...)
    if type(levelOrName) == "number" then
        for name, val in pairs(levels) do
            if val == levelOrName then
                return output(name, tag, fmt, ...)
            end
        end
        return output("info", tag, fmt, ...)
    end
    return output(levelOrName, tag, fmt, ...)
end

-- Backwards compatibility aliases (lowercase)
ig.log.error = ig.log.Error
ig.log.warn = ig.log.Warn
ig.log.info = ig.log.Info
ig.log.debug = ig.log.Debug
ig.log.trace = ig.log.Trace
ig.log.log = ig.log.Log

return ig.log
