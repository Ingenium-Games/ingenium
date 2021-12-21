-- ====================================================================================--
c.class.Npc = {}
c.class.Npc.__index = c.class.Npc
-- ====================================================================================--
--- func desc
---@param net any
function c.class.Npc:Create(net)
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    -- Gender ("Male"/"Female")
    self.Gender, self.GenderString = c.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    self.State.GenderString = self.GenderString
    --
    -- Humaniod Model (true/false)
    self.IsHuman = c.IsPedHuman(self.Model)
    self.State.IsHuman = self.IsHuman
    --
    -- Animation?
    self.State.Animation = false

    self.Inventory = self:UnpackInventory()
    self.Weight = 0
    --
    -- City_ID
    local s1 = string.upper(c.rng.let())
    local s2 = c.rng.nums(4)
    self.City_ID = string.format("%s-%sN", s1, s2)
    self.State.City_ID = self.City_ID
    --
    -- Name 
    if self.Gender and self.IsHuman then
        -- is male, is human
        self.First_Name = c.name.RandomMale()
        self.State.First_Name = self.First_Name
        --
        self.Last_Name = c.name.RandomMale()
        self.State.Last_Name = self.Last_Name
        --
        self.Full_Name = self.First_Name .. " " .. self.Last_Name
        self.State.Full_Name = self.Full_Name
    elseif not self.Gender and self.IsHuman then
        -- is not male but is human
        self.First_Name = c.name.RandomFemale()
        self.State.First_Name = self.First_Name
        --
        self.Last_Name = c.name.RandomMale()
        self.State.Last_Name = self.Last_Name
        --
        self.Full_Name = self.First_Name .. " " .. self.Last_Name
        self.State.Full_Name = self.Full_Name
    end
    return self
end
--- func desc
function c.class.Npc:GetSource()
    return NetworkGetEntityOwner(self.Entity)
end
--- func desc
function c.class.Npc:GetModel()
    return self.Model
end
--- func desc
function c.class.Npc:GetGender()
    return self.Gender
end
--- func desc
function c.class.Npc:GetFirst_Name()
    if self.IsHuman then
        return self.First_Name
    end
    return ""
end
--- func desc
function c.class.Npc:GetLast_Name()
    if self.IsHuman then
        return self.Last_Name
    end
    return ""
end
--- func desc
function c.class.Npc:GetFull_Name()
    if self.IsHuman then
        return self.Full_Name
    end
    return ""
end
--- func desc
---@param inv any
function c.class.Npc:UnpackInventory(inv)
    local inv = inv or {}
    --
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
function c.class.Npc:GetInventory()
    return self.Inventory
end
--- func desc
---@param name any
function c.class.Npc:HasItem(name)
    for k, v in ipairs(self.Inventory) do
        if v.Item == name then
            return true, k
        end
    end
    return false, nil
end
--
--- func desc
function c.class.Npc:GetWeight()
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
function c.class.Npc:SteralizeItem(v)
    if type(v) ~= "table" then
        c.debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for NPC: " .. self.Net)
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
function c.class.Npc:AddItem(tbl)
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
        c.debug_1("Ignoring invalid .AddItem() for NPC: " .. self.Net)
    end
end
--- func desc
---@param name any
---@param slot any
function c.class.Npc:RemoveItem(name, slot)
    local has, position = self:HasItem(name)
    if has and slot == position then
        table.remove(self.Inventory, position)
    end
end
--- func desc
---@param new any
---@param old any
function c.class.Npc:RearrangeItems(new, old)
    table.insert(self.Inventory, new, table.remove(self.Inventory, old))
end
--- func desc
function c.class.Npc:CompressInventory()
    local inv = {}
    for i = 1, #self.Inventory do
        table.insert(inv, i)
        inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality,
                  self.Inventory[i].Weapon, self.Inventory[i].Meta}
    end
    return inv
end
-- ====================================================================================--
--- func desc
---@param net any
function c.class.Npc.Generate(net)
    local self = {}
    setmetatable(self, c.class.Npc)
    self:Create(net)
    -- Add items at random onto the NPC"s at creation of table data.
    -- self.AddItem({"Cash",math.random(5,65),100,false,false})
    self:AddItem({"Cash", math.random(25, 89), 100, false, false})
    return self
end
