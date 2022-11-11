-- ====================================================================================--

if not c.class then
    c.class = {}
end

-- ====================================================================================--
--- func desc
---@param source any
---@param character_id any
function c.class.Player(source, character_id)
    local src = tonumber(source)
    local Character_ID = character_id
    local Steam_ID, FiveM_ID, License_ID, Discord_ID = c.func.identifiers(src)
    local user = c.sql.user.Get(License_ID)
    local char = c.sql.char.Get(Character_ID)
    local self = {}
    --
    self.ID = src
    self.State = Player(self.ID).state
    --
    self.Entity = GetPlayerPed(tostring(src))
    self.Ped = self.Entity
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
    self.Gender, self.GenderString = c.func.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    self.State.GenderString = self.GenderString
    --
    -- Humaniod Model (true/false)
    self.IsHuman = c.func.IsPedHuman(self.Model)
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
    self.Weight = 0
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
    self.Duty = false
    self.State.Duty = false
    -- Tables (JSONIZE)
    self.Job = json.decode(char.Job)
    self.State.Job = self.Job.Name
    self.State.Grade = self.Job.Grade
    self.State.Boss = false
    --
    self.Coords = json.decode(char.Coords)
    self.OldCoords = self.Coords
    --
    self.Ammo = json.decode(char.Ammo)
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
    self.State.Modifiers = self.Modifiers
    --
    self.OldModifiers = self.Modifiers
    --
    self.Tattoos = json.decode(char.Tattoos)
    --    
    self.Appearance = json.decode(char.Appearance)
    --    
    self.Skills = json.decode(char.Skills)
    self.State.Skills = self.Skills
    --
    ExecuteCommand(("remove_principal identifier.%s group.%s"):format(self.License_ID, self.Ace))
    ExecuteCommand(("add_principal identifier.%s group.%s"):format(self.License_ID, self.Ace))
    --
    self.Notify = function(string, colour, fade)
        TriggerClientEvent("Client:Notify", self.ID, string, colour, fade)
    end
    --
    self.GetModel = function()
        return self.Model
    end
    --
    self.GetPed = function()
        return self.Ped
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
        return c.func.identifier(self.ID)
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
        return self.Instance
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
        self.State.Modifiers = self.Modifiers
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
    self.GetDead = function()
        return self.Dead
    end
    --
    self.SetDead = function(b)
        local bool = c.check.Boolean(b)
        self.Dead = bool
        self.State.IsDead = self.Dead
    end
    --
    self.OnDuty = function()
        return self.Duty
    end
    --
    self.SetDuty = function(b)
        local bool = c.check.Boolean(b)
        self.Duty = bool
        self.State.Duty = self.Duty
    end
    --
    self.GetSkills = function()
        return self.Skills
    end
    --
    self.GetSkill = function(skill)
        for k, v in pairs(self.Skills) do
            if k == skill then
                return v
            end
        end
    end
    --
    self.SetSkill = function(skill, v)
        local num = c.check.Number(v, 0, 255)
        num = c.math.Decimals(num, 0)
        if self.Skills[skill] then
            self.Skills[skill] = num
            self.State.Skills = self.Skills
        else
            c.func.Debug_1("Skill entered does not exist")
        end
    end
    --
    self.AddSkill = function(skill, v)
        local num = c.check.Number(v, 0, 255)
        num = c.math.Decimals(num, 0)
        if self.Skills[skill] then
            self.Skills[skill] = self.Skills[skill] + num
            self.State.Skills = self.Skills
        else
            self.Skills[skill] = 0 + num
            self.State.Skills = self.Skills
            c.func.Debug_1("Skill did not exist, adding in now.")
        end
    end
    --
    self.CompareSkill = function(sk, level)
        local skill = self.GetSkill(sk)
        if skill < level then
            return false
        else
            return true
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
        num = c.math.Decimals(num, 2)
        if self.Accounts[acc] then
            self.Accounts[acc] = num
        else
            c.func.Debug_1("Account entered does not exist")
        end
    end
    --
    self.RefreshAccounts = function()
        --local cash = self.GetAccount("Cash")
        local bank = self.GetAccount("Bank")
        --[[
        if cash then
            self.State.Cash = cash
        end
        ]]--
        if bank then
            self.State.Bank = bank
        end
    end
    --
    self.GetCash = function()
        local amount, position = self.GetItemQuantity("Cash")
        if amount then
            return amount
        else
            return 0
        end
    end
    --
    self.SetCash = function(v)
        local amount, position = self.GetItemQuantity("Cash")
        local num = c.check.Number(v)
        if amount > 0 then
            self.Inventory[position].Quantity = num
            self.State.Cash = self.Inventory[position].Quantity
        else
            self.AddItem({"Cash", num, 100, false, false})
            self.State.Cash = num
        end
        TriggerClientEvent("Client:Inventory:Update", self.ID)
        --[[
        local num = c.check.Number(v)
        local acc = self.GetAccount("Cash")
        if acc then
            acc = c.math.Decimals(num, 2)
            if acc < 0 then
                acc = 0
                self.Kick(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.func.Debug_1(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                        self.ID)
                CancelEvent()
            else
                self.SetAccount("Cash", acc)
                self.State.Cash = acc
            end
        end
        ]]--
    end
    --
    self.AddCash = function(v)
        -- DollarBillz Yall
        local amount, position = self.GetItemQuantity("Cash")
        local num = c.check.Number(v)
        if amount > 0 then
            self.Inventory[position].Quantity = amount + c.math.Decimals(num, 0)
            self.State.Cash = self.Inventory[position].Quantity
        else
            self.AddItem({"Cash", num, 100, false, false})
            self.State.Cash = num
        end
        -- Coins
        local amount, position = self.GetItemQuantity("Change")
        local mod = math.fmod(num, 1)
        local num = mod * 100 -- each decimal is a cent
        if amount > 0 then
            self.Inventory[position].Quantity = amount + num
        else
            self.AddItem({"Change", num, 100, false, false})
        end
        TriggerClientEvent("Client:Inventory:Update", self.ID)
        --[[
        local num = c.check.Number(v)
        local acc = self.GetAccount("Cash")
        if acc then
            acc = acc + c.math.Decimals(num, 2)
            if acc < 0 then
                acc = 0
                self.Kick(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.func.Debug_1(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                        self.ID)
                CancelEvent()
            else
                self.SetAccount("Cash", acc)
                self.State.Cash = acc
            end
        end
        ]]--
    end
    --
    self.RemoveCash = function(v)
        local amount, position = self.GetItemQuantity("Cash")
        local num = c.check.Number(v)
        if amount > 0 then
            if (amount - num) > 0 then
                self.Inventory[position].Quantity = amount - c.math.Decimals(num, 0)
                self.State.Cash = self.Inventory[position].Quantity
            elseif (amount - num) == 0 then
                self.Inventory[position].Quantity = 1
                self.RemoveItem("Cash", position)
            else
                self.Kick(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.func.Debug_1(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                        self.ID)
                CancelEvent()
            end
        end
        -- Coins
        local amount, position = self.GetItemQuantity("Change")
        local mod = math.fmod(num, 1)
        local num = mod * 100 -- each decimal is a cent
        if amount > 0 then
            if (amount - num) > 0 then
                self.Inventory[position].Quantity = amount - num
            elseif (amount - num) == 0 then
                self.Inventory[position].Quantity = 1
                self.RemoveItem("Change", position)
                -- If you got chash, break it into change.
            elseif (amount - num) < 0 and (self.GetItemQuantity("Cash") >= 1) then
                local _a, position = self.GetItemQuantity("Cash")
                if (_a - num) > 0 then
                self.Inventory[position].Quantity = _a - c.math.Decimals(1, 0)
                self.State.Cash = self.Inventory[position].Quantity
                self.AddItem({"Change", 100, 100})
                elseif (_a - num) == 0 then
                self.Inventory[position].Quantity = 1
                self.RemoveItem("Cash", position)
                self.AddItem({"Change", 100, 100})
                --
                local amount, position = self.GetItemQuantity("Change")
                local mod = math.fmod(num, 1)
                local num = mod * 100 -- each decimal is a cent
                self.Inventory[position].Quantity = amount - num
                else
                self.Kick(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.func.Debug_1(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                        self.ID)
                CancelEvent()
                end
            else
            self.Kick(
                "A bug has occoured to make your change a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
            c.func.Debug_1(
                "A bug has occoured to make your change a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                    self.ID)
            CancelEvent()
        end
    end
        TriggerClientEvent("Client:Inventory:Update", self.ID)
        --[[
        local num = c.check.Number(v)
        local acc = self.GetAccount("Cash")
        if acc then
            acc = acc - c.math.Decimals(num, 2)
            if acc < 0 then
                acc = 0
                self.Kick(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.func.Debug_1(
                    "A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for " ..
                        self.ID)
                CancelEvent()
            else
                self.SetAccount("Cash", acc)
                self.State.Cash = acc
            end
        end
        ]]--
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
        local acc = c.math.Decimals(num, 2)
        if acc then
            self.SetAccount("Bank", acc)
            self.State.Bank = acc
            TriggerClientEvent("high_phone:receivedMessage", self.ID, conf.phone["bank"], "Account Set to $" .. num,
                "[]")
        end
    end
    --
    self.AddBank = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Bank")
        if acc then
            acc = acc + c.math.Decimals(num, 2)
            self.SetAccount("Bank", acc)
            self.State.Bank = acc
            TriggerClientEvent("high_phone:receivedMessage", self.ID, conf.phone["bank"], "Account Credited $" .. num,
                "[]")
        end
    end
    --
    self.RemoveBank = function(v)
        local num = c.check.Number(v)
        local acc = self.GetAccount("Bank")
        if acc then
            acc = acc - c.math.Decimals(num, 2)
            self.SetAccount("Bank", acc)
            self.State.Bank = acc
            TriggerClientEvent("high_phone:receivedMessage", self.ID, conf.phone["bank"], "Account Debited $" .. num,
                "[]")
        end
    end
    --
    self.GetAmmos = function()
        return self.Ammo
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
    --
    self.SetAmmo = function(type, v)
        local num = c.check.Number(v)
        local ammo = self.GetAmmo(type)
        if num < 0 then
            self.Ammo[type] = 0
            self.Kick(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin")
            c.func.Debug_1(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin: for " ..
                    self.ID)
            CancelEvent()
        end
        self.Ammo[type] = num
        self.State.Ammo = self.Ammo
    end
    --
    self.AddAmmo = function(type, v)
        local num = c.check.Number(v)
        local ammo = self.GetAmmo(type)
        self.Ammo[type] = ammo + num
        if self.Ammo[type] < 0 then
            self.Ammo[type] = 0
            self.Kick(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin")
            c.func.Debug_1(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin: for " ..
                    self.ID)
            CancelEvent()
        end
        self.State.Ammo = self.Ammo
    end
    --
    self.RemoveAmmo = function(type, v)
        local num = c.check.Number(v)
        local ammo = self.GetAmmo(type)
        self.Ammo[type] = ammo - num
        if self.Ammo[type] < 0 then
            self.Ammo[type] = 0
            self.Kick(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin")
            c.func.Debug_1(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin: for " ..
                    self.ID)
            CancelEvent()
        end
        self.State.Ammo = self.Ammo
    end
    --- func desc
    self.GetJob = function()
        return self.Job
    end

    --- func desc
    ---@param t any
    self.SetJob = function(Name, Grade)
        if c.job.Exist(Name, Grade) then
            self.Job.Name = Name
            self.Job.Grade = Grade
            self.State.Job = self.Job.Name
            self.State.Grade = self.Job.Grade
            self.State.Boss = c.job.IsBoss(self.Job.Name, self.Job.Grade)
            --
            TriggerEvent("Server:Character:SetJob", self.ID, self.Job)
            TriggerClientEvent("Client:Character:SetJob", self.ID, self.Job.Name, self.Job.Grade)
        else
            c.func.Debug_1("Ignoring invalid .SetJob() :" .. Name .. ", " .. Grade .. " for " .. self.ID)
            print(c.table.Dump(c.jobs))
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
    self.GetEntity = function()
        return self.Entity
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
        self.OldCoords = self.GetCoords()
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
            -- Validate Quality and Quantity are numbers.
            if type(self.Inventory[i].Quantity) ~= "number" or type(self.Inventory[i].Quality) ~= "number" then
                c.func.Debug_1("Error in Creating Inventory, Quantity or Quality is not a number.")
                break
            end
            -- If the Quality is below 0, then destroy the item on unpacking.
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
    -- [Internal] func desc
    ---@param v table "Must contain a minimum of a name string at point 1 {\"Cash\"}"
    self.SteralizeItem = function(v)
        if type(v) ~= "table" then
            c.func.Debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Player ID: " .. self.ID)
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
    ---@param add table "Array Format {\"Name\", 1, math.random(65,100), ('String' or false), ({} or false)}"
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
            TriggerClientEvent("Client:Inventory:Update", self.ID)
        else
            c.func.Debug_1("Ignoring invalid .AddItem() for " .. self.ID)
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
            return 0, false
        end
    end
    --
    self.GetItemQuantity = function(name)
        local has, position = self.HasItem(name)
        if has then
            return self.Inventory[position].Quantity, position
        else
            return 0, false
        end
    end
    -- Only Players can Consume
    self.ConsumeItem = function(number)
        local item = self.GetItemFromPosition(number)
        if type(item) ~= "boolean" then
            TriggerEvent("Inventory:Consume:" .. item.Item, self.ID, number, item.Quantity)
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
            c.func.Debug_1(
                "Ignoring invalid .SteralizeItem() while .AddItem() was called, for Offline Player License: " ..
                    self.License_ID)
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
