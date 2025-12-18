-- ====================================================================================--
-- MySQL.Async Compatibility Layer
-- Provides backward compatibility with mysql-async API
-- This allows for gradual migration of existing code
-- ====================================================================================--

MySQL = {}
MySQL.Async = {}
MySQL.Sync = {}

-- ====================================================================================--
-- MySQL.Async Compatibility Functions
-- ====================================================================================--

--- Async fetchAll - Returns all rows from query
---@param query string SQL query
---@param parameters table|nil Query parameters
---@param callback function Callback(results)
function MySQL.Asynig.fetchAll(query, parameters, callback)
    local params = parameters or {}
    
    Citizen.CreateThread(function()
        local results = ig.sql.Query(query, params)
        
        if callback and type(callback) == 'function' then
            callback(results)
        end
    end)
end

--- Async fetchScalar - Returns a single value
---@param query string SQL query
---@param parameters table|nil Query parameters
---@param callback function Callback(value)
function MySQL.Asynig.fetchScalar(query, parameters, callback)
    local params = parameters or {}
    
    Citizen.CreateThread(function()
        local result = ig.sql.FetchScalar(query, params)
        
        if callback and type(callback) == 'function' then
            callback(result)
        end
    end)
end

--- Async execute - Execute UPDATE/DELETE/INSERT
---@param query string SQL query
---@param parameters table|nil Query parameters
---@param callback function|nil Optional callback(affectedRows)
function MySQL.Asynig.execute(query, parameters, callback)
    local params = parameters or {}
    
    Citizen.CreateThread(function()
        -- Determine if this is an INSERT or UPDATE/DELETE
        local upperQuery = string.upper(query)
        local result
        
        if string.find(upperQuery, "^%s*INSERT") then
            result = ig.sql.Insert(query, params)
        else
            result = ig.sql.Update(query, params)
        end
        
        if callback and type(callback) == 'function' then
            callback(result)
        end
    end)
end

--- Async insert - Execute INSERT and return insertId
---@param query string|number SQL query or prepared query ID
---@param parameters table Query parameters
---@param callback function|nil Optional callback(insertId)
function MySQL.Asynig.insert(query, parameters, callback)
    local params = parameters or {}
    
    Citizen.CreateThread(function()
        local result
        
        -- Check if this is a prepared query (number) or raw query (string)
        if type(query) == 'number' or (type(query) == 'string' and tonumber(query)) then
            -- Prepared query execution
            result = ig.sql.ExecutePrepared(query, params)
        else
            -- Regular insert
            result = ig.sql.Insert(query, params)
        end
        
        if callback and type(callback) == 'function' then
            callback(result)
        end
    end)
end

--- Async store - Prepare a query for later execution
---@param query string SQL query to prepare
---@param callback function Callback(queryId)
function MySQL.Asynig.store(query, callback)
    Citizen.CreateThread(function()
        local queryId = ig.sql.PrepareQuery(query)
        
        if callback and type(callback) == 'function' then
            callback(queryId)
        end
    end)
end

--- Async transaction - Execute multiple queries in a transaction
---@param queries table Array of {query, parameters} objects
---@param callback function|nil Optional callback(success)
function MySQL.Asynig.transaction(queries, callback)
    Citizen.CreateThread(function()
        local result = ig.sql.Transaction(queries)
        
        if callback and type(callback) == 'function' then
            callback(result.success)
        end
    end)
end

-- ====================================================================================--
-- MySQL.Sync Compatibility Functions (Blocking)
-- ====================================================================================--

--- Sync fetchAll - Returns all rows from query (blocking)
---@param query string SQL query
---@param parameters table|nil Query parameters
---@return table Results array
function MySQL.Synig.fetchAll(query, parameters)
    local params = parameters or {}
    return ig.sql.Query(query, params)
end

--- Sync fetchScalar - Returns a single value (blocking)
---@param query string SQL query
---@param parameters table|nil Query parameters
---@return any Single value
function MySQL.Synig.fetchScalar(query, parameters)
    local params = parameters or {}
    return ig.sql.FetchScalar(query, params)
end

--- Sync execute - Execute UPDATE/DELETE/INSERT (blocking)
---@param query string SQL query
---@param parameters table|nil Query parameters
---@return number Affected rows or insert ID
function MySQL.Synig.execute(query, parameters)
    local params = parameters or {}
    local upperQuery = string.upper(query)
    
    if string.find(upperQuery, "^%s*INSERT") then
        return ig.sql.Insert(query, params)
    else
        return ig.sql.Update(query, params)
    end
end

--- Sync insert - Execute INSERT and return insertId (blocking)
---@param query string SQL query
---@param parameters table|nil Query parameters
---@return number Insert ID
function MySQL.Synig.insert(query, parameters)
    local params = parameters or {}
    return ig.sql.Insert(query, params)
end

--- Sync transaction - Execute multiple queries in a transaction (blocking)
---@param queries table Array of {query, parameters} objects
---@return boolean Success
function MySQL.Synig.transaction(queries)
    local result = ig.sql.Transaction(queries)
    return result.success
end

-- ====================================================================================--
-- Initialization
-- ====================================================================================--

Citizen.CreateThread(function()
    print("^3[SQL Compatibility] MySQL.Async/MySQL.Sync wrapper loaded^7")
    print("^3[SQL Compatibility] Legacy mysql-async calls will be redirected to new handler^7")
end)

-- ====================================================================================--
-- Deprecation Warning (Optional - can be enabled for migration tracking)
-- ====================================================================================--

local SHOW_DEPRECATION_WARNINGS = false -- Set to true to see where legacy calls are used

if SHOW_DEPRECATION_WARNINGS then
    local function wrapWithWarning(funcName, originalFunc)
        return function(...)
            print(string.format("^3[SQL DEPRECATION] %s is deprecated - migrate to ig.sql.* API^7", funcName))
            
            -- Get call stack for debugging
            local info = debug.getinfo(2, "Sl")
            if info then
                print(string.format("^3[SQL DEPRECATION] Called from: %s:%d^7", info.source, info.currentline))
            end
            
            return originalFunc(...)
        end
    end
    
    -- Wrap all functions with deprecation warnings
    for name, func in pairs(MySQL.Async) do
        MySQL.Async[name] = wrapWithWarning("MySQL.Asynig." .. name, func)
    end
    
    for name, func in pairs(MySQL.Sync) do
        MySQL.Sync[name] = wrapWithWarning("MySQL.Synig." .. name, func)
    end
end
