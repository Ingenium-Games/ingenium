-- ====================================================================================--
--[[
NOTES.
    - Probably going to have to meta table this shit...
    
    EXAMPLE: 
    
    Inventory from DB: 
    {1:{"item", 1, 100, false, {metadata}}, 2:false, 3:{"item", 1, 100, "-12321321", {metadata}}, 4:false, 5:{"item"}}
    
    
    Slot 1, has a quntity of 1 and has 100 quality and is not a weapon.
    Slot 2 is empty
    Slot 3 has, a quantity of 1, quality of 100, and is a weapon based on its hash, with metadata about it after.

]] --
-- ====================================================================================--
c.class.Inventory = {}
c.class.Inventory._index = c.class.Inventory

function c.class.Inventory:Create(inv)
    local self = {}
    self.Inventory = {}
    self.Weight = 0
    --
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
    end
    --
    self.GetInventory = function()
        return self.Inventory
    end
    --
    self.HasItem = function(name)
        for k, v in ipairs(self.Inventory) do
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
            c.debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Player ID: " .. self.ID)
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
            c.debug_1("Ignoring invalid .AddItem() for " .. self.ID)
        end
    end
    -- 
    self.RemoveItem = function(name, slot)
        local has, position = self.HasItem(name)
        if has and slot == position then
            table.remove(self.Inventory, position)
        end
    end
    --
    self.RearrangeItems = function(new, old)
        table.insert(self.Inventory, new, table.remove(self.Inventory, old))
    end
    --
    self.CompressInventory = function()
        local inv = {}
        for i = 1, #self.Inventory do
            table.insert(inv, i)
            inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality,
                      self.Inventory[i].Weapon, self.Inventory[i].Meta}
        end
        return inv
    end
    return self
end

function c.class.Inventory.New(inv)
    local self = {} 
    setmetatable(self, c.class.Inventory:Create(inv))
    return self
end
