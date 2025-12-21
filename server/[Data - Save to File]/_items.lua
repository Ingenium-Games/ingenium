--  To create json creator on web tool to enable users to create items.

-- ====================================================================================--
ig.item = {} -- function level
ig.items = {}
-- ====================================================================================--

--- func desc
---@param . any
function ig.item.GetItems()
    return ig.items
end

--- func desc
---@param name any
function ig.item.Exists(name)
    if ig.items[name] then
        return true
    else
        return false
    end
end

--- func desc
---@param name any
function ig.item.GetItem(name)
    if ig.item.Exists(name) then
        return ig.items[name]
    end 
end

--- 
---@param name any
function ig.item.IsConsumeable(name)
    return ig.items[name].Consumeable
end

--- func desc
---@param name any
function ig.item.IsCraftable(name)
    return ig.items[name].Craftable
end

--- func desc
---@param name any
function ig.item.IsWeapon(name)
    return ig.items[name].Weapon
end

--- func desc
---@param name any
function ig.item.GetWeaponAmmoType(name)
    return ig.items[name].Meta.Ammo
end

--- func desc
---@param name any
function ig.item.GetAbout(name)
    return ig.items[name].Meta.About
end

--- func desc
---@param name any
function ig.item.CanDegrade(name)
    return ig.items[name].Degrade
end

--- func desc
---@param name any
function ig.item.CanStack(name)
    return ig.items[name].Stackable
end

--- func desc
---@param name any
function ig.item.CanHotkey(name)
    return ig.items[name].Hotkey
end

--- func desc
---@param name any
function ig.item.GetMeta(name)
    return ig.items[name].Meta
end

--- func desc
---@param name any
function ig.item.GetData(name)
    return ig.items[name].Data
end

--- func desc
---@param name any
function ig.item.GetValue(name)
    return ig.items[name].Value
end

--- func desc
---@param name any
function ig.item.ReturnPosition(name)
    for k,v in ipairs(ig.items) do
        if v == name then
            return k
        end
    end
    return false
end

-- ====================================================================================--
-- Enhanced Item Helper Functions
-- ====================================================================================--

---Get all items
---@return table All items
function ig.item.GetAll()
    return ig.items
end

---Get item by name
---@param name string Item name
---@return table|nil Item data or nil
function ig.item.GetByName(name)
    return ig.items[name]
end

---Get items by category
---@param category string Category name (e.g., "weapon", "consumable", "tool")
---@return table Array of items
function ig.item.GetByCategory(category)
    local result = {}
    for name, item in pairs(ig.items) do
        if item.Category == category then
            table.insert(result, item)
        end
    end
    return result
end

---Get craftable items
---@return table Array of craftable items
function ig.item.GetCraftable()
    local result = {}
    for name, item in pairs(ig.items) do
        if item.Craftable then
            table.insert(result, item)
        end
    end
    return result
end

---Get all weapons
---@return table Array of weapon items
function ig.item.GetWeapons()
    local result = {}
    for name, item in pairs(ig.items) do
        if item.Weapon then
            table.insert(result, item)
        end
    end
    return result
end

---Get all consumables
---@return table Array of consumable items
function ig.item.GetConsumables()
    local result = {}
    for name, item in pairs(ig.items) do
        if item.Consumeable then
            table.insert(result, item)
        end
    end
    return result
end

---Get items that can degrade
---@return table Array of degradable items
function ig.item.GetDegradable()
    local result = {}
    for name, item in pairs(ig.items) do
        if item.Degrade then
            table.insert(result, item)
        end
    end
    return result
end

---Get items by weight range
---@param minWeight number Minimum weight
---@param maxWeight number Maximum weight
---@return table Array of items in weight range
function ig.item.GetByWeightRange(minWeight, maxWeight)
    local result = {}
    for name, item in pairs(ig.items) do
        if item.Weight >= minWeight and item.Weight <= maxWeight then
            table.insert(result, item)
        end
    end
    return result
end

---Get items by value range
---@param minValue number Minimum value
---@param maxValue number Maximum value
---@return table Array of items in value range
function ig.item.GetByValueRange(minValue, maxValue)
    local result = {}
    for name, item in pairs(ig.items) do
        if item.Value >= minValue and item.Value <= maxValue then
            table.insert(result, item)
        end
    end
    return result
end

---Check if item requires license
---@param name string Item name
---@return boolean True if license required
function ig.item.RequiresLicense(name)
    local item = ig.items[name]
    return item and item.Meta and item.Meta.RequiresLicense or false
end

---Get item weight
---@param name string Item name
---@return number Weight or 0 if not found
function ig.item.GetWeight(name)
    local item = ig.items[name]
    return item and item.Weight or 0
end

---Get item label/display name
---@param name string Item name
---@return string Label or item name
function ig.item.GetLabel(name)
    local item = ig.items[name]
    return item and item.Name or name
end

---Get item description
---@param name string Item name
---@return string Description or empty string
function ig.item.GetDescription(name)
    local item = ig.items[name]
    return item and item.Meta and item.Meta.About or ""
end

---Get recipe for craftable item
---@param name string Item name
---@return table|nil Recipe data or nil
function ig.item.GetRecipe(name)
    local item = ig.items[name]
    if item and item.Craftable and item.Meta and item.Meta.Recipe then
        return item.Meta.Recipe
    end
    return nil
end

