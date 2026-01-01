-- ====================================================================================--
if not ig.class then
    ig.class = {}
end
-- ====================================================================================--

--- func desc
---@param net any
---@param bool any
function ig.class.Vehicle(net)
    local data = {
        Fuel = math.random(25, 89),
        Plate = string.upper(ig.rng.chars(8)),
        Instance = false,
        Garage = false,
        Parked = false,
        Impound = false,
        Owner = false,
        Wanted = true,
        -- Json
        Modifications = {},
        Inventory = {},
        Condition = {},
        Keys = {},
        Updated = ig.func.Timestamp()
    }
    local self = {}
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    -- Model
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    -- Plate
    self.Plate = data.Plate
    self.State.Plate = self.Plate
    --
    self.Weight = 0
    -- Owner
    self.Owner = data.Owner
    self.State.Owner = self.Owner
    -- Wanted
    self.Wanted = data.Wanted
    self.State.Wanted = self.Wanted
    -- Fuel
    self.Fuel = data.Fuel
    self.State.Fuel = self.Fuel
    --
    self.Instance = data.Instance
    self.State.Instance = self.Instance
    --
    self.Garage = data.Garage
    self.State.Garage = self.Garage
    --
    self.Parked = data.Parked
    self.State.Parked = self.Parked
    --
    self.Impound = data.Impound
    self.State.Impound = self.Impound
    --
    -- Inventory
    self.Inventory = data.Inventory
    -- Condition
    self.Condition = data.Condition
    -- Modifications
    self.Modifications = data.Modifications
    -- Key
    self.Keys = data.Keys
    self.State.Keys = self.Keys
    --
    self.Updated = data.Updated
    self.State.Updated = self.Updated
    --
    self.Spawned = false
    --
    -- Dirty Flag System for Database Optimization
    self.IsDirty = false
    self.DirtyFields = {}
    --
    -- Cached JSON Encoding for Performance
    self.EncodedInventory = nil
    self.EncodedCondition = nil
    self.EncodedModifications = nil
    self.EncodedKeys = nil
    --
    self.HasSpawned = function()
        self.Spawned = true
        self.State.Spawned = self.Spawned
    end
    --- func desc
    self.ClearDirty = function()
        self.IsDirty = false
        self.DirtyFields = {}
    end
    --- func desc
    self.GetIsDirty = function()
        return self.IsDirty
    end
    --
    self.MarkDirty = function(fieldName)
        self.IsDirty = true
        if fieldName then
            self.DirtyFields[fieldName] = true
        end
    end
    --- func desc
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end
    --- func desc
    self.GetNet = function()
        return self.Net
    end
    --
    --- func desc
    self.SetUpdated = function()
        self.Updated = ig.func.Timestamp()
        self.IsDirty = true
    end
    --- func desc
    self.GetModel = function()
        return self.Model
    end
    --- func desc
    self.GetPlate = function()
        return self.Plate
    end
    --- func desc
    self.GetEntity = function()
        return self.Entity
    end
    --
    self.GetParked = function()
        return self.Parked
    end
    --
    self.SetParked = function(b)
        local bool = ig.check.Boolean(b)
        self.Parked = bool
        self.SetUpdated()
    end
    --- func desc
    self.GetCoords = function()
        local x, y, z = table.unpack(GetEntityCoords(self.Entity))
        local h = GetEntityHeading(self.Entity)
        local rx, ry, rz = table.unpack(GetEntityRotation((self.Entity)))
        return {
            ["x"] = ig.math.Decimals(x, 2),
            ["y"] = ig.math.Decimals(y, 2),
            ["z"] = ig.math.Decimals(z, 2),
            ["h"] = ig.math.Decimals(h, 2),
            ["rx"] = ig.math.Decimals(rx, 2),
            ["ry"] = ig.math.Decimals(ry, 2),
            ["rz"] = ig.math.Decimals(rz, 2)
        }
    end
    --- func desc
    ---@param coords any
    self.SetCoords = function(coords)
        self.Coords = {
            x = ig.math.Decimals(coords.x, 2),
            y = ig.math.Decimals(coords.y, 2),
            z = ig.math.Decimals(coords.z, 2),
            h = ig.math.Decimals(coords.h, 2),
            rx = ig.math.Decimals(coords.rx, 2),
            ry = ig.math.Decimals(coords.ry, 2),
            rz = ig.math.Decimals(coords.rz, 2),
        }
        --
        SetEntityCoords(self.Entity, vec3(self.Coords.x, self.Coords.y, self.Coords.z))
        SetEntityHeading(self.Entity, self.Coords.h)
        SetEntityRotation(self.Entity, vec3(self.Coords.rx, self.Coords.ry, self.Coords.rz), 3)
        ---
        self.SetUpdated()
    end

    --- func desc
    self.GetKeys = function()
        return self.Keys
    end
    --- func desc
    ---@param t any
    self.SetKeys = function(t)
        self.Keys = t
        self.State.Keys = self.Keys
        self.DirtyFields.Keys = true
        self.EncodedKeys = nil
        self.SetUpdated()
    end
    --- func desc
    ---@param id any
    self.AddKey = function(id)
        local t = self.GetKeys()
        if not self.CheckKeys(id) then
            table.insert(self.Keys, id)
            self.State.Keys = self.Keys
            self.DirtyFields.Keys = true
            self.EncodedKeys = nil
        else
            ig.func.Debug_1("User: " .. id .. " Already has key to this vehicle.")
        end
        self.SetUpdated()
    end
    --- func desc
    ---@param id any
    self.RemoveKey = function(id)
        local t = self.GetKeys()
        if self.CheckKeys(id) then
            table.remove(self.Keys, id)
            self.State.Keys = self.Keys
            self.DirtyFields.Keys = true
            self.EncodedKeys = nil
        else
            ig.func.Debug_1("User: " .. id .. " Never had a key to this vehicle.")
        end        
        self.SetUpdated()
    end
    --- func desc
    ---@param id any
    self.CheckKeys = function(id)
        local t = self.GetKeys()
        for k, v in pairs(t) do
            if v == id then
                return true
            end
        end
        return false
    end
    --- func desc
    self.GetCondition = function()
        return self.Condition
    end
    --- func desc
    ---@param conditions any
    self.SetCondition = function(conditions)
        self.Condition = conditions
        self.State.Condition = self.Condition
        self.DirtyFields.Condition = true
        self.EncodedCondition = nil
        self.SetUpdated()
    end
    --- func desc
    ---@param id any
    ---@param v any
    self.AlterCondition = function(id, v)
        if self.CheckConds(id) then
            self.Condition[id] = v
            self.SetUpdated()
        end
    end
    --- func desc
    ---@param id any
    self.CheckConds = function(id)
        local t = self.GetCondition()
        if t[id] then
            return true
        else
            return false
        end
    end
    --- func desc
    self.GetModifications = function()
        return self.Modifications
    end
    --- func desc
    ---@param modifications any
    self.SetModifications = function(modifications)
        self.Modifications = modifications
        self.State.Modifications = self.Modifications
        self.DirtyFields.Modifications = true
        self.EncodedModifications = nil
        self.SetUpdated()
    end
    --- func desc
    ---@param id any
    ---@param v any
    self.AlterModification = function(id, v)
        if self.CheckMods(id) then
            self.Modifications[id] = v
            self.SetUpdated()
        end
    end
    --- func desc
    ---@param id any
    self.CheckMods = function(id)
        local t = self.GetModifications()
        if t[id] then
            return true
        else
            return false
        end
    end
    --- func desc
    self.GetFuel = function()
        return self.Fuel
    end
    --- func desc
    ---@param v any
    self.SetFuel = function(v)
        local num = ig.check.Number(v, 0, 100)
        if self.Fuel ~= num then
            self.Fuel = num
            self.State.Fuel = num
            self.DirtyFields.Fuel = true
            self.SetUpdated()
        end
    end
    --- func desc
    ---@param v any
    self.AddFuel = function(v)
        local num = ig.check.Number(v, 0, 100)
        self.SetFuel((self.GetFuel() + num))
        self.Fuel = self.GetFuel()
        self.State.Fuel = self.Fuel
        if self.GetFuel() >= 100 then
            self.SetFuel(100)
            self.Fuel = 100
            self.State.Fuel = 100
        end
        self.SetUpdated()
    end
    --- func desc
    ---@param v any
    self.RemoveFuel = function(v)
        local num = ig.check.Number(v, 0, 100)
        self.SetFuel((self.GetFuel() - num))
        self.Fuel = self.GetFuel()
        self.State.Fuel = self.Fuel
        if self.GetFuel() <= 0 then
            self.SetFuel(0)
            self.Fuel = 0
            self.State.Fuel = 0
        end
        self.SetUpdated()
    end
    --- func desc
    self.GetGarage = function()
        return self.Garage
    end
    --- func desc
    self.SetGarage = function(v)
        local str = ig.check.String(v)
        self.Garage = str
        self.SetUpdated()
    end
    --- func desc
    self.GetOwner = function()
        return self.Owner
    end
    --- func desc
    self.SetOwner = function(id)
        self.Owner = id
        self.SetUpdated()
    end
    --- func desc
    self.GetWanted = function()
        return self.Wanted
    end
    --
    --- func desc
    self.GetWeight = function()
        self.Weight = 0
        for _, v in pairs(self.Inventory) do
            if ig.item.Exists(v.Item) then
                local item = ig.items[v.Item]
                self.Weight = self.Weight + item.Weight
            else
                ig.func.Debug_1("Ignoring invalid item within .GetWeight()")
            end
        end
        return self.Weight
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        -- Use unified validation function (no source for vehicles)
        local processed, valid, error = ig.validation.ValidateAndUnpack(nil, inv)
        
        if not valid then
            ig.func.Debug_1("Error unpacking vehicle inventory: " .. (error or "unknown"))
            self.Inventory = {}
            return
        end
        
        self.Inventory = processed
    end
    --- func desc
    self.GetInventory = function()
        return self.Inventory
    end
    --- func desc
    ---@param name any
    self.HasItem = function(name)
        for k, v in ipairs(self.Inventory) do
            if v.Item == name then
                return true, k
            end
        end
        return false, nil
    end
    --
    --- [Internal] func desc
    ---@param v table "Must contain a minimum of a name string at point 1 {\"Cash\"}"
    self.SteralizeItem = function(v)
        if type(v) ~= "table" then
            ig.func
                .Debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Vehicle ID: " .. self.Net)
            return
        end
        local info = {
            ["Item"] = ig.check.String(v[1]), -- string
            ["Quantity"] = ig.check.Number((v[2] or ig.items[v[1]].Quantity)), -- number/int >= 1
            ["Quality"] = ig.check.Number((v[3] or ig.items[v[1]].Quality)), -- number/int >= 1 <= 100
            ["Weapon"] = (v[4] or ig.items[v[1]].Weapon),
            ["Meta"] = (v[5] or ig.items[v[1]].Meta),
            ["Name"] = (v[6] or ig.items[v[1]].Name)
        }
        return info
    end
    --
    --- func desc
    ---@param add table "Array Format {\"Name\", 1, math.random(65,100), (String or false), {}}"
    self.AddItem = function(tbl)
        local item = self.SteralizeItem(tbl)
        if ig.item.Exists(item.Item) then
            local weapon = ig.item.IsWeapon(item.Item)
            local stackable = ig.item.CanStack(item.Item)
            local has, key = self.HasItem(item.Item)
            if (weapon and type(item.Weapon) == "string") or (not stackable) then
                self.Inventory[#self.Inventory + 1] = item
            elseif (stackable and has) then
                self.Inventory[key].Quantity = self.Inventory[key].Quantity + item.Quantity
            else
                self.Inventory[#self.Inventory + 1] = item
            end
        else
            ig.func.Debug_1("Ignoring invalid .AddItem() for Vehicle ID: " .. self.Net)
        end
    end
    --
    self.GetItemFromPosition = function(position)
        local position = tonumber(position)
        if self.Inventory[position] then
            return self.Inventory[position]
        else
            return false
        end
    end
    --
    self.GetItemMeta = function(position)
        local position = tonumber(position)
        if self.Inventory[position] then
            return self.Inventory[position].Meta
        else
            return false
        end
    end
    --
    self.GetItemData = function(position)
        local position = tonumber(position)
        if self.Inventory[position] then
            return self.Inventory[position].Data
        else
            return false
        end
    end
    --
    self.GetItemQuality = function(name)
        local has, position = self.HasItem(name)
        if has then
            return self.Inventory[position].Quality, position
        else
            return false
        end
    end
    --
    self.GetItemQuantity = function(name)
        local has, position = self.HasItem(name)
        if has then
            return self.Inventory[position].Quantity, position
        else
            return false, false
        end
    end
    --- func desc
    ---@param name any
    ---@param slot any
    self.RemoveItem = function(name, slot)
        local quantity, position = self.GetItemQuantity(name)
        if quantity >= 2 then
            self.Inventory[position].Quantity = self.Inventory[position].Quantity - 1
        elseif quantity <= 1 and slot == position then
            table.remove(self.Inventory, position)
        else
            table.remove(self.Inventory, position)
        end
    end
    --- func desc
    ---@param new any
    ---@param old any
    self.RearrangeItems = function(new, old)
        table.insert(self.Inventory, new, table.remove(self.Inventory, old))
    end
    --- func desc
    self.CompressInventory = function()
        local inv = {}
        for i = 1, #self.Inventory do
            inv[i] = {self.Inventory[i].Item, self.Inventory[i].Quantity, self.Inventory[i].Quality,
                      self.Inventory[i].Weapon, self.Inventory[i].Meta, self.Inventory[i].Name}
        end
        return inv
    end
    -- ====================================================================================--
    -- Dirty Flag Helper Methods
    -- ====================================================================================--
    self.GetIsDirty = function()
        return self.IsDirty
    end
    --
    self.ClearDirty = function()
        self.IsDirty = false
        self.DirtyFields = {}
    end
    --
    self.MarkDirty = function(fieldName)
        self.IsDirty = true
        self.DirtyFields[fieldName] = true
    end
    --
    -- ====================================================================================--
    -- Cached JSON Encoding Methods
    -- ====================================================================================--
    self.GetEncodedInventory = function()
        if not self.EncodedInventory or self.DirtyFields.Inventory then
            self.EncodedInventory = json.encode(self.CompressInventory())
            self.DirtyFields.Inventory = false
        end
        return self.EncodedInventory
    end
    --
    self.GetEncodedCondition = function()
        if not self.EncodedCondition or self.DirtyFields.Condition then
            self.EncodedCondition = json.encode(self.GetCondition())
            self.DirtyFields.Condition = false
        end
        return self.EncodedCondition
    end
    --
    self.GetEncodedModifications = function()
        if not self.EncodedModifications or self.DirtyFields.Modifications then
            self.EncodedModifications = json.encode(self.GetModifications())
            self.DirtyFields.Modifications = false
        end
        return self.EncodedModifications
    end
    --
    self.GetEncodedKeys = function()
        if not self.EncodedKeys or self.DirtyFields.Keys then
            self.EncodedKeys = json.encode(self.GetKeys())
            self.DirtyFields.Keys = false
        end
        return self.EncodedKeys
    end
    --
    self.GetEncodedCoords = function()
        -- Coords don't have a dedicated cache field, encode fresh each time
        return json.encode(self.GetCoords())
    end
    --
    -- ====================================================================================--
    SetVehicleNumberPlateText(self.Entity, self.Plate) 
    self.UnpackInventory(self.Inventory)
    self.HasSpawned()
    -- ====================================================================================--
    return self
end