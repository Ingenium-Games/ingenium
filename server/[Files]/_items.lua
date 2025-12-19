-- ====================================================================================--
ig.item = {} -- function level
ig.items = {}
-- ====================================================================================--

--- func desc
---@param . any
function ig.item.GetItems()
    return ig.items
end

--- func desc
---@param name any
function ig.item.Exists(name)
    if ig.items[name] then
        return true
    else
        return false
    end
end

--- func desc
---@param name any
function ig.item.GetItem(name)
    if ig.item.Exists(name) then
        return ig.items[name]
    end 
end

--- 
---@param name any
function ig.item.IsConsumeable(name)
    return ig.items[name].Consumeable
end

--- func desc
---@param name any
function ig.item.IsCraftable(name)
    return ig.items[name].Craftable
end

--- func desc
---@param name any
function ig.item.IsWeapon(name)
    return ig.items[name].Weapon
end

--- func desc
---@param name any
function ig.item.GetWeaponAmmoType(name)
    return ig.items[name].Meta.Ammo
end

--- func desc
---@param name any
function ig.item.GetAbout(name)
    return ig.items[name].Meta.About
end

--- func desc
---@param name any
function ig.item.CanDegrade(name)
    return ig.items[name].Degrade
end

--- func desc
---@param name any
function ig.item.CanStack(name)
    return ig.items[name].Stackable
end

--- func desc
---@param name any
function ig.item.CanHotkey(name)
    return ig.items[name].Hotkey
end

--- func desc
---@param name any
function ig.item.GetMeta(name)
    return ig.items[name].Meta
end

--- func desc
---@param name any
function ig.item.GetData(name)
    return ig.items[name].Data
end

--- func desc
---@param name any
function ig.item.GetValue(name)
    return ig.items[name].Value
end

--- func desc
---@param name any
function ig.item.ReturnPosition(name)
    for k,v in ipairs(ig.items) do
        if v == name then
            return k
        end
    end
    return false
end

-- ====================================================================================--
--- [Internal] Server Side Only, used in combination with callbacks
function ig.item.GenerateConsumptionEvents()
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
end