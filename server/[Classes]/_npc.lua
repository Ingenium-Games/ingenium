-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--[[
NOTES
    - 
]] --


-- ====================================================================================--

function c.class.CreateNpc(net)
    local self = {}
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    --
    -- Current entity owner
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end
    --
    -- Model (hash)
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    --
    self.GetModel = function()
        return self.State.Model or self.Model
    end
    --
    -- Gender ("Male"/"Female")
    self.Gender, self.GenderString = c.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    self.State.GenderString = self.GenderString
    --
    self.GetGender =  function()
        return self.State.Gender or self.Gender
    end
    --
    -- Humaniod Model (true/false)
    self.IsHuman = c.IsPedHuman(self.Model)
    self.State.IsHuman = self.IsHuman
    --
    -- Animation?
    self.State.Animation = false
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
        self.Full_Name = self.First_Name..' '.. self.Last_Name
        self.State.Full_Name = self.Full_Name
    elseif not self.Gender and self.IsHuman then
        -- is not male but is human
        self.First_Name = c.name.RandomFemale()
        self.State.First_Name = self.First_Name
        --
        self.Last_Name = c.name.RandomMale()
        self.State.Last_Name = self.Last_Name
        --
        self.Full_Name = self.First_Name..' '.. self.Last_Name
        self.State.Full_Name = self.Full_Name
    end

    self.GetFirst_Name = function()
        if self.IsHuman then
            return self.State.First_Name or self.First_Name
        end
        return ''
    end
    --
    self.GetLast_Name = function()
        if self.IsHuman then
            return self.State.Last_Name or self.Last_Name
        end
        return ''
    end
    --
    self.GetFull_Name = function()
        if self.IsHuman then
            return self.State.Full_Name or self.Full_Name
        end
        return ''
    end
    --
    self.Weight = 0
    --
    self.Inventory = {}
    self.State.Inventory = self.Inventory
    --
    self.GetInventory = function()
        return self.State.Inventory or self.Inventory
    end
    --
    self.HasItem = function(name)
        for k,v in ipairs(self.Inventory) do
            if v.Item == name then
                return true, k 
            end
        end
        return false
    end
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
            c.debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for NPC, NetID: "..self.Net)
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
        if c.item.Exists(item) then
            local weapon = c.item.IsWeapon(item.Item)
            local stackable = c.item.CanStack(item.Item)
            local has, key = self.HasItem(item.Item)
            if (weapon and type(item.Weapon) == "string") or (not stackable and has) then
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
            c.debug_1("Ignoring invalid .AddItem() for "..self.Net)
        end
    end
    -- 
    self.RemoveItem = function(name, slot)
        local has, position = self.HasItem(name)
        if has and (slot == position) then
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
    self.CompileInventory = function()
        local inv = {}
        for k,v in ipairs(self.Inventory) do
            inv[k] = {v.Item, v.Quanitity, v.Quality, v.Weapon, v.Meta}
        end
        return inv
    end
    --
    -- Add items at random onto the NPC's at creation of table data.
    -- self.AddItem({"Cash",math.random(5,65),100,false,false})




    --
    -- Complated Generation
    c.debug_2("Generated NPC State: "..net)
    --
    return self
end
