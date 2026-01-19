-- ====================================================================================--
-- Game Mode Specific Event Handlers
-- Consolidated handlers for different game modes (RP, DM, TDM, KOTH, FR, GG)
-- Uses registry pattern to avoid code duplication
-- ====================================================================================--

-- ====================================================================================--
-- Game Mode Handler Registry
-- ====================================================================================--

local gameModeHandlers = {
    RP = {
        onEnteredVehicle = function(vehicle, seat, name, netId)
            -- Set player state for RP features
            if seat == -1 then
                -- Driver seat
                LocalPlayer.state:set("IsDriving", true, false)
            else
                -- Passenger
                LocalPlayer.state:set("IsPassenger", true, false)
            end
        end,
        onLeftVehicle = function(vehicle, seat, name, netId)
            -- Clear vehicle-related states
            LocalPlayer.state:set("IsDriving", false, false)
            LocalPlayer.state:set("IsPassenger", false, false)
        end
    },
    DM = {
        onEnteredVehicle = function(vehicle, seat, name, netId)
            -- Combat mode specific logic
            -- Example: Restore armor when entering vehicle
            if modeSettings and modeSettings.restoreArmorInVehicle then
                SetPedArmour(PlayerPedId(), 100)
            end
        end,
        onLeftVehicle = function(vehicle, seat, name, netId)
            -- No special handling for DM mode exit
        end
    },
    TDM = {
        -- TDM uses same handlers as DM
        -- Will be resolved by looking up DM if not found
    },
    KOTH = {
        onEnteredVehicle = function(vehicle, seat, name, netId)
            -- KOTH specific vehicle logic can be added here
        end,
        onLeftVehicle = function(vehicle, seat, name, netId)
            -- KOTH specific exit logic can be added here
        end
    },
    FR = {
        onEnteredVehicle = function(vehicle, seat, name, netId)
            -- Free roam vehicle logic (similar to RP but less restrictive)
        end,
        onLeftVehicle = function(vehicle, seat, name, netId)
            -- Free roam exit logic
        end
    },
    GG = {
        onEnteredVehicle = function(vehicle, seat, name, netId)
            -- Gun game typically disables vehicles or has special rules
        end,
        onLeftVehicle = function(vehicle, seat, name, netId)
            -- Gun game exit logic
        end
    }
}

-- TDM shares handlers with DM (reference copy for clarity)
-- If handlers need to be modified at runtime, use shallow copy instead:
-- gameModeHandlers.TDM = {onEnteredVehicle = gameModeHandlers.DM.onEnteredVehicle, ...}
gameModeHandlers.TDM = gameModeHandlers.DM

-- ====================================================================================--
-- Unified Event Handlers
-- ====================================================================================--

-- Get current gamemode handlers or use no-op fallbacks
local currentHandlers = gameModeHandlers[conf.gamemode] or {}

-- Vehicle enter handler
AddEventHandler("Client:EnteredVehicle", function(vehicle, seat, name, netId)
    -- Log vehicle entry (unified logging)
    ig.log.Trace("GameMode", string.format("%s Mode: Entered vehicle %s", conf.gamemode, name))
    
    -- Execute mode-specific logic
    if currentHandlers.onEnteredVehicle then
        currentHandlers.onEnteredVehicle(vehicle, seat, name, netId)
    end
end)

-- Vehicle exit handler
AddEventHandler("Client:LeftVehicle", function(vehicle, seat, name, netId)
    -- Log vehicle exit (unified logging)
    ig.log.Trace("GameMode", string.format("%s Mode: Left vehicle %s", conf.gamemode, name))
    
    -- Execute mode-specific logic
    if currentHandlers.onLeftVehicle then
        currentHandlers.onLeftVehicle(vehicle, seat, name, netId)
    end
end)
