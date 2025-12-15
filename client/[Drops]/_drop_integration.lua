-- ====================================================================================--
-- Drop Integration: Client-side drop system integration
-- ====================================================================================--

--- Handle State Bag changes for drop inventories
--- This provides real-time updates when other players modify the drop
CreateThread(function()
    AddStateBagChangeHandler('Inventory', nil, function(bagName, key, value, reserved, replicated)
        -- Only handle if it's an entity state bag and not from this client
        if not replicated then return end
        
        -- Extract entity from bag name (e.g., "entity:12345")
        local entityId = tonumber(bagName:gsub('entity:', ''), 10)
        if not entityId then return end
        
        local entity = Entity(entityId)
        if not entity or not entity.state then return end
        
        -- Check if this is a drop (compare model hash directly)
        local model = GetEntityModel(entityId)
        if model == conf.drops.default_model then
            local netId = NetworkGetNetworkIdFromEntity(entityId)
            
            -- If the inventory UI is open for this drop, update it
            TriggerEvent("Client:Drop:InventoryUpdated", netId, value)
            
            c.func.Debug_3("Drop inventory updated for NetID: " .. tostring(netId))
        end
    end)
end)

--- Listen for when a drop's inventory is closed
--- This is triggered by the NUI inventory system
RegisterNetEvent('Client:Drop:InventoryUpdated', function(netId, inventory)
    -- This event can be used for additional UI updates if needed
    -- The inventory UI handles updates via Client:Inventory:Update automatically
end)

