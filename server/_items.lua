-- ====================================================================================--
ig.item = {} -- function level
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