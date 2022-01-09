-- ====================================================================================--
if not c.class then
    c.class = {}
end
-- ====================================================================================--
function c.class.Player(source, character_id)
    local src = tonumber(source)
    local Character_ID = character_id
    local Steam_ID, FiveM_ID, License_ID, Discord_ID = c.identifiers(src)
    local user = c.sql.user.Get(License_ID)
    local char = c.sql.char.Get(Character_ID)
    --
    self.ID = src
    self.State = Player(self.ID).state
    --
    self.Entity = GetPlayerPed(tostring(src))
    --
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    --
    -- Animation?
    self.State.Animation = false
    --
    self.InstanceID = tonumber(char.ID)
    --
    -- Strings
    self.Name = GetPlayerName(self.ID)
    self.State.Name = self.Name
    --
    self.Steam_ID = Steam_ID
    self.State.Steam_ID = self.Steam_ID
    --
    self.FiveM_ID = FiveM_ID
    self.State.FiveM_ID = self.FiveM_ID
    --
    self.License_ID = License_ID
    self.State.License_ID = self.License_ID
    --
    self.Discord_ID = Discord_ID
    self.State.Discord_ID = self.Discord_ID
    --
    self.Ace = user.Ace
    self.State.Ace = self.Ace
    --
    self.Locale = user.Locale
    self.State.Locale = self.Locale
    --
    self.Character_ID = char.Character_ID -- 50 Random Characters [Aa-Zz][0-9]
    self.State.Character_ID = self.Character_ID
    --
    self.City_ID = char.City_ID -- X-00000
    self.State.City_ID = self.City_ID
    --
    self.Birth_Date = char.Birth_Date
    self.State.Birth_Date = self.Birth_Date
    --
    self.First_Name = char.First_Name
    self.State.First_Name = self.First_Name
    --
    self.Last_Name = char.Last_Name
    self.State.Last_Name = self.Last_Name
    --
    self.Full_Name = char.First_Name .. " " .. char.Last_Name
    self.State.Full_Name = self.Full_Name
    --
    self.Phone = char.Phone -- 200000 - 699999
    self.State.Phone = self.Phone
    --
    -- Gender ("Male"/"Female")
    self.Gender, self.GenderString = c.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    self.State.GenderString = self.GenderString
    --
    -- Humaniod Model (true/false)
    self.IsHuman = c.IsPedHuman(self.Model)
    self.State.IsHuman = self.IsHuman
    --
    -- Integers
    self.Instance = char.Instance
    self.State.Instance = self.Instance
    --
    self.Health = char.Health
    self.State.Health = self.Health
    --
    self.Armour = char.Armour
    self.State.Armour = self.Armour
    --
    self.Hunger = char.Hunger
    self.State.Hunger = self.Hunger
    --
    self.Thirst = char.Thirst
    self.State.Thirst = self.Thirst
    --
    self.Stress = char.Stress
    self.State.Stress = self.Stress
    --
    self.MaxWeight = 25
    --         
    -- Booleans
    self.IsWanted = char.Wanted
    self.State.IsWanted = self.IsWanted
    --
    self.IsDead = false
    self.State.IsDead = self.IsDead
    --
    self.IsCuffed = false
    self.State.IsCuffed = self.IsCuffed
    --
    self.IsEscorted = false
    self.State.IsEscorted = self.IsEscorted
    --
    self.IsFrozen = false
    self.State.IsFrozen = self.IsFrozen
    --
    self.IsEscorting = false
    self.State.IsEscorting = self.IsEscorting
    --
    self.IsSwimming = false
    self.State.IsSwimming = self.IsSwimming
    --    
    self.IsSupporter = user.Supporter
    self.State.IsSupporter = self.IsSupporter
    --
    -- Tables (JSONIZE)
    self.Job = json.decode(char.Job)
    self.State.Job = self.Job.Name
    self.State.Grade = self.Job.Grade
    self.State.Boss = false
    --
    self.Coords = json.decode(char.Coords)
    self.OldCoords = self.Coords
    --
    self.Accounts = json.decode(char.Accounts)
    self.State.Cash = self.Accounts.Cash
    self.State.Bank = self.Accounts.Bank
    --
    self.Licenses = json.decode(char.Licenses)
    --
    self.Inventory = json.decode(char.Inventory)
    --
    self.Hotbar = json.decode(char.Hotbar)
    --
    self.Modifiers = json.decode(char.Modifiers)
    --
    self.OldModifiers = self.Modifiers
    --
    self.Tattoos = json.decode(char.Tattoos)
    --    
    self.Appearance = json.decode(char.Appearance)
    --
    ExecuteCommand(("remove_principal identifier.%s group.%s"):format(self.License_ID, self.Ace))
    ExecuteCommand(("add_principal identifier.%s group.%s"):format(self.License_ID, self.Ace))

    --
    self.GetModel = function()
        return self.Model
    end
    -- Functions
    self.Kick = function(reason)
        DropPlayer(self.ID, reason)
        TriggerEvent("txaLogger:CommandExecuted", "xPlayer.DropPlayer: " .. reason)
    end
    --
    self.GetName = function()
        return self.Name
    end
    --
    self.GetAce = function()
        return self.Ace
    end
    --
    self.GetLocale = function()
        return self.Locale
    end
    --
    self.GetID = function()
        return self.ID
    end
    --
    self.GetSteam_ID = function()
        return self.Steam_ID
    end
    --
    self.GetFiveM_ID = function()
        return self.FiveM_ID
    end
    --
    self.GetLicense_ID = function()
        return self.License_ID
    end
    --
    self.GetDiscord_ID = function()
        return self.Discord_ID
    end
    --
    self.GetIdentifier = function()
        return c.identifier(self.ID)
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
    self.SetSupporter = function(bool)
        local bool = c.check.Boolean(bool)
        self.IsSupporter = bool
        self.State.IsSupporter = self.IsSupporter
    end
    --
    self.GetGender = function()
        return self.Gender
    end
    --
    self.GetInstance = function()
        return GetPlayerRoutingBucket(self.ID)
    end
    --
    self.SetInstance = function(id)
        local id = id or self.InstanceID
        SetPlayerRoutingBucket(self.ID, id)
        SetEntityRoutingBucket(self.Entity, id)
        c.sql.char.SetInstance(self.GetIdentifier(), id)
    end
    -- 
    self.GetHealth = function()
        return self.Health
    end
    --
    self.SetHealth = function(v)
        local n = c.check.Number(v, 0, conf.defaulthealth)
        self.Health = n
        self.State.Health = self.Health
    end
    --
    self.GetArmour = function()
        return self.Armour
    end
    --
    self.SetArmour = function(v)
        local n = c.check.Number(v, 0, conf.defaultarmour)
        self.Armour = n
        self.State.Armour = self.Armour
    end
    --
    self.GetHunger = function()
        return self.Hunger
    end
    --
    self.SetHunger = function(v)
        local n = c.check.Number(v, 0, 100)
        self.Hunger = n
        self.State.Hunger = self.Hunger
    end
    --
    self.GetThirst = function()
        return self.Thirst
    end
    --
    self.SetThirst = function(v)
        local n = c.check.Number(v, 0, 100)
        self.Thirst = n
        self.State.Thirst = self.Thirst
    end
    --
    self.GetStress = function()
        return self.Stress
    end
    --
    self.SetStress = function(v)
        local n = c.check.Number(v, 0, 100)
        self.Stress = n
        self.State.Stress = self.Stress
    end
    --
    self.GetOldModifiers = function()
        return self.OldModifiers
    end
    --
    self.GetModifiers = function()
        return self.Modifiers
    end
    --
    self.SetModifiers = function(t)
        local tab = c.check.Table(t)
        self.OldModifiers = self.Modifiers
        self.Modifiers = tab
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
    self.SetAccount = function(acc, v)
        local num = c.check.Number(v)
        if self.Accounts[acc] then
            self.Accounts[acc] = c.math.Decimals(num, 0)
        else
            c.debug_1("Account entered does not exist")
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
    self.SetCash = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Cash")
        if acc then
            acc = c.math.Decimals(num, 0)
            if acc < 0 then
                acc = 0
                CancelEvent()
                self.Kick(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.debug_1(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                        self.ID)
            else
                self.SetAccount("Cash", acc)
                self.State.Cash = acc
            end
        end
    end
    --
    self.AddCash = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Cash")
        if acc then
            acc = acc + c.math.Decimals(num, 0)
            if acc < 0 then
                acc = 0
                CancelEvent()
                self.Kick(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.debug_1(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                        self.ID)
            else
                self.SetAccount("Cash", acc)
                self.State.Cash = acc
            end
        end
    end
    --
    self.RemoveCash = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Cash")
        if acc then
            acc = acc - c.math.Decimals(num, 0)
            if acc < 0 then
                acc = 0
                CancelEvent()
                self.Kick(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.debug_1(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                        self.ID)
            else
                self.SetAccount("Cash", acc)
                self.State.Cash = acc
            end
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
    self.SetBank = function(v)
        local num = c.check.Number(v)
        local acc = c.math.Decimals(num, 0)
        if acc then
            if acc < 0 then
                self.SetAccount("Bank", acc)
                self.State.Bank = acc
            else
                self.SetAccount("Bank", acc)
                self.State.Bank = acc
            end
        end
    end
    --
    self.AddBank = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Bank")
        if acc then
            acc = acc + c.math.Decimals(num, 0)
            if acc < 0 then
                self.SetAccount("Bank", acc)
                self.State.Bank = acc
            else
                self.SetAccount("Bank", acc)
                self.State.Bank = acc
            end
        end
    end
    --
    self.RemoveBank = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Bank")
        if acc then
            acc = acc - c.math.Decimals(num, 0)
            if acc < 0 then
                self.SetAccount("Bank", acc)
                self.State.Bank = acc
            else
                self.SetAccount("Bank", acc)
                self.State.Bank = acc
            end
        end
    end
    --- func desc
    self.GetJob = function()
        return self.Job
    end

    --- func desc
    ---@param t any
    self.SetJob = function(t)
        if c.job.Exist(t.Name, t.Grade) then
            self.Job.Name = t.Name
            self.Job.Grade = t.Grade
            self.State.Job = self.Job.Name
            self.State.Grade = self.Job.Grade
            self.State.Boss = c.job.IsBoss(self.Job.Name, self.Job.Grade)
            --
            TriggerEvent("Server:Character:SetJob", self.ID, self.Job)
            TriggerClientEvent("Client:Character:SetJob", self.ID, self.Job)
        else
            c.debug_1("Ignoring invalid .SetJob() for " .. self.ID)
        end
    end
    --- func desc
    self.GetPhone = function()
        return self.Phone
    end
    --- func desc
    ---@param s any
    self.SetPhone = function(s)
        local s = c.check.String(s)
        self.Phone = s
        self.State.Phone = self.Phone
    end
    --- func desc
    self.GetAppearance = function()
        return self.Appearance
    end
    --- func desc
    ---@param t any
    self.SetAppearance = function(t)
        self.Appearance = t
    end
    --- func desc
    self.GetTattoos = function()
        return self.Tattoos
    end
    --- func desc
    ---@param t any
    self.SetTattoos = function(t)
        local t = c.check.Table(t)
        self.Tattoos = t
    end
    --- func desc
    self.GetOldCoords = function()
        return self.OldCoords
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
    ---@param t any
    self.SetCoords = function(t)
        self.OldCoords = self:GetCoords()
        self.Coords = {
            x = c.math.Decimals(t.x, 2),
            y = c.math.Decimals(t.y, 2),
            z = c.math.Decimals(t.z, 2),
            h = c.math.Decimals(t.h, 2)
        }
        SetEntityCoords(self.Entity, self.Coords.x, self.Coords.y, self.Coords.z)
        SetEntityHeading(self.Entity, self.Coords.h)
    end
    --- func desc
    self.GetHotbar = function()
        return self.Hotbar
    end
    --- func desc
    ---@param t any
    self.SetHotbar = function(t)
        local t = c.check.Table(t)
        self.Hotbar = t
    end
    --- func desc
    self.GetWanted = function()
        return self.IsWanted
    end
    --- func desc
    ---@param b any
    self.SetWanted = function(b)
        local b = c.check.Boolean(b)
        self.IsWanted = b
        self.State.IsWanted = self.IsWanted
    end
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
    self.GetFrozen = function()
        return self.IsFrozen
    end
    --- func desc
    ---@param b any
    self.SetFrozen = function(b)
        local b = c.check.Boolean(b)
        self.IsFrozen = b
        self.State.IsFrozen = self.IsFrozen
    end
    --- func desc
    self.GetDragged = function()
        return self.IsEscorted
    end
    --- func desc
    ---@param b any
    self.SetDragged = function(b)
        local b = c.check.Boolean(b)
        self.IsEscorted = b
        self.State.IsEscorted = self.IsEscorted
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        local inv = inv or {}
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
