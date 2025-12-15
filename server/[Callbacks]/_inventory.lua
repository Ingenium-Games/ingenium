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
                
                -- Enhanced validation: Check inventory integrity (duplication/injection)
                -- Skip individual slot validation since UnpackInventory handles that
                local valid, error = c.validation.ValidateInventoryIntegrity(
                    beforeInventory, nil, inv1, nil
                )
                
                if not valid then
                    c.validation.LogAndBanExploiter(src, error)
                    return false
                end
                
                -- UnpackInventory will handle detailed slot validation
                xObject.UnpackInventory(inv1)
                return true
                --
                -- Vehicle
            elseif type == 2 then
                local xVehicle = c.data.GetVehicle(net)
                beforeInventory = xVehicle.GetInventory()
                
                -- Enhanced validation: Check inventory integrity (duplication/injection)
                local valid, error = c.validation.ValidateInventoryIntegrity(
                    beforeInventory, nil, inv1, nil
                )
                
                if not valid then
                    c.validation.LogAndBanExploiter(src, error)
                    return false
                end
                
                -- UnpackInventory will handle detailed slot validation
                xVehicle.UnpackInventory(inv1)
                return true
                --
                -- Ped
            elseif type == 1 then
                if IsPedAPlayer(entity) then
                    local xPlayer = c.data.GetPlayer(net)
                    beforeInventory = xPlayer.GetInventory()
                    
                    -- Enhanced validation: Check inventory integrity (duplication/injection)
                    local valid, error = c.validation.ValidateInventoryIntegrity(
                        beforeInventory, nil, inv1, nil
                    )
                    
                    if not valid then
                        c.validation.LogAndBanExploiter(src, error)
                        return false
                    end
                    
                    -- UnpackInventory will handle detailed slot validation
                    xPlayer.UnpackInventory(inv1)
                    return true
                else
                    -- is an NPC
                    local xNpc = c.data.GetNpc(net)
                    beforeInventory = xNpc.GetInventory()
                    
                    -- Enhanced validation: Check inventory integrity (duplication/injection)
                    local valid, error = c.validation.ValidateInventoryIntegrity(
                        beforeInventory, nil, inv1, nil
                    )
                    
                    if not valid then
                        c.validation.LogAndBanExploiter(src, error)
                        return false
                    end
                    
                    -- UnpackInventory will handle detailed slot validation
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
        
        -- CRITICAL: Get CURRENT server state, not cached client state
        -- This prevents race conditions when multiple players access the same inventory
        local xPlayer = c.data.GetPlayer(src)
        local currentPlayer = xPlayer.GetInventory()  -- Current server state for player
        local currentExternal  -- Current server state for external entity
        
        -- Get external inventory based on entity type
        if type == 3 then
            -- Object
            local xObject = c.data.GetObject(net)
            currentExternal = xObject.GetInventory()
        elseif type == 2 then
            -- Vehicle
            local xVehicle = c.data.GetVehicle(net)
            currentExternal = xVehicle.GetInventory()
        elseif type == 1 then
            -- Ped
            if IsPedAPlayer(entity) then
                local xTarget = c.data.GetPlayer(net)
                currentExternal = xTarget.GetInventory()
            else
                local xNpc = c.data.GetNpc(net)
                currentExternal = xNpc.GetInventory()
            end
        end
        
        -- Enhanced validation: Check that submitted inventories are reasonable
        -- given CURRENT server state (not snapshot from when UI opened)
        -- This prevents issues when multiple players access the same drop
        
        -- Calculate total items submitted by client
        local submittedTotal = {}
        for _, item in ipairs(inv1) do
            local itemName = item.Item or item[1]
            local quantity = item.Quantity or item[2] or 1
            submittedTotal[itemName] = (submittedTotal[itemName] or 0) + quantity
        end
        for _, item in ipairs(inv2) do
            local itemName = item.Item or item[1]
            local quantity = item.Quantity or item[2] or 1
            submittedTotal[itemName] = (submittedTotal[itemName] or 0) + quantity
        end
        
        -- Calculate current total on server
        local currentTotal = {}
        for _, item in ipairs(currentPlayer) do
            currentTotal[item.Item] = (currentTotal[item.Item] or 0) + item.Quantity
        end
        for _, item in ipairs(currentExternal) do
            currentTotal[item.Item] = (currentTotal[item.Item] or 0) + item.Quantity
        end
        
        -- Validate: submitted total should not exceed current server total
        for itemName, submittedQty in pairs(submittedTotal) do
            local currentQty = currentTotal[itemName] or 0
            
            if submittedQty > currentQty then
                -- This indicates either:
                -- 1. Client tried to duplicate items
                -- 2. Race condition where another player took items
                
                -- Check if the difference is reasonable (likely another player)
                local difference = submittedQty - currentQty
                
                -- If difference is small, it's likely concurrent access
                -- Adjust client inventory to match server state
                if difference <= 10 then
                    c.func.Debug_1(("Concurrent access detected: %s quantity adjusted from %d to %d for player %d"):format(
                        itemName, submittedQty, currentQty, src
                    ))
                    
                    -- Adjust the submitted inventory to match server reality
                    -- Remove excess from inv1 first, then inv2
                    local toRemove = difference
                    
                    -- Try removing from player inventory first
                    for i = #inv1, 1, -1 do
                        if toRemove <= 0 then break end
                        local item = inv1[i]
                        local name = item.Item or item[1]
                        local qty = item.Quantity or item[2] or 1
                        
                        if name == itemName then
                            if qty <= toRemove then
                                table.remove(inv1, i)
                                toRemove = toRemove - qty
                            else
                                if type(item) == "table" and item.Quantity then
                                    item.Quantity = qty - toRemove
                                else
                                    item[2] = qty - toRemove
                                end
                                toRemove = 0
                            end
                        end
                    end
                    
                    -- If still need to remove, remove from external
                    for i = #inv2, 1, -1 do
                        if toRemove <= 0 then break end
                        local item = inv2[i]
                        local name = item.Item or item[1]
                        local qty = item.Quantity or item[2] or 1
                        
                        if name == itemName then
                            if qty <= toRemove then
                                table.remove(inv2, i)
                                toRemove = toRemove - qty
                            else
                                if type(item) == "table" and item.Quantity then
                                    item.Quantity = qty - toRemove
                                else
                                    item[2] = qty - toRemove
                                end
                                toRemove = 0
                            end
                        end
                    end
                else
                    -- Large difference = likely exploit attempt
                    c.validation.LogAndBanExploiter(src, 
                        ("Item duplication attempt: %s quantity %d exceeds server total %d"):format(
                            itemName, submittedQty, currentQty
                        ))
                    return false
                end
            end
        end
        
        -- Additional check: No new items should appear
        for itemName, _ in pairs(submittedTotal) do
            if not currentTotal[itemName] then
                c.validation.LogAndBanExploiter(src,
                    ("Item injection detected: %s not present in current server state"):format(itemName))
                return false
            end
        end
        
        -- UnpackInventory will handle detailed slot validation for both inventories
        xPlayer.UnpackInventory(inv1)
        
        if type == 3 then
            -- Object
            local xObject = c.data.GetObject(net)
            xObject.UnpackInventory(inv2)
            
            -- Check if this is a drop (model hash comparison - backtick notation auto-hashes)
            local model = GetEntityModel(entity)
            if model == conf.drops.default_model then
                local inventory = xObject.GetInventory()
                if not inventory or #inventory == 0 then
                    -- Drop is empty, remove it
                    if c.drop and c.drop.Remove then
                        c.drop.Remove(net)
                    end
                else
                    -- Drop still has items, deactivate it
                    if c.drop and c.drop.Deactivate then
                        c.drop.Deactivate(net)
                    end
                end
            end
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

