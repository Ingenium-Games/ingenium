-- ====================================================================================--
if not c.class then
    c.class = {}
end
-- ====================================================================================--
local function GetVeh(plate)
    if type(plate) == "string" then
        return c.sql.GetVehicleByPlate(plate)
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
            Wanted = false
        }
    end
end
--- func desc
---@param net any
---@param bool any
function c.class.Vehicle(net, plate)
    local net = net or CancelEvent()
    local plate = false or plate
    local data = GetVeh(plate)
    local self = {}
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    -- Model
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    -- Plate
    self.Plate = GetVehicleNumberPlateText(self.Entity)
    self.State.Plate = self.Plate
    --
    self.Weight = 0
    -- Inventory
    self.Inventory = json.decode(data.Inventory)
    -- Condition
    self.Condition = json.decode(data.Condition)
    -- Modifications
    self.Modifications = json.decode(data.Modifications)
    -- Keys
    self.Keys = json.decode(data.Keys)
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

    --- func desc
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end
    --- func desc
    self.GetModel = function()
        return self.Model
    end
    --- func desc
    self.GetPlate = function()
        return self.Plate
    end
    --- func desc
    self.GetCoords = function()
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
    ---@param coords any
    self.SetCoords = function(coords)
        if coords.x and coords.y and coords.z and coords.h then
            SetEntityHeading(self.Entity, coords.h)
            SetEntityCoords(self.Entity, coords.x, coords.y, coords.z, false)
        else
            c.debug_1("Table missing x,y,z,h referance, table dump below: " .. c.table.Dump(coords))
        end
    end

    --- func desc
    self.GetKeys = function()
        return self.Keys
    end
    --- func desc
    ---@param t any
    self.SetKeys = function(t)
        self.Keys = t
        self.State.Keys = self.Keys
    end
    --- func desc
    ---@param id any
    self.AddKey = function(id)
        local t = self.GetKeys()
        if not self.CheckKey(id) then
            table.insert(self.Keys, id)
            self.State.Keys = self.Keys
        else
            c.debug_1("User: " .. id .. " Already has key to this vehicle.")
        end
    end
    --- func desc
    ---@param id any
    self.RemoveKey = function(id)
        local t = self.GetKeys()
        if self.CheckKey(id) then
            table.remove(self.Keys, id)
            self.State.Keys = self.Keys
        else
            c.debug_1("User: " .. id .. " Never had a key to this vehicle.")
        end
    end
    --- func desc
    ---@param id any
    self.CheckKey = function(id)
        local t = self.GetKeys()
        if t[id] then
            return true
        else
            return false
        end
    end
    --- func desc
    self.GetCondition = function()
        return self.Condition
    end
    --- func desc
    ---@param conditions any
    self.SetCondition = function(conditions)
        self.Condition = conditions or TriggerClientCallback({
            source = self.GetSource(),
            eventName = "GetVehicleCondition",
            args = {self.Net}
        })
        TriggerClientCallback({
            source = self.GetSource(),
            eventName = "SetVehicleCondition",
            args = {self.Net}
        })
    end
    --- func desc
    ---@param id any
    ---@param v any
    self.AlterCondition = function(id, v)
        if self.CheckConds(id) then
            self.Condition[id] = v
        end
    end
    --- func desc
    ---@param id any
    self.CheckConds = function(id)
        local t = self.GetCondition()
        if t[id] then
            return true
        else
            return false
        end
    end
    --- func desc
    self.GetModifications = function()
        return self.Modifications
    end
    --- func desc
    ---@param modifications any
    self.SetModifications = function(modifications)
        self.Modifications = modifications or TriggerClientCallback({
            source = self.GetSource(),
            eventName = "GetVehicleModifications",
            args = {self.Net}
        })
        TriggerClientCallback({
            source = self.GetSource(),
            eventName = "SetVehicleModifications",
            args = {self.Net}
        })
    end
    --- func desc
    ---@param id any
    ---@param v any
    self.AlterModification = function(id, v)
        if self:CheckMods(id) then
            self.Modifications[id] = v
        end
    end
    --- func desc
    ---@param id any
    self.CheckMods = function(id)
        local t = self.GetModifications()
        if t[id] then
            return true
        else
            return false
        end
    end
    --- func desc
    self.GetFuel = function()
        return self.Fuel
    end
    --- func desc
    ---@param v any
    self.SetFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.Fuel = num
        self.State.Fuel = num
    end
    --- func desc
    ---@param v any
    self.AddFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self:SetFuel((self:GetFuel() + num))
        self.Fuel = self:GetFuel()
        self.State.Fuel = self.Fuel
        if self:GetFuel() >= 100 then
            self:SetFuel(100)
            self.Fuel = 100
            self.State.Fuel = 100
        end
    end
    --- func desc
    ---@param v any
    self.RemoveFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self:SetFuel((self:GetFuel() - num))
        self.Fuel = self:GetFuel()
        self.State.Fuel = self.Fuel
        if self:GetFuel() <= 0 then
            self:SetFuel(0)
            self.Fuel = 0
            self.State.Fuel = 0
        end
    end
    --- func desc
    self.GetOwner = function()
        return self.Owner
    end
    --- func desc
    self.GetWanted = function()
        return self.Wanted
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        local inv = inv or {}
        --
        self.Inventory = {}
        for i = 1, #inv do
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
                    c.debug_1("Ignoring invalid item within .GetWeight()")
                end
            end
        end
    end
    --- func desc
    self.GetInventory = function()
        return self.Inventory
    end
    --- func desc
    ---@param name any
    self.HasItem = function(name)
        for k, v in ipairs(self.Inventory) do
            if v.Item == name then
                return true, k
            end
        end
        return false, nil
    end
    --
    --- func desc
    self.GetWeight = function()
        self.Weight = 0
        for k, v in ipairs(self.Inventory) do
            if c.item.Exists(v.Item) then
                local item = c.items[v.Item]
                self.Weight = self.Weight + item.Weight
            else
                c.debug_1("Ignoring invalid item within .GetWeight()")
            end
        end
        return self.Weight
    end
    --
    --- [Internal] func desc
    ---@param v table "Must contain a minimum of a name string at point 1 {\"Cash\"}"
    self.SteralizeItem = function(v)
        if type(v) ~= "table" then
            c.debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Vehicle: " .. self.Net)
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
    self.AddItem = function(tbl)
        local item = self.SteralizeItem(tbl)
        if c.item.Exists(item.Item) then
            local weapon = c.item.IsWeapon(item.Item)
            local stackable = c.item.CanStack(item.Item)
            local has, key = self.HasItem(item.Item)
            if (weapon and type(item.Weapon) == "string") or (not stackable) then
                self.Inventory[#self.Inventory + 1] = item

            elseif (stackable and has) then
                self.Inventory[key].Quantity = self.Inventory[key].Quantity + item.Quantity

            else
                self.Inventory[#self.Inventory + 1] = item

            end
        else
            c.debug_1("Ignoring invalid .AddItem() for Vehicle: " .. self.Net)
        end
    end
    --- func desc
    ---@param name any
    ---@param slot any
    self.RemoveItem = function(name, slot)
        local has, position = self.HasItem(name)
        if has and slot == position then
            table.remove(self.Inventory, position)
        end
    end
    --- func desc
    ---@param new any
    ---@param old any
    self.RearrangeItems = function(new, old)
        table.insert(self.Inventory, new, table.remove(self.Inventory, old))
    end
    --- func desc
    self.CompressInventory = function()
        local inv = {}
        for i = 1, #self.Inventory do
            table.insert(inv, i)
            inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality,
                      self.Inventory[i].Weapon, self.Inventory[i].Meta}
        end
        return inv
    end
    -- ====================================================================================--
    self.UnpackInventory(self.Inventory)
    -- ====================================================================================--
    return self
end
-- ====================================================================================--
