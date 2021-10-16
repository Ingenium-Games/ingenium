-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - 
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

function c.class.CreateNpc(net)
    local self = {}
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    --
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end
    --
    -- Gender
    self.Gender = IsPedMale(self.Entity) -- boolean value true = m, false = f
    self.State.Gender = self.Gender
    --    
    self.GetGender = function()
        if self.Gender then
            return 0 -- Male
        else
            return 1 -- Female / technically all others, would need to then run a IsPedHuman check.
        end
    end
    --
    self.Human = IsPedHuman(self.Entity)
    self.State.Human = self.Human
    --
    self.IsHuman = function()
        if self.Human then
            return 0 -- Yes is human, true
        else
            return 1 -- No is an animal or some shit.
        end
    end
    --
    -- Model
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    --
    self.GetModel = function()
        return self.State.Model or self.Model
    end
    -- Sorting names based on gender of ped
    if self.Gender then
        local rng = math.random(1,5)
        if rng >= 2 then
            self.First_Name = c.name.RandomMale()
        else
            self.First_Name = c.name.RandomFemale()
        end
        local rng = math.random(1,5)
        if rng >= 3 then
            self.Last_Name = c.name.RandomMale()
        else
            self.Last_Name = c.name.RandomFemale()    
        end
    else
        local rng = math.random(1,5)
        if rng >= 2 then
            self.First_Name = c.name.RandomFemale()
        else
            self.First_Name = c.name.RandomMale()
        end
        local rng = math.random(1,5)
        if rng >= 3 then
            self.Last_Name = c.name.RandomFemale()
        else
            self.Last_Name = c.name.RandomMale()    
        end
    end
    --    
    self.Full_Name = self.First_Name .. " " .. self.Last_Name
    --
    c.debug("Generated NPC State: "..net)
    --
    return self
end
