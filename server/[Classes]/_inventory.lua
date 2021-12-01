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
                ["Item"] = inv[i][1],
                ["Quantity"] = inv[i][2],
                ["Quality"] = inv[i][3],
                ["Weapon"] = inv[i][4],
                ["Meta"] = inv[i][5]
            }
            -- If it is a weapon, does it have more than one in a stack? Or Does it not list itself as a weapon
            if self[i].Weapon == true then
                if type(c.item.IsWeapon(self[i].Item)) ~= "string" or self[i].Quantity >= 1 then
                    c.debug_1("Error in Creating Inventory, Weapon quanity or wepaon flag is broken.")
                    break
                end
            end
            -- Validate Meta data
            if type(self[i].Quantity) ~= "number" or type(self[i].Quality) ~= "number" then
                c.debug_1("Error in Creating Inventory, Quantity or Quality is not a number.")
                break
            end
            -- Validate Meta data
            if type(self[i].Meta) ~= "table" or type(self[i].Meta) ~= "boolean" then
                c.debug_1("Error in Creating Inventory, Meta data is not false or a table.")
                break
            end
            -- If the Quality is below 0, then destroy the item.
            if self[i].Quality <= 0 then
                table.remove(self, k)
            end
        end
    return self
end