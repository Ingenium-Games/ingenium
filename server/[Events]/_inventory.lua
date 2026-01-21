-- ====================================================================================--
-- Server-Side Inventory Event Handlers
-- Handles UseItem, GiveItem, and DropItem events from client NUI
-- ====================================================================================--

---
-- Use item from inventory (triggered from NUI)
-- @param itemName string The name of the item to use
-- @param quantity number The quantity to use
-- @param position number The inventory slot position
-- @param panelId string The panel ID ("player" or "external")
RegisterNetEvent("Server:Inventory:UseItem", function(itemName, quantity, position, panelId)
    local source = source
    
    -- Security: Validate invoking resource
    if GetInvokingResource() ~= conf.resourcename then
        ig.log.Error("Inventory", "Unauthorized resource attempted to trigger Server:Inventory:UseItem")
        return
    end
    
    -- Get player
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        ig.log.Error("Inventory", "Player not found for UseItem event: " .. source)
        return
    end
    
    -- Validate input
    itemName = ig.check.String(itemName)
    quantity = ig.check.Number(quantity, 1, 9999)
    position = ig.check.Number(position, 1, 100)
    
    if not itemName then
        ig.log.Error("Inventory", "Invalid item name in UseItem")
        return
    end
    
    -- Get item from position
    local item = xPlayer.GetItemFromPosition(position)
    if not item or item.Item ~= itemName then
        xPlayer.Notify("Item not found in inventory")
        ig.log.Debug("Inventory", string.format("Item mismatch: expected %s at position %d, found %s", 
            itemName, position, item and item.Item or "nil"))
        return
    end
    
    -- Check if item exists in database
    if not ig.item.Exists(itemName) then
        xPlayer.Notify("Unknown item: " .. itemName)
        ig.log.Error("Inventory", "Unknown item used: " .. itemName)
        return
    end
    
    -- Use the item via ConsumeItem which triggers appropriate events
    xPlayer.ConsumeItem(position)
    
    ig.log.Info("Inventory", string.format("Player %d used item: %s (qty: %d, pos: %d)", 
        source, itemName, quantity, position))
end)

---
-- Give item to another player (triggered from NUI)
-- @param itemName string The name of the item to give
-- @param quantity number The quantity to give
-- @param position number The inventory slot position
RegisterNetEvent("Server:Inventory:GiveItem", function(itemName, quantity, position)
    local source = source
    
    -- Security: Validate invoking resource
    if GetInvokingResource() ~= conf.resourcename then
        ig.log.Error("Inventory", "Unauthorized resource attempted to trigger Server:Inventory:GiveItem")
        return
    end
    
    -- Get player
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        ig.log.Error("Inventory", "Player not found for GiveItem event: " .. source)
        return
    end
    
    -- Validate input
    itemName = ig.check.String(itemName)
    quantity = ig.check.Number(quantity, 1, 9999)
    position = ig.check.Number(position, 1, 100)
    
    if not itemName then
        ig.log.Error("Inventory", "Invalid item name in GiveItem")
        return
    end
    
    -- Get item from position
    local item = xPlayer.GetItemFromPosition(position)
    if not item or item.Item ~= itemName then
        xPlayer.Notify("Item not found in inventory")
        ig.log.Debug("Inventory", string.format("Item mismatch in GiveItem: expected %s at position %d, found %s", 
            itemName, position, item and item.Item or "nil"))
        return
    end
    
    -- Check quantity
    if item.Quantity < quantity then
        xPlayer.Notify("Insufficient quantity")
        return
    end
    
    -- Find nearest player
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local closestPlayer = nil
    local closestDistance = 3.0  -- Max distance to give items
    
    for _, playerId in ipairs(GetPlayers()) do
        local targetId = tonumber(playerId)
        if targetId and targetId ~= source then
            local targetPed = GetPlayerPed(targetId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = targetId
            end
        end
    end
    
    -- If no player nearby, notify
    if not closestPlayer then
        xPlayer.Notify("No player nearby to give item to")
        return
    end
    
    -- Get target player
    local xTarget = ig.data.GetPlayer(closestPlayer)
    if not xTarget then
        xPlayer.Notify("Target player not found")
        return
    end
    
    -- Transfer the item
    -- Remove from giver
    for i = 1, quantity do
        xPlayer.RemoveItem(itemName, position)
    end
    
    -- Add to receiver
    xTarget.AddItem({itemName, quantity, item.Quality or 100, item.Weapon or false, item.Meta or {}})
    
    -- Notify both players
    xPlayer.Notify(string.format("You gave %dx %s to a player", quantity, itemName))
    xTarget.Notify(string.format("You received %dx %s from a player", quantity, itemName))
    
    ig.log.Info("Inventory", string.format("Player %d gave %dx %s to player %d", 
        source, quantity, itemName, closestPlayer))
end)

---
-- Drop item on ground (triggered from NUI)
-- @param itemName string The name of the item to drop
-- @param quantity number The quantity to drop
-- @param position number The inventory slot position
RegisterNetEvent("Server:Inventory:DropItem", function(itemName, quantity, position)
    local source = source
    
    -- Security: Validate invoking resource
    if GetInvokingResource() ~= conf.resourcename then
        ig.log.Error("Inventory", "Unauthorized resource attempted to trigger Server:Inventory:DropItem")
        return
    end
    
    -- Get player
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        ig.log.Error("Inventory", "Player not found for DropItem event: " .. source)
        return
    end
    
    -- Validate input
    itemName = ig.check.String(itemName)
    quantity = ig.check.Number(quantity, 1, 9999)
    position = ig.check.Number(position, 1, 100)
    
    if not itemName then
        ig.log.Error("Inventory", "Invalid item name in DropItem")
        return
    end
    
    -- Get item from position
    local item = xPlayer.GetItemFromPosition(position)
    if not item or item.Item ~= itemName then
        xPlayer.Notify("Item not found in inventory")
        ig.log.Debug("Inventory", string.format("Item mismatch in DropItem: expected %s at position %d, found %s", 
            itemName, position, item and item.Item or "nil"))
        return
    end
    
    -- Check quantity
    if item.Quantity < quantity then
        xPlayer.Notify("Insufficient quantity")
        return
    end
    
    -- Get player coords
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)
    
    -- Calculate drop position (slightly in front of player)
    local forwardX = math.sin(math.rad(playerHeading)) * 0.5
    local forwardY = math.cos(math.rad(playerHeading)) * 0.5
    local dropCoords = vector3(playerCoords.x + forwardX, playerCoords.y + forwardY, playerCoords.z - 0.3)
    
    -- Remove item from player
    for i = 1, quantity do
        xPlayer.RemoveItem(itemName, position)
    end
    
    -- Create drop object
    if ig.drop and ig.drop.Create then
        local dropData = {
            {itemName, quantity, item.Quality or 100, item.Weapon or false, item.Meta or {}}
        }
        ig.drop.Create(dropCoords, dropData)
        
        xPlayer.Notify(string.format("Dropped %dx %s", quantity, itemName))
        
        ig.log.Info("Inventory", string.format("Player %d dropped %dx %s at coords: %s", 
            source, quantity, itemName, tostring(dropCoords)))
    else
        ig.log.Error("Inventory", "Drop system not available")
        -- Return item to player if drop system fails
        xTarget.AddItem({itemName, quantity, item.Quality or 100, item.Weapon or false, item.Meta or {}})
        xPlayer.Notify("Failed to drop item")
    end
end)

ig.log.Info("Events", "Inventory event handlers registered")
