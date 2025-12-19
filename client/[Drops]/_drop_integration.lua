-- ====================================================================================--
-- Drop Integration: Client-side drop system integration
-- ====================================================================================--

-- Table to store blip handles for targeted drops (using existing ig.blips system)
local dropBlipHandles = {}

--- Handle drop notification for targeted drops
RegisterNetEvent('Client:Drop:Notify', function(data)
    local coords = data.coords
    local isDeadDrop = data.isDeadDrop
    local netId = data.netId
    local uuid = data.uuid
    
    -- Send NUI notification
    SendNUIMessage({
        message = "dropNotification",
        data = {
            title = isDeadDrop and "Dead Drop" or "Drop Delivery",
            description = isDeadDrop and "A package has been left for you" or "A drop has been marked on your map",
            coords = coords,
            isDeadDrop = isDeadDrop
        }
    })
    
    -- Create blip if not a dead drop using the existing blip system
    if not isDeadDrop then
        local blipHandle = ig.blip.CreateBlip(
            vector3(coords.x, coords.y, coords.z),
            478,  -- Package icon sprite
            2,    -- Green color
            "Drop Delivery",
            0.8,  -- Scale
            nil,  -- No flash
            nil,  -- No fade
            false, -- Not short range (visible from distance)
            true,  -- High detail
            4,     -- Display type
            1,     -- Category
            false  -- Not hidden on legend
        )
        
        -- Store blip handle for cleanup
        dropBlipHandles[uuid] = blipHandle
        
        ig.func.Debug_3("Created blip for drop at (" .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ")")
    end
    
    -- Trigger hook for custom scripts (phone notifications, etig.)
    TriggerEvent('Client:Drop:Received', {
        coords = coords,
        isDeadDrop = isDeadDrop,
        netId = netId,
        uuid = uuid
    })
    
    ig.func.Debug_1("Received drop notification" .. (isDeadDrop and " (dead drop)" or " (with blip)"))
end)

--- Handle access denied
RegisterNetEvent('Client:Drop:AccessDenied', function(data)
    -- Send NUI notification
    SendNUIMessage({
        message = "notification",
        data = {
            type = "error",
            title = "Access Denied",
            description = data.message or "This drop is not for you"
        }
    })
    
    ig.func.Debug_1("Access denied to restricted drop")
end)

--- Clean up blip when drop is removed
RegisterNetEvent('Client:Drop:Removed', function(uuid)
    if dropBlipHandles[uuid] then
        ig.blip.Remove(dropBlipHandles[uuid])
        dropBlipHandles[uuid] = nil
        ig.func.Debug_3("Removed blip for drop " .. uuid)
    end
end)

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
        
        -- Check if this is a drop (model hash comparison - backtick notation auto-hashes)
        local model = GetEntityModel(entityId)
        if model == conf.drops.default_model then
            local netId = NetworkGetNetworkIdFromEntity(entityId)
            
            -- Update the UI if inventory is currently open
            TriggerEvent("Client:Drop:InventoryUpdated", netId, value)
            
            ig.func.Debug_3("Drop inventory updated via State Bag for NetID: " .. tostring(netId))
        end
    end)
end)

--- Listen for real-time inventory updates from other players
--- Triggered when someone transfers items while UI is open
RegisterNetEvent('Client:Inventory:UpdateLive', function(fromNetId, toNetId)
    -- Check if we currently have an inventory UI open for either of these entities
    -- Use the export from inventory.lua
    local currentExternal = exports['ingenium']:GetCurrentExternalInventory()
    
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
            
            ig.func.Debug_3("Live inventory update sent to NUI")
        end
    end
end)

--- Event for when a drop's inventory is closed
RegisterNetEvent('Client:Drop:InventoryUpdated', function(netId, inventory)
    -- This event can be used for additional UI updates if needed
    -- The inventory UI handles updates via State Bags automatically
end)

