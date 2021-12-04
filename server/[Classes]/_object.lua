-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--[[
NOTES
    - 
]] --
-- ====================================================================================--

function c.class.CreateObject(net)
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
    self.Inventory = {}
    self.State.Inventory = self.Inventory
    --
    self.GetInventory = function()
        return self.Inventory
    end
    --
    self.HasItem = function(name)
        for k,v in ipairs(self.Inventory) do
            if v.Item == name then
                return true, k 
            end
        end
        return false, nil
    end
    --
    --
    self.GetWeight = function()
        self.Weight = 0
        for k,v in ipairs(self.Inventory) do
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
            c.debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Player ID: "..self.ID)
            return 
        end
        local info = {
            ["Item"] = c.check.String(v[1]), -- string
            ["Quantity"] = c.check.Number((v[2] or c.items[v[1]].Quantity)), -- number/int >= 1
            ["Quality"] = c.check.Number((v[3] or c.items[v[1]].Quality)), -- number/int >= 1 <= 100
            ["Weapon"] = (v[4] or c.items[v[1]].Weapon),
            ["Meta"] = (v[5] or c.items[v[1]].Meta),
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
                self.State.Inventory = self.Inventory
            elseif (stackable and has) then
                self.Inventory[key].Quantity = self.Inventory[key].Quantity + item.Quantity
                self.State.Inventory = self.Inventory
            else
                self.Inventory[#self.Inventory + 1] = item
                self.State.Inventory = self.Inventory
            end
        else
            c.debug_1("Ignoring invalid .AddItem() for "..self.ID)
        end
    end
    -- 
    self.RemoveItem = function(name, slot)
        local has, position = self.HasItem(name)
        if has and slot == position then
            table.remove(self.Inventory, position)
            self.State.Inventory = self.Inventory
        end
    end
    --
    self.RearrangeItems = function(new, old)
        table.insert(self.Inventory, new, table.remove(self.Inventory, old))
        self.State.Inventory = self.Inventory
    end
    --
    self.CompressInventory = function()
        local inv = {}
        for i=1, #self.Inventory do
            table.insert(inv, i)
            inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality, self.Inventory[i].Weapon, self.Inventory[i].Meta}
        end
        return inv
    end
    --
    return self
end