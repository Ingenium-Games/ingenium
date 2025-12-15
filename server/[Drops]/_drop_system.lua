-- ====================================================================================--
-- Drop System: Physical item drops in the world
-- ====================================================================================--
c.active_drops = {} -- Drops currently being accessed by players
-- ====================================================================================--

--- Create a drop in the world with items
---@param coords table {x, y, z, h}
---@param items table Array of items to add [{Item, Quantity, Quality, Weapon, Meta}]
---@param model string|nil Optional model hash, uses default if nil
---@return number|boolean netId Network ID of created drop or false on failure
function c.drop.Create(coords, items, model)
    if type(coords) ~= "table" or not coords.x or not coords.y or not coords.z then
        c.func.Debug_1("Invalid coords provided to c.drop.Create")
        return false
    end
    
    if type(items) ~= "table" or #items == 0 then
        c.func.Debug_1("Invalid or empty items provided to c.drop.Create")
        return false
    end
    
    local dropModel = model or conf.drops.default_model
    local heading = coords.h or 0.0
    
    -- Create the physical object in the world
    local entity, netId = c.func.CreateObject(dropModel, coords.x, coords.y, coords.z, false)
    
    if not entity or not netId then
        c.func.Debug_1("Failed to create drop object")
        return false
    end
    
    -- Get the object from the object index
    local xObject = c.data.GetObject(netId)
    if not xObject then
        c.func.Debug_1("Failed to get xObject for drop")
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
    
    -- Update state bag for synchronization
    xObject.State.Inventory = xObject.GetInventory()
    
    -- Create drop entry
    local uuid = c.rng.UUID()
    local timestamp = c.func.Timestamp()
    
    c.drops[uuid] = {
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
        Updated = timestamp
    }
    
    c.func.Debug_1("Created drop with UUID: " .. uuid .. " NetID: " .. netId)
    
    return netId
end

--- Remove a drop from the world
---@param netId number Network ID of the drop
---@return boolean success
function c.drop.Remove(netId)
    if not netId then
        c.func.Debug_1("Invalid netId provided to c.drop.Remove")
        return false
    end
    
    -- Find the drop by NetID
    local dropUUID = nil
    for uuid, drop in pairs(c.drops) do
        if drop.NetID == netId then
            dropUUID = uuid
            break
        end
    end
    
    -- Also check active drops
    if not dropUUID then
        for uuid, drop in pairs(c.active_drops) do
            if drop.NetID == netId then
                dropUUID = uuid
                break
            end
        end
    end
    
    if not dropUUID then
        c.func.Debug_1("Drop not found for NetID: " .. netId)
        return false
    end
    
    -- Remove from both tables
    c.drops[dropUUID] = nil
    c.active_drops[dropUUID] = nil
    
    -- Delete the entity
    local entity = NetworkGetEntityFromNetworkId(netId)
    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
    
    -- Remove from object index
    c.data.RemoveObject(tostring(netId))
    
    c.func.Debug_1("Removed drop with UUID: " .. dropUUID)
    
    return true
end

--- Move drop from c.drops to c.active_drops when opened
---@param netId number Network ID of the drop
---@return boolean success
function c.drop.Activate(netId)
    if not netId then
        c.func.Debug_1("Invalid netId provided to c.drop.Activate")
        return false
    end
    
    -- Find the drop
    local dropUUID = nil
    local dropData = nil
    
    for uuid, drop in pairs(c.drops) do
        if drop.NetID == netId then
            dropUUID = uuid
            dropData = drop
            break
        end
    end
    
    -- Already active?
    if not dropUUID then
        for uuid, drop in pairs(c.active_drops) do
            if drop.NetID == netId then
                c.func.Debug_3("Drop already active: " .. uuid)
                return true
            end
        end
        c.func.Debug_1("Drop not found for activation: " .. netId)
        return false
    end
    
    -- Move to active
    c.active_drops[dropUUID] = dropData
    c.drops[dropUUID] = nil
    
    c.func.Debug_3("Activated drop: " .. dropUUID)
    
    return true
end

--- Move drop from c.active_drops back to c.drops when closed
---@param netId number Network ID of the drop
---@return boolean success
function c.drop.Deactivate(netId)
    if not netId then
        c.func.Debug_1("Invalid netId provided to c.drop.Deactivate")
        return false
    end
    
    -- Find the drop in active drops
    local dropUUID = nil
    local dropData = nil
    
    for uuid, drop in pairs(c.active_drops) do
        if drop.NetID == netId then
            dropUUID = uuid
            dropData = drop
            break
        end
    end
    
    if not dropUUID then
        c.func.Debug_3("Drop not found in active drops: " .. netId)
        return false
    end
    
    -- Get current inventory from xObject
    local xObject = c.data.GetObject(netId)
    if xObject then
        dropData.Inventory = xObject.CompressInventory()
        dropData.Updated = c.func.Timestamp()
    end
    
    -- If inventory is empty, remove the drop entirely
    if not dropData.Inventory or #dropData.Inventory == 0 then
        c.func.Debug_3("Drop inventory empty, removing: " .. dropUUID)
        c.active_drops[dropUUID] = nil
        c.drop.Remove(netId)
        return true
    end
    
    -- Move back to persistent drops
    c.drops[dropUUID] = dropData
    c.active_drops[dropUUID] = nil
    
    c.func.Debug_3("Deactivated drop: " .. dropUUID)
    
    return true
