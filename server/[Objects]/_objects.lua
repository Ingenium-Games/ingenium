-- ====================================================================================--

c.object = {} -- function level
c.objects = {} -- database pull 
c.odex = {} -- the odex/store for currently used objects prior to storage

-- ====================================================================================--

--- func desc
---@param coords any
function c.object.FindByUUID(UUID)
    for k, v in pairs(c.objects) do
        if k == UUID then
            return true, v
        end
    end
    return false, false
end
