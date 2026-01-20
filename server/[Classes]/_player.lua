-- ====================================================================================--
if not ig.class then
    ig.class = {}
end
-- ====================================================================================--
--- Player class constructor - creates a player character object instance
---@wiki:ignore 
---@param source integer "Player server ID (source)"
---@param character_id integer "Character/instance ID from database"
---@return table Player instance with properties and methods
function ig.class.Player(source, character_id)
    local src = tonumber(source)
    local Character_ID = character_id
    local Steam_ID, FiveM_ID, License_ID, Discord_ID = ig.func.identifiers(src)
    local user = ig.sql.user.Get(License_ID)
    local char = ig.sql.char.Get(Character_ID)
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
    self.Iban = char.Iban
    self.State.Iban = self.Iban
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
    self.Gender, self.GenderString = ig.func.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    self.State.GenderString = self.GenderString
    --
    -- Humaniod Model (true/false)
    self.IsHuman = ig.func.IsPedHuman(self.Model)
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
    
    -- Migration: Convert old array format to new object format
    -- Old format: ["none", "Unemployed"] or {"none", "Unemployed"}
    -- New format: {Name = "none", Grade = "Unemployed"}
    if type(self.Job) == "table" and self.Job[1] and not self.Job.Name then
        -- Old array format detected, convert to object format
        self.Job = {
            Name = self.Job[1],
            Grade = self.Job[2]
        }
        ig.log.Debug("PLAYER", "Migrated job format for player " .. self.ID .. " from array to object")
        -- Mark as dirty to save the new format
        self.IsDirty = true
        self.DirtyFields.Job = true
    end
    
    self.State.Job = self.Job.Name
    self.State.Grade = self.Job.Grade
    self.State.Boss = false
    --
    self.Coords = json.decode(char.Coords)
    self.OldCoords = self.Coords
    --
    self.Ammo = json.decode(char.Ammo)
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
    self.Appearance = json.decode(char.Appearance)
    --    
    self.Skills = json.decode(char.Skills)
    self.State.Skills = self.Skills
    --
    -- Dirty Flag System for Database Optimization
    self.IsDirty = false
    self.DirtyFields = {}
    --
    -- Cached JSON Encoding for Performance
    self.EncodedInventory = nil
    self.EncodedModifiers = nil
    self.EncodedSkills = nil
    self.EncodedAmmo = nil
    self.EncodedJob = nil
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
        return ig.func.identifier(self.ID)
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
    self.GetIban = function()
        return self.Iban
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
        local bool = ig.check.Boolean(bool)
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
        ig.sql.char.SetInstance(self.GetIdentifier(), id)
    end
    -- 
    self.GetHealth = function()
        return self.Health
    end
    --
    self.SetHealth = function(v)
        local n = ig.check.Number(v, 0, conf.defaulthealth)
        if self.Health ~= n then
            self.Health = n
            self.State.Health = self.Health
            self.IsDirty = true
            self.DirtyFields.Health = true
        end
    end
    --
    self.GetArmour = function()
        return self.Armour
    end
    --
    self.SetArmour = function(v)
        local n = ig.check.Number(v, 0, conf.defaultarmour)
        if self.Armour ~= n then
            self.Armour = n
            self.State.Armour = self.Armour
            self.IsDirty = true
            self.DirtyFields.Armour = true
        end
    end
    --
    self.GetHunger = function()
        return self.Hunger
    end
    --
    self.SetHunger = function(v)
        local n = ig.check.Number(v, 0, 100)
        if self.Hunger ~= n then
            self.Hunger = n
            self.State.Hunger = self.Hunger
            self.IsDirty = true
            self.DirtyFields.Hunger = true
        end
    end
    --
    self.GetThirst = function()
        return self.Thirst
    end
    --
    self.SetThirst = function(v)
        local n = ig.check.Number(v, 0, 100)
        if self.Thirst ~= n then
            self.Thirst = n
            self.State.Thirst = self.Thirst
            self.IsDirty = true
            self.DirtyFields.Thirst = true
        end
    end
    --
    self.GetStress = function()
        return self.Stress
    end
    --
    self.SetStress = function(v)
        local n = ig.check.Number(v, 0, 100)
        if self.Stress ~= n then
            self.Stress = n
            self.State.Stress = self.Stress
            self.IsDirty = true
            self.DirtyFields.Stress = true
        end
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
        local tab = ig.check.Table(t)
        self.OldModifiers = self.Modifiers
        self.Modifiers = tab
        self.State.Modifiers = self.Modifiers
        self.IsDirty = true
        self.DirtyFields.Modifiers = true
        self.EncodedModifiers = nil
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
        local bool = ig.check.Boolean(b)
        self.Dead = bool
        self.State.IsDead = self.Dead
    end
    --
    self.OnDuty = function()
        return self.Duty
    end
    --
    self.SetDuty = function(b)
        local bool = ig.check.Boolean(b)
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
        local num = ig.check.Number(v, 0, 255)
        num = ig.math.Decimals(num, 0)
        if self.Skills[skill] then
            if self.Skills[skill] ~= num then
                self.Skills[skill] = num
                self.State.Skills = self.Skills
                self.IsDirty = true
                self.DirtyFields.Skills = true
                self.EncodedSkills = nil
            end
        else
            self.Skills[skill] = num
            self.State.Skills = self.Skills
            self.IsDirty = true
            self.DirtyFields.Skills = true
            self.EncodedSkills = nil
            ig.log.Debug("PLAYER", "Skill did not exist, adding in now.")
        end
    end
    --
    self.AddSkill = function(skill, v)
        local num = ig.check.Number(v, 0, 255)
        num = ig.math.Decimals(num, 0)
        if self.Skills[skill] then
            self.Skills[skill] = self.Skills[skill] + num
            self.State.Skills = self.Skills
            self.IsDirty = true
            self.DirtyFields.Skills = true
            self.EncodedSkills = nil
        else
            self.Skills[skill] = 0 + num
            self.State.Skills = self.Skills
            self.IsDirty = true
            self.DirtyFields.Skills = true
            self.EncodedSkills = nil
            ig.log.Debug("PLAYER", "Skill did not exist on character, adding in now.")
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
        local num = ig.check.Number(v)
        local ammo = self.GetAmmo(type)
        if num < 0 then
            self.Ammo[type] = 0
            self.Kick(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin")
            ig.log.Error("Player",
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin: for " ..
                    self.ID)
            CancelEvent()
        end
        if self.Ammo[type] ~= num then
            self.Ammo[type] = num
            self.State.Ammo = self.Ammo
            self.IsDirty = true
            self.DirtyFields.Ammo = true
            self.EncodedAmmo = nil
        end
    end
    --
    self.AddAmmo = function(type, v)
        local num = ig.check.Number(v)
        local ammo = self.GetAmmo(type)
        self.Ammo[type] = ammo + num
        if self.Ammo[type] < 0 then
            self.Ammo[type] = 0
            self.Kick(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin")
            ig.log.Error("Player",
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin: for " ..
                    self.ID)
            CancelEvent()
        end
        self.State.Ammo = self.Ammo
        self.IsDirty = true
        self.DirtyFields.Ammo = true
        self.EncodedAmmo = nil
    end
    --
    self.RemoveAmmo = function(type, v)
        local num = ig.check.Number(v)
        local ammo = self.GetAmmo(type)
        self.Ammo[type] = ammo - num
        if self.Ammo[type] < 0 then
            self.Ammo[type] = 0
            self.Kick(
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin")
            ig.log.Error("Player",
                "A bug has occoured to make your ammo a negative amount, as you cannot have negative ammo in hand, please report this to the Server Admin: for " ..
                    self.ID)
            CancelEvent()
        end
        self.State.Ammo = self.Ammo
        self.IsDirty = true
        self.DirtyFields.Ammo = true
        self.EncodedAmmo = nil
    end
    --- func desc
    self.GetJob = function()
        return self.Job
    end

    --- func desc
    ---@param t any
    self.SetJob = function(Name, Grade)
        if ig.job.Exists(Name, Grade) then
            if self.Job.Name ~= Name or self.Job.Grade ~= Grade then
                self.Job.Name = Name
                self.Job.Grade = Grade
                self.State.Job = self.Job.Name
                self.State.Grade = self.Job.Grade
                self.State.Boss = ig.job.IsBoss(self.Job.Name, self.Job.Grade)
                self.IsDirty = true
                self.DirtyFields.Job = true
                self.EncodedJob = nil
                --
                TriggerEvent("Server:Character:SetJob", self.ID, self.Job)
                TriggerClientEvent("Client:Character:SetJob", self.ID, self.Job.Name, self.Job.Grade)
            end
        else
            ig.log.Debug("PLAYER", "Ignoring invalid .SetJob() :" .. Name .. ", " .. Grade .. " for " .. self.ID)
            print(ig.table.Dump(ig.jobs))
        end
    end
    --- func desc
    self.GetPhone = function()
        return self.Phone
    end
    --- func desc
    ---@param s any
    self.SetPhone = function(s)
        local s = ig.check.String(s)
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
            ["x"] = ig.math.Decimals(x, 2),
            ["y"] = ig.math.Decimals(y, 2),
            ["z"] = ig.math.Decimals(z, 2),
            ["h"] = ig.math.Decimals(h, 2)
        }
    end
    --- func desc
    ---@param t any
    self.SetCoords = function(t)
        self.OldCoords = self.GetCoords()
        local newCoords = {
            x = ig.math.Decimals(t.x, 2),
            y = ig.math.Decimals(t.y, 2),
            z = ig.math.Decimals(t.z, 2),
            h = ig.math.Decimals(t.h, 2)
        }
        -- Check if coords actually changed
        if self.Coords.x ~= newCoords.x or self.Coords.y ~= newCoords.y or 
           self.Coords.z ~= newCoords.z or self.Coords.h ~= newCoords.h then
            self.Coords = newCoords
            self.IsDirty = true
            self.DirtyFields.Coords = true
        end
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
        local t = ig.check.Table(t)
        self.Hotbar = t
    end
    --- func desc
    self.GetWanted = function()
        return self.IsWanted
    end
    --- func desc
    ---@param b any
    self.SetWanted = function(b)
        local b = ig.check.Boolean(b)
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
        local b = ig.check.Boolean(b)
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
        local b = ig.check.Boolean(b)
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
            if ig.item.Exists(v.Item) then
                local item = ig.items[v.Item]
                self.Weight = self.Weight + item.Weight
            else
                ig.log.Debug("PLAYER", "Ignoring invalid item within .GetWeight() for Player ID: " .. self.ID)
            end
        end
        return self.Weight
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        -- Use unified validation function
        local processed, valid, error = ig.validation.ValidateAndUnpack(self.ID, inv)
        
        if not valid then
            -- Error already logged and player kicked by ValidateAndUnpack
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
    --
    -- [Internal] func desc
    ---@param v table "Must contain a minimum of a name string at point 1 {\"Cash\"}"
    self.SteralizeItem = function(v)
        if type(v) ~= "table" then
            ig.log.Debug("PLAYER", "Ignoring invalid .SteralizeItem() while .AddItem() was called, for Player ID: " .. self.ID)
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
    ---@param add table "Array Format {\"Name\", 1, math.random(65,100), ('String' or false), ({} or false)}"
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
            self.IsDirty = true
            self.DirtyFields.Inventory = true
            self.EncodedInventory = nil
            TriggerClientEvent("Client:Inventory:Update", self.ID)
        else
            ig.log.Debug("PLAYER", "Ignoring invalid .AddItem() for Player ID: " .. self.ID)
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
    self.RemoveItem = function(name, slot, amount)
        local quantity, position = self.GetItemQuantity(name)
        if quantity == amount then
            table.remove(self.Inventory, position)
        elseif quantity >= 2 then
            self.Inventory[position].Quantity = self.Inventory[position].Quantity - 1
        elseif quantity <= 1 and slot == position then
            table.remove(self.Inventory, position)
        else
            table.remove(self.Inventory, position)
        end
        self.IsDirty = true
        self.DirtyFields.Inventory = true
        self.EncodedInventory = nil
        TriggerClientEvent("Client:Inventory:Update", self.ID)
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
    --
    self.FoundItems = function(reward)
        local chance = math.random(0, 255)
        for k, v in pairs(reward) do
            if k <= chance then
                local item = v.Item
                local quanitity = math.random(v.Range[1], v.Range[2])
                if quanitity == 1 then
                    self.Notify("Found a "..item..".")
                else
                    self.Notify("Found "..quanitity.. " "..item)
                end
                self.AddItem({item, quanitity, 100})
            end
        end
    end
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
        self.DirtyFields[fieldName] = true
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
    self.GetEncodedModifiers = function()
        if not self.EncodedModifiers or self.DirtyFields.Modifiers then
            self.EncodedModifiers = json.encode(self.GetModifiers())
            self.DirtyFields.Modifiers = false
        end
        return self.EncodedModifiers
    end
    --
    self.GetEncodedSkills = function()
        if not self.EncodedSkills or self.DirtyFields.Skills then
            self.EncodedSkills = json.encode(self.GetSkills())
            self.DirtyFields.Skills = false
        end
        return self.EncodedSkills
    end
    --
    self.GetEncodedAmmo = function()
        if not self.EncodedAmmo or self.DirtyFields.Ammo then
            self.EncodedAmmo = json.encode(self.GetAmmos())
            self.DirtyFields.Ammo = false
        end
        return self.EncodedAmmo
    end
    --
    self.GetEncodedJob = function()
        if not self.EncodedJob or self.DirtyFields.Job then
            self.EncodedJob = json.encode(self.GetJob())
            self.DirtyFields.Job = false
        end
        return self.EncodedJob
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
    -- VOIP Methods
    -- ====================================================================================--
    -- Initialize VOIP state variables (set defaults on character creation)
    self.VoiceMode = conf.voip.defaultMode or 2
    self.State.VoiceMode = self.VoiceMode
    --
    self.VoiceDistance = 0.0
    self.State.VoiceDistance = self.VoiceDistance
    --
    self.RadioFrequency = 0
    self.State.RadioFrequency = self.RadioFrequency
    --
    self.RadioTransmitting = false
    self.State.RadioTransmitting = self.RadioTransmitting
    --
    self.InVoice = false
    self.State.InVoice = self.InVoice
    --
    self.InCall = false
    self.State.InCall = self.InCall
    --
    self.InConnection = false
    self.State.InConnection = self.InConnection
    --
    self.InAdminCall = false
    self.State.InAdminCall = self.InAdminCall
    --
    self.CallActive = false
    self.State.CallActive = self.CallActive
    --
    self.ConnectionActive = false
    self.State.ConnectionActive = self.ConnectionActive
    --
    --- Get player's voice mode
    ---@return number The voice mode index (1-3)
    self.GetVoiceMode = function()
        return self.VoiceMode
    end
    --
    --- Set player's voice mode
    ---@param modeIndex number The voice mode index (1-3)
    self.SetVoiceMode = function(modeIndex)
        local mode = ig.voip.GetVoiceMode(modeIndex)
        if not mode then
            return
        end
        if self.VoiceMode ~= modeIndex then
            self.VoiceMode = modeIndex
            self.VoiceDistance = mode.distance
            self.State.VoiceMode = self.VoiceMode
            self.State.VoiceDistance = self.VoiceDistance
        end
    end
    --
    --- Get player's radio frequency
    ---@return number The radio frequency (0 = none)
    self.GetRadioFrequency = function()
        return self.RadioFrequency
    end
    --
    --- Set player's radio frequency
    ---@param frequency number The radio frequency (0 to leave radio)
    self.SetRadioFrequency = function(frequency)
        local freq = ig.check.Number(frequency, 0, conf.voip.radioChannelMax)
        if self.RadioFrequency ~= freq then
            self.RadioFrequency = freq
            self.State.RadioFrequency = self.RadioFrequency
        end
    end
    --
    --- Get player's radio transmitting state
    ---@return boolean True if transmitting
    self.GetRadioTransmitting = function()
        return self.RadioTransmitting
    end
    --
    --- Set player's radio transmitting state
    ---@param transmitting boolean Whether transmitting
    self.SetRadioTransmitting = function(transmitting)
        local tx = ig.check.Boolean(transmitting)
        if self.RadioTransmitting ~= tx then
            self.RadioTransmitting = tx
            self.State.RadioTransmitting = self.RadioTransmitting
        end
    end
    --
    --- Get player's InCall state
    ---@return boolean True if in call
    self.GetInCall = function()
        return self.InCall
    end
    --
    --- Set player's InCall state
    ---@param inCall boolean Whether in call
    self.SetInCall = function(inCall)
        local ic = ig.check.Boolean(inCall)
        if self.InCall ~= ic then
            self.InCall = ic
            self.State.InCall = self.InCall
        end
    end
    --
    --- Get player's CallActive state
    ---@return boolean True if call is active
    self.GetCallActive = function()
        return self.CallActive
    end
    --
    --- Set player's CallActive state
    ---@param active boolean Whether call is active
    self.SetCallActive = function(active)
        local ca = ig.check.Boolean(active)
        if self.CallActive ~= ca then
            self.CallActive = ca
            self.State.CallActive = self.CallActive
        end
    end
    --
    --- Get player's InConnection state
    ---@return boolean True if in connection
    self.GetInConnection = function()
        return self.InConnection
    end
    --
    --- Set player's InConnection state
    ---@param inConnection boolean Whether in connection
    self.SetInConnection = function(inConnection)
        local ic = ig.check.Boolean(inConnection)
        if self.InConnection ~= ic then
            self.InConnection = ic
            self.State.InConnection = self.InConnection
        end
    end
    --
    --- Get player's ConnectionActive state
    ---@return boolean True if connection is active
    self.GetConnectionActive = function()
        return self.ConnectionActive
    end
    --
    --- Set player's ConnectionActive state
    ---@param active boolean Whether connection is active
    self.SetConnectionActive = function(active)
        local ca = ig.check.Boolean(active)
        if self.ConnectionActive ~= ca then
            self.ConnectionActive = ca
            self.State.ConnectionActive = self.ConnectionActive
        end
    end
    --
    --- Get player's InAdminCall state (read-only for non-admins)
    ---@return boolean True if in admin call
    self.GetInAdminCall = function()
        return self.InAdminCall
    end
    --
    --- Set player's InAdminCall state (server-only, requires admin permission)
    ---@param inAdminCall boolean Whether in admin call
    ---@param adminSource number|nil The admin's server ID (for verification)
    self.SetInAdminCall = function(inAdminCall, adminSource)
        -- Only allow setting if adminSource has permission
        if adminSource and not IsPlayerAceAllowed(adminSource, conf.voip.adminCallAce) then
            ig.log.Error("Player", ("Player %d attempted to set InAdminCall without permission"):format(adminSource))
            return
        end
        local iac = ig.check.Boolean(inAdminCall)
        if self.InAdminCall ~= iac then
            self.InAdminCall = iac
            self.State.InAdminCall = self.InAdminCall
        end
    end
    --
    -- ====================================================================================--
    -- RUN FUNCTIONS TO INIT CLASS STATE ON ENTITY
    self.UnpackInventory(self.Inventory)
    self.SetJob(self.GetJob().Name, self.GetJob().Grade)
    -- ====================================================================================--
    return self
end
