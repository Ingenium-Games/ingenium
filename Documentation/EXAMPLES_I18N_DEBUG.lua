-- ====================================================================================--
-- i18n and Debugging Examples
-- ====================================================================================--
-- This file demonstrates the new internationalization and debugging features.
-- You can use these examples as a reference for implementing these features in your code.
-- ====================================================================================--

-- Example 1: Using locale translations
local function LocaleExample()
    -- Basic translation
    local switchText = _("switch")
    print("Translation for 'switch':", switchText)
    
    -- Translation with uppercase first character
    local switchTextUpper = _L("switch")
    print("Uppercase translation:", switchTextUpper)
    
    -- If a key doesn't exist, it returns the key itself (no errors)
    local missingKey = _("this_key_does_not_exist")
    print("Missing key returns:", missingKey)
end

-- Example 2: Using different debug levels
local function DebugLevelsExample()
    -- Error level (always logged if conf.error = true)
    ig.debug.Error("This is a critical error")
    
    -- Warning level
    ig.debug.Warn("This is a warning")
    
    -- Info level (requires conf.debug_1 = true)
    ig.debug.Info("This is informational")
    
    -- Debug level (requires conf.debug_2 = true)
    ig.debug.Debug("This is debug information")
    
    -- Trace level (requires conf.debug_3 = true)
    ig.debug.Trace("This is detailed trace information")
end

-- Example 3: Backward compatible debug functions
local function BackwardCompatibleExample()
    -- These still work and use the new system internally
    ig.func.Error("Old style error")
    ig.func.Alert("Old style alert")
    ig.func.Debug_1("Old style debug 1")
    ig.func.Debug_2("Old style debug 2")
    ig.func.Debug_3("Old style debug 3")
end

-- Example 4: Wrapping a function for automatic error handling
local function WrappedFunctionExample()
    -- Create a wrapped function that handles errors automatically
    local SafeCalculation = ig.debug.Wrap(function(a, b)
        if b == 0 then
            error("Division by zero!")
        end
        return a / b
    end, "SafeCalculation")
    
    -- This will work fine
    local result1 = SafeCalculation(10, 2)
    ig.debug.Info("10 / 2 = " .. tostring(result1))
    
    -- This will error but be caught and logged with full context
    local result2 = SafeCalculation(10, 0)
    ig.debug.Info("Result after error: " .. tostring(result2))
end

-- Example 5: Error handling with context tracking
local function ErrorContextExample()
    local function InnerFunction()
        error("This error will show the full stack trace")
    end
    
    local function MiddleFunction()
        InnerFunction()
    end
    
    -- Wrap the call to get detailed error information
    local success = xpcall(MiddleFunction, ig.debug.ErrorHandler)
    
    if not success then
        ig.debug.Info("Error was caught and logged with context")
    end
end

-- Example 6: Combining locale and debug features
local function CombinedExample()
    local playerName = "TestPlayer"
    
    -- Get localized message
    local jobText = _("setjob")
    
    -- Log with context
    ig.debug.Info("Player " .. playerName .. " attempted: " .. jobText)
    
    -- Check permissions
    if not HasPermission(playerName, "moderator") then
        ig.debug.Warn("Player " .. playerName .. " lacks permission: " .. jobText)
    end
end

-- Example 7: Server-side file logging (server only)
if IsDuplicityVersion() then
    local function ServerLoggingExample()
        -- ERROR and WARN are automatically logged to files
        ig.debug.Error("This error will be in the log file")
        ig.debug.Warn("This warning will be in the log file")
        
        -- You can also manually log to a file
        exports['ingenium']:LogToFile("Custom log entry", "ERROR")
        
        -- Check logs in: logs/ingenium_error_YYYY-MM-DD.log
    end
end

-- Example 8: Practical usage in event handlers
RegisterNetEvent("example:testNewFeatures", function()
    local src = source
    
    ig.debug.Info("Testing new features for player: " .. src)
    
    -- Get player name with error handling
    local GetPlayerNameSafe = ig.debug.Wrap(function(playerId)
        local name = GetPlayerName(playerId)
        if not name then
            error("Player not found: " .. playerId)
        end
        return name
    end, "GetPlayerNameSafe")
    
    local playerName = GetPlayerNameSafe(src)
    if playerName then
        local welcomeMsg = _("switch") -- Use actual locale key
        ig.debug.Info("Sending message to " .. playerName .. ": " .. welcomeMsg)
    end
end)

-- Example 9: Debug levels in loops
local function LoopDebuggingExample()
    local data = {1, 2, 3, 4, 5}
    
    ig.debug.Info("Starting data processing")
    
    for i, value in ipairs(data) do
        -- Use TRACE for detailed iteration info
        ig.debug.Trace(string.format("Processing item %d: %d", i, value))
        
        -- Simulate processing
        local result = value * 2
        
        -- Use DEBUG for important loop results
        ig.debug.Debug(string.format("Processed %d -> %d", value, result))
    end
    
    ig.debug.Info("Data processing completed")
end

-- Example 10: Error recovery with fallback
local function ErrorRecoveryExample()
    local function RiskyOperation()
        -- Simulate a risky operation
        if math.random() > 0.5 then
            error("Random failure occurred")
        end
        return "Success"
    end
    
    local SafeRiskyOperation = ig.debug.Wrap(RiskyOperation, "RiskyOperation")
    
    local result = SafeRiskyOperation()
    if result then
        ig.debug.Info("Operation succeeded: " .. result)
    else
        ig.debug.Warn("Operation failed, using fallback")
        result = "Fallback value"
    end
    
    return result
end

-- ====================================================================================--
-- Uncomment below to run examples (for testing only)
-- ====================================================================================--

--[[
-- Client/Server safe examples
Citizen.CreateThread(function()
    Wait(5000) -- Wait for resource to fully load
    
    print("\n========== Running i18n and Debug Examples ==========\n")
    
    LocaleExample()
    Wait(100)
    
    DebugLevelsExample()
    Wait(100)
    
    BackwardCompatibleExample()
    Wait(100)
    
    WrappedFunctionExample()
    Wait(100)
    
    LoopDebuggingExample()
    Wait(100)
    
    print("\n========== Examples Complete ==========\n")
end)
]]--

-- ====================================================================================--
