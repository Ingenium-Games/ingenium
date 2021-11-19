-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.item = {} -- function level
--[[
NOTES
    -
]] --
-- ====================================================================================--

function c.item.GetItems()
    return c.items
end

function c.item.Exists(name)
    if c.items[name] then
        return true
    else
        return false
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

function c.item.CanDegrade(name)
    return c.items[name].Degrade
end

function c.item.CanStack(name)
    return c.items[name].Stackable
end

function c.item.ReturnPosition(name)
    for k,v in ipairs(c.items) do
        if v == name then
            return k
        end
    end
    return false
end