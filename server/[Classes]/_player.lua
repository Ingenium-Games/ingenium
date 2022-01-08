-- ====================================================================================--
if not c.class then c.class = {} end
-- ====================================================================================--
c.class.Player = {}
c.class.Player.__index = c.class.Player
-- ====================================================================================--
function c.class.Player:Create(source, character_id)
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
    self:UnpackInventory(self.Inventory)
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
    return self
end
--
function c.class.Player:GetModel()
    return self.Model
end
-- Functions
function c.class.Player:Kick(reason)
    DropPlayer(self.ID, reason)
    TriggerEvent("txaLogger:CommandExecuted", "xPlayer:DropPlayer: " .. reason)
end
--
function c.class.Player:GetName()
    return self.Name
end
--
function c.class.Player:GetAce()
    return self.Ace
end
--
function c.class.Player:GetLocale()
    return self.Locale
end
--
function c.class.Player:GetID()
    return self.ID
end
--
function c.class.Player:GetSteam_ID()
    return self.Steam_ID
end
--
function c.class.Player:GetFiveM_ID()
    return self.FiveM_ID
end
--
function c.class.Player:GetLicense_ID()
    return self.License_ID
end
--
function c.class.Player:GetDiscord_ID()
    return self.Discord_ID
end
--
function c.class.Player:GetIdentifier()
    return c.identifier(self.ID)
end
--
function c.class.Player:GetCharacter_ID()
    return self.Character_ID
end
--
function c.class.Player:GetCity_ID()
    return self.City_ID
end
--
function c.class.Player:GetBirth_Date()
    return self.Birth_Date
end
--
function c.class.Player:GetFirst_Name()
    return self.First_Name
end
--
function c.class.Player:GetLast_Name()
    return self.Last_Name
end
--
function c.class.Player:GetFull_Name()
    return self.Full_Name
end
--
function c.class.Player:GetSupporter()
    return self.IsSupporter
end
--    
function c.class.Player:SetSupporter(bool)
    local bool = c.check.Boolean(bool)
    self.IsSupporter = bool
    self.State.IsSupporter = self.IsSupporter
end
--
function c.class.Player:GetGender()
    return self.Gender
end
--
function c.class.Player:GetInstance()
    return GetPlayerRoutingBucket(self.ID)
end
--
function c.class.Player:SetInstance(id)
    local id = id or self.InstanceID
    SetPlayerRoutingBucket(self.ID, id)
    SetEntityRoutingBucket(self.Entity, id)
    c.sql.char.SetInstance(self.GetIdentifier(), id)
end
-- 
function c.class.Player:GetHealth()
    return self.Health
end
--
function c.class.Player:SetHealth(v)
    local n = c.check.Number(v, 0, conf.defaulthealth)
    self.Health = n
    self.State.Health = self.Health
end
--
function c.class.Player:GetArmour()
    return self.Armour
end
--
function c.class.Player:SetArmour(v)
    local n = c.check.Number(v, 0, conf.defaultarmour)
    self.Armour = n
    self.State.Armour = self.Armour
end
--
function c.class.Player:GetHunger()
    return self.Hunger
end
--
function c.class.Player:SetHunger(v)
    local n = c.check.Number(v, 0, 100)
    self.Hunger = n
    self.State.Hunger = self.Hunger
end
--
function c.class.Player:GetThirst()
    return self.Thirst
end
--
function c.class.Player:SetThirst(v)
    local n = c.check.Number(v, 0, 100)
    self.Thirst = n
    self.State.Thirst = self.Thirst
end
--
function c.class.Player:GetStress()
    return self.Stress
end
--
function c.class.Player:SetStress(v)
    local n = c.check.Number(v, 0, 100)
    self.Stress = n
    self.State.Stress = self.Stress
end
--
function c.class.Player:GetOldModifiers()
    return self.OldModifiers
end
--
function c.class.Player:GetModifiers()
    return self.Modifiers
