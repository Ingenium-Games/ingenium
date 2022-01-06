-- ====================================================================================--
c.class.Object = {}
c.class.Object.__index = c.class.Object
-- ====================================================================================--
local function GetObj(id)
    if type(id) == "string" then
        return c.sql.GetObjectByName(id)
    else
        return {
            Fuel = math.random(25, 89),
            Keys = "{}",
            Inventory = "{}",
            Condition = "{}",
            Modifications = "{}",
            Instance = false,
            Garage = false,
            Status = false,
            Impound = false,
            Owner = false,
            Wanted = false,
        }
    end
end
--- func desc
---@param net any
function c.class.Object:Create(net,id)
    local data = GetObj(id)
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    -- Model (hash)
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model    
    self.Weight = 0
    -- Inventory
    self.Inventory = json.decode(data.Inventory)
    self:UnpackInventory(self.Inventory)
    return self
end
--- func desc
function c.class.Object:GetSource()
    return NetworkGetEntityOwner(self.Entity)
end
--- func desc
function c.class.Object:GetModel()
    return self.Model
end
--- func desc
function c.class.Object:GetCoords()
    local x, y, z = table.unpack(GetEntityCoords(self.Entity))
    local h = GetEntityHeading(self.Entity)
    return {
        ["x"] = c.math.Decimals(x, 2),
        ["y"] = c.math.Decimals(y, 2),
        ["z"] = c.math.Decimals(z, 2),
        ["h"] = c.math.Decimals(h, 2)
    }
end
--- func desc
---@param t any
function c.class.Object:SetCoords(t)
    self.Coords = {
        x = c.math.Decimals(t.x, 2),
        y = c.math.Decimals(t.y, 2),
        z = c.math.Decimals(t.z, 2),
        h = c.math.Decimals(t.h, 2)
    }
end
--- func desc
---@param inv any
function c.class.Object:UnpackInventory(inv)
    local inv = inv or {}
    --
    self.Inventory = {}
    for i = 1, #inv do
        table.insert(self.Inventory, i)
        self.Inventory[i] = {
            ["Item"] = inv[i][1],
            ["Quantity"] = inv[i][2],
            ["Quality"] = inv[i][3],
            ["Weapon"] = inv[i][4],
            ["Meta"] = inv[i][5]
        }
        -- If it is a weapon, does it have more than one in a stack? Or Does it not list itself as a weapon
        if self.Inventory[i].Weapon == true then
            if type(c.item.IsWeapon(self.Inventory[i].Item)) ~= "string" or self.Inventory[i].Quantity >= 1 then
                c.debug_1("Error in Creating Inventory, Weapon quanity or wepaon flag is broken.")
                break
            end
        end
        -- Validate Meta data
        if type(self.Inventory[i].Quantity) ~= "number" or type(self.Inventory[i].Quality) ~= "number" then
            c.debug_1("Error in Creating Inventory, Quantity or Quality is not a number.")
            break
        end
        -- Validate Meta data
        --[[
                if type(self[i].Meta) ~= "table" or type(self[i].Meta) ~= "boolean" then
                c.debug_1("Error in Creating Inventory, Meta data is not false or a table.")
                break
                end
            ]] --
        -- If the Quality is below 0, then destroy the item.
        if self.Inventory[i].Quality <= 0 then
            table.remove(self.Inventory, i)
        end
        -- adding weight into the generation
        for k, v in ipairs(self.Inventory) do
            if c.item.Exists(v.Item) then
                local item = c.items[v.Item]
                self.Weight = self.Weight + item.Weight
            else
                c.debug_1("Ignoring invalid item within .GetWeight(), for Object: " .. self.Name)
            end
        end
    end
end
--- func desc
function c.class.Object:GetInventory()
    return self.Inventory
end
--- func desc
---@param name any
function c.class.Object:HasItem(name)
    for k, v in ipairs(self.Inventory) do
        if v.Item == name then
            return true, k
        end
    end
    return false, nil
end
--
--- func desc
function c.class.Object:GetWeight()
    self.Weight = 0
    for k, v in ipairs(self.Inventory) do
        if c.item.Exists(v.Item) then
            local item = c.items[v.Item]
            self.Weight = self.Weight + item.Weight
        else
            c.debug_1("Ignoring invalid item within .GetWeight(), for Object: " .. self.Name)
        end
    end
    return self.Weight
end
--
--- [Internal] func desc
---@param v table "Must contain a minimum of a name string at point 1 {\"Cash\"}"
function c.class.Object:SteralizeItem(v)
    if type(v) ~= "table" then
        c.debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Object: " .. self.Name)
        return
    end
    local info = {
        ["Item"] = c.check.String(v[1]), -- string
        ["Quantity"] = c.check.Number((v[2] or c.items[v[1]].Quantity)), -- number/int >= 1
        ["Quality"] = c.check.Number((v[3] or c.items[v[1]].Quality)), -- number/int >= 1 <= 100
        ["Weapon"] = (v[4] or c.items[v[1]].Weapon),
        ["Meta"] = (v[5] or c.items[v[1]].Meta)
    }
    return info
end
--
--- func desc
---@param add table "Array Format {\"Name\", 1, math.random(65,100), (String or false), {}}"
function c.class.Object:AddItem(tbl)
    local item = self:SteralizeItem(tbl)
    if c.item.Exists(item.Item) then
        local weapon = c.item.IsWeapon(item.Item)
        local stackable = c.item.CanStack(item.Item)
        local has, key = self:HasItem(item.Item)
        if (weapon and type(item.Weapon) == "string") or (not stackable) then
            self.Inventory[#self.Inventory + 1] = item

        elseif (stackable and has) then
            self.Inventory[key].Quantity = self.Inventory[key].Quantity + item.Quantity

        else
            self.Inventory[#self.Inventory + 1] = item

        end
    else
        c.debug_1("Ignoring invalid .AddItem() for Object: " .. self.Name)
    end
end
--- func desc
---@param name any
---@param slot any
function c.class.Object:RemoveItem(name, slot)
    local has, position = self:HasItem(name)
    if has and slot == position then
        table.remove(self.Inventory, position)
    end
end
--- func desc
---@param new any
---@param old any
function c.class.Object:RearrangeItems(new, old)
    table.insert(self.Inventory, new, table.remove(self.Inventory, old))
end
--- func desc
function c.class.Object:CompressInventory()
    local inv = {}
    for i = 1, #self.Inventory do
        table.insert(inv, i)
        inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality,
                  self.Inventory[i].Weapon, self.Inventory[i].Meta}
    end
    return inv
end
-- ====================================================================================--
--- func desc
---@param net any
function c.class.Object.Generate(net,plate)
    local self = {__index = self}
    setmetatable(self, c.class.Object)
    self:Create(net,plate)
    c.debug_2(c.table.Dump(self))
    return self
end
