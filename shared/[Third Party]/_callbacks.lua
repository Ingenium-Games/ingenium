-- ====================================================================================--
-- Callbacks Section
-- ====================================================================================--

--[[
MIT License

Copyright (c) 2020 PiterMcFlebor

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--


local IS_SERVER = IsDuplicityVersion()
local table_unpack = table.unpack
-- from scheduler.lua
local debug = debug
local debug_getinfo = debug.getinfo
local msgpack = msgpack
local msgpack_pack = msgpack.pack
local msgpack_unpack = msgpack.unpack
local msgpack_pack_args = msgpack.pack_args
-- from deferred.lua
local PENDING = 0
local RESOLVING = 1
local REJECTING = 2
local RESOLVED = 3
local REJECTED = 4

-- custom function to check any type
local function ensure(obj, typeof, opt_typeof, errMessage)
	local objtype = type(obj)
	local di = debug_getinfo(2)
	-- Guard against nil callback name
	local callbackName = (di and di.name) or "unknown"
	local errMessage = errMessage or (opt_typeof == nil and (callbackName .. " expected %s, but got %s") or (callbackName .. " expected %s or %s, but got %s"))
	if typeof ~= "function" then
		if objtype ~= typeof and objtype ~= opt_typeof then
			error((errMessage):format(typeof, (opt_typeof == nil and objtype or opt_typeof), objtype))
		end
	else
		if objtype == "table" and not rawget(obj, "__cfx_functionReference") then
			error((errMessage):format(typeof, (opt_typeof == nil and objtype or opt_typeof), objtype))
		end
	end
end

-- SERVER-SIDE
if IS_SERVER then
	-- ====================================================================================--
	-- Ticket Validation System
	-- ====================================================================================--
	local issuedTickets = {}
	local TICKET_VALIDITY_MS = conf.callback.ticketValidity
	local TICKET_LENGTH = conf.callback.ticketLength
	
	-- Rate Limiting Configuration
	local rateLimitConfig = {
		enabled = conf.callback.rateLimitEnabled,
		maxRequestsPerSecond = conf.callback.maxRequestsPerSecond,
		windowMs = conf.callback.rateLimitWindow
	}
	local requestCounts = {}
	
	-- Generate cryptographically secure ticket
	local function generateSecureTicket()
		-- Use existing RNG from the framework
		-- Generate a 20+ character random string for better security
		-- NOTE: ig.rng.chars uses Lua's math.random() which is not cryptographically secure
		-- For production use, consider using a more secure entropy source
		-- However, combined with short expiration (30s) and source validation,
		-- this provides reasonable security against brute force attacks
		return ig.rng.chars(TICKET_LENGTH)
	end
	
	-- Clean up expired tickets
	local function cleanupExpiredTickets()
		local now = GetGameTimer()
		for ticket, data in pairs(issuedTickets) do
			if data.expiresAt < now then
				issuedTickets[ticket] = nil
			end
		end
	end
	
	-- Clean up stale rate limit data
	local function cleanupRateLimitData()
		local now = GetGameTimer()
		local STALE_THRESHOLD = conf.callback.staleThreshold
		for key, data in pairs(requestCounts) do
			if now - data.windowStart > STALE_THRESHOLD then
				requestCounts[key] = nil
			end
		end
	end
	
	-- Centralized ticket cleanup function
	local function removeTicket(ticket)
		if ticket and issuedTickets[ticket] then
			issuedTickets[ticket] = nil
		end
	end
	
	-- Rate limiting check
	local function checkRateLimit(source)
		if not rateLimitConfig.enabled then
			return true
		end
		
		local now = GetGameTimer()
		local key = tostring(source)
		
		-- Initialize if first request
		if not requestCounts[key] then
			requestCounts[key] = {
				count = 0,
				windowStart = now
			}
		end
		
		local data = requestCounts[key]
		
		-- Reset window if expired
		if now - data.windowStart >= rateLimitConfig.windowMs then
			data.count = 0
			data.windowStart = now
		end
		
		-- Check if rate limit exceeded
		if data.count >= rateLimitConfig.maxRequestsPerSecond then
			ig.log.Warn("CALLBACK:SECURITY", "Rate limit exceeded for source %d (max: %d/sec)", source, rateLimitConfig.maxRequestsPerSecond)
			return false
		end
		
		data.count = data.count + 1
		return true
	end
	
	-- Validate ticket and source
	local function validateTicket(ticket, source)
		if not ticket then
			ig.log.Warn("CALLBACK:SECURITY", "Missing ticket in callback return")
			return false
		end
		
		local ticketData = issuedTickets[ticket]
		
		if not ticketData then
			ig.log.Warn("CALLBACK:SECURITY", "Invalid or expired ticket: %s from source %d", ticket, source)
			return false
		end
		
		-- Check expiration
		local now = GetGameTimer()
		if ticketData.expiresAt < now then
			ig.log.Warn("CALLBACK:SECURITY", "Expired ticket: %s from source %d", ticket, source)
			issuedTickets[ticket] = nil
			return false
		end
		
		-- Check source match
		if ticketData.source ~= source then
			ig.log.Warn("CALLBACK:SECURITY", "Source mismatch - ticket source: %d, actual source: %d", ticketData.source, source)
			return false
		end
		
		return true
	end
	
	-- Periodic cleanup of expired tickets and stale rate limit data
	CreateThread(function()
		while true do
			Wait(conf.callback.cleanupInterval)
			cleanupExpiredTickets()
			cleanupRateLimitData()
		end
	end)
	
	-- ====================================================================================--
	--
	-- @table RegisterServerCallback
	-- @wiki:ignore
	--
	-- @string eventName - The name of the event to be registered
	-- @function eventCallback - The function to be executed when event is fired
	-- 
	-- ACL Permission Example:
	-- For sensitive callbacks (e.g., money, inventory, admin), consider adding:
	--   if not IsPlayerAceAllowed(source, 'callback.eventName') then
	--     return nil, "Permission denied"
	--   end
	_G.RegisterServerCallback = function(args)
		ensure(args, "table"); ensure(args.eventName, "string"); ensure(args.eventCallback, "function")

		-- save the callback function on this call
		local eventCallback = args.eventCallback
		-- save the event name on this call
		local eventName = args.eventName
		
		ig.log.Debug("CALLBACK:SERVER", "Registering server callback: %s", eventName)
		
		-- save the event data to return
		local eventData = RegisterNetEvent("Server:Callback:"..eventName, function(packed, src, cb)
			-- Handle both client and server callbacks:
			-- Client call (TriggerServerEvent): packed only, source is a FiveM global
			-- Server call (TriggerEvent): packed, src, and cb as explicit parameters
			local actualSource = src or source
			
			ig.log.Trace("CALLBACK:SERVER", "Received callback request: %s from source: %d (isSimulated: %s)", eventName, actualSource, tostring(cb ~= nil))
			
			-- Unpack arguments safely
			local unpacked = msgpack_unpack(packed)
			local callbackArgs = {table_unpack(unpacked)}
			
			ig.log.Trace("CALLBACK:SERVER", "Arguments count: %d", #callbackArgs)
			
			-- Execute the callback
			local success, result = pcall(function()
				return eventCallback(actualSource, table_unpack(callbackArgs))
			end)
			
			if not success then
				ig.log.Error("CALLBACK:SERVER", "Error executing callback %s: %s", eventName, tostring(result))
				result = nil
			end
			
			ig.log.Debug("CALLBACK:SERVER", "Callback %s executed, preparing response", eventName)
			
			-- check if this is a simulated callback (TriggerServerCallback on server)
			if cb then
				-- return the simulated data (server-side TriggerServerCallback)
				ig.log.Trace("CALLBACK:SERVER", "Sending response via simulated callback (server-to-server)")
				cb( msgpack_pack_args( result ) )
			else
				-- return the data to client (client-side TriggerServerCallback)
				local responseName = ("Client:Callback:Response:%s:%s"):format(eventName, actualSource)
				ig.log.Debug("CALLBACK:SERVER", "Sending response to client via event: %s", responseName)
				TriggerClientEvent(responseName, actualSource, msgpack_pack_args( result ))
				ig.log.Trace("CALLBACK:SERVER", "Response sent to client")
			end
		end)
		-- return the event data to UnregisterServerCallback
		return eventData
	end

	exports("RegisterServerCallback", RegisterServerCallback)
	--
	-- @void UnregisterServerCallback
	-- @wiki:ignore
	--
	-- @table eventData - The data from the RegisterServerCallback
	_G.UnregisterServerCallback = function(eventData)
		RemoveEventHandler(eventData)
	end

	exports("UnregisterServerCallback", UnregisterServerCallback)
	--
	-- @any TriggerClientCallback
	-- @wiki:ignore
	--
	-- @string/number source - The playerId to be triggered
	-- @string eventName - The name of the event to be fired
	-- @table args - The arguments to be sent with the event
	-- [@number timeout - Seconds to wait for response]
	-- [@function timedout - The function that will be executed if timeout is reached]
	-- [@function callback - Asynchronous response]
	_G.TriggerClientCallback = function(args)
		ensure(args, "table"); ensure(args.source, "string", "number"); ensure(args.eventName, "string"); ensure(args.args, "table", "nil"); ensure(args.timeout, "number", "nil"); ensure(args.timedout, "function", "nil"); ensure(args.callback, "function", "nil")

			-- Check rate limit
			if not checkRateLimit(args.source) then
				if args.timedout then
					args.timedout("rate_limited")
				end
				return nil
			end

			-- create a new ticket
			local ticket = generateSecureTicket()
			-- Store ticket with metadata
			local now = GetGameTimer()
			issuedTickets[ticket] = {
				source = tonumber(args.source),
				eventName = args.eventName,
				createdAt = now,
				expiresAt = now + TICKET_VALIDITY_MS
			}
			
			-- create a new promise
			local prom = promise.new()
			-- save the callback function on this call
			local eventCallback = args.callback
			-- save the event data on this call
			local eventData = RegisterNetEvent(("Callback:Return:%s:%s:%s"):format(args.source, args.eventName, ticket), function(packed)
				-- Get the responding source (FiveM provides this as a global in network events)
				local responseSource = tonumber(source)
				
				-- Validate ticket and source before processing
				if not validateTicket(ticket, responseSource) then
				ig.log.Warn("CALLBACK:SECURITY", "Rejected callback return for event %s", args.eventName)
					return
				end
				
				-- Remove ticket after successful validation (one-time use)
				removeTicket(ticket)
				
				-- check if this call was async
				-- & if promise wasn"t rejected or resolved
				if eventCallback and prom.state == PENDING then eventCallback( table_unpack(msgpack_unpack(packed)) ) end
				prom:resolve( table_unpack(msgpack_unpack(packed)) )
			end)

			-- request the callback
			TriggerClientEvent(("Client:Callback:%s"):format(args.eventName), args.source, msgpack_pack(args.args or {}), ticket)

			-- timeout response
			if args.timeout ~= nil and args.timedout then
				local timedout = args.timedout
				SetTimeout(args.timeout * 1000, function()
					-- check if promise wasn"t resolved
					if
						prom.state == PENDING or
						prom.state == REJECTED or
						prom.state == REJECTING
					then
						-- call the timeout callback
						timedout(prom.state)
						-- reject the promise
						if prom.state == PENDING then prom:reject() end
						-- remove the event handler
						RemoveEventHandler(eventData)
						-- Clean up ticket on timeout
						removeTicket(ticket)
					end
				end)
			end

			-- check if this call was async
			if not eventCallback then
				local result = Citizen.Await(prom)
				RemoveEventHandler(eventData)
				-- Clean up ticket after use
				removeTicket(ticket)
				return result
			end
	end

	exports("TriggerClientCallback", TriggerClientCallback)

	--
	-- @any TriggerServerCallback
	-- @wiki:ignore
	-- Simulate a client callback
	--
	-- @string/number source - The simulated playerId that triggers
	-- @string eventName - The name of the event to be fired
	-- @table args - The arguments to be sent with the event
	-- [@number timeout - Seconds to wait for response]
	-- [@function timedout - The function that will be executed if timeout is reached]
	-- [@function callback - Asynchronous response]
	_G.TriggerServerCallback = function(args)
		ensure(args, "table"); ensure(args.source, "string", "number"); ensure(args.eventName, "string"); ensure(args.args, "table", "nil"); ensure(args.timeout, "number", "nil"); ensure(args.timedout, "function", "nil"); ensure(args.callback, "function", "nil")

		-- create a new promise
		local prom = promise.new()
		-- save the callback on this call
		local eventCallback = args.callback
		-- save the event name on this call
		local eventName = args.eventName
		TriggerEvent("Server:Callback:"..eventName, msgpack_pack(args.args or {}), args.source,
		function(packed)
			-- check if this call was async
			-- & if promise wasn"t rejected or resolved
			if eventCallback and prom.state == PENDING then eventCallback( table_unpack(msgpack_unpack(packed)) ) end
			prom:resolve( table_unpack(msgpack_unpack(packed)) )
		end)

		-- timeout response
		if args.timeout ~= nil and args.timedout then
			local timedout = args.timedout
			SetTimeout(args.timeout * 1000, function()
				-- check if promise wasn"t resolved
				if
					prom.state == PENDING or
					prom.state == REJECTED or
					prom.state == REJECTING
				then
					-- call timeout callback
					timedout(prom.state)
					-- reject the promise
					if prom.state == PENDING then prom:reject() end
				end
			end)
		end

		-- check if this call was async
		if not eventCallback then
			return Citizen.Await(prom)
		end
	end
	exports("TriggerServerCallback", TriggerServerCallback)
end

-- CLIENT-SIDE
if not IS_SERVER then
	local SERVER_ID = GetPlayerServerId(PlayerId())

	--
	-- @table RegisterClientCallback
	-- @wiki:ignore
	--
	-- @string eventName - The name of the event to be fired
	-- @function eventCallback - The function to be executed when event is fired
	_G.RegisterClientCallback = function(args)
		ensure(args, "table"); ensure(args.eventName, "string"); ensure(args.eventCallback, "function")
		
		-- save the callback function on this call
		local eventCallback = args.eventCallback
		-- save the event name on this call
		local eventName = args.eventName
		-- save the event data to return
		local eventData = RegisterNetEvent("Client:Callback:"..eventName, function(packed, ticket)
			-- check if this call is simulated (TriggerClientCallback)
			if type(ticket) == "function" then
				-- return the data to the simulated call
				ticket( msgpack_pack_args( eventCallback( table_unpack(msgpack_unpack(packed)) ) ) )
			else
				-- return the data to the call
				TriggerServerEvent(("Callback:Return:%s:%s:%s"):format(SERVER_ID, eventName, ticket), msgpack_pack_args( eventCallback( table_unpack(msgpack_unpack(packed)) ) ))
			end
		end)
		-- return event data so you can UnregisterClientCallback
		return eventData
	end

	exports("RegisterClientCallback", RegisterClientCallback)
	--
	-- @void UnregisterClientCallback
	-- @wiki:ignore
	--
	-- @table eventData - The data from RegisterClientCallback
	_G.UnregisterClientCallback = function(eventData)
		RemoveEventHandler(eventData)
	end

	exports("UnregisterClientCallback", UnregisterClientCallback)
	--
	-- @any TriggerServerCallback
	-- @wiki:ignore
	--
	-- @string eventName - The name of the event to be fired
	-- @table args - The arguments passed with the event
	-- [@number timeout - Seconds to wait for response]
	-- [@function timedout - The function that will be executed if timeout is reached]
	-- [@function callback - Asynchronous response]
	_G.TriggerServerCallback = function(args)
		ensure(args, "table"); ensure(args.args, "table", "nil"); ensure(args.eventName, "string"); ensure(args.timeout, "number", "nil"); ensure(args.timedout, "function", "nil"); ensure(args.callback, "function", "nil")
		
		ig.log.Debug("CALLBACK:CLIENT", "TriggerServerCallback: %s (async: %s)", args.eventName, tostring(args.callback ~= nil))
		ig.log.Trace("CALLBACK:CLIENT", "Arguments: %s", json.encode(args.args or {}))
		ig.log.Trace("CALLBACK:CLIENT", "Server ID: %d", SERVER_ID)
		
		-- create a new promise
		local prom = promise.new()
		-- save the callback function on this call
		local eventCallback = args.callback
		
		-- Create response event name
		local responseEventName = ("Client:Callback:Response:%s:%s"):format(args.eventName, SERVER_ID)
		ig.log.Trace("CALLBACK:CLIENT", "Listening for response: %s", responseEventName)
		
		-- save the event data to remove it when resolved
		local eventData = RegisterNetEvent(responseEventName,
		function(packed)
			ig.log.Debug("CALLBACK:CLIENT", "Received response for: %s", args.eventName)
			
			local success, result = pcall(function()
				return table_unpack(msgpack_unpack(packed))
			end)
			
			if not success then
				ig.log.Error("CALLBACK:CLIENT", "Error unpacking response: %s", tostring(result))
				return
			end
			
			ig.log.Trace("CALLBACK:CLIENT", "Response unpacked successfully")
			
			-- check if this call is async
			-- & the promise wasn"t rejected or resolved
			if eventCallback and prom.state == PENDING then
				ig.log.Trace("CALLBACK:CLIENT", "Executing async callback")
				local callSuccess, callResult = pcall(function()
					eventCallback( result )
				end)
				if not callSuccess then
					ig.log.Error("CALLBACK:CLIENT", "Error in async callback: %s", tostring(callResult))
				end
			end
			
			prom:resolve( result )
		end)

		-- fire the callback event
		ig.log.Debug("CALLBACK:CLIENT", "Triggering server event: Server:Callback:%s", args.eventName)
		TriggerServerEvent("Server:Callback:"..args.eventName, msgpack_pack( args.args or {} ))
		ig.log.Trace("CALLBACK:CLIENT", "Server event triggered")

		-- timeout response
		if args.timeout ~= nil and args.timedout then
			local timedout = args.timedout
			ig.log.Trace("CALLBACK:CLIENT", "Setting timeout: %d seconds", args.timeout)
			SetTimeout(args.timeout * 1000, function()
				-- check if the promise wasn"t resolved yet
				if
					prom.state == PENDING or
					prom.state == REJECTED or
					prom.state == REJECTING
				then
					ig.log.Warn("CALLBACK:CLIENT", "Timeout reached for: %s (state: %d)", args.eventName, prom.state)
					-- call the timeout callback
					timedout(prom.state)
					-- reject the promise if it wasn"t rejected
					if prom.state == PENDING then prom:reject() end
					-- remove the event handler
					RemoveEventHandler(eventData)
				end
			end)
		end

		-- check if this call is async
		if not eventCallback then
			ig.log.Debug("CALLBACK:CLIENT", "Awaiting synchronous response for: %s", args.eventName)
			local result = Citizen.Await(prom)
			RemoveEventHandler(eventData)
			ig.log.Debug("CALLBACK:CLIENT", "Synchronous callback completed: %s", args.eventName)
			return result
		end
	end
	exports("TriggerServerCallback", TriggerServerCallback)

	--
	-- @any TriggerClientCallback
	-- @wiki:ignore
	-- Simulate a server callback
	--
	-- @string eventName - The name of the event to be fired
	-- @table args - The arguments to be sent with the event
	-- [@number timeout - Seconds to wait for response]
	-- [@function timedout - The function that will be executed if timeout is reached]
	-- [@function callback - Asynchronous response]
	_G.TriggerClientCallback = function(args)
		ensure(args, "table"); ensure(args.eventName, "string"); ensure(args.args, "table", "nil"); ensure(args.timeout, "number", "nil"); ensure(args.timedout, "function", "nil"); ensure(args.callback, "function", "nil")

		-- create a new promise for this call
		local prom = promise.new()
		-- save the callback function on this call
		local eventCallback = args.callback
		-- save the event name on this call
		local eventName = args.eventName
		-- trigger the callback
		TriggerEvent("Client:Callback:"..eventName, msgpack_pack(args.args or {}),
		function(packed)
			-- check if it was an async call
			-- & if the promise wasn"t rejected or already resolved
			if eventCallback and prom.state == PENDING then eventCallback( table_unpack(msgpack_unpack(packed)) ) end
			prom:resolve( table_unpack(msgpack_unpack(packed)) )
		end)

		-- timeout response
		if args.timeout ~= nil and args.timedout then
			local timedout = args.timedout
			SetTimeout(args.timeout * 1000, function()
				-- check if the promise wasn"t resolved
				if
					prom.state == PENDING or
					prom.state == REJECTED or
					prom.state == REJECTING
				then
					-- call timeout callback
					timedout(prom.state)
					-- check if it"s pending and reject
					if prom.state == PENDING then prom:reject() end
				end
			end)
		end

		-- check if this call is async
		if not eventCallback then
			return Citizen.Await(prom)
		end
	end

	exports("TriggerClientCallback", TriggerClientCallback)
end

-- ====================================================================================--