end
--
function c.class.Player:SetModifiers(t)
    local tab = c.check.Table(t)
    self.OldModifiers = self.Modifiers
    self.Modifiers = tab
end
--
function c.class.Player:GetLicenses()
    return self.Licenses
end
--
function c.class.Player:GetLicense(license)
    for k, v in pairs(self.Licenses) do
        if k == license then
            return v
        end
    end
end
--
function c.class.Player:GetAccounts()
    return self.Accounts
end
--
function c.class.Player:GetAccount(acc)
    for k, v in pairs(self.Accounts) do
        if k == acc then
            return v
        end
    end
end
--
function c.class.Player:SetAccount(acc, v)
    local num = c.check.Number(v)
    if self.Accounts[acc] then
        self.Accounts[acc] = c.math.Decimals(num, 0)
    else
        c.debug_1("Account entered does not exist")
    end
end
--
function c.class.Player:GetCash()
    local acc = self:GetAccount("Cash")
    if acc then
        return acc
    end
end
--
function c.class.Player:SetCash(v)
    local num = c.check.Number(v)
    local acc = self:GetAccount("Cash")
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
            self:SetAccount("Cash", acc)
            self.State.Cash = acc
        end
    end
end
--
function c.class.Player:AddCash(v)
    local num = c.check.Number(v)
    local acc = self:GetAccount("Cash")
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
            self:SetAccount("Cash", acc)
            self.State.Cash = acc
        end
    end
end
--
function c.class.Player:RemoveCash(v)
    local num = c.check.Number(v)
    local acc = self:GetAccount("Cash")
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
            self:SetAccount("Cash", acc)
            self.State.Cash = acc
        end
    end
end
--
function c.class.Player:GetBank()
    local acc = self:GetAccount("Bank")
    if acc then
        return acc
    end
end
--
function c.class.Player:SetBank(v)
    local num = c.check.Number(v)
    local acc = c.math.Decimals(num, 0)
    if acc then
        if acc < 0 then
            self:SetAccount("Bank", acc)
            self.State.Bank = acc
        else
            self:SetAccount("Bank", acc)
            self.State.Bank = acc
        end
    end
end
--
function c.class.Player:AddBank(v)
    local num = c.check.Number(v)
    local acc = self:GetAccount("Bank")
    if acc then
        acc = acc + c.math.Decimals(num, 0)
        if acc < 0 then
            self:SetAccount("Bank", acc)
            self.State.Bank = acc
        else
            self:SetAccount("Bank", acc)
            self.State.Bank = acc
        end
    end
end
--
function c.class.Player:RemoveBank(v)
    local num = c.check.Number(v)
    local acc = self:GetAccount("Bank")
    if acc then
        acc = acc - c.math.Decimals(num, 0)
        if acc < 0 then
            self:SetAccount("Bank", acc)
            self.State.Bank = acc
        else
            self:SetAccount("Bank", acc)
            self.State.Bank = acc
        end
    end
end
--- func desc
function c.class.Player:GetJob()
    return self.Job
end

--- func desc
---@param t any
function c.class.Player:SetJob(t)
    if c.job.Exist(t.Name, t.Grade) then
        self.Job.Name = t.Name
        self.Job.Grade = t.Grade
        self.State.Job = self.Job.Name
        self.State.Grade = self.Job.Grade
        self.State.Boss = c.job.IsBoss(self.Job.Name,self.Job.Grade) 
        --
        TriggerEvent("Server:Character:SetJob", self.ID, self.Job)
        TriggerClientEvent("Client:Character:SetJob", self.ID, self.Job)
    else
        c.debug_1("Ignoring invalid .SetJob() for " .. self.ID)
    end
end
--- func desc
function c.class.Player:GetPhone()
    return self.Phone
end
--- func desc
---@param s any
function c.class.Player:SetPhone(s)
    local s = c.check.String(s)
    self.Phone = s
    self.State.Phone = self.Phone
end
--- func desc
function c.class.Player:GetAppearance()
    return self.Appearance
