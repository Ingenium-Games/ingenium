-- ====================================================================================--
-- Game Mode Specific Event Handlers
-- Consolidated handlers for different game modes (RP, DM, TDM, KOTH, FR, GG)
-- Migrated from ig.base
-- ====================================================================================--

-- ====================================================================================--
-- RP Mode Specific Handlers
-- ====================================================================================--

if conf.gamemode == "RP" then
    -- Additional RP-specific vehicle handlers can be added here
    -- These work in conjunction with the core vehicle tracking system
    
    AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, netId)
        -- RP-specific logic when entering vehicle
        ig.log.Trace("GameMode", "RP Mode: Entered vehicle " .. name)
        
        -- Example: Set player state for RP features
        if seat == -1 then
            -- Driver seat
            LocalPlayer.state:set("IsDriving", true, false)
        else
            -- Passenger
            LocalPlayer.state:set("IsPassenger", true, false)
        end
    end)
    
    AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, netId)
        -- RP-specific logic when leaving vehicle
        ig.log.Trace("GameMode", "RP Mode: Left vehicle " .. name)
        
        -- Clear vehicle-related states
        LocalPlayer.state:set("IsDriving", false, false)
        LocalPlayer.state:set("IsPassenger", false, false)
    end)
end

-- ====================================================================================--
-- DM/TDM Mode Specific Handlers
-- ====================================================================================--

if conf.gamemode == "DM" or conf.gamemode == "TDM" then
    -- Simplified vehicle handling for combat modes
    AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, netId)
        ig.log.Trace("GameMode", conf.gamemode .. " Mode: Entered vehicle " .. name)
        
        -- Combat mode specific logic
        -- Example: Restore armor when entering vehicle
        if modeSettings.restoreArmorInVehicle then
            SetPedArmour(PlayerPedId(), 100)
        end
    end)
    
    AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, netId)
        ig.log.Trace("GameMode", conf.gamemode .. " Mode: Left vehicle " .. name)
    end)
end

-- ====================================================================================--
-- KOTH (King of the Hill) Mode Specific Handlers
-- ====================================================================================--

if conf.gamemode == "KOTH" then
    AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, netId)
        ig.log.Trace("GameMode", "KOTH Mode: Entered vehicle " .. name)
        
        -- KOTH specific vehicle logic
    end)
    
    AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, netId)
        ig.log.Trace("GameMode", "KOTH Mode: Left vehicle " .. name)
    end)
end

-- ====================================================================================--
-- FR (Free Roam) Mode Specific Handlers
-- ====================================================================================--

if conf.gamemode == "FR" then
    AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, netId)
        ig.log.Trace("GameMode", "FR Mode: Entered vehicle " .. name)
        
        -- Free roam vehicle logic (similar to RP but less restrictive)
    end)
    
    AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, netId)
        ig.log.Trace("GameMode", "FR Mode: Left vehicle " .. name)
    end)
end

-- ====================================================================================--
-- GG (Gun Game) Mode Specific Handlers
-- ====================================================================================--

if conf.gamemode == "GG" then
    AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, netId)
        ig.log.Trace("GameMode", "GG Mode: Entered vehicle " .. name)
        
        -- Gun game typically disables vehicles or has special rules
    end)
    
    AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, netId)
        ig.log.Trace("GameMode", "GG Mode: Left vehicle " .. name)
    end)
end
