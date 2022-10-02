--- 
local UseItem = RegisterServerCallback({
    eventName = "UseItem",
    eventCallback = function(source, number)
        local xPlayer = c.data.GetPlayer(source)
        local itemtbl = xPlayer.GetItemFromPosition(number)
        local has, position = xPlayer.HasItem(itemtbl.Item)
        if has then
            xPlayer.ConsumeItem(number)
            return true
        else
            xPlayer.Notify("No Item Found...")
            return false
        end
    end
})
--

local UpdateAmmo = RegisterServerCallback({
    eventName = "UpdateAmmo",
    eventCallback = function(source, ammotype, amount)
        local xPlayer = c.data.GetPlayer(source)
        xPlayer.SetAmmo(tostring(ammotype), tonumber(amount))
    end
})
--

local GiveItem = RegisterServerCallback({
    eventName = "GiveItem",
    eventCallback = function(source, number, target)
        local xPlayer = c.data.GetPlayer(source)
        local itemtbl = xPlayer.GetItemFromPosition(number)

    end
})
--

local DropItem = RegisterServerCallback({
    eventName = "DropItem",
    eventCallback = function(source, number, position)
        local xPlayer = c.data.GetPlayer(source)
        local itemtbl = xPlayer.GetItemFromPosition(number)

    end
})
--

local UseItemQuick = RegisterServerCallback({
    eventName = "UseItemQuick",
    eventCallback = function(source, number)
        local xPlayer = c.data.GetPlayer(source)
        local itemtbl = xPlayer.GetItemFromPosition(number)
        if itemtbl then
            local useable = c.item.CanHotkey(itemtbl.Item)
            if useable then
                xPlayer.ConsumeItem(number)
                return true
            else
                xPlayer.Notify("Item is not useable via quickslot: " .. number)
                return false
            end
        end
        xPlayer.Notify("No Item in Quickslot id: " .. number)
        return false
    end
})
--

local GetItemQuantity = RegisterServerCallback({
    eventName = "GetItemQuantity",
    eventCallback = function(source, item)
        local src = source
        local xPlayer = c.data.GetPlayer(src)
        local quantity, postiion = xPlayer.GetItemQuantity(item)
        return quantity
    end
})

local GetInventory = RegisterServerCallback({
    eventName = "GetInventory",
    eventCallback = function(source, net)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(net)
        local type = GetEntityType(entity)
        -- Is it valid on the server?
        if DoesEntityExist(entity) then
            --
            -- Object
            if type == 3 then
                local xObject = c.data.GetObject(net)
                return xObject.GetInventory()
                --
                -- Vehicle
            elseif type == 2 then
                local xVehicle = c.data.GetVehicle(net)
                return xVehicle.GetInventory()
                --
                -- Ped
            elseif type == 1 then
                if IsPedAPlayer(entity) then
                    if GetPlayerPed(src) == entity then
                        local xPlayer = c.data.GetPlayer(src)
                        return xPlayer.GetInventory()
                    else
                        local xPlayer = c.data.GetPlayer(net)
                        return xPlayer.GetInventory()
                    end
                else
                    -- is an NPC
                    local xNpc = c.data.GetNpc(net)
                    return xNpc.GetInventory()
                end
            end
        end
    end
})
--

local OrganizeInventory = RegisterServerCallback({
    eventName = "OrganizeInventory",
    eventCallback = function(source, net, inv1)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(net)
        local type = GetEntityType(entity)
        -- Is it valid on the server?
        if DoesEntityExist(entity) then
            -- Object
            if type == 3 then
                local xObject = c.data.GetObject(net)
                local size = xObject.GetInventory()
                if #size == #inv1 then
                    xObject.UnpackInventory(inv1)
                else
                    c.func.Eventban(src,
                        "Error in organizing invent, additional items or quanitty found, removed player.")
                end
                --
                -- Vehicle
            elseif type == 2 then
                local xVehicle = c.data.GetVehicle(net)
                local size = xVehicle.GetInventory()
                if #size == #inv1 then
                    xVehicle.UnpackInventory(inv1)
                else
                    c.func.Eventban(src,
                        "Error in organizing invent, additional items or quanitty found, removed player.")
                end
                --
                -- Ped
            elseif type == 1 then
                if IsPedAPlayer(entity) then
                    local xPlayer = c.data.GetPlayer(net)
                    local size = xPlayer.GetInventory()
                    if #size == #inv1 then
                        xPlayer.UnpackInventory(inv1)
                    else
                        c.func.Eventban(src,
                            "Error in organizing invent, additional items or quanitty found, removed player.")
                    end
                else
                    -- is an NPC
                    local xNpc = c.data.GetNpc(net)
                    local size = xNpc.GetInventory()
                    if #size == #inv1 then
                        xNpc.UnpackInventory(inv1)
                    else
                        c.func.Eventban(src,
                            "Error in organizing invent, additional items or quanitty found, removed player.")
                    end
                end
            end

        end
    end
})
--

local OrganizeInventories = RegisterServerCallback({
    eventName = "OrganizeInventories",
    eventCallback = function(source, net, inv1, inv2)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(net)
        local type = GetEntityType(entity)
        -- Is it valid on the server?

            -- Chcek number total prior to unpack.
            local xPlayer = c.data.GetPlayer(src)
            if type == 3 then
                --
                local xObject = c.data.GetObject(net)
                xPlayer.UnpackInventory(inv1)
                xObject.UnpackInventory(inv2)
                --
                -- Vehicle
            elseif type == 2 then
                --
                local xVehicle = c.data.GetVehicle(net)
                xPlayer.UnpackInventory(inv1)
                xVehicle.UnpackInventory(inv2)

                --
                -- Ped
            elseif type == 1 then
                if IsPedAPlayer(entity) then
                    --
                    local xTarget = c.data.GetPlayer(net)
                    xPlayer.UnpackInventory(inv1)
                    xTarget.UnpackInventory(inv2)
                    --
                else
                    --
                    local xNpc = c.data.GetNpc(net)
                    xPlayer.UnpackInventory(inv1)
                    xNpc.UnpackInventory(inv2)
                    --
                end
            end

    end
})
--

