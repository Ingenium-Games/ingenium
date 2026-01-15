-- ====================================================================================--
-- Drop System (ig.active_drops initialized in server/_var.lua)
-- Physical item drops in the world
-- ====================================================================================--
ig.drop = ig.drop or {} -- function level
ig.drops = ig.drops or {} -- dropped items table
-- ====================================================================================--

--- Create a drop in the world with items
---@param coords table {x, y, z, h}
---@param items table Array of items to add [{Item, Quantity, Quality, Weapon, Meta}]
---@param model string|nil Optional model hash, uses default if nil
---@param targetPlayer number|nil Optional target player source to notify
---@param isDeadDrop boolean|nil If true, notifies player without blip (for secret drops)
---@return number|boolean netId Network ID of created drop or false on failure
function ig.drop.Create(coords, items, model, targetPlayer, isDeadDrop)
    if type(coords) ~= "table" or not coords.x or not coords.y or not coords.z then
        ig.func.Debug_1("Invalid coords provided to ig.drop.Create")
        return false
    end
    
    if type(items) ~= "table" or #items == 0 then
        ig.func.Debug_1("Invalid or empty items provided to ig.drop.Create")
        return false
    end
    
    local dropModel = model or conf.drops.default_model
    local heading = coords.h or 0.0
    
    -- Create the physical object in the world
    local entity, netId = ig.func.CreateObject(dropModel, coords.x, coords.y, coords.z, false)
    
    if not entity or not netId then
        ig.func.Debug_1("Failed to create drop object")
        return false
    end
    
    -- Get the object from the object index
    local xObject = ig.data.GetObject(netId)
    if not xObject then
        ig.func.Debug_1("Failed to get xObject for drop")
        return false
    end
    
    -- Set position and freeze entity
    xObject.SetCoords({
        x = coords.x,
        y = coords.y,
        z = coords.z,
        h = heading,
        rx = 0.0,
        ry = 0.0,
        rz = 0.0
    })
    
    -- Freeze and enable collision
    FreezeEntityPosition(xObject.Entity, true)
    SetEntityCollision(xObject.Entity, true, true)
    
    -- Add items to the drop
    for _, item in ipairs(items) do
        xObject.AddItem(item)
    end
    
    -- Create drop entry
    local uuid = ig.rng.UUID()
    local timestamp = ig.func.Timestamp()
    
    ig.drops[uuid] = {
        UUID = uuid,
        NetID = netId,
        Coords = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            h = heading
        },
        Model = dropModel,
        Inventory = xObject.CompressInventory(),
        Created = timestamp,
        Updated = timestamp,
        TargetPlayer = targetPlayer or nil,
        IsDeadDrop = isDeadDrop or false
    }
    
    -- Notify target player if specified
    if targetPlayer and type(targetPlayer) == "number" then
        local xPlayer = ig.data.GetPlayer(targetPlayer)
        if xPlayer then
            -- Send notification to target player
            TriggerClientEvent('Client:Drop:Notify', targetPlayer, {
                coords = coords,
                isDeadDrop = isDeadDrop or false,
                netId = netId,
                uuid = uuid
            })
            
            ig.func.Debug_3("Notified player " .. targetPlayer .. " of drop at (" .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ")")
            
            -- Trigger hook event for custom scripts (phone systems, etig.)
            TriggerEvent('Server:Drop:Created:Targeted', {
                targetPlayer = targetPlayer,
                coords = coords,
                netId = netId,
                uuid = uuid,
                isDeadDrop = isDeadDrop or false,
                items = items
            })
        end
    end
    
    ig.func.Debug_1("Created drop with UUID: " .. uuid .. " NetID: " .. netId)
    
    return netId
end

--- Remove a drop from the world
---@param netId number Network ID of the drop
---@return boolean success
function ig.drop.Remove(netId)
    if not netId then
        ig.func.Debug_1("Invalid netId provided to ig.drop.Remove")
        return false
    end
    
    -- Find the drop by NetID
    local dropUUID = nil
    local dropData = nil
    for uuid, drop in pairs(ig.drops) do
        if drop.NetID == netId then
            dropUUID = uuid
            dropData = drop
            break
        end
    end
    
    -- Also check active drops
    if not dropUUID then
        for uuid, drop in pairs(ig.active_drops) do
            if drop.NetID == netId then
                dropUUID = uuid
                dropData = drop
                break
            end
        end
    end
    
    if not dropUUID then
        ig.func.Debug_1("Drop not found for NetID: " .. netId)
        return false
    end
    
    -- Notify target player to remove blip if this was a targeted drop
    if dropData and dropData.TargetPlayer then
        TriggerClientEvent('Client:Drop:Removed', dropData.TargetPlayer, dropUUID)
    end
    
    -- Remove from both tables
    ig.drops[dropUUID] = nil
    ig.active_drops[dropUUID] = nil
    
    -- Delete the entity
    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
    
    -- Remove from object index
    ig.data.RemoveObject(tostring(netId))
    
    ig.func.Debug_1("Removed drop with UUID: " .. dropUUID)
    
    return true
