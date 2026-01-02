-- ====================================================================================--
ig.pick = {} -- function level
ig.picks = {} -- dropped items table
-- ====================================================================================--

---Create a new pickup at coordinates
---@param coords table Coordinates {x, y, z, h}
---@param model number Model hash
---@param event string|nil Event to trigger on pickup
---@param data table|nil Additional data
---@return string UUID of created pickup
function ig.pick.Create(coords, model, event, data)
    local uuid = ig.rng.UUID()
    
    local pickup = {
        UUID = uuid,
        Coords = coords,
        Model = model,
        Time = os.time(),
        Event = event,
        Data = data or {},
        Active = true
    }
    
    ig.picks[uuid] = pickup
    
    -- Sync to clients
    TriggerClientEvent("Client:Pickups:Add", -1, pickup)
    
    ig.func.Debug_2("Created pickup " .. uuid .. " at " .. json.encode(coords))
    
    return uuid
end

---Remove a pickup by UUID
---@param uuid string Pickup UUID
---@return boolean True if removed
function ig.pick.Remove(uuid)
    if ig.picks[uuid] then
        ig.picks[uuid] = nil
        
        -- Sync to clients
        TriggerClientEvent("Client:Pickups:Remove", -1, uuid)
        
        ig.func.Debug_2("Removed pickup " .. uuid)
        return true
    end
    
    return false
end

---Get pickup by UUID
---@param uuid string Pickup UUID
---@return table|nil Pickup data or nil
function ig.pick.GetByUUID(uuid)
    return ig.picks[uuid]
end

---Get all pickups
---@return table All pickups
function ig.pick.GetAll()
    return ig.picks
end

---Get pickups near coordinates
---@param coords vector3 Center coordinates
---@param radius number Search radius
---@return table Array of nearby pickups
function ig.pick.GetNearby(coords, radius)
    local nearby = {}
    
    for uuid, pickup in pairs(ig.picks) do
        if pickup.Coords and pickup.Active then
            local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(pickup.Coords.x, pickup.Coords.y, pickup.Coords.z))
            if dist <= radius then
                table.insert(nearby, {uuid = uuid, pickup = pickup, distance = dist})
            end
        end
    end
    
    -- Sort by distance
    table.sort(nearby, function(a, b) return a.distance < b.distance end)
    
    return nearby
end

---Get pickups by model
---@param model number Model hash
---@return table Array of pickups with model
function ig.pick.GetByModel(model)
    local result = {}
    
    for uuid, pickup in pairs(ig.picks) do
        if pickup.Model == model then
            table.insert(result, {uuid = uuid, pickup = pickup})
        end
    end
    
    return result
end

---Deactivate a pickup (temporarily disable)
---@param uuid string Pickup UUID
---@param duration number|nil Duration in ms (permanent if nil)
---@return boolean True if deactivated
function ig.pick.Deactivate(uuid, duration)
    local pickup = ig.picks[uuid]
    if not pickup then
        return false
    end
    
    pickup.Active = false
    
    -- Sync to clients
    TriggerClientEvent("Client:Pickups:Update", -1, uuid, pickup)
    
    if duration then
        -- Reactivate after duration
        SetTimeout(duration, function()
            ig.pick.Activate(uuid)
        end)
    end
    
    ig.func.Debug_3("Deactivated pickup " .. uuid .. (duration and (" for " .. duration .. "ms") or " permanently"))
    
    return true
end

---Activate a pickup
---@param uuid string Pickup UUID
---@return boolean True if activated
function ig.pick.Activate(uuid)
    local pickup = ig.picks[uuid]
    if not pickup then
        return false
    end
    
    pickup.Active = true
    
    -- Sync to clients
    TriggerClientEvent("Client:Pickups:Update", -1, uuid, pickup)
    
    ig.func.Debug_3("Activated pickup " .. uuid)
    
    return true
end

---Check if pickup is active
---@param uuid string Pickup UUID
---@return boolean True if active
function ig.pick.IsActive(uuid)
    local pickup = ig.picks[uuid]
    return pickup and pickup.Active or false
end

---Get pickup count
---@return number Total pickups, number Active pickups
function ig.pick.GetCount()
    local total = 0
    local active = 0
    
    for _, pickup in pairs(ig.picks) do
        total = total + 1
        if pickup.Active then
            active = active + 1
        end
    end
    
    return total, active
end

