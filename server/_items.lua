-- ====================================================================================--

c.item = {} -- function level

-- ====================================================================================--

--- func desc
---@param . any
function c.item.GetItems()
    return c.items
end

--- func desc
---@param name any
function c.item.Exists(name)
    if c.items[name] then
        return true
    else
        return false
    end
end

--- func desc
---@param name any
function c.item.GetItem(name)
    if c.item.Exists(name) then
        return c.items[name]
    end 
end

--- 
---@param name any
function c.item.IsConsumeable(name)
    return c.items[name].Consumeable
end

--- func desc
---@param name any
function c.item.IsCraftable(name)
    return c.items[name].Craftable
end

--- func desc
---@param name any
function c.item.IsWeapon(name)
    return c.items[name].Weapon
end

--- func desc
---@param name any
function c.item.GetWeaponAmmoType(name)
    return c.items[name].Meta.Ammo
end

--- func desc
---@param name any
function c.item.GetAbout(name)
    return c.items[name].Meta.About
end

--- func desc
---@param name any
function c.item.CanDegrade(name)
    return c.items[name].Degrade
end

--- func desc
---@param name any
function c.item.CanStack(name)
    return c.items[name].Stackable
end

--- func desc
---@param name any
function c.item.CanHotkey(name)
    return c.items[name].Hotkey
end

--- func desc
---@param name any
function c.item.GetMeta(name)
    return c.items[name].Meta
end

--- func desc
---@param name any
function c.item.GetData(name)
    return c.items[name].Data
end

--- func desc
---@param name any
function c.item.GetValue(name)
    return c.items[name].Value
end

--- func desc
---@param name any
function c.item.ReturnPosition(name)
    for k,v in ipairs(c.items) do
        if v == name then
            return k
        end
    end
    return false
end