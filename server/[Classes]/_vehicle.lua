-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Reasoning behind duplicating it as a state and class table.
    - Just incase it goes arse up and state bags become fucked.
    - Preemuch the reason. So, Why rely on one, when you can have two?
    - FUka you.

    Shallow limitations
State getters and setters are naive: 
every get will return the full serialized state from the game, 
and only a direct set operation will serialize the entire state back into the game.

fuck my life, seeya later self code.
    local entState = Entity(veh).state
    entState:set('owner', GetPlayerName(source), false)
    entState:set('fishedSpawning', false, true)
    
]] --
math.randomseed(c.Seed)
-- ====================================================================================--

function c.class.UnownedVehicle(net, bool)
    local stolen = c.check.Boolean(bool)
    local fuel = math.random(45, 100)
    --
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

    -- Plate
    self.Plate = GetVehicleNumberPlateText(self.Entity)
    self.State.Plate = self.Plate
    --
    self.GetPlate = function()
        return self.State.Plate or self.Plate
    end

    -- Coords
    self.GetCoords = function()
        local x, y, z = GetEntityCoords(self.Entity)
        local h = GetEntityHeading(self.Entity)
        local Coords = {
            ['x'] = c.math.Decimals(x, 2),
            ['y'] = c.math.Decimals(y, 2),
            ['z'] = c.math.Decimals(z, 2),
            ['h'] = c.math.Decimals(h, 2)
        }
        return Coords
    end
    --
    self.SetCoords = function(coords)
        if coords.x and coords.y and coords.z and coords.h then
            SetEntityHeading(self.Entity, coords.h)
            SetEntityCoords(self.Entity, coords.x, coords.y, coords.z, false)
        else
            c.debug("Table missing x,y,z,h referance, table dump below: " .. c.table.Dump(coords))
        end
    end

    -- Inventory
    self.Inventory = {}
    self.State.Inventory = self.Inventory
    --
    self.GetInventory = function()
        return self.State.Inventory or self.Inventory
    end
    --
    self.SetInventory = function(t)
        self.Inventory = t
        self.State.Inventory = self.Inventory
    end

    -- Keys
    self.Keys = {}
    self.State.Keys = self.Keys
    --
    self.GetKeys = function()
        return self.State.Keys or self.Keys
    end
    --
    self.SetKeys = function(t)
        self.Keys = t
        self.State.Keys = self.Keys
    end
    --
    self.AddKey = function(id)
        local t = self.GetKeys()
        if not self.CheckKey(id) then
            table.insert(self.Keys, id)
            self.State.Keys = self.Keys
        else
            c.debug('User: ' .. id .. ' Already has key to this vehicle.')
        end
    end
    --
    self.RemoveKey = function(id)
        local t = self.GetKeys()
        if self.CheckKey(id) then
            table.remove(self.Keys, id)
            self.State.Keys = self.Keys
        else
            c.debug('User: ' .. id .. ' Never had a key to this vehicle.')
        end
    end
    --
    self.CheckKey = function(id)
        local t = self.GetKeys()
        if t[id] then
            return true
        else
            return false
        end
    end

    -- Condition
    self.Condition = c.TriggerClientCallback(self.GetSource(), "GetVehicleCondition", self.Net)
    self.State.Condition = self.Condition
    --
    self.GetCondition = function()
        return self.State.Condition or self.Condition
    end
    --
    self.SetCondition = function(conditions)
        self.Condition = conditions
        self.State.Condition = self.Condition
        c.TriggerClientCallback(self.GetSource(), "SetVehicleCondition", self.Net)
    end
    --
    self.AlterCondition = function(id, v)
        if self.CheckConds(id) then
            self.Condition[id] = v
            self.State.Condition = self.Condition
        end
    end
    --
    self.CheckConds = function(id)
        local t = self.GetCondition()
        if t[id] then
            return true
        else
            return false
        end
    end

    -- Modifications
    self.Modifications = c.TriggerClientCallback(self.GetSource(), "GetVehicleModifications", self.Net)
    self.State.Modifications = self.Condition
    --
    self.GetModifications = function()
        return self.State.Modifications or self.Modifications
    end
    --
    self.SetModifications = function(modifications)
        self.Modifications = modifications
        self.State.Modifications = self.Modifications
        c.TriggerClientCallback(self.GetSource(), "SetVehicleModifications", self.Net)
    end
    --
    self.AlterModification = function(id, v)
        if self.CheckMods(id) then
            self.Modifications[id] = v
            self.State.Modifications = self.Modifications
        end
    end
    --
    self.CheckMods = function(id)
        local t = self.GetModifications()
        if t[id] then
            return true
        else
            return false
        end
    end
    --

    -- Fuel
    self.Fuel = fuel
    self.State.Fuel = self.Fuel
    --
    self.GetFuel = function()
        return self.State.Fuel or self.Fuel
    end
    --
    self.SetFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.State.Fuel = num
        self.Fuel = num
    end
    --
    self.AddFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.SetFuel((self.GetFuel() + num))
        self.Fuel = self.GetFuel()
        if self.GetFuel() >= 100 then
            self.SetFuel(100)
            self.Fuel = 100
        end
    end
    --
    self.RemoveFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.SetFuel((self.GetFuel() - num))
        self.Fuel = self.GetFuel()
        if self.GetFuel() <= 0 then
            self.SetFuel(0)
            self.Fuel = 0
        end
    end

    self.Instance = false
    self.State.Instance = self.Instance

    self.Garage = false
    self.State.Garage = self.Garage

    self.State = false
    self.State.State = self.State

    self.Impound = false
    self.State.Impound = self.Impound

    -- Owner
    self.Owner = false
    self.State.Owner = self.Owner
    --
    self.GetOwner = function()
        return self.State.Owner or self.Owner
    end
    --

    -- Wanted
    self.Wanted = stolen
    self.State.Wanted = self.Wanted
    --
    self.GetWanted = function()
        return self.State.Wanted or self.Wanted
    end
    --

    return self
