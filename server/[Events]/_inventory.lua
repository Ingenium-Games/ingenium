-- ====================================================================================--
--- [Internal] Server Side Only, used in combination with callbacks
for k,v in pairs (ig.items) do
    AddEventHandler(("Inventory:Consume:%s"):format(k), function(source, position, quantity) 
        local src = source
        local position = position
        local quantity = quantity or 1
        local xPlayer = ig.data.GetPlayer(src)
        --
        if ig.item.IsWeapon(k) then
            --
            local item = ig.item.GetItem(k)
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
        if ig.item.IsConsumeable(k) then
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
            if ig.item.IsWeapon(content) then
                Meta = {
                    Ammo = ig.item.GetWeaponAmmoType(content),
                    Components = {},
                    SerialNumber = ig.rng.chars(6),
                    BatchNumber = ig.rng.nums(10),
                    Crafted = false,
                    Registered = true,
                    About = ig.item.GetAbout(content)
                }
            end
            -- if consumeable get meta
            if ig.item.IsConsumeable(content) then
                Meta = ig.item.GetMeta()
            end
            --
            xPlayer.RemoveItem(k, position)
            xPlayer.AddItem({content,1,100,ig.item.IsWeapon(content),(Meta or false)})
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

        if k == "Phone" then
            -- Get the item inside the pacakge
            --
            TriggerClientCallback({
                source = src,
                eventName = "Client:Item:Phone",
                args = {}
            })
            return
        end

        if k == "FishingRod" then
            TriggerClientEvent('wasabi_fishing:startFishing', src)
            return
        end
        
    end)
end