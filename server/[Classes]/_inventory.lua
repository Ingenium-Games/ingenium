-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
--[[
NOTES.
    - Probably going to have to meta table this shit...
    
    EXAMPLE: 
    
    Inventory from DB: 
    {1:{"item", 1, 100, false, {metadata}}, 2:false, 3:{"item", 1, 100, "-12321321", {metadata}}, 4:false, 5:{"item"}}
    
    
    Slot 1, has a quntity of 1 and has 100 quality and is not a weapon.
    Slot 2 is empty
    Slot 3 has, a quantity of 1, quality of 100, and is a weapon based on its hash, with metadata about it after.

]] --


-- ====================================================================================--

function c.class.CreateInventory(inv)
    local self = {}
        for i=1, #inv do
            table.insert(self, i)
            self[i] = {
                ["Item"] = v[1],
                ["Quantity"] = v[2],
                ["Quality"] = v[3],
                ["Weapon"] = v[4],
                ["Meta"] = v[5]
            }
            -- If it is a weapon, does it have more than one in a stack? Or Does it not list itself as a weapon
            if self[k].Weapon == true then
                if type(c.item.IsWeapon(self[k].Item)) ~= "string" or self[k].Quantity >= 1 then
                    c.debug_1("Error in Creating Inventory, Weapon quanity or wepaon flag is broken.")
                    break
                end
            end
            -- Validate Meta data
            if type(self[k].Quantity) ~= "number" or type(self[k].Quality) ~= "number" then
                c.debug_1("Error in Creating Inventory, Quantity or Quality is not a number.")
                break
            end
            -- Validate Meta data
            if type(self[k].Meta) ~= "table" or self[k].Meta ~= false then
                c.debug_1("Error in Creating Inventory, Meta data is not false or a table.")
                break
            end
            -- If the Quality is below 0, then destroy the item.
            if self[k].Quality <= 0 then
                table.remove(self, k)
            end
        end
    return self
end