-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Why have the user and character classes seperate?
    - Becasue a player has different data to the character being played.
    - Not using the Player State, as still testing.
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

function c.class.CreateCharacter(source, character_id)
    local src = tonumber(source)
    local data = c.sql.char.Get(character_id)
    local self = {}
    --
    -- For the State to work
    self.ID = src
    self.State = Player(self.ID).state
    --
    -- Strings
    self.Character_ID = data.Character_ID -- 50 Random Characters [Aa-Zz][0-9]
    self.State.Character_ID = self.Character_ID
    --
    self.City_ID = data.City_ID -- X-00000
    self.State.City_ID = self.City_ID
    --
    self.Birth_Date = data.Birth_Date
    self.State.Birth_Date = self.Birth_Date
    --
    self.First_Name = data.First_Name
    self.State.First_Name = self.First_Name
    --
    self.Last_Name = data.Last_Name
    self.State.Last_Name = self.Last_Name
    --
    self.Full_Name = data.First_Name .. " " .. data.Last_Name
    self.State.Full_Name = self.Full_Name
    --
    self.Phone = data.Phone -- 200000 - 699999
    self.State.Phone = self.Phone
    --
    -- Integers
    self.Instance = data.Instance
    self.State.Instance = self.Instance
    --
    self.Health = data.Health
    self.State.Health = self.Health
    --
    self.Armour = data.Armour
    self.State.Armour = self.Armour
    --
    self.Hunger = data.Hunger
    self.State.Hunger = self.Hunger
    --
    self.Thirst = data.Thirst
    self.State.Thirst = self.Thirst
    --
    self.Stress = data.Stress
    self.State.Stress = self.Stress
    --
    -- Booleans
    self.Wanted = data.Wanted
    self.State.Wanted = self.Wanted
    --
    self.Supporter = data.Supporter
    self.State.Supporter = self.Supporter
    --
    -- Tables (JSONIZE)
    self.Job = json.decode(data.Job)
    self.State.Job = self.Job
    --
    self.Coords = json.decode(data.Coords)
    self.State.Coords = self.Coords
    --
    self.Accounts = json.decode(data.Accounts)
    self.State.Accounts = self.Accounts
    --
    self.Licenses = json.decode(data.Licenses)
    self.State.Licenses = self.Licenses
    --
    self.Inventory = json.decode(data.Inventory)
    self.State.Inventory = self.Inventory
    --
    self.Modifiers = json.decode(data.Modifiers)    
    self.State.Modifiers = self.Modifiers
    --
    self.OldModifiers = self.Modifiers
    --
    self.Tattoos = json.decode(data.Tattoos)
    self.State.Tattoos = self.Tattoos
    --    
    self.Appearance = json.decode(data.Appearance)
    self.State.Appearance = self.Appearance
    --
    -- Functions
    self.IsSupporter = function()
        return self.State.Supporter or self.Supporter
    end
    --
    self.GetIdentifier = function()
        return self.State.Character_ID or self.Character_ID
    end
    --
    self.GetCharacter_ID = function()
        return self.State.Character_ID or self.Character_ID
    end
    --
    self.GetCity_ID = function()
        return self.State.City_ID or self.City_ID
    end
    --
    self.GetBirth_Date = function()
        return self.State.Birth_Date or self.Birth_Date
    end
    --
    self.GetFirst_Name = function()
        return self.State.First_Name or self.First_Name
    end
    --
    self.GetLast_Name = function()
        return self.State.Last_Name or self.Last_Name
    end
    --
    self.GetFull_Name = function()
        return self.State.Full_Name or self.Full_Name
    end
    --
    self.Get = function(k)
        return self[k]
    end
    --
    self.Set = function(k,v)
        self[k] = v
    end
    --
    self.GetGender = function()
        if self.Appearance["sex"] ~= 0 then
            return "Female"
        else
            return "Male"
        end
    end
    --
    self.GetAccounts = function()
        return self.State.Accounts or self.Accounts
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
            self.State.Accounts = self.Accounts
        else
            c.debug_1("Account entered does not exist")
        end
    end
    --
    self.GetLicenses = function()
        return self.State.Licenses or self.Licenses
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
            else
                self.SetAccount("Cash", acc)
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
            else
                self.SetAccount("Cash", acc)
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
            else
                self.SetAccount("Cash", acc)
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
            else
                self.SetAccount("Bank", acc)
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
            else
                self.SetAccount("Bank", acc)
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
            else
                self.SetAccount("Bank", acc)
            end
        end
    end
    -- esx style, except table format.
    self.GetJob = function()
        return self.State.Job or self.Job
    end
    --
    self.SetJob = function(t)
        if c.job.Exist(t.Name, t.Grade) then
            local Object = c.jobs[t.Name]
            --
            self.Job.Name = Object.Name
            self.Job.Label = Object.Label
            --
            self.Job.Grade = Object.Grades[t.Grade].Grade
            self.Job.Grade_Label = Object.Grades[t.Grade].Grade_Label
            self.Job.Grade_Salary = Object.Grades[t.Grade].Grade_Salary
            self.State.Job = self.Job
        else
            c.debug_1("Ignoring invalid .SetJob()")
        end
    end
    --
    self.GetPhone = function()
        return self.State.Phone or self.Phone
    end
    --
    self.SetPhone = function(s)
        local str = c.check.String(s)
        self.Phone = str
        self.State.Phone = self.Phone
    end
    -- 
    self.GetInstance = function()
        return self.State.Instance or self.Instance
    end
    --
    self.SetInstance = function(v)
        local num = c.check.Number(v)
        if num ~= self.GetInstance() then
            self.Instance = num
            self.State.Instance = self.Instance
            c.sql.char.SetInstance(self.GetIdentifier(), num)
        end
    end
    -- 
    self.GetHealth = function()
        return self.State.Health or self.Health
    end
    --
    self.SetHealth = function(v)
        local num = c.check.Number(v, 0, conf.defaulthealth)
        self.Health = num
        self.State.Health = self.Health
    end
    --
    self.GetArmour = function()
        return self.State.Armour or self.Armour
    end
    --
    self.SetArmour = function(v)
        local num = c.check.Number(v, 0, conf.defaultarmour)        
        self.Armour = num
        self.State.Armour = self.Armour
    end
    --
    self.GetHunger = function()
        return self.State.Hunger or self.Hunger
    end
    --
    self.SetHunger = function(v)
        local num = c.check.Number(v, 0, 100)
        self.Hunger = num
        self.State.Hunger = self.Hunger
    end
    --
    self.GetThirst = function()
        return self.State.Thirst or self.Thirst
    end
    --
    self.SetThirst = function(v)
        local num = c.check.Number(v, 0, 100)
        self.Thirst = num
        self.State.Thirst = self.Thirst
    end
    --
    self.GetStress = function()
        return self.State.Stress or self.Stress
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
        return self.State.Modifiers or self.Modifiers
    end
    --
    self.SetModifiers = function(t)
        local tab = c.check.Table(t)
        self.OldModifiers = self.Modifiers
        self.Modifiers = tab
        self.State.Modifiers = self.Modifiers
    end
    --
    self.GetAppearance = function()
        return self.State.Appearance or self.Appearance
    end
    --
    self.SetAppearance = function(t)
        local tab = c.check.Table(t)
        self.Appearance = tab
        self.State.Appearance = self.Appearance
    end
    --
    self.GetTattoos = function()
        return self.State.Tattoos or self.Tattoos
    end
    --
    self.SetTattoos = function(t)
        local tab = c.check.Table(t)
        self.Tattoos = tab
        self.State.Tattoos = self.Tattoos
    end
    --
    self.GetCoords = function()
        return self.State.Coords or self.Coords
    end
    --
    self.SetCoords = function(t)
        local tab = c.check.Table(t)
        self.Coords = {
            x = c.math.Decimals(tab.x, 2),
            y = c.math.Decimals(tab.y, 2),
            z = c.math.Decimals(tab.z, 2)
        }
        self.State.Coords = self.Coords
    end
    --
    self.GetWanted = function()
        return self.State.Wanted or self.Wanted
    end
    --
    self.SetWanted = function(b)
        local b = c.check.Boolean(b)
        self.Wanted = b
        self.State.Wanted = self.Wanted
    end
    --
    self.AddItem = function(name, qty)
        if c.item.Exists(name) then
            if not self.Inventory[name] then
                table.insert(self.Inventory, name)
                self.Inventory[name] = qty
                self.State.Inventory = self.Inventory
            else
                self.Inventory[name] = self.Inventory[name] + qty
                self.State.Inventory = self.Inventory
            end
        end
    end
    --
    -- need to remove qty prior to remove from table.
    self.RemoveItem = function(name, qty)
        if self.HasItem(name) then
            for k,v in pairs(self.Inventory) do
                if k == name then
                    table.remove(self.Inventory, k)
                end
            end
        end
    end
    --
    self.HasItem = function(name)
        for k,v in pairs(self.Inventory) do
            if k == name then
                return true
            end
        end
        return false
    end
    --
    self.CraftItem = function()
        
    end
    --

    --
    c.debug_2("Generated Character")
    return self
end
