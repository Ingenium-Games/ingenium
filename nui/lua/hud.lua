-- ====================================================================================--
-- HUD Control System - Client-Side Integration
-- Manages HUD positioning, focus states, and drag mode toggling
-- ====================================================================================--

hudFocused = false
local hudPosition = { x = 20, y = 0 }

-- Calculate initial HUD Y position (bottom-left area)
Citizen.CreateThread(function()
    Wait(100)
    hudPosition.y = GetScreenResolution() - 120
end)

-- ====================================================================================--
-- HUD Focus Toggle Command
-- ====================================================================================--

--- Toggle HUD focus/drag mode
--- When focused, HUD appears on top of other UI elements and is highlighted
--- When unfocused, HUD returns to normal z-index and can be hidden by other menus
RegisterCommand('toggleHudFocus', function()
    hudFocused = not hudFocused
    -- Send message to NUI
    SendNUIMessage({
        message = "Client:NUI:HUDFocus",
        data = { 
            focused = hudFocused,
            timestamp = GetGameTimer(),
            focusKey = conf.hud.focusKey
        }
    })
    -- Set NUI focus: cursor captured when focused (for dragging), keyboard never captured (allows command to work)
    SetNuiFocus(hudFocused, false)
    -- Trigger event for other resources to hook into
    -- NOTE: This event is currently triggered but has no registered handlers
    -- TODO: If HUD focus state needs to be consumed by other systems, add handlers
    TriggerEvent("Client:HUD:FocusToggled", hudFocused)
end, false)

-- Register the key mapping with FiveM
-- Users can customize this in their FiveM keybinding settings
if conf.hud.focusKey then
    RegisterKeyMapping(
        'toggleHudFocus',
        'Toggle HUD Drag Mode',
        'keyboard',
        conf.hud.focusKey:lower()
    )
end

-- ====================================================================================--
-- HUD Position Sync - CALLBACK MOVED TO NUI-Client
-- ====================================================================================--
-- HUDPositionUpdate callback moved to nui/lua/NUI-Client/_hud.lua
-- This file now contains wrapper functions and exports only
-- ====================================================================================--

-- ====================================================================================--
-- HUD Reset Command
-- ====================================================================================--

--- Reset HUD to default position (bottom-left)
RegisterCommand('resetHudPosition', function()
    hudPosition = { x = 20, y = 0 }
    
    -- Request HUD to reset
    SendNUIMessage({
        message = "Client:NUI:HUDResetPosition",
        data = { }
    })
    
    ig.log.Info("HUD", "HUD position reset to default")
    
    -- NOTE: This event is currently triggered but has no registered handlers
    -- TODO: If HUD position reset needs to be consumed by other systems, add handlers
    TriggerEvent("Client:HUD:PositionReset", hudPosition)
end, false)

-- ====================================================================================--
-- Exports
-- ====================================================================================--

--- Check if HUD is currently in focus/drag mode
exports('IsHudFocused', function()
    return hudFocused
end)

--- Programmatically toggle HUD focus
exports('ToggleHudFocus', function()
    TriggerCommand('toggleHudFocus')
end)

--- Get current HUD position
exports('GetHudPosition', function()
    return hudPosition
end)

--- Set HUD position programmatically
exports('SetHudPosition', function(x, y)
    hudPosition = { x = x, y = y }
    SendNUIMessage({
        message = "Client:NUI:HUDSetPosition",
        data = { position = { x = x, y = y } }
    })
end)

-- ====================================================================================--
-- Event Handlers
-- ====================================================================================--

--- Listen for menu opens - potentially auto-unfocus HUD when user interacts with menus
RegisterNetEvent("Client:Banking:OpenMenu", function()
    if hudFocused and conf.hud.autoUnfocusOnMenuOpen then
        hudFocused = false
        SendNUIMessage({
            message = "Client:NUI:HUDFocus",
            data = { focused = false }
        })
    end
end)

-- ====================================================================================--
-- Configuration Validation
-- ====================================================================================--

if not conf.hud then
    ig.log.Warn("HUD", "HUD configuration not found, using defaults")
    conf.hud = {
        focusKey = "F2",
        allowDragging = true,
        persistPosition = true,
        enableFocusHighlight = true,
        normalZIndex = 100,
        focusedZIndex = 1001
    }
end

if conf.hud.allowDragging then
    ig.log.Info("HUD", string.format("HUD dragging enabled - Focus key: %s", conf.hud.focusKey or "None"))
else
    ig.log.Info("HUD", "HUD dragging disabled by configuration")
end
