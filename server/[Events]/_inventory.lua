-- ====================================================================================--


-- ====================================================================================--
--  Get Character Info for the NUI to allow character selection.
-- [C+S]
for k,v in pairs (c.items) do
    AddEventHandler(("Inventory:Consume:%s"):format(v), function(source, position, quantity) 
        local src = source
        local position = position
        local quantity = quantity or 1
        --
        if c.item[v].Weapon == true then
            -- To Do
            -- Ammo Count as item find callback

            return
        end
        --
        if c.item[v].Consumeable == true then
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Consume",
                args = {Name = v, Quantity = quantity}
            })
            return
        end
        --


        
    end)
end