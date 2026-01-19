-- ====================================================================================--
if not ig.class then
    ig.class = {}
end
-- ====================================================================================--
--- func desc
---@wiki:ignore 
---@param tab any
function ig.class.Job(tab)
    local self = {}
    self.Name = tab.Name
    self.Label = tab.Label
    self.Boss = tab.Boss
    self.Grades = tab.Grades
    self.Members = tab.Members
    self.Description = tab.Description
    --
    self.Inventory = json.decode(tab.Inventory)
    self.Stock = json.decode(tab.Stock)
    self.Contact = conf.phone[self.Name] or false
    --
    self.Updated = tab.Updated
    self.Save = false
    --- func desc
    self.SetUpdated = function()
        self.Updated = ig.func.Timestamp()
        self.Save = true
    end
    --- func desc
    self.Saved = function()
        self.Save = false
    end
    --- func desc
    self.ShouldSave = function()
         return self.Save
    end
    --- func desc
    self.GetName = function()
        return self.Name
    end
    --- func desc
    self.GetGrades = function()
        return self.Grades
    end
    --- func desc
    self.GetGradeSalery = function(Grade)
        return self.Grades[Grade].Grade_Salary
    end
    --- func desc
    self.GetDescription = function()
        return self.Description
    end
    --- func desc
    ---@param s any
    self.SetDescription = function(s)
        local str = tostring(s)
        if #str <= 1500 then
            self.Description = str
            self.SetUpdated()
        else
            ig.log.Debug("Job", "Unable to set description as length is too long. Must be less than 1500 characters.")
        end
    end
    --- func desc
    ---@param member any
    self.FindMember = function(member)
        for _, v in pairs(self.Members) do
            if v == member then
                return true
            end
        end
        return false
    end
    --- func desc
    ---@param member any
    self.AddMember = function(member)
        local check = self.FindMember(member)
        if not check then
            table.insert(self.Members, member)
            self.SetUpdated()
        end
    end
    --- func desc
    ---@param member any
    self.RemoveMember = function(member)
        local check = self.FindMember(member)
        if check then
            table.remove(self.Members, member)
            self.SetUpdated()
        end
    end
    --- func desc
    ---@param member any
    self.SetBoss = function(member)
        self.AddMember(member)
        self.Boss = member
        self.SetUpdated()
    end
    ---
    self.GetSupplyLevel = function()
        return self.Supplies
    end
    ---
    --- func desc
    ---@param num "number"
    self.SetSupplyLevel = function(num)
        local num = ig.check.Number(num)
        local v = ig.math.Decimals(num, 0)
        self.Supplies = v
        self.SetUpdated()
    end
    ---
    --- func desc
    ---@param num "number"
    self.AddSupplies = function(num)
        local num = ig.check.Number(num)
        local v = ig.math.Decimals(num, 0)
        self.Supplies = self.Supplies + v
        self.SetUpdated()
    end
    ---
    --- func desc
    ---@param num "number"
    self.RemoveSupplies = function(num)
        local num = ig.check.Number(num)
        local v = ig.math.Decimals(num, 0)
        self.Supplies = self.Supplies - v
        self.SetUpdated()
    end
    --
    --- func desc
    self.GetWeight = function()
        self.Weight = 0
        for _, v in pairs(self.Inventory) do
            if ig.item.Exists(v.Item) then
                local item = ig.items[v.Item]
                self.Weight = self.Weight + item.Weight
            else
                ig.log.Debug("Job", "Ignoring invalid item within .GetWeight() for Job ID: " .. self.Name)
            end
        end
        return self.Weight
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        -- Use unified validation function (no source for jobs)
        local processed, valid, error = ig.validation.ValidateAndUnpack(nil, inv)
        
        if not valid then
            ig.log.Debug("Job", "Error unpacking job inventory: " .. (error or "unknown"))
            self.Inventory = {}
            return
        end
        
        self.Inventory = processed
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
    --- [Internal] func desc
    ---@param v table "Must contain a minimum of a name string at point 1 {\"Cash\"}"
    self.SteralizeItem = function(v)
        if type(v) ~= "table" then
            ig.log.Debug("Job", "Ignoring invalid .SteralizeItem() while .AddItem() was called, for Job ID: " .. self.Name)
            return
        end
        local info = {
            ["Item"] = ig.check.String(v[1]), -- string
            ["Quantity"] = ig.check.Number((v[2] or ig.items[v[1]].Quantity)), -- number/int >= 1
            ["Quality"] = ig.check.Number((v[3] or ig.items[v[1]].Quality)), -- number/int >= 1 <= 100
            ["Weapon"] = (v[4] or ig.items[v[1]].Weapon),
            ["Meta"] = (v[5] or ig.items[v[1]].Meta),
            ["Name"] = (v[6] or ig.items[v[1]].Name)
        }
        return info
    end
    --
    --- func desc
    ---@param add table "Array Format {\"Name\", 1, math.random(65,100), (String or false), {}}"
    self.AddItem = function(tbl)
        local item = self.SteralizeItem(tbl)
        if ig.item.Exists(item.Item) then
            local weapon = ig.item.IsWeapon(item.Item)
            local stackable = ig.item.CanStack(item.Item)
            local has, key = self.HasItem(item.Item)
            if (weapon and type(item.Weapon) == "string") or (not stackable) then
                self.Inventory[#self.Inventory + 1] = item
            elseif (stackable and has) then
                self.Inventory[key].Quantity = self.Inventory[key].Quantity + item.Quantity
            else
                self.Inventory[#self.Inventory + 1] = item
            end
            self.SetUpdated()
        else
            ig.log.Debug("Job", "Ignoring invalid .AddItem() for Job ID:  " .. self.Name)
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
        self.SetUpdated()
    end
    --- func desc
    ---@param new any
    ---@param old any
    self.RearrangeItems = function(new, old)
        table.insert(self.Inventory, new, table.remove(self.Inventory, old))
        self.SetUpdated()
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
    --    --
    self.GetCash = function()
        local amount, position = self.GetItemQuantity("Cash")
        local a, p = self.GetItemQuantity("Change")
        if amount then
            if a > 0 then
                return ig.math.Decimals((amount + (a / 100)), 2)
            else
                return ig.math.Decimals(amount, 2)
            end
        else
            return 0
        end
    end
    --
    self.SetCash = function(v)
        -- Rate limiting check
        if ig.security and ig.security.CheckTransactionRateLimit and ig.security.CheckTransactionRateLimit(self, "set_cash") then
            return
        end
        
        -- negative check first
        if v < 0.00 then
            self.Notify("Nope")
            ig.log.Error("Player",
                "self.SetCash: for " ..
                    self.ID)
            CancelEvent()
            return
        end

        -- DollarBillz Yall
        local amount, position = self.GetItemQuantity("Cash")
        local a, p = self.GetItemQuantity("Change")

        local num = ig.check.Number(v)
        local mod = ig.math.Decimals((math.fmod(num, 1) * 100), 0) -- each decimal is a cent

        if amount > 0 then
            self.Inventory[position].Quantity = ig.math.Decimals(num, 0)
        else
            self.AddItem({"Cash", num, 100, false, false})
        end

        -- Coins
        if mod > 0 then
            if a > 0 then
                self.Inventory[p].Quantity = a + mod
            else
                self.AddItem({"Change", mod, 100, false, false})
            end
        end 

        self.State.Cash = self.GetCash()
        TriggerClientEvent("Client:Inventory:Update", self.ID)
        
        -- Transaction logging
        if ig.security and ig.security.LogPlayerTransaction then
            ig.security.LogPlayerTransaction(self, "set_cash", num, "SetCash API call")
        end
    end
    --
    self.AddCash = function(v)
        -- Rate limiting check
        if ig.security and ig.security.CheckTransactionRateLimit and ig.security.CheckTransactionRateLimit(self, "add_cash") then
            return
        end
        
        -- negative check first
        if v < 0 then
            self.Notify("Nope")
            ig.log.Error("Player",
                "self.AddCash: for " ..
                    self.ID)
            CancelEvent()
            return
        end

        -- DollarBillz Yall
        local amount, position = self.GetItemQuantity("Cash")
        local a, p = self.GetItemQuantity("Change")

        local num = ig.check.Number(v)
        local mod = ig.math.Decimals((math.fmod(num, 1) * 100), 0) -- each decimal is a cent

        -- Dallar Billz
        if amount > 0 then
            self.Inventory[position].Quantity = amount + ig.math.Decimals(num, 0)
        else
            self.AddItem({"Cash", ig.math.Decimals(num, 0), 100, false, false})
        end

        -- Coins
        if mod > 0 then
            if a > 0 then
                self.Inventory[p].Quantity = a + mod
            else
                self.AddItem({"Change", mod, 100, false, false})
            end
        end

        self.State.Cash = self.GetCash()
        TriggerClientEvent("Client:Inventory:Update", self.ID)
        
        -- Transaction logging
        if ig.security and ig.security.LogPlayerTransaction then
            ig.security.LogPlayerTransaction(self, "add_cash", num, "AddCash API call")
        end
    end
    --
    self.RemoveCash = function(v)
        -- Rate limiting check
        if ig.security and ig.security.CheckTransactionRateLimit and ig.security.CheckTransactionRateLimit(self, "remove_cash") then
            return
        end
        
        -- negative check first
        if self.GetCash() < ig.math.Decimals(v, 2) then
            self.Notify("Nope")
            ig.log.Error("Player",
                "self.RemoveCash: for " ..
                    self.ID)
            CancelEvent()
            return
        end

        local amount, position = self.GetItemQuantity("Cash")
        local a, p = self.GetItemQuantity("Change")

        local num = ig.check.Number(v)
        local mod = ig.math.Decimals((math.fmod(num, 1) * 100), 0) -- each decimal is a cent
        local billz = ig.math.Decimals(num, 0)

        -- Dollarr Billz
        if amount >= 1 then
            if (amount - billz) == 0 then
                self.RemoveItem("Cash", position, billz)
            elseif (amount - billz) > 0 then
                self.Inventory[position].Quantity = self.Inventory[position].Quantity - billz
            end
        end

        -- Coins
        if mod > 0 then
            if a >= 0 then
                if (a - mod) == 0 then
                    self.RemoveItem("Change", p, mod)
                elseif (a - mod) > 0 then
                    self.Inventory[p].Quantity = a - mod
                    -- If you got chash, break it into change.
                elseif (a - mod) <= 0 then
                    local _a, _p = self.GetItemQuantity("Cash")
                    if (_a - num) > 0 then
                        self.Inventory[_p].Quantity = self.Inventory[_p].Quantity - 1
                        self.AddItem({"Change", 100, 100})
                        --
                        local __a, __p = self.GetItemQuantity("Change")
                        self.Inventory[__p].Quantity = __a - mod
                    else
                        self.Notify("You dont have the cash to break...")
                    end
                end
            end
        end

        self.State.Cash = self.GetCash()
        TriggerClientEvent("Client:Inventory:Update", self.ID)
        
        -- Transaction logging
        if ig.security and ig.security.LogPlayerTransaction then
            ig.security.LogPlayerTransaction(self, "remove_cash", num, "RemoveCash API call")
        end
    end

    self.PayBalance = function(v)
        local num = ig.check.Number(v)
        if self.GetCash() >= num then
            self.RemoveCash(num)
        else
            self.Notify("You do not have enough cash to pay the balance.")
            ig.log.Error("Player",
                "Insufficient funds in self.PayBalance: for " ..
                    self.First_Name .. " " .. self.Last_Name .. " (" .. self.ID .. ") trying to pay " .. tostring(num))
            CancelEvent()
        end
    end
    --
    -- ====================================================================================--
    self.UnpackInventory(self.Inventory)
    -- ====================================================================================--
    ExecuteCommand("add_ace group." .. self.Name .. " command.bill allow")
    -- ====================================================================================--
    return self
end
