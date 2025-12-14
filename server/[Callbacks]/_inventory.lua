-- ====================================================================================--
-- Load the inventory validator module for enhanced security
local InventoryValidator = require('server/[Validation]/_inventory_validator')
-- ====================================================================================--

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
            -- Get the current inventory (before changes)
            local beforeInventory = nil
            
            -- Object
            if type == 3 then
                local xObject = c.data.GetObject(net)
                beforeInventory = xObject.GetInventory()
                
                -- Enhanced validation: Check inventory integrity
                local valid, error = InventoryValidator.ValidateInventoryIntegrity(
                    beforeInventory, nil, inv1, nil
                )
                
                if not valid then
                    InventoryValidator.HandleExploit(src, error)
                    return false
                end
                
                -- Additional validation: Validate each slot
                local slotValid, slotError = InventoryValidator.ValidateInventory(inv1)
                if not slotValid then
                    InventoryValidator.HandleExploit(src, slotError)
                    return false
                end
                
                xObject.UnpackInventory(inv1)
                return true
                --
                -- Vehicle
            elseif type == 2 then
                local xVehicle = c.data.GetVehicle(net)
                beforeInventory = xVehicle.GetInventory()
                
                -- Enhanced validation: Check inventory integrity
                local valid, error = InventoryValidator.ValidateInventoryIntegrity(
                    beforeInventory, nil, inv1, nil
                )
                
                if not valid then
                    InventoryValidator.HandleExploit(src, error)
                    return false
                end
                
                -- Additional validation: Validate each slot
                local slotValid, slotError = InventoryValidator.ValidateInventory(inv1)
                if not slotValid then
                    InventoryValidator.HandleExploit(src, slotError)
                    return false
                end
                
                xVehicle.UnpackInventory(inv1)
                return true
                --
                -- Ped
            elseif type == 1 then
                if IsPedAPlayer(entity) then
                    local xPlayer = c.data.GetPlayer(net)
                    beforeInventory = xPlayer.GetInventory()
                    
                    -- Enhanced validation: Check inventory integrity
                    local valid, error = InventoryValidator.ValidateInventoryIntegrity(
                        beforeInventory, nil, inv1, nil
                    )
                    
                    if not valid then
                        InventoryValidator.HandleExploit(src, error)
                        return false
                    end
                    
                    -- Additional validation: Validate each slot
                    local slotValid, slotError = InventoryValidator.ValidateInventory(inv1)
                    if not slotValid then
                        InventoryValidator.HandleExploit(src, slotError)
                        return false
                    end
                    
                    xPlayer.UnpackInventory(inv1)
                    return true
                else
                    -- is an NPC
                    local xNpc = c.data.GetNpc(net)
                    beforeInventory = xNpc.GetInventory()
                    
                    -- Enhanced validation: Check inventory integrity
                    local valid, error = InventoryValidator.ValidateInventoryIntegrity(
                        beforeInventory, nil, inv1, nil
                    )
                    
                    if not valid then
                        InventoryValidator.HandleExploit(src, error)
                        return false
                    end
                    
                    -- Additional validation: Validate each slot
                    local slotValid, slotError = InventoryValidator.ValidateInventory(inv1)
                    if not slotValid then
                        InventoryValidator.HandleExploit(src, slotError)
                        return false
                    end
                    
                    xNpc.UnpackInventory(inv1)
                    return true
                end
            end
        end
        return false
    end
})
--

local OrganizeInventories = RegisterServerCallback({
    eventName = "OrganizeInventories",
    eventCallback = function(source, net, inv1, inv2)
        local src = source
        local entity = NetworkGetEntityFromNetworkId(net)
        local type = GetEntityType(entity)
        
        -- Get current inventories before changes
        local xPlayer = c.data.GetPlayer(src)
        local beforePlayer = xPlayer.GetInventory()
        local beforeExternal = nil
        
        -- Get external inventory based on entity type
        if type == 3 then
            -- Object
            local xObject = c.data.GetObject(net)
            beforeExternal = xObject.GetInventory()
        elseif type == 2 then
            -- Vehicle
            local xVehicle = c.data.GetVehicle(net)
            beforeExternal = xVehicle.GetInventory()
        elseif type == 1 then
            -- Ped
            if IsPedAPlayer(entity) then
                local xTarget = c.data.GetPlayer(net)
                beforeExternal = xTarget.GetInventory()
            else
                local xNpc = c.data.GetNpc(net)
                beforeExternal = xNpc.GetInventory()
            end
        end
        
        -- Enhanced validation: Check combined inventory integrity
        local valid, error = InventoryValidator.ValidateInventoryIntegrity(
            beforePlayer, beforeExternal, inv1, inv2
        )
        
        if not valid then
            InventoryValidator.HandleExploit(src, error)
            return false
        end
        
        -- Additional validation: Validate each inventory's slots
        local playerValid, playerError = InventoryValidator.ValidateInventory(inv1)
        if not playerValid then
            InventoryValidator.HandleExploit(src, "Player inventory: " .. playerError)
            return false
        end
        
        local externalValid, externalError = InventoryValidator.ValidateInventory(inv2)
        if not externalValid then
            InventoryValidator.HandleExploit(src, "External inventory: " .. externalError)
            return false
        end
        
        -- All validation passed, update inventories
        xPlayer.UnpackInventory(inv1)
        
        if type == 3 then
            -- Object
            local xObject = c.data.GetObject(net)
            xObject.UnpackInventory(inv2)
        elseif type == 2 then
            -- Vehicle
            local xVehicle = c.data.GetVehicle(net)
            xVehicle.UnpackInventory(inv2)
        elseif type == 1 then
            -- Ped
            if IsPedAPlayer(entity) then
                local xTarget = c.data.GetPlayer(net)
                xTarget.UnpackInventory(inv2)
            else
                local xNpc = c.data.GetNpc(net)
                xNpc.UnpackInventory(inv2)
            end
        end
        
        return true
    end
})
--

