if not ig.class then
    ig.class = {}
end
-- ====================================================================================--
--- Only GET functions, do not alter characters out of world.
--- func desc
---@wiki:ignore 
---@param data any
function ig.class.OfflinePlayer(data)
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
    self.GetCharacter_ID = function()
        return self.Character_ID
    end
    --
    self.GetIdentifier = function()
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
            if ig.item.Exists(v.Item) then
                local item = ig.items[v.Item]
                self.Weight = self.Weight + item.Weight
            else
                ig.func.Debug_1("Ignoring invalid item within .GetWeight()")
            end
        end
        return self.Weight
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        -- Use unified validation function (no source since this is for offline player)
        local processed, valid, error = ig.validation.ValidateAndUnpack(nil, inv)
        
        if not valid then
            -- Log error but don't kick since player is offline
            ig.func.Debug_1("Error unpacking offline player inventory: " .. (error or "unknown"))
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
            ig.func.Debug_1(
                "Ignoring invalid .SteralizeItem() while .AddItem() was called, for Offline Player License: " ..
                    self.License_ID)
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