end

--- Move drop from ig.drops to ig.active_drops when opened
---@param netId number Network ID of the drop
---@return boolean success
function ig.drop.Activate(netId)
    if not netId then
        ig.func.Debug_1("Invalid netId provided to ig.drop.Activate")
        return false
    end
    
    -- Find the drop
    local dropUUID = nil
    local dropData = nil
    
    for uuid, drop in pairs(ig.drops) do
        if drop.NetID == netId then
            dropUUID = uuid
            dropData = drop
            break
        end
    end
    
    -- Already active?
    if not dropUUID then
        for uuid, drop in pairs(ig.active_drops) do
            if drop.NetID == netId then
                ig.func.Debug_3("Drop already active: " .. uuid)
                return true
            end
        end
        ig.func.Debug_1("Drop not found for activation: " .. netId)
        return false
    end
    
    -- Move to active
    ig.active_drops[dropUUID] = dropData
    ig.drops[dropUUID] = nil
    
    ig.func.Debug_3("Activated drop: " .. dropUUID)
    
    return true
end

--- Move drop from ig.active_drops back to ig.drops when closed
---@param netId number Network ID of the drop
---@return boolean success
function ig.drop.Deactivate(netId)
    if not netId then
        ig.func.Debug_1("Invalid netId provided to ig.drop.Deactivate")
        return false
    end
    
    -- Find the drop in active drops
    local dropUUID = nil
    local dropData = nil
    
    for uuid, drop in pairs(ig.active_drops) do
        if drop.NetID == netId then
            dropUUID = uuid
            dropData = drop
            break
        end
    end
    
    if not dropUUID then
        ig.func.Debug_3("Drop not found in active drops: " .. netId)
        return false
    end
    
    -- Get current inventory from xObject
    local xObject = ig.data.GetObject(netId)
    if xObject then
        dropData.Inventory = xObject.CompressInventory()
        dropData.Updated = ig.func.Timestamp()
    end
    
    -- If inventory is empty, remove the drop entirely
    if not dropData.Inventory or #dropData.Inventory == 0 then
        ig.func.Debug_3("Drop inventory empty, removing: " .. dropUUID)
        ig.active_drops[dropUUID] = nil
        ig.drop.Remove(netId)
        return true
    end
    
    -- Move back to persistent drops
    ig.drops[dropUUID] = dropData
    ig.active_drops[dropUUID] = nil
    
    ig.func.Debug_3("Deactivated drop: " .. dropUUID)
    
    return true
end

--- Clean up old drops if cleanup is enabled
function ig.drop.CleanupOld()
    if not conf.drops.cleanup_enabled then
        return
    end
    
    local currentTime = ig.func.Timestamp()
    local removedCount = 0
    
    for uuid, drop in pairs(ig.drops) do
        if drop.Created and (currentTime - drop.Created) >= conf.drops.cleanup_time then
            ig.drop.Remove(drop.NetID)
            removedCount = removedCount + 1
        end
    end
    
    if removedCount > 0 then
        ig.func.Debug_1("Cleaned up " .. removedCount .. " old drops")
    end
end

-- Note: Periodic cleanup is managed by server/[Data - Save to File]/_gsr.lua
-- Consolidated Cleanup Manager to reduce thread overhead

--- Helper function to merge active drops back into drops for saving
---@return table dropsToSave Combined drops table
function ig.drop.MergeDropsForSave()
    local dropsToSave = {}
    
    -- Copy ig.drops
    for uuid, drop in pairs(ig.drops) do
        dropsToSave[uuid] = drop
    end
    
    -- Merge ig.active_drops with updated inventory
    for uuid, drop in pairs(ig.active_drops) do
        -- Update inventory from xObject before saving
        local xObject = ig.data.GetObject(drop.NetID)
        if xObject then
            drop.Inventory = xObject.CompressInventory()
            drop.Updated = ig.func.Timestamp()
            dropsToSave[uuid] = drop
        else
            -- If xObject doesn't exist, skip this drop (will be cleaned up)
            ig.func.Debug_1("Skipping save for drop " .. uuid .. " - xObject not found")
        end
    end
    
    return dropsToSave
end


-- ====================================================================================--
-- Events
-- ====================================================================================--