end

-- ====================================================================================--

function c.class.OwnedVehicle(net, plate)
    local data = c.sql.GetVehicleByPlate(plate)
    local self = {}
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    --
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end

    -- Model
    self.Model = data.Model
    self.State.Model = self.Model
    --
    self.GetModel = function()
        return self.State.Model or self.Model
    end
    --    

    -- Plate
    self.Plate = data.Plate
    self.State.Plate = self.Plate
    --
    self.GetPlate = function()
        return self.State.Plate or self.Plate
    end

    -- Coords
    self.GetCoords = function()
        local x, y, z = GetEntityCoords(self.Entity)
        local h = GetEntityHeading(self.Entity)
        local Coords = {
            ['x'] = c.math.Decimals(x, 2),
            ['y'] = c.math.Decimals(y, 2),
            ['z'] = c.math.Decimals(z, 2),
            ['h'] = c.math.Decimals(h, 2)
        }
        return Coords
    end
    --
    self.SetCoords = function(coords)
        if coords.x and coords.y and coords.z and coords.h then
            SetEntityHeading(self.Entity, coords.h)
            SetEntityCoords(self.Entity, coords.x, coords.y, coords.z, false)
        else
            c.debug("Table missing x,y,z,h referance, table dump below: " .. c.table.Dump(coords))
        end
    end

    -- Inventory
    self.Inventory = data.Inventory
    self.State.Inventory = self.Inventory
    --
    self.GetInventory = function()
        return self.State.Inventory or self.Inventory
    end
    --
    self.SetInventory = function(t)
        self.Inventory = t
        self.State.Inventory = self.Inventory
    end

    -- Keys
    self.Keys = data.Keys
    self.State.Keys = self.Keys
    --
    self.GetKeys = function()
        return self.State.Keys or self.Keys
    end
    --
    self.SetKeys = function(t)
        self.Keys = t
        self.State.Keys = self.Keys
    end
    --
    self.AddKey = function(id)
        local t = self.GetKeys()
        if not self.CheckKey(id) then
            table.insert(self.Keys, id)
            self.State.Keys = self.Keys
        else
            c.debug('User: ' .. id .. ' Already has key to this vehicle.')
        end
    end
    --
    self.RemoveKey = function(id)
        local t = self.GetKeys()
        if self.CheckKey(id) then
            table.remove(self.Keys, id)
            self.State.Keys = self.Keys
        else
            c.debug('User: ' .. id .. ' Never had a key to this vehicle.')
        end
    end
    --
    self.CheckKey = function(id)
        local t = self.GetKeys()
        if t[id] then
            return true
        else
            return false
        end
    end

    -- Condition
    self.Condition = data.Condition
    self.State.Condition = self.Condition
    --
    self.GetCondition = function()
        return self.State.Condition or self.Condition
    end
    --
    self.SetCondition = function(conditions)
        self.Condition = conditions
        self.State.Condition = self.Condition
        c.TriggerClientCallback(self.GetSource(), "SetVehicleCondition", self.Net)
    end
    --
    self.AlterCondition = function(id, v)
        if self.CheckConds(id) then
            self.Condition[id] = v
            self.State.Condition = self.Condition
        end
    end
    --
    self.CheckConds = function(id)
        local t = self.GetCondition()
        if t[id] then
            return true
        else
            return false
        end
    end

    -- Modifications
    self.Modifications = data.Modifications
    self.State.Modifications = self.Condition
    --
    self.GetModifications = function()
        return self.State.Modifications or self.Modifications
    end
    --
    self.SetModifications = function(modifications)
        self.Modifications = modifications
        self.State.Modifications = self.Modifications
        c.TriggerClientCallback(self.GetSource(), "SetVehicleModifications", self.Net)
    end
    --
    self.AlterModification = function(id, v)
        if self.CheckMods(id) then
            self.Modifications[id] = v
            self.State.Modifications = self.Modifications
        end
    end
    --
    self.CheckMods = function(id)
        local t = self.GetModifications()
        if t[id] then
            return true
        else
            return false
        end
    end
    --

    self.Instance = data.Instance
    self.State.Instance = self.Instance

    self.Garage = data.Garage
    self.State.Garage = self.Garage

    self.State = data.State
    self.State.State = self.State

    self.Impound = data.Impound
    self.State.Impound = self.Impound

    -- Fuel
    self.Fuel = self.Modifications.Fuel
    self.State.Fuel = self.Fuel
    --
    self.GetFuel = function()
        return self.State.Fuel or self.Fuel
    end
    --
    self.SetFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.State.Fuel = num
        self.Fuel = num
        self.Modifications.Fuel = num
    end
    --
    self.AddFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.SetFuel((self.GetFuel() + num))
        self.Fuel = self.GetFuel()
        self.Modifications.Fuel = self.GetFuel()
        if self.GetFuel() >= 100 then
            self.SetFuel(100)
            self.Fuel = 100
            self.Modifications.Fuel = 100
        end
    end
    --
    self.RemoveFuel = function(v)
        local num = c.check.Number(v, 0, 100)
        self.SetFuel((self.GetFuel() - num))
        self.Fuel = self.GetFuel()
        self.Modifications.Fuel = self.GetFuel()
        if self.GetFuel() <= 0 then
            self.SetFuel(0)
            self.Fuel = 0
            self.Modifications.Fuel = 0
        end
    end

    -- Owner
    self.Owner = data.Character_ID
    self.State.Owner = self.Owner
    --
    self.GetOwner = function()
        return self.State.Owner or self.Owner
    end
    --

    -- Wanted
    self.Wanted = data.Wanted
    self.State.Wanted = self.Wanted
    --
    self.GetWanted = function()
        return self.State.Wanted or self.Wanted
    end
    --

    --
    return self
end