---Check if player has required items for crafting
---@param xPlayer table Player object
---@param itemName string Item to craft
---@return boolean, table True if has materials, or false with missing items
function ig.item.CanCraft(xPlayer, itemName)
    local recipe = ig.item.GetRecipe(itemName)
    if not recipe then
        return false, {"No recipe found"}
    end
    
    local missing = {}
    for ingredient, quantity in pairs(recipe) do
        local hasQty = xPlayer.GetItemQuantity(ingredient)
        if hasQty < quantity then
            table.insert(missing, {item = ingredient, need = quantity, have = hasQty})
        end
    end
    
    return #missing == 0, missing
end

---Search items by name pattern
---@param pattern string Search pattern
---@return table Array of matching items
function ig.item.Search(pattern)
    local result = {}
    local lowerPattern = pattern:lower()
    
    for name, item in pairs(ig.items) do
        if name:lower():find(lowerPattern) or 
           (item.Name and item.Name:lower():find(lowerPattern)) then
            table.insert(result, {name = name, data = item})
        end
    end
    
    return result
end

---Get item stack size
---@param name string Item name
---@return number Stack size (1 if not stackable)
function ig.item.GetStackSize(name)
    local item = ig.items[name]
    if not item then return 1 end
    
    if not item.Stackable then return 1 end
    
    -- If weapon, never stack
    if item.Weapon then return 1 end
    
    -- Check for custom stack size in meta
    if item.Meta and item.Meta.MaxStack then
        return item.Meta.MaxStack
    end
    
    -- Default: unlimited stacking for stackable items
    return 999999
end

---Get total count of an item across all inventories
---@param itemName string Item name
---@return number Total count in economy
function ig.item.GetTotalInEconomy(itemName)
    local total = 0
    
    -- Count in player inventories
    for _, xPlayer in pairs(ig.pdex or {}) do
        if xPlayer then
            total = total + (xPlayer.GetItemQuantity(itemName) or 0)
        end
    end
    
    -- Count in vehicle inventories
    for _, xVehicle in pairs(ig.vdex or {}) do
        if xVehicle then
            total = total + (xVehicle.GetItemQuantity(itemName) or 0)
        end
    end
    
    -- Count in drops
    for _, drop in pairs(ig.drops or {}) do
        if drop and drop.Inventory then
            for _, slot in ipairs(drop.Inventory) do
                if slot[1] == itemName or slot.Item == itemName then
                    total = total + (slot[2] or slot.Quantity or 0)
                end
            end
        end
    end
    
    -- Count in job inventories
    for _, xJob in pairs(ig.jdex or {}) do
        if xJob then
            total = total + (xJob.GetItemQuantity(itemName) or 0)
        end
    end
    
    return total
end

---Validate item data structure
---@param itemData table Item data to validate
---@return boolean, string True if valid, or false with error message
function ig.item.ValidateItemData(itemData)
    if type(itemData) ~= "table" then
        return false, "Item data must be a table"
    end
    
    -- Required fields
    if not itemData.Name or type(itemData.Name) ~= "string" then
        return false, "Missing or invalid Name field"
    end
    
    if not itemData.Value or type(itemData.Value) ~= "number" then
        return false, "Missing or invalid Value field"
    end
    
    if not itemData.Weight or type(itemData.Weight) ~= "number" then
        return false, "Missing or invalid Weight field"
    end
    
    -- Boolean fields
    local boolFields = {"Weapon", "Consumeable", "Stackable", "Craftable", "Degrade", "Hotkey"}
    for _, field in ipairs(boolFields) do
        if itemData[field] ~= nil and type(itemData[field]) ~= "boolean" then
            return false, field .. " must be boolean"
        end
    end
    
    return true, "Valid"
end

-- ====================================================================================--
--- [Internal] Server Side Only, used in combination with callbacks
function ig.item.GenerateConsumptionEvents()
for k,v in pairs (ig.items) do
    AddEventHandler(("Inventory:Consume:%s"):format(k), function(source, position, quantity) 
        local src = source
        local position = position
        local quantity = quantity or 1
        local xPlayer = ig.data.GetPlayer(src)
        --
        if ig.item.IsWeapon(k) then
            --
            local item = ig.item.GetItem(k)
            local ammotype = item.Meta.Ammo     
            local hash = item.Weapon

            -- Components to load from inv item not data table
            local components = item.Meta.Components
                   
            local ammo = xPlayer.GetAmmo(ammotype)
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Weapon",
                args = {k, ammo, ammotype, hash, components}
            })
            --
            return
        end
        --
        if ig.item.IsConsumeable(k) then
            --
            xPlayer.RemoveItem(k, position)
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Consumeable",
                args = {k}
            })
            return
        end
        --
        if k == "Package" then
            -- Get the item inside the pacakge
            local item = xPlayer.GetItemFromPosition(position)
            local content = item.Meta.Contents
            local name = k
            local Meta
            -- If Weapon add meta
            if ig.item.IsWeapon(content) then
                Meta = {
                    Ammo = ig.item.GetWeaponAmmoType(content),
                    Components = {},
                    SerialNumber = ig.rng.chars(6),
                    BatchNumber = ig.rng.nums(10),
                    Crafted = false,
                    Registered = true,
                    About = ig.item.GetAbout(content)
                }
            end
            -- if consumeable get meta
            if ig.item.IsConsumeable(content) then
                Meta = ig.item.GetMeta()
            end
            --
            xPlayer.RemoveItem(k, position)
            xPlayer.AddItem({content,1,100,ig.item.IsWeapon(content),(Meta or false)})
            return
        end
        --
        if k == "Skateboard" then
            -- Get the item inside the pacakge
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Skateboard",
                args = {}
            })
            return
        end

        if k == "Phone" then
            -- Get the item inside the pacakge
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Phone",
                args = {}
            })
            return
        end

        if k == "FishingRod" then
            TriggerClientEvent('wasabi_fishing:startFishing', src)
            return
        end
        
    end)
end
end