end

--- Clean up old drops if cleanup is enabled
function c.drop.CleanupOld()
    if not conf.drops.cleanup_enabled then
        return
    end
    
    local currentTime = c.func.Timestamp()
    local removedCount = 0
    
    for uuid, drop in pairs(c.drops) do
        if drop.Created and (currentTime - drop.Created) >= conf.drops.cleanup_time then
            c.drop.Remove(drop.NetID)
            removedCount = removedCount + 1
        end
    end
    
    if removedCount > 0 then
        c.func.Debug_1("Cleaned up " .. removedCount .. " old drops")
    end
end

--- Start periodic cleanup routine
function c.drop.StartCleanupRoutine()
    if not conf.drops.cleanup_enabled then
        c.func.Debug_1("Drop cleanup is disabled")
        return
    end
    
    local function DoCleanup()
        c.drop.CleanupOld()
        SetTimeout(conf.drops.cleanup_time, DoCleanup)
    end
    
    SetTimeout(conf.drops.cleanup_time, DoCleanup)
    c.func.Debug_1("Drop cleanup routine started")
end

-- ====================================================================================--
-- Events
-- ====================================================================================--

--- Handle player dropping items
RegisterNetEvent("Server:Item:Drop", function(item, quantity, quality, weapon, meta)
    local source = source
    local xPlayer = c.GetPlayer(source)
    
    if not xPlayer then
        c.func.Debug_1("Player not found for drop event")
        return
    end
    
    -- Validate item exists
    if not c.item.Exists(item) then
        c.func.Debug_1("Invalid item in drop event: " .. tostring(item))
        return
    end
    
    -- Check if player has the item
    local hasItem, slot = xPlayer.HasItem(item)
    if not hasItem then
        c.func.Debug_1("Player does not have item: " .. item)
        return
    end
    
    -- Get player coords
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    -- Offset coords slightly in front of player
    local forwardX = coords.x + math.cos(math.rad(heading)) * 1.0
    local forwardY = coords.y + math.sin(math.rad(heading)) * 1.0
    
    -- Create the drop
    local itemData = {
        Item = item,
        Quantity = quantity or 1,
        Quality = quality or 100,
        Weapon = weapon or false,
        Meta = meta or {}
    }
    
    local netId = c.drop.Create(
        {x = forwardX, y = forwardY, z = coords.z - 0.9, h = heading},
        {{item, quantity or 1, quality or 100, weapon or false, meta or {}}}
    )
    
    if netId then
        -- Remove item from player
        xPlayer.RemoveItem(item, slot)
        c.func.Debug_3("Player " .. source .. " dropped " .. item)
    end
end)

--- Handle player picking up items from a drop
RegisterNetEvent("Server:Item:Pickup", function(netId)
    local source = source
    local xPlayer = c.GetPlayer(source)
    
    if not xPlayer then
        c.func.Debug_1("Player not found for pickup event")
        return
    end
    
    -- Get the drop object
    local xObject = c.data.GetObject(netId)
    if not xObject then
        c.func.Debug_1("Drop object not found for NetID: " .. tostring(netId))
        return
    end
    
    -- Activate the drop if not already active
    c.drop.Activate(netId)
    
    -- Get inventory
    local inventory = xObject.GetInventory()
    if not inventory or #inventory == 0 then
        c.func.Debug_1("Drop inventory is empty")
        c.drop.Remove(netId)
        return
    end
    
    -- Transfer all items to player
    local transferredCount = 0
    for i = #inventory, 1, -1 do
        local item = inventory[i]
        -- Try to add to player
        xPlayer.AddItem({item.Item, item.Quantity, item.Quality, item.Weapon, item.Meta})
        -- Remove from drop
        xObject.RemoveItem(item.Item, i)
        transferredCount = transferredCount + 1
    end
    
    -- Update state bag
    xObject.State.Inventory = xObject.GetInventory()
    
    c.func.Debug_3("Transferred " .. transferredCount .. " items to player " .. source)
    
    -- Remove the drop if empty
    if #xObject.GetInventory() == 0 then
        c.drop.Remove(netId)
    else
        c.drop.Deactivate(netId)
    end
end)

-- ====================================================================================--
-- Initialization
-- ====================================================================================--

-- Start cleanup routine when resource is ready
CreateThread(function()
    while c._loading do
        Wait(1000)
    end
    c.drop.StartCleanupRoutine()
end)
