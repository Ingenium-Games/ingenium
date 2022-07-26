-- ====================================================================================--


-- ====================================================================================--
--  Get Character Info for the NUI to allow character selection.
-- [C+S]
for k,v in pairs (c.items) do
    AddEventHandler(("Inventory:Consume:%s"):format(v), function(source, position, quantity) 
        local src = source
        local position = position
        local quantity = quantity or 1
        local xPlayer = c.data.GetPlayer(src)
        --
        if c.item.IsWeapon() then
            -- client should have this data as its provided on loading in, leaving as local var for now to test
            local meta = c.item.GetMeta()
            local data = c.item.GetData()
            -- To Do
            -- Ammo Count as item find callback
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Weapon",
                args = {Name = v, Meta = meta, Data = data}
            })
            return
        end
        --
        if c.item.IsConsumeable() then
            -- client should have this data as its provided on loading in, leaving as local var for now to test
            local meta = c.item.GetMeta()
            local data = c.item.GetData()
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Consumeable",
                args = {Name = v, Meta = meta, Data = data}
            })
            xPlayer.RemoveItem(v, position)
            return
        end
        --
    end)
end