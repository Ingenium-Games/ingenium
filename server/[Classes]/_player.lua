c.class.Player = {}
c.class.Player._index = c.class.Player

function c.class.Player:Create(source, character_id)
    local src = tonumber(source)
    local Steam_ID, FiveM_ID, License_ID, Discord_ID = c.identifiers(src)
    local user = c.sql.user.Get(License_ID)
    local char = c.sql.char.Get(character_id)
    --
    local self = {}
    --
    self.ID = src
    self.State = Player(self.ID).state
    --
    self.Entity = GetPlayerPed(src)
    --
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    --
    self.GetModel = function()
        return self.Model
    end
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
    --
    self.Coords = json.decode(char.Coords)
    --
    self.Accounts = json.decode(char.Accounts)
    --
    self.Licenses = json.decode(char.Licenses)
    --
    self.Inventory = c.class.Inventory.New(json.decode(char.Inventory))
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
    -- Functions
    self.Kick = function(reason)
        DropPlayer(self.ID, reason)
        TriggerEvent("txaLogger:CommandExecuted", "xPlayer:DropPlayer: "..reason)
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
        return self.Character_ID
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
    -- Gender ("Male"/"Female")
    self.Gender, self.GenderString = c.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    self.State.GenderString = self.GenderString
    --
    self.GetGender =  function()
        return self.Gender
    end
    --
    -- Humaniod Model (true/false)
    self.IsHuman = c.IsPedHuman(self.Model)
    self.State.IsHuman = self.IsHuman
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
    self.GetInstance = function()
        return GetPlayerRoutingBucket(src)
    end
    --
    self.SetInstance = function(id)
        local id = id or self.InstanceID
        SetPlayerRoutingBucket(self.ID, id)
        SetEntityRoutingBucket(self.Entity, id)
        c.sql.char.SetInstance(self.GetIdentifier(), num)
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
    self.GetCash = function()
        local acc = self.GetAccount("Cash")
        if acc then
            self.State.Cash = acc
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
                self.Kick("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.debug_1("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for "..self.ID)
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
                self.Kick("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.debug_1("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for "..self.ID)
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
                self.Kick("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin")
                c.debug_1("A bug has occoured to make your cash a negative amount, as you cannot have negative money in hand, please report this to the Server Admin: for "..self.ID)
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
            self.State.Bank = acc
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
    -- esx style, except table format.
    self.GetJob = function()
        return self.Job
    end
    --
    self.SetJob = function(t)
        if c.job.Exist(t.Name, t.Grade) then
            self.Job.Name = t.Name
            self.Job.Grade = t.Grade
            self.State.Job = self.Job.Name
            self.State.Grade = self.Job.Grade
            --
            TriggerEvent("Server:Character:SetJob", self.ID, self.Job)
            TriggerClientEvent("Client:Character:SetJob", self.ID, self.Job)
        else
            c.debug_1("Ignoring invalid .SetJob() for "..self.ID)
        end
    end
    --
    self.GetPhone = function()
        return self.Phone
    end
    --
    self.SetPhone = function(s)
        local str = c.check.String(s)
        self.Phone = str
        self.State.Phone = self.Phone
    end
    -- 
    self.GetHealth = function()
        return self.Health
    end
    --
    self.SetHealth = function(v)
        local num = c.check.Number(v, 0, conf.defaulthealth)
        self.Health = num
        self.State.Health = self.Health
    end
    --
    self.GetArmour = function()
        return self.Armour
    end
    --
    self.SetArmour = function(v)
        local num = c.check.Number(v, 0, conf.defaultarmour)        
        self.Armour = num
        self.State.Armour = self.Armour
    end
    --
    self.GetHunger = function()
        return self.Hunger
    end
    --
    self.SetHunger = function(v)
        local num = c.check.Number(v, 0, 100)
        self.Hunger = num
        self.State.Hunger = self.Hunger
    end
    --
    self.GetThirst = function()
        return self.Thirst
    end
    --
    self.SetThirst = function(v)
        local num = c.check.Number(v, 0, 100)
        self.Thirst = num
        self.State.Thirst = self.Thirst
    end
    --
    self.GetStress = function()
        return self.Stress
    end
    --
    self.SetStress = function(v)
        local num = c.check.Number(v, 0, 100)
        self.Stress = num
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
    self.GetAppearance = function()
        return self.Appearance
    end
    --
    self.SetAppearance = function(t)
        self.Appearance = t
    end
    --
    self.GetTattoos = function()
        return self.Tattoos
    end
    --
    self.SetTattoos = function(t)
        local tab = c.check.Table(t)
        self.Tattoos = tab
    end
    --
    self.GetCoords = function()
        local x, y, z = GetEntityCoords(self.Entity)
        local h = GetEntityHeading(self.Entity)
        return {
            ["x"] = c.math.Decimals(x, 2),
            ["y"] = c.math.Decimals(y, 2),
            ["z"] = c.math.Decimals(z, 2),
            ["h"] = c.math.Decimals(h, 2)
        }
    end
    --
    self.SetCoords = function(t)
        self.Coords = {
            x = c.math.Decimals(t.x, 2),
            y = c.math.Decimals(t.y, 2),
            z = c.math.Decimals(t.z, 2),
            h = c.math.Decimals(t.h, 2),
        }
    end
    --
    self.GetHotbar = function()
        return self.Hotbar
    end
    --
    self.SetHotbar = function(t)
        self.Hotbar = t
    end
    --
    self.GetWanted = function()
        return self.IsWanted
    end
    --
    self.SetWanted = function(b)
        local b = c.check.Boolean(b)
        self.IsWanted = b
        self.State.IsWanted = self.IsWanted
    end
    --
    self.GetCuffed = function()
        return self.IsCuffed
    end
    --
    self.SetCuffed = function(b)
        local b = c.check.Boolean(b)
        self.IsCuffed = b
        self.State.IsCuffed = self.IsCuffed
    end    
end

function c.class.Player.New(source, character_id)
    local self = {}
	setmetatable(self, c.class.Player:Create(source, character_id))
	return self
end