end
--- func desc
---@param t any
function c.class.Player:SetAppearance(t)
    self.Appearance = t
end
--- func desc
function c.class.Player:GetTattoos()
    return self.Tattoos
end
--- func desc
---@param t any
function c.class.Player:SetTattoos(t)
    local t = c.check.Table(t)
    self.Tattoos = t
end
--- func desc
function c.class.Player:GetOldCoords()
    return self.OldCoords
end
--- func desc
function c.class.Player:GetCoords()
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
function c.class.Player:SetCoords(t)
    self.OldCoords = self:GetCoords()
    self.Coords = {
        x = c.math.Decimals(t.x, 2),
        y = c.math.Decimals(t.y, 2),
        z = c.math.Decimals(t.z, 2),
        h = c.math.Decimals(t.h, 2)
    }
    SetEntityCoords(self.Entity, self.Coords.x, self.Coords.y, self.Coords.z)
    SetEntityHeading(self.Entity,self.Coords.h)
end
--- func desc
function c.class.Player:GetHotbar()
    return self.Hotbar
end
--- func desc
---@param t any
function c.class.Player:SetHotbar(t)
    local t = c.check.Table(t)
    self.Hotbar = t
end
--- func desc
function c.class.Player:GetWanted()
    return self.IsWanted
end
--- func desc
---@param b any
function c.class.Player:SetWanted(b)
    local b = c.check.Boolean(b)
    self.IsWanted = b
    self.State.IsWanted = self.IsWanted
end
--- func desc
function c.class.Player:GetCuffed()
    return self.IsCuffed
end
--- func desc
---@param b any
function c.class.Player:SetCuffed(b)
    local b = c.check.Boolean(b)
    self.IsCuffed = b
    self.State.IsCuffed = self.IsCuffed
end
--- func desc
function c.class.Player:GetFrozen()
    return self.IsFrozen
end
--- func desc
---@param b any
function c.class.Player:SetFrozen(b)
    local b = c.check.Boolean(b)
    self.IsFrozen = b
    self.State.IsFrozen = self.IsFrozen
end
--- func desc
function c.class.Player:GetDragged()
    return self.IsEscorted
end
--- func desc
---@param b any
function c.class.Player:SetDragged(b)
    local b = c.check.Boolean(b)
    self.IsEscorted = b
    self.State.IsEscorted = self.IsEscorted
end
--- func desc
---@param inv any
function c.class.Player:UnpackInventory(inv)
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
function c.class.Player:GetInventory()
    return self.Inventory
end
--- func desc
---@param name any
function c.class.Player:HasItem(name)
    for k, v in ipairs(self.Inventory) do
        if v.Item == name then
            return true, k
        end
    end
    return false, nil
end
--
--- func desc
function c.class.Player:GetWeight()
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
function c.class.Player:SteralizeItem(v)
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
function c.class.Player:AddItem(tbl)
    local item = self:SteralizeItem(tbl)
    if c.item.Exists(item.Item) then
        local weapon = c.item.IsWeapon(item.Item)
        local stackable = c.item.CanStack(item.Item)
        local has, key = self:HasItem(item.Item)
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
function c.class.Player:RemoveItem(name, slot)
    local has, position = self:HasItem(name)
    if has and slot == position then
        table.remove(self.Inventory, position)
    end
end
--- func desc
---@param new any
---@param old any
function c.class.Player:RearrangeItems(new, old)
    table.insert(self.Inventory, new, table.remove(self.Inventory, old))
end
--- func desc
function c.class.Player:CompressInventory()
    local inv = {}
    for i = 1, #self.Inventory do
        table.insert(inv, i)
        inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality,
                  self.Inventory[i].Weapon, self.Inventory[i].Meta}
    end
    return inv
end
-- ====================================================================================--
function c.class.Player.New(source, character_id)
    local self = {}
    setmetatable(self, c.class.Player)
    self:Create(source, character_id)
    return self
end