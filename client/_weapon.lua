-- ====================================================================================--

-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
c.weapon = {}
-- _weapons.lua
c._weapon = nil
c._weaponname = nil
c._components = nil

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