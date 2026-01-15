local path = '/items'
local callback = function(req, res)
    -- default request data
    req.head            = {}
    req.method          = 'GET'
    req.address         = '127.0.0.1'
    -- path and param data
    req.path.base       = 'items'
    req.path.registered = '/items'
    req.path.full       = '/items'
    -- change the response body if you want to
    res.body = ig.file.Read("items.json")
    -- the request body is only recieved with
    -- few diffrent type of requests
	-- the recieved body is already decoding
    req.body = {}
    return res -- the result data should always be returned
end

if type(restfx) == "table" and type(restfx.route) == "function" then
    restfx.route(path, callback, 'GET') --> void
else
    ig.log.Warn("restfx not available - skipping API route: " .. tostring(path))
end

local path2 = '/jobs'
local callback2 = function(req, res)
    -- default request data
    req.head            = {}
    req.method          = 'GET'
    req.address         = '127.0.0.1'
    -- path and param data
    req.path.base       = 'jobs'
    req.path.registered = '/jobs'
    req.path.full       = '/jobs'
    -- change the response body if you want to
    res.body = ig.file.Read("jobs.json")
    -- the request body is only recieved with
    -- few diffrent type of requests
	-- the recieved body is already decoding
    req.body = {}
    return res -- the result data should always be returned
end

if type(restfx) == "table" and type(restfx.route) == "function" then
    restfx.route(path2, callback2, 'GET') --> void
else
    ig.log.Warn("restfx not available - skipping API route: " .. tostring(path2))
end