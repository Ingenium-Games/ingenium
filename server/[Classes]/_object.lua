-- ====================================================================================--

--[[
NOTES
    - 
]] --
-- ====================================================================================--

c.class.Object = {}
c.class.Object._index = c.class.Object

function c.class.Object:Create(net)
    local self = {}
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    --
    -- Current entity owner
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end
    --
    -- Model (hash)
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    --
    self.GetModel = function()
        return self.Model
    end
    --
    self.Weight = 0
    --
    self.Inventory = c.class.Inventory.New()
    --
    return self
end

function c.class.Object.Generate(net)
    local self = {}
	setmetatable(self, c.class.Object:Create(net))
	return self
end