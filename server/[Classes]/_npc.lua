-- ====================================================================================--

--[[
NOTES
    - 
]] --


-- ====================================================================================--

c.class.Npc = {}
c.class.Npc._index = c.class.Npc

function c.class.Npc:Create(net)
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
        return self.Model
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
        self.Full_Name = self.First_Name.." ".. self.Last_Name
        self.State.Full_Name = self.Full_Name
    elseif not self.Gender and self.IsHuman then
        -- is not male but is human
        self.First_Name = c.name.RandomFemale()
        self.State.First_Name = self.First_Name
        --
        self.Last_Name = c.name.RandomMale()
        self.State.Last_Name = self.Last_Name
        --
        self.Full_Name = self.First_Name.." ".. self.Last_Name
        self.State.Full_Name = self.Full_Name
    end

    self.GetFirst_Name = function()
        if self.IsHuman then
            return self.First_Name
        end
        return ""
    end
    --
    self.GetLast_Name = function()
        if self.IsHuman then
            return self.Last_Name
        end
        return ""
    end
    --
    self.GetFull_Name = function()
        if self.IsHuman then
            return self.Full_Name
        end
        return ""
    end
    --
    self.Inventory = c.class.Inventory:Create()
    --
    -- Add items at random onto the NPC"s at creation of table data.
    -- self.AddItem({"Cash",math.random(5,65),100,false,false})
    self:AddItem({"Cash", math.random(25,89), 100, false, false})
    --
    -- Complated Generation
    c.debug_2("Generated NPC State: "..net)
    --
    return self
end

function c.class.Npc.Generate(net)
    local self = {}
	setmetatable(self, c.class.Npc:Create(net))
	return self
end