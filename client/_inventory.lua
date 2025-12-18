-- ====================================================================================--
-- gets triggered via ig.nui to set the pulled current contents, then this can be used to confirm if items exist prior to menu activations.
--
ig.inventory = {} -- functions
ig._inventory = {} -- from server
-- ====================================================================================--
AddEventHandler("Client:Character:SetInventory", function(inv)
    ig._inventory = inv
end)

exports("GetInventory", function()
    return ig._inventory
end)
-- ====================================================================================--

--- func desc
function ig.inventory.GetWeight()
    ig.inventory.Weight = 0
    for _, v in pairs(ig._inventory) do
        if ig.item.Exists(v.Item) then
            local item = ig.items[v.Item]
            ig.inventory.Weight = ig.inventory.Weight + item.Weight
        else
            ig.funig.Debug_1("Ignoring invalid item within .GetWeight()")
        end
    end
    return ig.inventory.Weight
end
--- func desc
function ig.inventory.GetInventory()
    return ig._inventory
end
--- func desc
---@param name any
function ig.inventory.HasItem(name)
    for k, v in ipairs(ig._inventory) do
        if v.Item == name then
            return true, k
        end
    end
    return false, nil
end
--
--
function ig.inventory.GetItemFromPosition(position)
    local position = tonumber(position)
    if ig._inventory[position] then
        return ig._inventory[position]
    else
        return false
    end
end
--
function ig.inventory.GetItemMeta(position)
    local position = tonumber(position)
    if ig._inventory[position] then
        return ig._inventory[position].Meta
    else
        return false
    end
end
--
function ig.inventory.GetItemData(position)
    local position = tonumber(position)
    if ig._inventory[position] then
        return ig._inventory[position].Data
    else
        return false
    end
end
--
function ig.inventory.GetItemQuality(name)
    local has, position = ig.inventory.HasItem(name)
    if has then
        return ig._inventory[position].Quality, position
    else
        return 0, false
    end
end
--
function ig.inventory.GetItemQuantity(name)
    local has, position = ig.inventory.HasItem(name)
    if has then
        return ig._inventory[position].Quantity, position
    else
        return 0, false
    end
end
