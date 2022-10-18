-- ====================================================================================--

c.object = {} -- function level
c.objects = {} -- database pull - If ever used?	
c.odex = {} -- the iodex/store for currently used vehciles prior to writing to db.

-- ====================================================================================--

---@param net integer "Network ID 16 bit integer"
function c.object.Find(net)
    for k,v in ipairs(c.odex) do
        if k == net and type(v) == "table" then
            return true
        end
    end
    return false
end
