-- ====================================================================================--
if not ig.class then
    ig.class = {}
end
-- ====================================================================================--

--

--[[

CREATE TABLE `objects` (
	`ID` INT(11) NOT NULL,
	`UUID` VARCHAR(36) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
    `Model` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Hash ID' COLLATE 'utf8mb4_unicode_ci',
	`Coords` VARCHAR(355) NOT NULL DEFAULT '{"x":0.00,"y":0.00,"z":0.00,"h":0.00}' COLLATE 'utf8mb4_unicode_ci',
	`Inventory` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`Created` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`Updated` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	UNIQUE INDEX `UUID` (`UUID`) USING BTREE,
	INDEX `Created` (`Created`) USING BTREE,
	INDEX `Updated` (`Updated`) USING BTREE,
	INDEX `Character_ID` (`Character_ID`) USING BTREE,
	INDEX `Model` (`Model`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;

]] --

--- func desc
---@wiki:ignore 
---@param net any
function ig.class.ExistingObject(net, data)
    local self = {}
    --
    self.Net = net
    self.Entity = NetworkGetEntityFromNetworkId(net)
    self.State = Entity(self.Entity).state
    -- Model (hash)
    self.Model = data.Model
    self.State.Model = self.Model
    -- Data Sent
    self.UUID = data.UUID
    self.State.UUID = self.UUID
    --
    self.Coords = json.decode(data.Coords)
    self.State.Coords = self.Coords
    --
    self.Inventory = json.decode(data.Inventory)
    self.State.Inventory = self.Inventory
    --
    self.Created = data.Created
    self.State.Created = self.Created
    --
    self.Updated = ig.func.Timestamp()
    self.State.Updated = self.Updated
    --
    self.IsDirty = false
    self.DirtyFields = {}
    --
    -- Cached JSON Encoding for Performance
    self.EncodedInventory = nil
    --
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
        if fieldName then
            self.DirtyFields[fieldName] = true
        end
    end
    --
    self.SetUpdated = function()
        self.Updated = ig.func.Timestamp()
        self.IsDirty = true
    end
    --- func desc
    ---@param return any
    self.GetSource = function()
        return NetworkGetEntityOwner(self.Entity)
    end
        --- func desc
    ---@param return any
    self.GetUUID = function()
        return self.UUID
    end
    --- func desc
    self.GetModel = function()
        return self.Model
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
    ---@param t any
    self.SetCoords = function(t)
        self.Coords = {
            x = ig.math.Decimals(t.x, 2),
            y = ig.math.Decimals(t.y, 2),
            z = ig.math.Decimals(t.z, 2),
            h = ig.math.Decimals(t.h, 2),
            rx = ig.math.Decimals(t.rx, 2),
            ry = ig.math.Decimals(t.ry, 2),
            rz = ig.math.Decimals(t.rz, 2),
        }
        --
        SetEntityCoords(self.Entity, vec3(self.Coords.x, self.Coords.y, self.Coords.z))
        SetEntityHeading(self.Entity, self.Coords.h)
        SetEntityRotation(self.Entity, vec3(self.Coords.rx, self.Coords.ry, self.Coords.rz), 3)
        ---
        self.State.Coords = self.Coords
        self.SetUpdated()
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
        local inv = inv or {}
        -- print(ig.table.Dump(inv))
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
                if type(ig.item.IsWeapon(self.Inventory[i].Item)) ~= "string" or self.Inventory[i].Quantity >= 1 then
                    ig.func.Debug_1("Error in Creating Inventory, Weapon quanity or wepaon flag is broken.")
                    break
                end
            end
            -- Validate Quuality and Quantity are numbers.
            if type(self.Inventory[i].Quantity) ~= "number" or type(self.Inventory[i].Quality) ~= "number" then
                ig.func.Debug_1("Error in Creating Inventory, Quantity or Quality is not a number.")
                break
            end
            -- If the Quality is below 0, then destroy the item.
            if self.Inventory[i].Quality <= 0 then
                table.remove(self.Inventory, i)
            end
        end
    end
    --- func desc
    self.GetInventory = function()
        return self.Inventory
    end
    --- Sync inventory to state bag
    --- NOTE: This method is rarely needed as AddItem, RemoveItem, and RearrangeItems
    --- automatically sync state bags. Use this only if you directly modify self.Inventory
    --- (which is not recommended) or need explicit control over sync timing.
    self.SyncInventory = function()
        self.State.Inventory = self.Inventory
        self.SetUpdated()
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
            ig.func.Debug_1("Ignoring invalid .SteralizeItem() while .AddItem() was called, for Object : " .. self.Net)
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
            ig.func.Debug_1("Ignoring invalid .AddItem() for Object : " .. self.Net)
        end
        self.State.Inventory = self.Inventory
            self.DirtyFields.Inventory = true
            self.EncodedInventory = nil
        self.SetUpdated()
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
        self.State.Inventory = self.Inventory
        self.DirtyFields.Inventory = true
        self.EncodedInventory = nil
        self.SetUpdated()
    end
    --- func desc
    ---@param new any
    ---@param old any
    self.RearrangeItems = function(new, old)
        table.insert(self.Inventory, new, table.remove(self.Inventory, old))
        self.State.Inventory = self.Inventory
        self.DirtyFields.Inventory = true
        self.EncodedInventory = nil
        self.SetUpdated()
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
    self.GetEncodedCoords = function()
        if not self.EncodedCoords or self.DirtyFields.Coords then
            self.EncodedCoords = json.encode(self.GetCoords())
            self.DirtyFields.Coords = false
        end
        return self.EncodedCoords
    end
    --
    -- ====================================================================================--
    self.UnpackInventory(self.Inventory)
    -- ====================================================================================--
    return self
end
