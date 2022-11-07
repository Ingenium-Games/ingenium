-- ====================================================================================--
--- [Internal] Server Side Only, used in combination with callbacks
for k,v in pairs (c.items) do
    AddEventHandler(("Inventory:Consume:%s"):format(k), function(source, position, quantity) 
        local src = source
        local position = position
        local quantity = quantity or 1
        local xPlayer = c.data.GetPlayer(src)
        --
        if c.item.IsWeapon(k) then
            --
            local item = c.item.GetItem(k)
            local ammotype = item.Meta.Ammo     
            local hash = item.Weapon

            -- Components to load from inv item not data table
            local components = item.Meta.Components
                   
            local ammo = xPlayer.GetAmmo(ammotype)
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
            xPlayer.RemoveItem(k, position)
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Consumeable",
                args = {k}
            })
            return
        end
        --
        if k == "Package" then
            -- Get the item inside the pacakge
            local item = xPlayer.GetItemFromPosition(position)
            local content = item.Meta.Contents
            local name = k
            local Meta
            -- If Weapon add meta
            if c.item.IsWeapon(content) then
                Meta = {
                    Ammo = c.item.GetWeaponAmmoType(content),
                    Components = {},
                    SerialNumber = c.rng.chars(6),
                    BatchNumber = c.rng.nums(10),
                    Crafted = false,
                    Registered = true,
                    About = c.item.GetAbout(content)
                }
            end
            -- if consumeable get meta
            if c.item.IsConsumeable(content) then
                Meta = c.item.GetMeta()
            end
            --
            xPlayer.RemoveItem(k, position)
            xPlayer.AddItem({content,1,100,c.item.IsWeapon(content),(Meta or false)})
            return
        end
        --
        if k == "Skateboard" then
            -- Get the item inside the pacakge
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Skateboard",
                args = {}
            })
            return
        end
    end)
end