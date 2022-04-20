-- ====================================================================================--


-- ====================================================================================--
--  Get Character Info for the NUI to allow character selection.
-- [C+S]
for k,v in pairs (c.items) do
    AddEventHandler(("Inventory:Consume:%s"):format(v), function(quantity, position) 
        local src = source
        local quantity = quantity or 1
        local postition = position
        --
        if c.item[v].Weapon == true then
            -- To Do
            -- Ammo Count as item find callback

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