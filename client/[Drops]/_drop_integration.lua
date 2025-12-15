-- ====================================================================================--
-- Drop Integration: Client-side drop system integration
-- ====================================================================================--

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
    
    -- Create blip if not a dead drop
    if not isDeadDrop then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 478) -- Package icon
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 2) -- Green
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Drop Delivery")
        EndTextCommandSetBlipName(blip)
        
        -- Store blip reference for cleanup
        if not c.drop then c.drop = {} end
        if not c.drop.blips then c.drop.blips = {} end
        c.drop.blips[uuid] = blip
        
        c.func.Debug_3("Created blip for drop at (" .. coords.x .. ", " .. coords.y .. ", " .. coords.z .. ")")
    end
    
    -- Trigger hook for custom scripts (phone notifications, etc.)
    TriggerEvent('Client:Drop:Received', {
        coords = coords,
        isDeadDrop = isDeadDrop,
        netId = netId,
        uuid = uuid
    })
    
    c.func.Debug_1("Received drop notification" .. (isDeadDrop and " (dead drop)" or " (with blip)"))
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
    
    c.func.Debug_1("Access denied to restricted drop")
end)

--- Clean up blip when drop is removed
RegisterNetEvent('Client:Drop:Removed', function(uuid)
    if c.drop and c.drop.blips and c.drop.blips[uuid] then
        RemoveBlip(c.drop.blips[uuid])
        c.drop.blips[uuid] = nil
        c.func.Debug_3("Removed blip for drop " .. uuid)
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
            
            c.func.Debug_3("Drop inventory updated via State Bag for NetID: " .. tostring(netId))
        end
    end)
end)

--- Listen for real-time inventory updates from other players
--- Triggered when someone transfers items while UI is open
RegisterNetEvent('Client:Inventory:UpdateLive', function(fromNetId, toNetId)
    -- Check if we currently have an inventory UI open for either of these entities
    -- Use the export from inventory.lua
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