---Cleanup old pickups
---@param maxAge number|nil Max age in seconds (uses config if nil)
---@return number Number of pickups removed
function ig.pick.CleanupOld(maxAge)
    local maxAge = maxAge or conf.file.cleanup
    local now = os.time()
    local removed = 0
    
    for uuid, pickup in pairs(ig.picks) do
        if pickup.Time and (now - pickup.Time) >= maxAge then
            ig.pick.Remove(uuid)
            removed = removed + 1
        end
    end
    
    if removed > 0 then
        ig.func.Debug_2("Cleaned up " .. removed .. " old pickups")
    end
    
    return removed
end

---Update pickup data
---@param uuid string Pickup UUID
---@param data table New data to merge
---@return boolean True if updated
function ig.pick.UpdateData(uuid, data)
    local pickup = ig.picks[uuid]
    if not pickup then
        return false
    end
    
    for k, v in pairs(data) do
        pickup[k] = v
    end
    
    -- Sync to clients
    TriggerClientEvent("Client:Pickups:Update", -1, uuid, pickup)
    
    return true
end

---Get pickups by event name
---@param eventName string Event name to search for
---@return table Array of pickups with event
function ig.pick.GetByEvent(eventName)
    local result = {}
    
    for uuid, pickup in pairs(ig.picks) do
        if pickup.Event == eventName then
            table.insert(result, {uuid = uuid, pickup = pickup})
        end
    end
    
    return result
end

---Create a loot pickup (common pattern)
---@param coords table Coordinates
---@param items table Array of items to give
---@param model number|nil Model hash (uses default if nil)
---@param respawnTime number|nil Respawn time in ms (no respawn if nil)
---@return string UUID of created pickup
function ig.pick.CreateLoot(coords, items, model, respawnTime)
    local model = model or conf.drops.default_model
    
    local uuid = ig.pick.Create(coords, model, "Server:Pickup:Loot", {
        items = items,
        respawnTime = respawnTime
    })
    
    return uuid
end

---Handle pickup collection
---@param source number Player source
---@param uuid string Pickup UUID
---@return boolean True if collected
function ig.pick.Collect(source, uuid)
    local pickup = ig.picks[uuid]
    if not pickup or not pickup.Active then
        return false
    end
    
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        return false
    end
    
    -- Trigger event if set
    if pickup.Event then
        TriggerEvent(pickup.Event, source, uuid, pickup.Data)
    end
    
    -- Handle loot pickup
    if pickup.Data and pickup.Data.items then
        for _, item in ipairs(pickup.Data.items) do
            xPlayer.AddItem(item)
        end
    end
    
    -- Deactivate or remove
    if pickup.Data and pickup.Data.respawnTime then
        ig.pick.Deactivate(uuid, pickup.Data.respawnTime)
    else
        ig.pick.Remove(uuid)
    end
    
    ig.func.Debug_3("Player " .. source .. " collected pickup " .. uuid)
    
    return true
end

---Create pickup zone (area with multiple pickups)
---@param center table Center coordinates
---@param radius number Spawn radius
---@param count number Number of pickups to create
---@param models table Array of model hashes
---@param data table Pickup data
---@return table Array of created UUIDs
function ig.pick.CreateZone(center, radius, count, models, data)
    local created = {}
    
    for i = 1, count do
        -- Random position in radius
        local angle = math.random() * 2 * math.pi
        local distance = math.random() * radius
        
        local coords = {
            x = center.x + (math.cos(angle) * distance),
            y = center.y + (math.sin(angle) * distance),
            z = center.z,
            h = math.random(0, 360)
        }
        
        -- Random model
        local model = models[math.random(1, #models)]
        
        local uuid = ig.pick.Create(coords, model, data.event, data)
        table.insert(created, uuid)
    end
    
    ig.func.Debug_2("Created pickup zone with " .. count .. " pickups")
    
    return created
end

---Validate pickup data
---@param pickup table Pickup data to validate
---@return boolean, string True if valid, or false with error
function ig.pick.ValidateData(pickup)
    if type(pickup) ~= "table" then
        return false, "Pickup data must be a table"
    end
    
    if not pickup.UUID or type(pickup.UUID) ~= "string" then
        return false, "Missing or invalid UUID"
    end
    
    if not pickup.Coords or type(pickup.Coords) ~= "table" then
        return false, "Missing or invalid Coords"
    end
    
    if not pickup.Model or type(pickup.Model) ~= "number" then
        return false, "Missing or invalid Model"
    end
    
    return true, "Valid"
end

---Resync all pickups to clients
function ig.pick.ResyncAll()
    TriggerClientEvent("Client:Pickups:Sync", -1, ig.picks)
    ig.func.Debug_2("Resynced all pickups to clients")
end

-- Register collection event
-- Migrated to callback for security
RegisterServerCallback({
    eventName = "Server:Pickup:Collect",
    eventCallback = function(source, uuid)
        ig.pick.Collect(source, uuid)
        return { success = true }
    end
})