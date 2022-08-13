-- ====================================================================================--


-- ====================================================================================--
--  Get Character Info for the NUI to allow character selection.
-- [C+S]
for k,v in pairs (c.items) do
    AddEventHandler(("Inventory:Consume:%s"):format(k), function(source, position, quantity) 
        print(source, position, quantity)
        local src = source
        local position = position
        local quantity = quantity or 1
        local xPlayer = c.data.GetPlayer(src)
        --
        if c.item.IsWeapon(k) then
            --
            local ammo = xPlayer.GetAmmo()
            local item = xPlayer.GetItemFromPosition(position)
            local hash = item.Weapon
            local components = item.Meta.Components
            local ammotype = item.Meta.Ammo            
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Weapon",
                args = {k, ammo, ammotype, hash, components}
            })
            --
            return
        end
        --
        if c.item.IsConsumeable(k) then
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Consumeable",
                args = {k}
            })
            --
            xPlayer.RemoveItem(k, position)
            return
        end
        --
    end)
end