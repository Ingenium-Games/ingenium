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
            
            -- Update the UI if inventory is currently open
            TriggerEvent("Client:Drop:InventoryUpdated", netId, value)
            
            c.func.Debug_3("Drop inventory updated via State Bag for NetID: " .. tostring(netId))
        end
    end)
end)

--- Listen for real-time inventory updates from other players
--- Triggered when someone transfers items while UI is open
RegisterNetEvent('Client:Inventory:UpdateLive', function(fromNetId, toNetId)
    -- Check if we currently have an inventory UI open for either of these entities
    local currentExternal = exports['ig.core']:GetCurrentExternalInventory()
    
    if currentExternal == fromNetId or currentExternal == toNetId then
        -- Fetch updated inventories from State Bags
        local fromEntity = NetworkGetEntityFromNetworkId(fromNetId)
        local toEntity = NetworkGetEntityFromNetworkId(toNetId)
        
        local fromInventory = nil
        local toInventory = nil
        
        if DoesEntityExist(fromEntity) then
            fromInventory = Entity(fromEntity).state.Inventory
        end
        
        if DoesEntityExist(toEntity) then
            toInventory = Entity(toEntity).state.Inventory
        end
        
        -- Update the NUI with fresh inventory data
        if fromInventory or toInventory then
            SendNUIMessage({
                message = "updateInventoryLive",
                data = {
                    fromNetId = fromNetId,
                    toNetId = toNetId,
                    fromInventory = fromInventory,
                    toInventory = toInventory
                }
            })
            
            c.func.Debug_3("Live inventory update sent to NUI")
        end
    end
end)

--- Event for when a drop's inventory is closed
RegisterNetEvent('Client:Drop:InventoryUpdated', function(netId, inventory)
    -- This event can be used for additional UI updates if needed
    -- The inventory UI handles updates via State Bags automatically
end)

--- Export to get current external inventory NetID (for live update detection)
exports('GetCurrentExternalInventory', function()
    -- This would be tracked in the inventory.lua file
    return currentExternalNetId or nil
end)

