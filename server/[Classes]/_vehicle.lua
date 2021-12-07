-- ====================================================================================--

--[[
NOTES
    - Fuck yeh onesync creation event boi.
]] --

-- ====================================================================================--

function c.class.CreateVehicle(net, bool)
    local stolen = c.check.Boolean(bool)
    local fuel = math.random(25, 100)
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
        return self.Model
    end
    --    

    -- Plate
    self.Plate = GetVehicleNumberPlateText(self.Entity)
    self.State.Plate = self.Plate
    --
    self.GetPlate = function()
        return self.Plate
    end

    -- Coords
    self.GetCoords = function()
        local x, y, z = GetEntityCoords(self.Entity)
        local h = GetEntityHeading(self.Entity)
        return {
            ['x'] = c.math.Decimals(x, 2),
            ['y'] = c.math.Decimals(y, 2),
            ['z'] = c.math.Decimals(z, 2),
            ['h'] = c.math.Decimals(h, 2)
        }
    end
    --
    self.SetCoords = function(coords)
        if coords.x and coords.y and coords.z and coords.h then
            SetEntityHeading(self.Entity, coords.h)
            SetEntityCoords(self.Entity, coords.x, coords.y, coords.z, false)
        else
            c.debug_1("Table missing x,y,z,h referance, table dump below: " .. c.table.Dump(coords))
        end
    end

    -- Inventory
    --
    self.Inventory = {}
    self.State.Inventory = self.Inventory
    --
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
    -- Keys
    self.Keys = {}
    self.State.Keys = self.Keys
    --
    self.GetKeys = function()
        return self.Keys
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
            c.debug_1('User: ' .. id .. ' Already has key to this vehicle.')
        end
    end
    --
    self.RemoveKey = function(id)
        local t = self.GetKeys()
        if self.CheckKey(id) then
            table.remove(self.Keys, id)
            self.State.Keys = self.Keys
        else
            c.debug_1('User: ' .. id .. ' Never had a key to this vehicle.')
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
    self.Condition = {}    
    self.State.Condition = self.Condition
    --
    self.GetCondition = function()
        return self.Condition
    end
    --
    self.SetCondition = function(conditions)
        self.Condition = conditions or TriggerClientCallback({
            source = self.GetSource(),
            eventName = 'GetVehicleCondition',
            args = {self.Net}
        })    
        self.State.Condition = self.Condition
        TriggerClientCallback({
            source = self.GetSource(),
            eventName = 'SetVehicleCondition',
            args = {self.Net}
        })
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
    self.Modifications = {}
    self.State.Modifications = self.Condition
    --
    self.GetModifications = function()
        return self.Modifications
    end
    --
    self.SetModifications = function(modifications)
        self.Modifications = modifications or TriggerClientCallback({
            source = self.GetSource(),
            eventName = 'GetVehicleModifications',
            args = {self.Net}
        })
        self.State.Modifications = self.Modifications
        TriggerClientCallback({
            source = self.GetSource(),
            eventName = 'SetVehicleModifications',
            args = {self.Net}
        })
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
        return self.Fuel
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

    self.Status = false
    self.State.Status = self.Status

    self.Impound = false
    self.State.Impound = self.Impound

    -- Owner
    self.Owner = false
    self.State.Owner = self.Owner
    --
    self.GetOwner = function()
        return self.Owner
    end
    --

    -- Wanted
    self.Wanted = stolen
    self.State.Wanted = self.Wanted
    --
    self.GetWanted = function()
        return self.Wanted
    end
    --
    
    --
    c.debug_2("Generated Vehicle State: "..net)
    return self
end

-- ====================================================================================--

function c.class.CreatePlayerVehicle(net, plate)
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
        return self.Model
    end
    --    

    -- Plate
    self.Plate = data.Plate
    self.State.Plate = self.Plate
    --
    self.GetPlate = function()
        return self.Plate
    end

    -- Coords
    self.GetCoords = function()
        local x, y, z = GetEntityCoords(self.Entity)
        local h = GetEntityHeading(self.Entity)
        return {
            ['x'] = c.math.Decimals(x, 2),
            ['y'] = c.math.Decimals(y, 2),
            ['z'] = c.math.Decimals(z, 2),
            ['h'] = c.math.Decimals(h, 2)
        }
    end
    --
    self.SetCoords = function(coords)
        if coords.x and coords.y and coords.z and coords.h then
            SetEntityHeading(self.Entity, coords.h)
            SetEntityCoords(self.Entity, coords.x, coords.y, coords.z, false)
        else
            c.debug_1("Table missing x,y,z,h referance, table dump below: " .. c.table.Dump(coords))
        end
    end
    --
    self.Weight = 0
    -- Inventory
    --
    self.Inventory = c.class.CreateInventory(json.decode(data.Inventory))
    self.State.Inventory = self.Inventory
    --
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

    -- Keys
    self.Keys = data.Keys
    self.State.Keys = self.Keys
    --
    self.GetKeys = function()
        return self.Keys
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
            c.debug_1('User: ' .. id .. ' Already has key to this vehicle.')
        end
    end
    --
    self.RemoveKey = function(id)
        local t = self.GetKeys()
        if self.CheckKey(id) then
            table.remove(self.Keys, id)
            self.State.Keys = self.Keys
        else
            c.debug_1('User: ' .. id .. ' Never had a key to this vehicle.')
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
        return self.Condition
    end
    --
    self.SetCondition = function(conditions)
        self.Condition = conditions
        self.State.Condition = self.Condition
        TriggerClientCallback({
            source = self.GetSource(),
            eventName = 'SetVehicleCondition',
            args = {self.Net}
        })
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
        return self.Modifications
    end
    --
    self.SetModifications = function(modifications)
        self.Modifications = modifications
        self.State.Modifications = self.Modifications
        TriggerClientCallback({
            source = self.GetSource(),
            eventName = 'SetVehicleModifications',
            args = {self.Net}
        })
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

    self.Status = data.Status
    self.State.Status = self.Status

    self.Impound = data.Impound
    self.State.Impound = self.Impound

    -- Fuel
    self.Fuel = self.Modifications.Fuel
    self.State.Fuel = self.Fuel
    --
    self.GetFuel = function()
        return self.Fuel
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
        return self.Owner
    end
    --

    -- Wanted
    self.Wanted = data.Wanted
    self.State.Wanted = self.Wanted
    --
    self.GetWanted = function()
        return self.Wanted
    end
    --

    --
    c.debug_2("Generated Player Vehicle State: "..net)
    --
    return self
end
