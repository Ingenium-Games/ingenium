-- ====================================================================================--

if not c.class then
    c.class = {}
end

-- ====================================================================================--
--- func desc
---@param tab any
function c.class.Job(tab)
    local self = {}
    self.Name = tab.Name
    self.Label = tab.Label
    self.Boss = tab.Boss
    self.Grades = tab.Grades
    self.Members = tab.Members
    self.Description = tab.Description
    self.Accounts = tab.Accounts
    --
    self.Inventory = json.decode(tab.Inventory)
    self.Stock = json.decode(tab.Stock)
    self.Contact = conf.phone[self.Name] or false
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
        else
            c.func.Debug_1("Unable to set description as length is too long. Must be less than 255 characters.")
        end
    end
    --- func desc
    ---@param b any
    self.GetAccounts = function(b)
        local bool = c.check.Boolean(b)
        if bool then
            local Accounts = {}
            for k, v in pairs(self.Accounts) do
                Accounts[k] = v
            end
            return Accounts
        else
            return self.Accounts
        end
    end
    --- func desc
    ---@param acc any
    self.GetAccount = function(acc)
        for k, v in pairs(self.Accounts) do
            if k == acc then
                return v
            end
        end
    end
    --- func desc
    ---@param acc any
    ---@param v any
    self.SetAccount = function(acc, v)
        local num = c.check.Number(v)
        if self.Accounts[acc] then
            self.Accounts[acc] = c.math.Decimals(num, 2)
        else
            c.func.Debug_1("Account entered does not exist")
        end
    end
    --- func desc
    self.GetSafe = function()
        local acc = self.GetAccount("Safe")
        if acc then
            return acc
        end
    end
    --- func desc
    ---@param v any
    self.SetSafe = function(v)
        local num = c.check.Number(v)
        if num >= 0 then
            local acc = c.math.Decimals(num, 2)
            self.SetAccount("Safe", acc)
        end
    end
    --- func desc
    ---@param v any
    self.AddSafe = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount("Safe")
            if acc then
                local bkp = acc
                acc = acc + c.math.Decimals(num, 2)
                if acc < 0 then
                    self.SetAccount("Safe", bkp)
                    c.func.Debug_1("Job " .. self.Name .. " has AddSafe() Cancelled due to Negative balance remaining.")
                    CancelEvent()
                else
                    self.SetAccount("Safe", acc)
                end
            end
        end
    end
    --- func desc
    ---@param v any
    self.RemoveSafe = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount("Safe")
            if acc then
                local bkp = acc
                acc = acc - c.math.Decimals(num, 2)
                if acc < 0 then
                    self.SetAccount("Safe", bkp)
                    c.func.Debug_1("Job " .. self.Name .. " has RemoveSafe() Cancelled due to Negative balance remaining.")
                    CancelEvent()
                else
                    self.SetAccount("Safe", acc)
                end
            end
        end
    end
    --- func desc
    self.GetBank = function()
        local acc = self.GetAccount("Bank")
        if acc then
            return acc
        end
    end
    --- func desc
    ---@param v any
    self.SetBank = function(v)
        local num = c.check.Number(v)
        local acc = c.math.Decimals(num, 0)
        self.SetAccount("Bank", acc)
    end
    --- func desc
    ---@param v any
    self.AddBank = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount("Bank")
            if acc then
                acc = acc + c.math.Decimals(num, 2)
                if acc < 0 then
                    self.SetAccount("Bank", acc)
                else
                    self.SetAccount("Bank", acc)
                end
            end
        end
    end
    --- func desc
    ---@param v any
    self.RemoveBank = function(v)
        local num = c.check.Number(v)
        if num > 0 then
            local acc = self.GetAccount("Bank")
            if acc then
                acc = acc - c.math.Decimals(num, 2)
                if acc < 0 then
                    self.SetAccount("Bank", acc)
                else
                    self.SetAccount("Bank", acc)
                end
            end
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
        end
    end
    --- func desc
    ---@param member any
    self.RemoveMember = function(member)
        local check = self.FindMember(member)
        if check then
            table.remove(self.Members, member)
        end
    end
    --- func desc
    ---@param member any
    self.SetBoss = function(member)
        self.AddMember(member)
        self.Boss = member
    end
    ---
    self.GetSupplyLevel = function()
        return self.Supplies
    end
    ---
    --- func desc
    ---@param num "number"
    self.SetSupplyLevel = function(num)
        local num = c.check.Number(num)
        local v = c.math.Decimals(num, 0)
        self.Supplies = v
    end
    ---
    --- func desc
    ---@param num "number"
    self.AddSupplies = function(num)
        local num = c.check.Number(num)
        local v = c.math.Decimals(num, 0)
        self.Supplies = self.Supplies + v
    end
    ---
    --- func desc
    ---@param num "number"
    self.RemoveSupplies = function(num)
        local num = c.check.Number(num)
        local v = c.math.Decimals(num, 0)
        self.Supplies = self.Supplies - v
    end
    --
    --- func desc
    self.GetWeight = function()
        self.Weight = 0
        for _, v in pairs(self.Inventory) do
            if c.item.Exists(v.Item) then
                local item = c.items[v.Item]
                self.Weight = self.Weight + item.Weight
            else
                c.func.Debug_1("Ignoring invalid item within .GetWeight()")
            end
        end
        return self.Weight
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        local inv = inv or {}
        -- print(c.table.Dump(inv))
        self.Inventory = {}
        for i = 1, #inv do
            self.Inventory[i] = {
                ["Item"] = inv[i]["Item"] or inv[i][1],
                ["Quantity"] = inv[i]["Quantity"] or inv[i][2],
                ["Quality"] = inv[i]["Quality"] or inv[i][3],
                ["Weapon"] = inv[i]["Weapon"] or inv[i][4],
                ["Meta"] = inv[i]["Meta"] or inv[i][5],
                ["Name"] = inv[i]["Name"] or inv[i][6]
            }
            -- If it is a weapon, does it have more than one in a stack? Or Does it not list itself as a weapon
            if self.Inventory[i].Weapon == true then
                if type(c.item.IsWeapon(self.Inventory[i].Item)) ~= "string" or self.Inventory[i].Quantity >= 1 then
                    c.func.Debug_1("Error in Creating Inventory, Weapon quanity or wepaon flag is broken.")
                    break
                end
            end
            -- Validate Quuality and Quantity are numbers.
            if type(self.Inventory[i].Quantity) ~= "number" or type(self.Inventory[i].Quality) ~= "number" then
                c.func.Debug_1("Error in Creating Inventory, Quantity or Quality is not a number.")
                break
            end
            -- If the Quality is below 0, then destroy the item.
            if self.Inventory[i].Quality <= 0 then
                table.remove(self.Inventory, i)
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
    --- [Internal] func desc
    ---@param v table "Must contain a minimum of a name string at point 1 {\"Cash\"}"
    self.SteralizeItem = function(v)
        if type(v) ~= "table" then
            c.func.Debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Job ID: " .. self.Name)
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
            c.func.Debug_1("Ignoring invalid .AddItem() for Job ID:  " .. self.Name)
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
    -- ====================================================================================--
    ExecuteCommand("add_ace group."..self.Name.." command.bill allow")
    -- ====================================================================================--
    return self
end
