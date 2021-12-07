-- ====================================================================================--

--[[
NOTES.
    - Why have the user and character classes seperate?
    - Becasue a player has different data to the character being played.
    - Not using the Player State, as still testing.
]] --
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
    self.Weight = 0
    self.MaxWeight = 25
    self.State.Weight = self.Weight
    --         
    -- Booleans
    self.IsWanted = data.Wanted
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
    -- Tables (JSONIZE)
    -- Uncertain if these table valeus are actually stored on the state bags as they are nieve...
    self.Job = json.decode(data.Job)
    self.State.Job = self.Job.Name
    self.State.Grade = self.Job.Grade
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
    self.Inventory = c.class.CreateInventory(json.decode(data.Inventory))
    self.State.Inventory = self.Inventory
    --
    self.Hotbar = json.decode(data.Hotbar)
    self.State.Hotbar = self.Hotbar
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
    -- Animation?
    self.State.Animation = false
    --
    -- Functions
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
            self.State.Accounts = self.Accounts
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
    self.State.Cash = 0
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
    self.State.Bank = 0
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
            TriggerEvent('Server:Character:SetJob', self.ID, self.Job)
            TriggerClientEvent('Client:Character:SetJob', self.ID, self.Job)
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
    self.GetInstance = function()
        return self.Instance
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
        self.State.Modifiers = self.Modifiers
    end
    --
    self.GetAppearance = function()
        return self.Appearance
    end
    --
    self.SetAppearance = function(t)
        local tab = c.check.Table(t)
        self.Appearance = tab
        self.State.Appearance = self.Appearance
    end
    --
    self.GetTattoos = function()
        return self.Tattoos
    end
    --
    self.SetTattoos = function(t)
        local tab = c.check.Table(t)
        self.Tattoos = tab
        self.State.Tattoos = self.Tattoos
    end
    --
    self.GetCoords = function()
        return self.Coords
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
    self.GetHotbar = function()
        return self.Hotbar
    end
    --
    self.SetHotbar = function(t)
        self.Hotbar = t
        self.State.Hotbar = self.Hotbar
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
    --
        --[[ Items are stored as such in the DB
            Will be stored as this

                1:{"item", 1, 100, false, {metadata}}

            Will be used as this.
                self[k] = {
                    ["Item"] = v[1],
                    ["Quantity"] = v[2],
                    ["Quality"] = v[3],
                    ["Weapon"] = v[4],
                    ["Meta"] = v[5]
                }

            You shouldnt need any other front end data to show on an nui etc.
        
        ]]--
    self.GetInventory = function()
        return self.Inventory
    end
    --
    self.HasItem = function(name)
        for k,v in ipairs(self.Inventory) do
            if v.Item == name then
                return true, k 
            end
        end
        return false, nil
    end
    --
    --
    self.GetWeight = function()
        self.Weight = 0
        for k,v in ipairs(self.Inventory) do
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
            c.debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Player ID: "..self.ID)
            return 
        end
        local info = {
            ["Item"] = c.check.String(v[1]), -- string
            ["Quantity"] = c.check.Number((v[2] or c.items[v[1]].Quantity)), -- number/int >= 1
            ["Quality"] = c.check.Number((v[3] or c.items[v[1]].Quality)), -- number/int >= 1 <= 100
            ["Weapon"] = (v[4] or c.items[v[1]].Weapon),
            ["Meta"] = (v[5] or c.items[v[1]].Meta),
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
                self.State.Inventory = self.Inventory
            elseif (stackable and has) then
                self.Inventory[key].Quantity = self.Inventory[key].Quantity + item.Quantity
                self.State.Inventory = self.Inventory
            else
                self.Inventory[#self.Inventory + 1] = item
                self.State.Inventory = self.Inventory
            end
        else
            c.debug_1("Ignoring invalid .AddItem() for "..self.ID)
        end
    end
    -- 
    self.RemoveItem = function(name, slot)
        local has, position = self.HasItem(name)
        if has and slot == position then
            table.remove(self.Inventory, position)
            self.State.Inventory = self.Inventory
        end
    end
    --
    self.RearrangeItems = function(new, old)
        table.insert(self.Inventory, new, table.remove(self.Inventory, old))
        self.State.Inventory = self.Inventory
    end
    --
    self.CompressInventory = function()
        local inv = {}
        for i=1, #self.Inventory do
            table.insert(inv, i)
            inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality, self.Inventory[i].Weapon, self.Inventory[i].Meta}
        end
        return inv
    end
    --
    c.debug_2("Generated Character")
    return self
end