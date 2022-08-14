-- ====================================================================================--

c.weapon = {}
c._weapon = nil
c._components = nil
-- ====================================================================================--

function c.weapon.Set(hash)
    if hash then
        c._weapon = tonumber(hash)
    else
        c._weapon = nil
    end
end

function c.weapon.Get(type)
    return c._weapon
end

function c.weapon.SetComponents(components)
    c._components = components
end

function c.weapon.GetComponents()
    return c._components
end