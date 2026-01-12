-- ====================================================================================--
-- Client-Side Callback Wrapper
-- Provides convenient wrapper methods for the global callback system
-- ====================================================================================--

ig.callback = {}

---Await a server callback response synchronously
---This is a convenience wrapper around TriggerServerCallback
---@param eventName string The name of the server callback to trigger
---@param ... any Additional arguments to pass to the callback
---@return any result The result from the server callback
---
---@usage
---  -- Simple usage
---  local data = ig.callback.Await('Server:GetData')
---
---  -- With arguments
---  local player = ig.callback.Await('Server:GetPlayer', playerId)
---
---  -- Multiple arguments
---  local result = ig.callback.Await('Server:DoSomething', arg1, arg2, arg3)
function ig.callback.Await(eventName, ...)
    return TriggerServerCallback({
        eventName = eventName,
        args = {...}
    })
end

---Await a server callback with timeout support
---@param eventName string The name of the server callback
---@param timeout number Timeout in seconds
---@param timeoutCallback function Function to call on timeout
---@param ... any Additional arguments
---@return any result The result from the server callback or nil on timeout
---
---@usage
---  local data = ig.callback.AwaitWithTimeout('Server:SlowOperation', 5, function(state)
---      print('Request timed out with state: ' .. state)
---  end, someArg)
function ig.callback.AwaitWithTimeout(eventName, timeout, timeoutCallback, ...)
    return TriggerServerCallback({
        eventName = eventName,
        args = {...},
        timeout = timeout,
        timedout = timeoutCallback
    })
end

---Trigger async server callback with response handler
---This does not block execution and calls the callback function when response arrives
---@param eventName string The name of the server callback
---@param callback function Function to handle the response
---@param ... any Additional arguments
---
---@usage
---  ig.callback.Async('Server:GetData', function(data)
---      print('Received data:', json.encode(data))
---  end)
---
---  -- With arguments
---  ig.callback.Async('Server:GetPlayer', function(player)
---      if player then
---          print('Player name:', player.name)
---      end
---  end, playerId)
function ig.callback.Async(eventName, callback, ...)
    TriggerServerCallback({
        eventName = eventName,
        args = {...},
        callback = callback
    })
end

---Trigger async server callback with timeout and response handler
---@param eventName string The name of the server callback
---@param timeout number Timeout in seconds
---@param callback function Function to handle the response
---@param timeoutCallback function Function to call on timeout
---@param ... any Additional arguments
---
---@usage
---  ig.callback.AsyncWithTimeout('Server:SlowOperation', 5, 
---      function(result)
---          print('Success:', result)
---      end,
---      function(state)
---          print('Timed out with state:', state)
---      end,
---      someArg
---  )
function ig.callback.AsyncWithTimeout(eventName, timeout, callback, timeoutCallback, ...)
    TriggerServerCallback({
        eventName = eventName,
        args = {...},
        timeout = timeout,
        callback = callback,
        timedout = timeoutCallback
    })
end

-- ====================================================================================--
-- CLIENT-TO-CLIENT CALLBACKS (Local simulation)
-- ====================================================================================--

---Await a client callback response synchronously (local only)
---@param eventName string The name of the client callback to trigger
---@param ... any Additional arguments to pass to the callback
---@return any result The result from the client callback
---
---@usage
---  local uiState = ig.callback.AwaitClient('Client:UI:GetState')
function ig.callback.AwaitClient(eventName, ...)
    return TriggerClientCallback({
        eventName = eventName,
        args = {...}
    })
end

---Trigger async client callback with response handler (local only)
---@param eventName string The name of the client callback
---@param callback function Function to handle the response
---@param ... any Additional arguments
---
---@usage
---  ig.callback.AsyncClient('Client:UI:GetState', function(state)
---      print('UI State:', json.encode(state))
---  end)
function ig.callback.AsyncClient(eventName, callback, ...)
    TriggerClientCallback({
        eventName = eventName,
        args = {...},
        callback = callback
    })
end

-- ====================================================================================--
-- UTILITY FUNCTIONS
-- ====================================================================================--

---Register a server callback handler
---This is a convenience wrapper for RegisterServerCallback
---Note: This can only be used on the SERVER side
---@param eventName string The name of the callback event
---@param handler function The function to handle the callback (receives source, ...)
---@return any eventData Event handler reference for unregistering
---
---@usage
---  -- Server-side only
---  ig.callback.RegisterServer('MyCallback', function(source, arg1, arg2)
---      return {success = true, data = someData}
---  end)
function ig.callback.RegisterServer(eventName, handler)
    if not IsDuplicityVersion() then
        error('ig.callback.RegisterServer can only be used on the server side')
        return nil
    end
    
    return RegisterServerCallback({
        eventName = eventName,
        eventCallback = handler
    })
end

---Register a client callback handler
---This is a convenience wrapper for RegisterClientCallback
---@param eventName string The name of the callback event
---@param handler function The function to handle the callback
---@return any eventData Event handler reference for unregistering
---
---@usage
---  ig.callback.RegisterClient('MyCallback', function(arg1, arg2)
---      return {success = true, data = someData}
---  end)
function ig.callback.RegisterClient(eventName, handler)
    return RegisterClientCallback({
        eventName = eventName,
        eventCallback = handler
    })
end

---Unregister a server callback
---@param eventData any The event data returned from RegisterServer
function ig.callback.UnregisterServer(eventData)
    if eventData then
        UnregisterServerCallback(eventData)
    end
end

---Unregister a client callback
---@param eventData any The event data returned from RegisterClient
function ig.callback.UnregisterClient(eventData)
    if eventData then
        UnregisterClientCallback(eventData)
    end
end
