-- ====================================================================================--
-- Server-Side Callback Wrapper
-- Provides server-only wrapper methods for the global callback system
-- ====================================================================================--

ig = ig or {}
ig.callback = ig.callback or {}

---Register a server callback handler
---This is a convenience wrapper for RegisterServerCallback
---Note: This can only be used on the SERVER side
---@param eventName string The name of the callback event
---@param handler function The function to handle the callback (receives source, ...)
---@return any eventData Event handler reference for unregistering
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

---Unregister a server callback
---@param eventData table|any "The event data returned from RegisterServer"
function ig.callback.UnregisterServer(eventData)
    if eventData then
        UnregisterServerCallback(eventData)
    end
end
