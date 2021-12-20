-- ====================================================================================--
c.class.Object = {}
c.class.Object._index = c.class.Object
-- ====================================================================================--
--- func desc
---@param net any
function c.class.Object:Create(net)
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    -- Model (hash)
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    self.Inventory = c.class.Inventory.New()
end
--- func desc
function c.class.Object:GetSource()
    return NetworkGetEntityOwner(self.Entity)
end
--- func desc
function c.class.Object:GetModel()
    return self.Model
end
-- ====================================================================================--
--- func desc
---@param net any
function c.class.Object.Generate(net)
    local self = {}
	setmetatable(self, c.class.Object:Create(net))
	return self
end