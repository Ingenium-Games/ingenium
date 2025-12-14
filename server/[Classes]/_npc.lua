-- ====================================================================================--
if not c.class then
    c.class = {}
end
-- ====================================================================================--
--- func desc
---@param net any
function c.class.Npc(net)
    local self = {}
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    -- Gender ("Male"/"Female")
    self.Gender, self.GenderString = c.func.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    self.State.GenderString = self.GenderString
    --
    -- Humaniod Model (true/false)
    self.IsHuman = c.func.IsPedHuman(self.Model)
    self.State.IsHuman = self.IsHuman
    --
    -- Animation?
    self.State.Animation = false
    --
    self.IsCuffed = false
    self.State.IsCuffed = self.IsCuffed
    --
    self.IsEscorted = false
    self.State.IsEscorted = self.IsEscorted 
    --
    self.Inventory = {}
    self.Weight = 0
    --
    -- City_ID
    local s1 = string.upper(c.rng.let())
    local s2 = c.rng.nums(4)
    self.City_ID = string.format("%s-%sN", s1, s2)
    self.State.City_ID = self.City_ID
    --
    -- Name 
    if self.Gender and self.IsHuman then
        -- is male, is human
        self.First_Name = c.name.RandomMale()
        self.State.First_Name = self.First_Name
        --
        self.Last_Name = c.name.RandomMale()
        self.State.Last_Name = self.Last_Name
        --
        self.Full_Name = self.First_Name .. " " .. self.Last_Name
        self.State.Full_Name = self.Full_Name
    elseif not self.Gender and self.IsHuman then
        -- is not male but is human
        self.First_Name = c.name.RandomFemale()
        self.State.First_Name = self.First_Name
        --
        self.Last_Name = c.name.RandomMale()
        self.State.Last_Name = self.Last_Name
        --
        self.Full_Name = self.First_Name .. " " .. self.Last_Name
        self.State.Full_Name = self.Full_Name
    end

    --- func desc
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end
    --- func desc
    self.GetModel = function()
        return self.Model
    end
    --- func desc
    self.GetGender = function()
        return self.Gender
    end
    --- func desc
    self.GetFirst_Name = function()
        if self.IsHuman then
            return self.First_Name
        end
        return ""
    end
    --- func desc
    self.GetLast_Name = function()
        if self.IsHuman then
            return self.Last_Name
        end
        return ""
    end
    --- func desc
    self.GetFull_Name = function()
        if self.IsHuman then
            return self.Full_Name
        end
        return ""
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
                c.func.Debug_1("Ignoring invalid item within .GetWeight()")
            end
        end
        return self.Weight
    end
    --
    --- func desc
    self.GetCuffed = function()
        return self.IsCuffed
    end
    --- func desc
    ---@param b any
    self.SetCuffed = function(b)
        local b = c.check.Boolean(b)
        self.IsCuffed = b
        self.State.IsCuffed = self.IsCuffed
    end
        --- func desc
        self.GetEscorted = function()
            return self.IsEscorted
        end
        --- func desc
        ---@param v any
        self.SetEscorted = function(v)
            self.IsEscorted = v
            self.State.IsEscorted = self.IsEscorted
        end
        --- func desc
        self.GetEscorting = function()
            return self.IsEscorting
        end
        --- func desc
        ---@param v any
        self.SetEscorting = function(v)
            self.IsEscorting = v
            self.State.IsEscorting = self.IsEscorting
        end
    --
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        -- Use unified validation function (no source for NPCs)
        local processed, valid, error = c.validation.ValidateAndUnpack(nil, inv)
        
        if not valid then
            c.func.Debug_1("Error unpacking NPC inventory: " .. (error or "unknown"))
            self.Inventory = {}
            self.State.Inventory = self.Inventory
            return
        end
        
        self.Inventory = processed
        self.State.Inventory = self.Inventory
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
    --- [Internal] func desc
    ---@param v table "Must contain a minimum of a name string at point 1 {\"Cash\"}"
    self.SteralizeItem = function(v)
        if type(v) ~= "table" then
            c.func.Debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for NPC: " .. self.Net)
            return
        end
        local info = {
            ["Item"] = c.check.String(v[1]), -- string
            ["Quantity"] = c.check.Number((v[2] or c.items[v[1]].Quantity)), -- number/int >= 1
            ["Quality"] = c.check.Number((v[3] or c.items[v[1]].Quality)), -- number/int >= 1 <= 100
            ["Weapon"] = (v[4] or c.items[v[1]].Weapon),
            ["Meta"] = (v[5] or c.items[v[1]].Meta),
            ["Name"] = (v[6] or c.items[v[1]].Name)
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
            c.func.Debug_1("Ignoring invalid .AddItem() for NPC: " .. self.Net)
        end
    end
    --
    self.GetItemFromPosition = function(position)
        local position = tonumber(position)
        if self.Inventory[position] then
            return self.Inventory[position]
        else
            return false
        end
    end
    --
    self.GetItemMeta = function(position)
        local position = tonumber(position)
        if self.Inventory[position] then
            return self.Inventory[position].Meta
        else
            return false
        end
    end
    --
    self.GetItemData = function(position)
        local position = tonumber(position)
        if self.Inventory[position] then
            return self.Inventory[position].Data
        else
            return false
        end
    end
    --
    self.GetItemQuality = function(name)
        local has, position = self.HasItem(name)
        if has then
            return self.Inventory[position].Quality, position
        else
            return false
        end
    end
    --
    self.GetItemQuantity = function(name)
        local has, position = self.HasItem(name)
        if has then
            return self.Inventory[position].Quantity, position
        else
            return false, false
        end
    end
    --- func desc
    ---@param name any
    ---@param slot any
    self.RemoveItem = function(name, slot)
        local quantity, position = self.GetItemQuantity(name)
        if quantity >= 2 then
            self.Inventory[position].Quantity = self.Inventory[position].Quantity - 1
        elseif quantity <= 1 and slot == position then
            table.remove(self.Inventory, position)
        else
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
            inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality,
                      self.Inventory[i].Weapon, self.Inventory[i].Meta, self.Inventory[i].Name}
        end
        return inv
    end
    -- ====================================================================================--
    self.UnpackInventory(self.Inventory)
    self.AddItem({"Cash", math.random(25, 89), 100, false, false})
    -- ====================================================================================--
    return self
end
