ig.object = {}
ig.objects = {}
ig.odex = {} -- the odex/store for currently generated objects


---@param net integer "Network ID 16 bit integer"
function ig.object.FindObject(net)
    for k, v in pairs(ig.odex) do
        if v then
            if k == net and type(v) == "table" then
                return true, v, k
            end
        end
    end
    return false, false, false
end

---@param net integer "Network ID 16 bit integer"
function ig.object.FindObjectFromUUID(uuid)
    for k, v in pairs(ig.odex) do
        if v and (v.UUID == uuid) then
            return true, v, k
        end
    end
    return false, false, false
end

---@param net integer "Network ID 16 bit integer"
function ig.object.GetObjectFromUUID(uuid)
    for k, v in pairs(ig.odex) do
        if v and (v.UUID == uuid) then
            return v
        end
    end
    return false
end

--- func desc
---@param net any
---@param cb any
function ig.object.AddObject(net, cb, ...)
    if not ig.objects.FindObject(net) then
        ig.odex[tostring(net)] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function ig.object.GetObject(net)
    return ig.odex[tostring(net)] or false
end

--- Get all xVehicles
function ig.object.GetObjects()
    return ig.odex
end

-- Set to nil for garbage collection
--- func desc
---@param uuid any
function ig.object.RemoveObject(uuid)
    ig.odex[tostring(uuid)] = nil
end