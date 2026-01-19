-- ====================================================================================--
if not ig.class then
    ig.class = {}
end
-- ====================================================================================--

--- func desc
---@wiki:ignore 
---@param net any
function ig.class.BlankObject(net)
    local self = {}
    --
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    -- Model (hash)
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    -- Data Sent
    self.UUID = ig.rng.UUID()
    self.State.UUID = self.UUID
    --
    self.Created = ig.func.Timestamp()
    self.State.Created = self.Created
    --
    self.Updated = ig.func.Timestamp()
    self.State.Updated = self.Updated
    --
    self.IsDirty = false
    self.DirtyFields = {}
    --
    -- Cached JSON Encoding for Performance
    self.EncodedInventory = nil
    --
    -- ====================================================================================--
    -- Dirty Flag Helper Methods
    -- ====================================================================================--
    self.GetIsDirty = function()
        return self.IsDirty
    end
    --
    self.ClearDirty = function()
        self.IsDirty = false
        self.DirtyFields = {}
    end
    --
    self.MarkDirty = function(fieldName)
        self.IsDirty = true
        if fieldName then
            self.DirtyFields[fieldName] = true
        end
    end
    --
    self.SetUpdated = function()
        self.Updated = ig.func.Timestamp()
        self.IsDirty = true
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
    self.GetCoords = function()
        local x, y, z = table.unpack(GetEntityCoords(self.Entity))
        local h = GetEntityHeading(self.Entity)
        local rx, ry, rz = table.unpack(GetEntityRotation((self.Entity)))
        return {
            ["x"] = ig.math.Decimals(x, 2),
            ["y"] = ig.math.Decimals(y, 2),
            ["z"] = ig.math.Decimals(z, 2),
            ["h"] = ig.math.Decimals(h, 2),
            ["rx"] = ig.math.Decimals(rx, 2),
            ["ry"] = ig.math.Decimals(ry, 2),
            ["rz"] = ig.math.Decimals(rz, 2)
        }
    end
    --- func desc
    ---@param t any
    self.SetCoords = function(t)
        self.Coords = {
            x = ig.math.Decimals(t.x, 2),
            y = ig.math.Decimals(t.y, 2),
            z = ig.math.Decimals(t.z, 2),
            h = ig.math.Decimals(t.h, 2),
            rx = ig.math.Decimals(t.rx, 2),
            ry = ig.math.Decimals(t.ry, 2),
            rz = ig.math.Decimals(t.rz, 2),
        }
        --
        SetEntityCoords(self.Entity, vec3(self.Coords.x, self.Coords.y, self.Coords.z))
        SetEntityHeading(self.Entity, self.Coords.h)
        SetEntityRotation(self.Entity, vec3(self.Coords.rx, self.Coords.ry, self.Coords.rz), 3)
        ---
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
                ig.log.Debug("Inventory", "Ignoring invalid item within .GetWeight() for " .. self.Net)
            end
        end
        return self.Weight
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        local inv = inv or {}
        -- print(ig.table.Dump(inv))
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
                if type(ig.item.IsWeapon(self.Inventory[i].Item)) ~= "string" or self.Inventory[i].Quantity >= 1 then
                    ig.log.Debug("Inventory", "Error in Creating Inventory, Weapon quantity or weapon flag is broken for " .. self.Net)
                    break
                end
            end
            -- Validate Quuality and Quantity are numbers.
            if type(self.Inventory[i].Quantity) ~= "number" or type(self.Inventory[i].Quality) ~= "number" then
                ig.log.Debug("Inventory", "Error in Creating Inventory, Quantity or Quality is not a number for " .. self.Net)
                break
            end
            -- If the Quality is below 0, then destroy the item.
            if self.Inventory[i].Quality <= 0 then
                table.remove(self.Inventory, i)
            end
        end
        self.State.Inventory = self.Inventory
    end
    --- func desc
    self.GetInventory = function()
        return self.Inventory
    end
    --- Sync inventory to state bag
    --- NOTE: This method is rarely needed as AddItem, RemoveItem, and RearrangeItems
    --- automatically sync state bags. Use this only if you directly modify self.Inventory
    --- (which is not recommended) or need explicit control over sync timing.
    self.SyncInventory = function()
        self.State.Inventory = self.Inventory
        self.SetUpdated()
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
            ig.log.Debug("Inventory", "Ignoring invalid .SteralizeItem() while .AddItem() was called, for Object : " .. self.Net)
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
            self.State.Inventory = self.Inventory
            self.DirtyFields.Inventory = true
            self.EncodedInventory = nil
        else
            ig.log.Debug("Inventory", "Ignoring invalid .AddItem() for Object : " .. self.Net)
        end
        self.SetUpdated()
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
    --
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
        self.State.Inventory = self.Inventory
        self.DirtyFields.Inventory = true
        self.EncodedInventory = nil
        self.SetUpdated()
    end
    --- func desc
    ---@param new any
    ---@param old any
    self.RearrangeItems = function(new, old)
        table.insert(self.Inventory, new, table.remove(self.Inventory, old))
        self.State.Inventory = self.Inventory
        self.DirtyFields.Inventory = true
        self.EncodedInventory = nil
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
        --
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
    --
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
    -- Cached JSON Encoding Methods
    -- ====================================================================================--
    self.GetEncodedInventory = function()
        if not self.EncodedInventory or self.DirtyFields.Inventory then
            self.EncodedInventory = json.encode(self.CompressInventory())
            self.DirtyFields.Inventory = false
        end
        return self.EncodedInventory
    end
    --
    self.GetEncodedCoords = function()
        if not self.EncodedCoords or self.DirtyFields.Coords then
            self.EncodedCoords = json.encode(self.GetCoords())
            self.DirtyFields.Coords = false
        end
        return self.EncodedCoords
    end
    --
    -- ====================================================================================--
    -- Initialize with empty inventory
    self.Inventory = {}
    self.UnpackInventory({})
    -- ====================================================================================--
    return self
end
--
