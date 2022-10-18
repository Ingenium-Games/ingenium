-- ====================================================================================--
if not c.class then
    c.class = {}
end
-- ====================================================================================--
--- func desc
---@param data any
function c.class.OfflinePlayer(data)
    local Character_ID = data.Character_ID
    local License_ID = data.License_ID
    local self = {}
    --
    self.License_ID = License_ID
    --
    self.Character_ID = data.Character_ID -- 50 Random dataacters [Aa-Zz][0-9]
    --
    self.City_ID = data.City_ID -- X-00000
    --
    self.Birth_Date = data.Birth_Date
    --
    self.First_Name = data.First_Name
    --
    self.Last_Name = data.Last_Name
    --
    self.Full_Name = data.First_Name .. " " .. data.Last_Name
    --
    self.Phone = data.Phone -- 200000 - 699999
    --
    self.Weight = 0
    --         
    -- Booleans
    self.IsWanted = data.Wanted
    --
    self.IsDead = data.Dead
    --
    -- Tables (JSONIZE)
    self.Job = json.decode(data.Job)
    --
    self.Coords = json.decode(data.Coords)
    --
    self.Ammo = json.decode(data.Ammo)
    --
    self.Accounts = json.decode(data.Accounts)
    --
    self.Licenses = json.decode(data.Licenses)
    --
    self.Inventory = json.decode(data.Inventory)
    --
    self.Modifiers = json.decode(data.Modifiers)
    --
    self.Tattoos = json.decode(data.Tattoos)
    --    
    self.Appearance = json.decode(data.Appearance)
    --
    self.GetLicense_ID = function()
        return self.License_ID
    end
    --
    self.GetIdentifier = function()
        return self.GetCharacter_ID()
    end
    --
    self.GetCharacter_ID = function()
        return self.Character_ID
    end
    --
    self.GetCity_ID = function()
        return self.City_ID
    end
    --
    self.GetBirth_Date = function()
        return self.Birth_Date
    end
    --
    self.GetFirst_Name = function()
        return self.First_Name
    end
    --
    self.GetLast_Name = function()
        return self.Last_Name
    end
    --
    self.GetFull_Name = function()
        return self.Full_Name
    end
    --
    self.GetSupporter = function()
        return self.IsSupporter
    end
    --
    self.GetGender = function()
        return self.Gender
    end
    --
    self.GetModifiers = function()
        return self.Modifiers
    end
    --
    self.GetLicenses = function()
        return self.Licenses
    end
    --
    self.GetLicense = function(license)
        for k, v in pairs(self.Licenses) do
            if k == license then
                return v
            end
        end
    end
    --
    self.GetAccounts = function()
        return self.Accounts
    end
    --
    self.GetAccount = function(acc)
        for k, v in pairs(self.Accounts) do
            if k == acc then
                return v
            end
        end
    end
    --
    self.GetCash = function()
        local acc = self.GetAccount("Cash")
        if acc then
            return acc
        end
    end
    --
    self.GetBank = function()
        local acc = self.GetAccount("Bank")
        if acc then
            return acc
        end
    end
    --
    self.GetAmmo = function(type)
        for k, v in pairs(self.Ammo) do
            if k == type then
                return v
            end
        end
        return 0
    end
    --- func desc
    self.GetJob = function()
        return self.Job
    end
    --- func desc
    self.GetPhone = function()
        return self.Phone
    end
    --- func desc
    self.GetAppearance = function()
        return self.Appearance
    end
    --- func desc
    self.GetTattoos = function()
        return self.Tattoos
    end
    --- func desc
    self.GetCoords = function()
        return data.Coords
    end
    --- func desc
    self.GetWanted = function()
        return self.IsWanted
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
            c.func.Debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Offline Player License: " .. self.License_ID)
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
            c.func.Debug_1("Ignoring invalid .AddItem() for Offline Player License: " .. self.License_ID)
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
    return self
end
