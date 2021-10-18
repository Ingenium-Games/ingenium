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
    -- Model
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    --
    self.GetModel = function()
        return self.State.Model or self.Model
    end
    --
    -- Gender
    _, self.Gender = c.IsPedMale(self.Model)
    self.State.Gender = self.Gender
    --
    self.GetGender =  function()
        return self.State.Gender or self.Gender
    end
    --
    -- Humaniod Model
    self.IsHuman = c.IsPedHuman(self.Model)
    self.State.IsHuman = self.IsHuman
    --


    c.debug("Generated NPC State: "..net)
    --
    return self
end
