-- ====================================================================================--
-- Item management (ig.item initialized in client/_var.lua)
ig.items = false
-- ====================================================================================--

function ig.item.SetItems(items)
    if not ig.items then
        ig.items = items
    end
end

function ig.item.GetItems()
    return ig.items
end

function ig.item.Exists(name)
    if ig.items[name] then
        return true, name
    else
        for k,v in pairs (ig.items) do
            if v.Item == name then
                return true, k
            end
        end
        return false, ""
    end
end

function ig.item.GetItem(name)
    if ig.item.Exists(name) then
        return ig.items[name]
    end 
end

function ig.item.IsCraftable(name)
    return ig.items[name].Craftable
end

function ig.item.IsWeapon(name)
    return ig.items[name].Weapon
end

function ig.item.GetWeaponAmmoType(name)
    return ig.items[name].Meta.Ammo
end

function ig.item.GetAbout(name)
    return ig.items[name].Meta.About
end

function ig.item.CanDegrade(name)
    return ig.items[name].Degrade
end

function ig.item.CanStack(name)
    return ig.items[name].Stackable
end

function ig.item.CanHotkey(name)
    return ig.items[name].Hotkey
end

function ig.item.GetMeta(name)
    return ig.items[name].Meta
end

function ig.item.GetData(name)
    return ig.items[name].Data
end

--- func desc
---@param name any
function ig.item.GetValue(name)
    return ig.items[name].Value
end


function ig.item.ReturnPosition(name)
    for k,v in ipairs(ig.items) do
        if v == name then
            return k
        end
    end
    return false
end