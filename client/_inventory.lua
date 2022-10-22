-- ====================================================================================--
-- gets triggered via ig.nui to set the pulled current contents, then this can be used to confirm if items exist prior to menu activations.
c.inventory = {} -- functions
c._inventory = {}

-- ====================================================================================--

AddEventHandler("Client:Character:SetInventory", function(inv)
    c._inventory = inv
end)

exports("GetInventory", function()
    return c._inventory
end)

-- ====================================================================================--

--- func desc
function c.inventory.GetWeight()
    c.inventory.Weight = 0
    for _, v in pairs(c._inventory) do
        if c.item.Exists(v.Item) then
            local item = c.items[v.Item]
            c.inventory.Weight = c.inventory.Weight + item.Weight
        else
            c.func.Debug_1("Ignoring invalid item within .GetWeight()")
        end
    end
    return c.inventory.Weight
end
--- func desc
function c.inventory.GetInventory()
    return c._inventory
end
--- func desc
---@param name any
function c.inventory.HasItem(name)
    for k, v in ipairs(c._inventory) do
        if v.Item == name then
            return true, k
        end
    end
    return false, nil
end
--
--
function c.inventory.GetItemFromPosition(position)
    local position = tonumber(position)
    if c._inventory[position] then
        return c._inventory[position]
    else
        return false
    end
end
--
function c.inventory.GetItemMeta(position)
    local position = tonumber(position)
    if c._inventory[position] then
        return c._inventory[position].Meta
    else
        return false
    end
end
--
function c.inventory.GetItemData(position)
    local position = tonumber(position)
    if c._inventory[position] then
        return c._inventory[position].Data
    else
        return false
    end
end
--
function c.inventory.GetItemQuality(name)
    local has, position = c.inventory.HasItem(name)
    if has then
        return c._inventory[position].Quality, position
    else
        return 0, false
    end
end
--
function c.inventory.GetItemQuantity(name)
    local has, position = c.inventory.HasItem(name)
    if has then
        return c._inventory[position].Quantity, position
    else
        return 0, false
    end
end
