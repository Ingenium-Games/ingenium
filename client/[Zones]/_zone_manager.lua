-- ====================================================================================--
-- Consolidated Zone Manager
-- Single thread to manage all zone enter/exit callbacks
-- Reduces thread overhead by consolidating per-zone threads into one manager
-- ====================================================================================--

-- Zone manager namespace
local ZoneManager = {
    zones = {},           -- Registered zones with callbacks
    isRunning = false,    -- Manager thread status
    checkInterval = 250,  -- Check interval in ms (configurable)
    lastStates = {}       -- Track last inside/outside state per zone
}

-- Register a zone with its callback
-- This replaces the need for zone:onPlayerInOut() creating individual threads
---@param zone table Zone object (PolyZone, BoxZone, CircleZone, etc.)
---@param callback function Callback(isInside, point, zone)
---@param getPointFunc function|nil Optional function to get point (defaults to player position)
---@param checkInterval number|nil Optional check interval override (ms)
---@return string zoneId Unique ID for this zone registration
function ZoneManager.RegisterZone(zone, callback, getPointFunc, checkInterval)
    if not zone then
        ig.log.Error("ZONES", "Cannot register nil zone")
        return nil
    end
    
    -- Generate unique ID for this zone registration
    local zoneId = tostring(zone) .. "_" .. tostring(GetGameTimer())
    
    -- Store zone data
    ZoneManager.zones[zoneId] = {
        zone = zone,
        callback = callback,
        getPoint = getPointFunc or PolyZone.getPlayerPosition,
        checkInterval = checkInterval or ZoneManager.checkInterval,
        lastCheck = 0,
        isInside = false
    }
    
    -- Initialize last state
    ZoneManager.lastStates[zoneId] = false
    
    -- Start manager if not already running
    if not ZoneManager.isRunning then
        ZoneManager.Start()
    end
    
    return zoneId
end

-- Unregister a zone
---@param zoneId string Zone ID from RegisterZone
---@return boolean success True if unregistered
function ZoneManager.UnregisterZone(zoneId)
    if ZoneManager.zones[zoneId] then
        ZoneManager.zones[zoneId] = nil
        ZoneManager.lastStates[zoneId] = nil
        return true
    end
    return false
end

-- Start the consolidated zone checking thread
function ZoneManager.Start()
    if ZoneManager.isRunning then
        return
    end
    
    ZoneManager.isRunning = true
    
    Citizen.CreateThread(function()
        while ZoneManager.isRunning do
            local currentTime = GetGameTimer()
            local anyZonesActive = false
            
            -- Check all registered zones
            for zoneId, zoneData in pairs(ZoneManager.zones) do
                anyZonesActive = true
                
                -- Check if it's time to evaluate this zone based on its interval
                if (currentTime - zoneData.lastCheck) >= zoneData.checkInterval then
                    zoneData.lastCheck = currentTime
                    
                    -- Skip destroyed zones
                    if not zoneData.zone.destroyed and not zoneData.zone.paused then
                        -- Get current position
                        local point = zoneData.getPoint()
                        
                        -- Check if inside zone
                        local isInside = zoneData.zone:isPointInside(point)
                        
                        -- Only trigger callback on state change
                        if isInside ~= ZoneManager.lastStates[zoneId] then
                            ZoneManager.lastStates[zoneId] = isInside
                            
                            -- Call the callback
                            if zoneData.callback then
                                zoneData.callback(isInside, point, zoneData.zone)
                            end
                        end
                    end
                end
            end
            
            -- If no zones are registered, stop the manager
            if not anyZonesActive then
                ZoneManager.isRunning = false
                ig.log.Debug("ZONES", "No active zones, stopping manager")
                break
            end
            
            -- Wait based on the shortest interval to check
            -- Most zones use 500ms, but we check more frequently to be responsive
            Wait(ZoneManager.checkInterval)
        end
    end)
    
    ig.log.Info("ZONES", "Started consolidated zone manager")
end

-- Stop the zone manager
function ZoneManager.Stop()
    ZoneManager.isRunning = false
end

-- Get statistics about registered zones
---@return table stats Statistics about zone manager
function ZoneManager.GetStats()
    local count = 0
    local byType = {}
    
    for zoneId, zoneData in pairs(ZoneManager.zones) do
        count = count + 1
        
        local zoneType = "unknown"
        if zoneData.zone.isPolyZone then
            zoneType = "PolyZone"
        elseif zoneData.zone.isBoxZone then
            zoneType = "BoxZone"
        elseif zoneData.zone.isCircleZone then
            zoneType = "CircleZone"
        elseif zoneData.zone.isEntityZone then
            zoneType = "EntityZone"
        elseif zoneData.zone.isComboZone then
            zoneType = "ComboZone"
        end
        
        byType[zoneType] = (byType[zoneType] or 0) + 1
    end
    
    return {
        totalZones = count,
        byType = byType,
        isRunning = ZoneManager.isRunning,
        checkInterval = ZoneManager.checkInterval
    }
end

-- Set the default check interval
---@param interval number Interval in milliseconds
function ZoneManager.SetCheckInterval(interval)
    ZoneManager.checkInterval = interval
end

-- ====================================================================================--
-- Replace legacy PolyZone functions to use consolidated manager
-- This replaces the old per-zone thread approach with the consolidated manager
-- ====================================================================================--

