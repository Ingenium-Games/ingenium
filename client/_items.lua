-- ====================================================================================--
c.item = {} -- function level
c.items = false
-- ====================================================================================--

function c.item.SetItems(items)
    if not c.items then
        c.items = items
    end
end

function c.item.GetItems()
    return c.items
end

function c.item.Exists(name)
    if c.items[name] then
        return true, name
    else
        for k,v in pairs (c.items) do
            if v.Item == name then
                return true, k
            end
        end
        return false, ""
    end
end

function c.item.GetItem(name)
    if c.item.Exists(name) then
        return c.items[name]
    end 
end

function c.item.IsCraftable(name)
    return c.items[name].Craftable
end

function c.item.IsWeapon(name)
    return c.items[name].Weapon
end

function c.item.GetWeaponAmmoType(name)
    return c.items[name].Meta.Ammo
end

function c.item.GetAbout(name)
    return c.items[name].Meta.About
end

function c.item.CanDegrade(name)
    return c.items[name].Degrade
end

function c.item.CanStack(name)
    return c.items[name].Stackable
end

function c.item.CanHotkey(name)
    return c.items[name].Hotkey
end

function c.item.GetMeta(name)
    return c.items[name].Meta
end

function c.item.GetData(name)
    return c.items[name].Data
end

--- func desc
---@param name any
function c.item.GetValue(name)
    return c.items[name].Value
end


function c.item.ReturnPosition(name)
    for k,v in ipairs(c.items) do
        if v == name then
            return k
        end
    end
    return false
end