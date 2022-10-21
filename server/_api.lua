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
    res.body = c.file.Read("Items.json")
    -- the request body is only recieved with
    -- few diffrent type of requests
	-- the recieved body is already decoding
    req.body = {}
    return res -- the result data should always be returned
end

restfx.route(path, callback, 'GET') --> void