---
-- Real-time inventory transfer callback for live State Bag updates
-- Called during drag-and-drop operations while inventory UI is open
-- This allows multiple players viewing the same inventory to see changes instantly
local TransferInventoryItem = RegisterServerCallback({
    eventName = "TransferInventoryItem",
    eventCallback = function(source, fromNetId, toNetId, itemData, fromSlot, toSlot)
        local src = source
        
        -- Validate source player
        local xPlayer = c.data.GetPlayer(src)
        if not xPlayer then
            c.func.Debug_1("Player not found for item transfer")
            return false
        end
        
        -- Get source and destination entities/inventories
        local fromEntity, fromInventory, fromType
        local toEntity, toInventory, toType
        
        -- Source inventory
        if fromNetId == GetPlayerPed(src) or fromNetId == src then
            fromInventory = xPlayer
            fromType = "player"
        else
            fromEntity = NetworkGetEntityFromNetworkId(fromNetId)
            local entityType = GetEntityType(fromEntity)
            if entityType == 3 then
                fromInventory = c.data.GetObject(fromNetId)
                fromType = "object"
            elseif entityType == 2 then
                fromInventory = c.data.GetVehicle(fromNetId)
                fromType = "vehicle"
            elseif entityType == 1 then
                if IsPedAPlayer(fromEntity) then
                    fromInventory = c.data.GetPlayer(fromNetId)
                    fromType = "player"
                else
                    fromInventory = c.data.GetNpc(fromNetId)
                    fromType = "npc"
                end
            end
        end
        
        -- Destination inventory
        if toNetId == GetPlayerPed(src) or toNetId == src then
            toInventory = xPlayer
            toType = "player"
        else
            toEntity = NetworkGetEntityFromNetworkId(toNetId)
            local entityType = GetEntityType(toEntity)
            if entityType == 3 then
                toInventory = c.data.GetObject(toNetId)
                toType = "object"
            elseif entityType == 2 then
                toInventory = c.data.GetVehicle(toNetId)
                toType = "vehicle"
            elseif entityType == 1 then
                if IsPedAPlayer(toEntity) then
                    toInventory = c.data.GetPlayer(toNetId)
                    toType = "player"
                else
                    toInventory = c.data.GetNpc(toNetId)
                    toType = "npc"
                end
            end
        end
        
        if not fromInventory or not toInventory then
            c.func.Debug_1("Invalid inventory in transfer")
            return false
        end
        
        -- Validate item exists in source inventory
        local sourceItem = fromInventory.GetItemFromPosition(fromSlot)
        if not sourceItem or sourceItem.Item ~= itemData.Item then
            c.func.Debug_1("Item mismatch or not found in source inventory")
            return false
        end
        
        -- Validate quantity
        if sourceItem.Quantity < itemData.Quantity then
            c.func.Debug_1("Insufficient quantity in source inventory")
            return false
        end
        
        -- Perform the transfer
        -- Remove from source
        for i = 1, itemData.Quantity do
            fromInventory.RemoveItem(itemData.Item, fromSlot)
        end
        
        -- Add to destination
        toInventory.AddItem({
            itemData.Item,
            itemData.Quantity,
            itemData.Quality or 100,
            itemData.Weapon or false,
            itemData.Meta or {}
        })
        
        -- CRITICAL: Update State Bags immediately for real-time sync
        if fromType ~= "player" and fromInventory.State then
            fromInventory.State.Inventory = fromInventory.GetInventory()
        end
        
        if toType ~= "player" and toInventory.State then
            toInventory.State.Inventory = toInventory.GetInventory()
        end
        
        -- Notify all nearby players of the update (for UI refresh)
        if fromType == "object" or toType == "object" then
            local coords = fromType == "object" and GetEntityCoords(fromEntity) or GetEntityCoords(toEntity)
            local nearbyPlayers = GetPlayers()
            for _, playerId in ipairs(nearbyPlayers) do
                local playerPed = GetPlayerPed(playerId)
                local playerCoords = GetEntityCoords(playerPed)
                local distance = #(coords - playerCoords)
                
                if distance < 10.0 then -- 10 meter range for updates
                    TriggerClientEvent('Client:Inventory:UpdateLive', playerId, fromNetId, toNetId)
                end
            end
        end
        
        c.func.Debug_3("Item transferred: " .. itemData.Item .. " x" .. itemData.Quantity)
        
        return true
    end
})
--

