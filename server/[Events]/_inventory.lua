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
        if c.item[v].weapon == true then
            TriggerClientCallback({
                source = src,
                eventName = "Client:Equip:Weapon",
                args = {v}
            })
        end
        --
        
    end)
end