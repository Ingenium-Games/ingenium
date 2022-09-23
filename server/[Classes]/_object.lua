-- ====================================================================================--
if not c.class then
    c.class = {}
end
-- ====================================================================================--
local function GetObj(id)
    if type(id) == "string" then
        return c.sql.GetObjectByName(id)
    else
        return {
            Fuel = math.random(25, 89),
            Keys = "{}",
            Inventory = "{}",
            Condition = "{}",
            Modifications = "{}",
            Instance = false,
            Garage = false,
            Status = false,
            Impound = false,
            Owner = false,
            Wanted = false
        }
    end
end
--- func desc
---@param net any
function c.class.Object(net, id)
    local data = GetObj(id)
    local self = {}
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    -- Model (hash)
    self.Model = GetEntityModel(self.Entity)
    self.State.Model = self.Model
    self.Weight = 0
    -- Inventory
    self.Inventory = json.decode(data.Inventory)

    --- func desc
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end
    --- func desc
    self.GetModel = function()
        return self.Model
    end
    --- func desc
    self.GetCoords = function()
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
    self.SetCoords = function(t)
        self.Coords = {
            x = c.math.Decimals(t.x, 2),
            y = c.math.Decimals(t.y, 2),
            z = c.math.Decimals(t.z, 2),
            h = c.math.Decimals(t.h, 2)
        }
    end
    --
    --- func desc
    self.GetWeight = function()
        self.Weight = 0
        for _, v in pairs(self.Inventory) do
            if c.item.Exists(v.Item) then
                local item = c.items[v.Item]
                self.Weight = self.Weight + item.Weight
            else
                c.func.Debug_1("Ignoring invalid item within .GetWeight()")
            end
        end
        return self.Weight
    end
    --- func desc
    ---@param inv any
    self.UnpackInventory = function(inv)
        local inv = inv or {}
        -- print(c.table.Dump(inv))
        self.Inventory = {}
        for i = 1, #inv do
            self.Inventory[i] = {
                ["Item"] = inv[i]["Item"] or inv[i][1],
                ["Quantity"] = inv[i]["Quantity"] or inv[i][2],
                ["Quality"] = inv[i]["Quality"] or inv[i][3],
                ["Weapon"] = inv[i]["Weapon"] or inv[i][4],
                ["Meta"] = inv[i]["Meta"] or inv[i][5],
                ["Name"] = inv[i]["Name"] or inv[i][6]
            }
            -- If it is a weapon, does it have more than one in a stack? Or Does it not list itself as a weapon
            if self.Inventory[i].Weapon == true then
                if type(c.item.IsWeapon(self.Inventory[i].Item)) ~= "string" or self.Inventory[i].Quantity >= 1 then
                    c.func.Debug_1("Error in Creating Inventory, Weapon quanity or wepaon flag is broken.")
                    break
                end
            end
            -- Validate Quuality and Quantity are numbers.
            if type(self.Inventory[i].Quantity) ~= "number" or type(self.Inventory[i].Quality) ~= "number" then
                c.func.Debug_1("Error in Creating Inventory, Quantity or Quality is not a number.")
                break
            end
            -- If the Quality is below 0, then destroy the item.
            if self.Inventory[i].Quality <= 0 then
                table.remove(self.Inventory, i)
            end
        end
        self.GetWeight()
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
            c.func.Debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Object : " .. self.Net)
            return
        end
        local info = {
            ["Item"] = c.check.String(v[1]), -- string
            ["Quantity"] = c.check.Number((v[2] or c.items[v[1]].Quantity)), -- number/int >= 1
            ["Quality"] = c.check.Number((v[3] or c.items[v[1]].Quality)), -- number/int >= 1 <= 100
            ["Weapon"] = (v[4] or c.items[v[1]].Weapon),
            ["Meta"] = (v[5] or c.items[v[1]].Meta),
            ["Name"] = (v[6] or c.items[v[1]].Name)
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
            elseif (stackable and has) then
                self.Inventory[key].Quantity = self.Inventory[key].Quantity + item.Quantity
            else
                self.Inventory[#self.Inventory + 1] = item
            end
        else
            c.func.Debug_1("Ignoring invalid .AddItem() for Object : " .. self.Net)
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
    --
    self.ConsumeItem = function(number)
        local item = self.GetItemFromPosition(number)
        if type(item) ~= "boolean" then
            TriggerEvent("Inventory:Consume:" .. item.Item, self.ID, item.Quantity, number)
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
    self.UnpackInventory(self.Inventory)
    -- ====================================================================================--
    return self
end
