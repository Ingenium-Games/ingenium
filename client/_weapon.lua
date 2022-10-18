-- ====================================================================================--

-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
c.weapon = {}

-- ====================================================================================--

function c.weapon.Get()
    return c._weapon
end

function c.weapon.GetComponents()
    return c._components
end

function c.weapon.GetName()
    return c._weaponname
end