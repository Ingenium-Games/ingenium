-- ====================================================================================--
-- INVENTORY NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for inventory/item operations.
--
-- NUI sends these messages:
--   - NUI:Client:InventoryClose   => Inventory was closed
--   - NUI:Client:InventoryUseItem => Player used item from inventory
--   - NUI:Client:InventoryDropItem => Player dropped item
--   - NUI:Client:InventorySwap    => Player swapped items between slots
--
-- ====================================================================================--

-- Player closes inventory
-- Sent from: nui/src/components/Inventory.vue
RegisterNUICallback('NUI:Client:InventoryClose', function(data, cb)
    ig.log.Trace("Inventory", "Inventory closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for inventory cleanup
    TriggerEvent("Client:Inventory:Close")
    
    cb({ok = true})
end)

-- Player uses item from inventory
-- Sent from: nui/src/components/Inventory.vue with item data
RegisterNUICallback('NUI:Client:InventoryUseItem', function(data, cb)
    if not data or not data.itemId or not data.quantity then
        ig.log.Error("Inventory", "NUI:Client:InventoryUseItem: missing item data")
        cb({ok = false, error = "Missing item data"})
        return
    end
    
    ig.log.Trace("Inventory", "Item used: " .. data.itemId .. " qty:" .. data.quantity)
    
    -- Send item use request to server
    TriggerServerEvent("Server:Inventory:UseItem", data.itemId, data.quantity)
    
    cb({ok = true})
end)

-- Player drops item from inventory
-- Sent from: nui/src/components/Inventory.vue with item data
RegisterNUICallback('NUI:Client:InventoryDropItem', function(data, cb)
    if not data or not data.itemId or not data.quantity then
        ig.log.Error("Inventory", "NUI:Client:InventoryDropItem: missing item data")
        cb({ok = false, error = "Missing item data"})
        return
    end
    
    ig.log.Trace("Inventory", "Item dropped: " .. data.itemId .. " qty:" .. data.quantity)
    
    -- Send drop request to server
    TriggerServerEvent("Server:Inventory:DropItem", data.itemId, data.quantity)
    
    cb({ok = true})
end)

-- Player swaps items between inventory slots
-- Sent from: nui/src/components/Inventory.vue with slot data
RegisterNUICallback('NUI:Client:InventorySwap', function(data, cb)
    if not data or not data.fromSlot or not data.toSlot then
        ig.log.Error("Inventory", "NUI:Client:InventorySwap: missing slot data")
        cb({ok = false, error = "Missing slot data"})
        return
    end
    
    ig.log.Trace("Inventory", "Items swapped: slot " .. data.fromSlot .. " <-> " .. data.toSlot)
    
    -- Send swap request to server
    TriggerServerEvent("Server:Inventory:SwapSlots", data.fromSlot, data.toSlot)
    
    cb({ok = true})
end)

-- Generic inventory action handler (for use, give, drop)
-- Sent from: nui/inventory/src/App.vue with action data
RegisterNUICallback('NUI:Client:InventoryAction', function(data, cb)
    if not data or not data.action or not data.item then
        ig.log.Error("Inventory", "NUI:Client:InventoryAction: missing action or item data")
        cb({ok = false, error = "Missing action or item data"})
        return
    end
    
    local action = data.action
    local item = data.item
    local position = data.position or 0
    local panelId = data.panelId or "player"
    
    ig.log.Trace("Inventory", string.format("Item action: %s on %s (pos: %d, panel: %s)", action, item.Item or "unknown", position, panelId))
    
    -- Route action to appropriate server event
    if action == "use" then
        TriggerServerEvent("Server:Inventory:UseItem", item.Item, item.Quantity or 1, position, panelId)
    elseif action == "give" then
        TriggerServerEvent("Server:Inventory:GiveItem", item.Item, item.Quantity or 1, position)
    elseif action == "drop" then
        TriggerServerEvent("Server:Inventory:DropItem", item.Item, item.Quantity or 1, position)
    else
        ig.log.Error("Inventory", "Unknown inventory action: " .. action)
        cb({ok = false, error = "Unknown action"})
        return
    end
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Inventory callbacks registered")
