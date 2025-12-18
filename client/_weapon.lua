-- ====================================================================================--
-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
ig.weapon = {}
-- _weapons.lua
ig._weapon = nil
ig._weaponname = nil
ig._components = nil
-- ====================================================================================--

function ig.weapon.Get()
    return ig._weapon
end

function ig.weapon.GetComponents()
    return ig._components
end

function ig.weapon.GetName()
    return ig._weaponname
end