--- Handle player accessing a drop (opening inventory UI)
-- Migrated to callback for security
RegisterServerCallback({
    eventName = "Server:Drop:Access",
    eventCallback = function(source, netId)
        local xPlayer = ig.GetPlayer(source)
        
        if not xPlayer then
            ig.func.Debug_1("Player not found for drop access event")
            return { success = false, error = "Player not found" }
        end
        
        -- Check if drop has restricted access
        local dropUUID = nil
        local dropData = nil
        
        -- Find drop in both active and inactive states
        for uuid, drop in pairs(ig.drops) do
            if drop.NetID == netId then
                dropUUID = uuid
                dropData = drop
                break
            end
        end
        
        if not dropUUID then
            for uuid, drop in pairs(ig.active_drops) do
                if drop.NetID == netId then
                    dropUUID = uuid
                    dropData = drop
                    break
                end
            end
        end
        
        -- Validate access permissions
        if dropData and dropData.TargetPlayer then
            if dropData.TargetPlayer ~= source then
                -- Not authorized to access this drop
                TriggerClientEvent('Client:Drop:AccessDenied', source, {
                    message = "This drop is not for you"
                })
                ig.func.Debug_1("Player " .. source .. " denied access to restricted drop (target: " .. dropData.TargetPlayer .. ")")
                return { success = false, error = "Access denied" }
            end
        end
        
        -- Activate the drop (move to active state)
        ig.drop.Activate(netId)
        
        ig.func.Debug_3("Player " .. source .. " accessed drop NetID: " .. netId)
        return { success = true }
    end
})

--- Handle when inventory UI is closed for a drop
--- The OrganizeInventories callback already handles saving, this is for cleanup
-- Migrated to callback for security
RegisterServerCallback({
    eventName = "Server:Drop:Close",
    eventCallback = function(source, netId)
        -- Get the drop object
        local xObject = ig.data.GetObject(netId)
        if not xObject then
            ig.func.Debug_1("Drop object not found for NetID: " .. tostring(netId))
            return { success = false, error = "Drop not found" }
        end
        
        -- Check if inventory is empty, if so remove the drop
        local inventory = xObject.GetInventory()
        if not inventory or #inventory == 0 then
            ig.drop.Remove(netId)
            ig.func.Debug_3("Drop removed (empty) after close by player " .. source)
        else
            -- Move back to inactive state
            ig.drop.Deactivate(netId)
            ig.func.Debug_3("Drop deactivated after close by player " .. source)
        end
        
        return { success = true }
    end
})

--- Handle player dropping items from inventory UI
--- This is called when items are dragged out of inventory in the UI
-- Migrated to callback for security
RegisterServerCallback({
    eventName = "Server:Item:Drop",
    eventCallback = function(source, item, quantity, quality, weapon, meta)
        local xPlayer = ig.GetPlayer(source)
        
        if not xPlayer then
            ig.func.Debug_1("Player not found for drop event")
            return { success = false, error = "Player not found" }
        end
        
        -- Validate item exists
        if not ig.item.Exists(item) then
            ig.func.Debug_1("Invalid item in drop event: " .. tostring(item))
            return { success = false, error = "Invalid item" }
        end
        
        -- Default values
        quantity = quantity or 1
        quality = quality or 100
        weapon = weapon or false
        meta = meta or {}
        
        -- Check if player has the item with sufficient quantity
        local hasItem, slot = xPlayer.HasItem(item)
        if not hasItem then
            ig.func.Debug_1("Player does not have item: " .. item)
            return { success = false, error = "Item not found" }
        end
        
        local playerQuantity = xPlayer.GetItemQuantity(item)
        if playerQuantity < quantity then
            ig.func.Debug_1("Player does not have enough quantity: " .. item .. " (has " .. playerQuantity .. ", needs " .. quantity .. ")")
            return { success = false, error = "Insufficient quantity" }
        end
        
        -- Get player coords
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        
        -- Offset coords slightly in front of player
        local forwardX = coords.x + math.cos(math.rad(heading)) * 1.0
        local forwardY = coords.y + math.sin(math.rad(heading)) * 1.0
        
        -- Create the drop
        local netId = ig.drop.Create(
            {x = forwardX, y = forwardY, z = coords.z - 0.9, h = heading},
            {{item, quantity, quality, weapon, meta}}
        )
        
        if netId then
            -- Remove the specified quantity from player (recalculate slot each time)
            for i = 1, quantity do
                local _, currentSlot = xPlayer.HasItem(item)
                if currentSlot then
                    xPlayer.RemoveItem(item, currentSlot)
                end
            end
            ig.func.Debug_3("Player " .. source .. " dropped " .. quantity .. "x " .. item)
            return { success = true, netId = netId }
        else
            return { success = false, error = "Failed to create drop" }
        end
    end
})