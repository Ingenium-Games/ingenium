-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    - Probably going to have to meta table this shit...
    
    EXAMPLE: 
    
    Inventory from DB: 
    {"item":{ 1, 100, false} , false, "item":{ 1, 100, -12321321:{metadata}}, false, "item":}
    Slot 1, has a quntity of 1 and has 100 quality and is not a weapon.
    Slot 2 is empty
    Slot 3 has, a quantity of 1, quality of 100, and is a weapon based on its hash, with metadata about it after.
    Slot 4 is empty
    Slot 5 is an item.

]] --

math.randomseed(c.Seed)
-- ====================================================================================--

function c.class.CreateInventory(inv)
    local self = {}

    

    return self
end