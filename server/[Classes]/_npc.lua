-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
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
    -- Gender ("Male"/"Felame")
    _, self.Gender = c.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    --
    self.GetGender =  function()
        return self.State.Gender or self.Gender
    end
    --
    -- Humaniod Model (true/false)
    self.IsHuman = c.IsPedHuman(self.Model)
    self.State.IsHuman = self.IsHuman
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
    c.debug_2("Generated NPC State: "..net)
    --
    return self
end
