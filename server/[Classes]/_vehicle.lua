-- ====================================================================================--
c.class.Vehicle = {}
c.class.Vehicle._index = c.class.Vehicle
-- ====================================================================================--

local function GetVeh(plate)
    if plate then
        return c.sql.GetVehicleByPlate(plate)
    else
        return {
            Fuel = math.random(25, 89),
            Keys = {},
            Condition = {},
            Modifications = {},
            Instance = false,
            Garage = false,
            Status = false,
            Impound = false,
            Owner = false,
            Wanted = false
        }
    end
end

--- func desc
---@param net any
---@param bool any
function c.class.Vehicle:Create(net, plate)
    local net = net or CancelEvent()
    local plate = plate or false
    local data = GetVeh(plate)
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    -- Model
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    -- Plate
    self.Plate = GetVehicleNumberPlateText(self.Entity)
    self.State.Plate = self.Plate
    -- Inventory
    self.Inventory = c.class.Inventory.New()
    -- Condition
    self.Condition = data.Condition
    -- Modifications
    self.Modifications = data.Modifications
    -- Keys
    self.Keys = data.Keys
    self.State.Keys = self.Keys
    -- Owner
    self.Owner = data.Owner
    self.State.Owner = self.Owner
    -- Wanted
    self.Wanted = data.Wanted
    self.State.Wanted = self.Wanted
    -- Fuel
    self.Fuel = data.Fuel
    self.State.Fuel = self.Fuel
    --
    self.Instance = data.Instance
    self.State.Instance = self.Instance
    --
    self.Garage = data.Garage
    self.State.Garage = self.Garage
    --
    self.Status = data.Status
    self.State.Status = self.Status
    --
    self.Impound = data.Impound
    self.State.Impound = self.Impound
    --
end
--- func desc
function c.class.Vehicle:GetSource()
    return NetworkGetEntityOwner(self.Entity)
end
--- func desc
function c.class.Vehicle:GetModel()
    return self.Model
end
--- func desc
function c.class.Vehicle:GetPlate()
    return self.Plate
end
--- func desc
function c.class.Vehicle:GetCoords()
    local x, y, z = GetEntityCoords(self.Entity)
    local h = GetEntityHeading(self.Entity)
    return {
        ["x"] = c.math.Decimals(x, 2),
        ["y"] = c.math.Decimals(y, 2),
        ["z"] = c.math.Decimals(z, 2),
        ["h"] = c.math.Decimals(h, 2)
    }
end
--- func desc
---@param coords any
function c.class.Vehicle:SetCoords(coords)
    if coords.x and coords.y and coords.z and coords.h then
        SetEntityHeading(self.Entity, coords.h)
        SetEntityCoords(self.Entity, coords.x, coords.y, coords.z, false)
    else
        c.debug_1("Table missing x,y,z,h referance, table dump below: " .. c.table.Dump(coords))
    end
end

--- func desc
function c.class.Vehicle:GetKeys()
    return self.Keys
end
--- func desc
---@param t any
function c.class.Vehicle:SetKeys(t)
    self.Keys = t
    self.State.Keys = self.Keys
end
--- func desc
---@param id any
function c.class.Vehicle:AddKey(id)
    local t = self:GetKeys()
    if not self:CheckKey(id) then
        table.insert(self.Keys, id)
        self.State.Keys = self.Keys
    else
        c.debug_1("User: " .. id .. " Already has key to this vehicle.")
    end
end
--- func desc
---@param id any
function c.class.Vehicle:RemoveKey(id)
    local t = self:GetKeys()
    if self:CheckKey(id) then
        table.remove(self.Keys, id)
        self.State.Keys = self.Keys
    else
        c.debug_1("User: " .. id .. " Never had a key to this vehicle.")
    end
end
--- func desc
---@param id any
function c.class.Vehicle:CheckKey(id)
    local t = self:GetKeys()
    if t[id] then
        return true
    else
        return false
    end
end
--- func desc
function c.class.Vehicle:GetCondition()
    return self.Condition
end
--- func desc
---@param conditions any
function c.class.Vehicle:SetCondition(conditions)
    self.Condition = conditions or TriggerClientCallback({
        source = self:GetSource(),
        eventName = "GetVehicleCondition",
        args = {self.Net}
    })
    TriggerClientCallback({
        source = self:GetSource(),
        eventName = "SetVehicleCondition",
        args = {self.Net}
    })
end
--- func desc
---@param id any
---@param v any
function c.class.Vehicle:AlterCondition(id, v)
    if self:CheckConds(id) then
        self.Condition[id] = v
    end
end
--- func desc
---@param id any
function c.class.Vehicle:CheckConds(id)
    local t = self:GetCondition()
    if t[id] then
        return true
    else
        return false
    end
end
--- func desc
function c.class.Vehicle:GetModifications()
    return self.Modifications
end
--- func desc
---@param modifications any
function c.class.Vehicle:SetModifications(modifications)
    self.Modifications = modifications or TriggerClientCallback({
        source = self:GetSource(),
        eventName = "GetVehicleModifications",
        args = {self.Net}
    })
    TriggerClientCallback({
        source = self:GetSource(),
        eventName = "SetVehicleModifications",
        args = {self.Net}
    })
end
--- func desc
---@param id any
---@param v any
function c.class.Vehicle:AlterModification(id, v)
    if self:CheckMods(id) then
        self.Modifications[id] = v
    end
end
--- func desc
---@param id any
function c.class.Vehicle:CheckMods(id)
    local t = self:GetModifications()
    if t[id] then
        return true
    else
        return false
    end
end
--- func desc
function c.class.Vehicle:GetFuel()
    return self.Fuel
end
--- func desc
---@param v any
function c.class.Vehicle:SetFuel(v)
    local num = c.check.Number(v, 0, 100)
    self.Fuel = num
    self.State.Fuel = num
end
--- func desc
---@param v any
function c.class.Vehicle:AddFuel(v)
    local num = c.check.Number(v, 0, 100)
    self:SetFuel((self:GetFuel() + num))
    self.Fuel = self:GetFuel()
    if self:GetFuel() >= 100 then
        self:SetFuel(100)
        self.Fuel = 100
    end
end
--- func desc
---@param v any
function c.class.Vehicle:RemoveFuel(v)
    local num = c.check.Number(v, 0, 100)
    self:SetFuel((self:GetFuel() - num))
    self.Fuel = self:GetFuel()
    if self:GetFuel() <= 0 then
        self:SetFuel(0)
        self.Fuel = 0
    end
end
--- func desc
function c.class.Vehicle:GetOwner()
    return self.Owner
end
--- func desc
function c.class.Vehicle:GetWanted()
    return self.Wanted
end
-- ====================================================================================--
--- func desc
---@param net any
---@param bool any
function c.class.Vehicle.Generate(net, plate)
    local self = {}
    setmetatable(self, c.class.Vehicle:Create(net, plate))
    return self
end
-- ====================================================================================--