-- Replace PolyZone:onPointInOut with managed version
function PolyZone:onPointInOut(getPointCb, onPointInOutCb, waitInMS)
    self._managedZoneId = ZoneManager.RegisterZone(self, onPointInOutCb, getPointCb, waitInMS)
end

-- Replace PolyZone:onPlayerInOut with managed version
function PolyZone:onPlayerInOut(onPointInOutCb, waitInMS)
    local getPoint = PolyZone.getPlayerPosition
    self._managedZoneId = ZoneManager.RegisterZone(self, onPointInOutCb, getPoint, waitInMS)
end

-- Replace ComboZone functions if available
if ComboZone then
    function ComboZone:onPointInOut(getPointCb, onPointInOutCb, waitInMS)
        self._managedZoneId = ZoneManager.RegisterZone(self, onPointInOutCb, getPointCb, waitInMS)
    end
    
    function ComboZone:onPlayerInOut(onPointInOutCb, waitInMS)
        local getPoint = PolyZone.getPlayerPosition
        self._managedZoneId = ZoneManager.RegisterZone(self, onPointInOutCb, getPoint, waitInMS)
    end
    
    -- Note: onPlayerInOutExhaustive and onPointInOutExhaustive are not replaced
    -- as they have different callback signatures with multiple zones
    -- These can be added if needed in the future
end

-- Destroy override to unregister from manager
local originalPolyZoneDestroy = PolyZone.destroy
function PolyZone:destroy()
    if self._managedZoneId then
        ZoneManager.UnregisterZone(self._managedZoneId)
        self._managedZoneId = nil
    end
    originalPolyZoneDestroy(self)
end

-- Export the zone manager
ig.zoneManager = ZoneManager

-- Command to check zone manager stats
RegisterCommand('zonestats', function()
    local stats = ZoneManager.GetStats()
    ig.log.Debug("ZONES", "=== Zone Manager Statistics ===")
    ig.log.Debug("ZONES", "Total Zones: %d", stats.totalZones)
    ig.log.Debug("ZONES", "Manager Running: %s", tostring(stats.isRunning))
    ig.log.Debug("ZONES", "Check Interval: %d ms", stats.checkInterval)
    ig.log.Debug("ZONES", "Zones by Type:")
    for zoneType, count in pairs(stats.byType) do
        ig.log.Debug("ZONES", "  %s: %d", zoneType, count)
    end
    ig.log.Debug("ZONES", "==============================")
end, false)

-- Command to list all client zones with details
RegisterCommand('listzones', function()
    local zoneCount = 0
    ig.log.Debug("ZONES", "=== Client Zone List ===")
    
    for zoneId, zoneData in pairs(ZoneManager.zones) do
        zoneCount = zoneCount + 1
        local zone = zoneData.zone
        
        -- Determine zone type
        local zoneType = "Unknown"
        if zone.isPolyZone then
            zoneType = "PolyZone"
        elseif zone.isBoxZone then
            zoneType = "BoxZone"
        elseif zone.isCircleZone then
            zoneType = "CircleZone"
        elseif zone.isEntityZone then
            zoneType = "EntityZone"
        elseif zone.isComboZone then
            zoneType = "ComboZone"
        end
        
        -- Get zone name
        local zoneName = zone.name or "Unnamed"
        
        -- Get current state
        local isInside = ZoneManager.lastStates[zoneId] or false
        local stateStr = isInside and "^2INSIDE^7" or "^1OUTSIDE^7"
        
        -- Get check interval
        local interval = zoneData.checkInterval or "N/A"
        
        -- Get zone status
        local isPaused = zone.paused and "^3PAUSED^7" or "^2ACTIVE^7"
        local isDestroyed = zone.destroyed and "^1DESTROYED^7" or "^2VALID^7"
        
        ig.log.Debug("ZONES", "Zone #%d:", zoneCount)
        ig.log.Debug("ZONES", "  Name: %s", zoneName)
        ig.log.Debug("ZONES", "  Type: %s", zoneType)
        ig.log.Debug("ZONES", "  State: %s", stateStr)
        ig.log.Debug("ZONES", "  Interval: %sms", interval)
        ig.log.Debug("ZONES", "  Status: %s / %s", isPaused, isDestroyed)
        
        -- Additional info for specific zone types
        if zone.center then
            ig.log.Debug("ZONES", "  Center: %.2f, %.2f, %.2f", zone.center.x or 0, zone.center.y or 0, zone.center.z or 0)
        end
        
        if zone.radius then
            ig.log.Debug("ZONES", "  Radius: %.2f", zone.radius)
        end
        
        if zone.length and zone.width then
            ig.log.Debug("ZONES", "  Dimensions: %.2f x %.2f", zone.length, zone.width)
        end
        
        if zone.heading then
            ig.log.Debug("ZONES", "  Heading: %.2f", zone.heading)
        end
        
        ig.log.Debug("ZONES", "  ---")
    end
    
    if zoneCount == 0 then
        ig.log.Debug("ZONES", "No zones registered for this client")
    else
        ig.log.Debug("ZONES", "Total: %d zones", zoneCount)
    end
    
    ig.log.Debug("ZONES", "========================")
end, false)

-- Debug info
ig.log.Info("ZONES", "Consolidated zone manager loaded")
ig.log.Info("ZONES", "Replaced onPlayerInOut() and onPointInOut() to use consolidated manager")
ig.log.Info("ZONES", "All zones now automatically use single-thread management")
ig.log.Info("ZONES", "Type /zonestats to see zone manager statistics")
ig.log.Info("ZONES", "Type /listzones to list all active zones")
