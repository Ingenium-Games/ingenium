ig.object = {}
ig.objects = {}
ig.odex = {} -- the odex/store for currently generated objects


---@param net integer "Network ID 16 bit integer"
function ig.objects.FindObject(net)
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
function ig.objects.FindObjectFromUUID(uuid)
    for k, v in pairs(ig.odex) do
        if v and (v.UUID == uuid) then
            return true, v, k
        end
    end
    return false, false, false
end

---@param net integer "Network ID 16 bit integer"
function ig.objects.GetObjectFromUUID(uuid)
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
function ig.objects.AddObject(net, cb, ...)
    if not ig.objects.FindObject(net) then
        ig.odex[tostring(net)] = cb(...)
    end
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer"
function ig.objects.GetObject(net)
    return ig.odex[tostring(net)] or false
end

--- Same as above.
---@param net integer "Network ID 16 bit integer"
function ig.GetObject(net)
    return ig.objects.GetObject(net)
end

--- Get all xVehicles
function ig.objects.GetObjects()
    return ig.odex
end

--- Get all xVehicles
function ig.GetObjects()
    return ig.objects.GetObjects()
end

-- Set to nil for garbage collection
--- func desc
---@param uuid any
function ig.objects.RemoveObject(uuid)
    ig.odex[tostring(uuid)] = nil
end