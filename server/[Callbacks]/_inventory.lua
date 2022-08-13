local UseItem = RegisterServerCallback({
    eventName = "UseItem",
    eventCallback = function(source, number)
        local xPlayer = c.data.GetPlayer(source)
        local itemtbl = xPlayer.GetItemFromPosition(number)
        local has, position = xPlayer.HasItem(itemtbl.Item)
        print(has, position)
        if has then
            print("has")
            xPlayer.ConsumeItem(number)
            return true
        else
            xPlayer.Notify("No Item Found...")
            return false
        end
    end
})

local GiveItem = RegisterServerCallback({
    eventName = "GiveItem",
    eventCallback = function(source, number, target)
        local xPlayer = c.data.GetPlayer(source)
        local itemtbl = xPlayer.GetItemFromPosition(number)


    end
})

local DropItem = RegisterServerCallback({
    eventName = "DropItem",
    eventCallback = function(source, number, position)
        local xPlayer = c.data.GetPlayer(source)
        local itemtbl = xPlayer.GetItemFromPosition(number)
        

    end
})

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

local OrganizeInventory = RegisterServerCallback({
    eventName = "OrganizeInventory",
    eventCallback = function(source, net, inv)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(net)
        local type = GetEntityType(entity)
        -- Is it valid on the server?
        if DoesEntityExist(entity) then
            --
            -- Object
            if type == 3 then
                local xObject = c.data.GetObject(net)
                local size = xObject.GetInventory()
                if #size == #inv then
                    xObject.UnpackInventory(inv)
                else
                    c.func.Eventban(src,
                        "Error in organizing invent, additional items or quanitty found, removed player.")
                end
                --
                -- Vehicle
            elseif type == 2 then
                local xVehicle = c.data.GetVehicle(net)
                local size = xVehicle.GetInventory()
                if #size == #inv then
                    xVehicle.UnpackInventory(inv)
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
                    if #size == #inv then
                        xPlayer.UnpackInventory(inv)
                    else
                        c.func.Eventban(src,
                            "Error in organizing invent, additional items or quanitty found, removed player.")
                    end
                else
                    -- is an NPC
                    local xNpc = c.data.GetNpc(net)
                    local size = xNpc.GetInventory()
                    if #size == #inv then
                        xNpc.UnpackInventory(inv)
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

