-- ====================================================================================--
-- HUD Control System - Client-Side Integration
-- Manages HUD positioning, focus states, and drag mode toggling
-- ====================================================================================--

local hudFocused = false
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
            timestamp = GetGameTimer()
        }
    })
    
    -- Log state change
    if hudFocused then
        ig.log.Info("HUD", "HUD focus enabled - drag mode active")
    else
        ig.log.Info("HUD", "HUD focus disabled - drag mode inactive")
    end
    
    -- Trigger event for other resources to hook into
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
-- HUD Position Sync
-- ====================================================================================--

--- Update HUD position when dragged in NUI
RegisterNUICallback("NUI:Client:HUDPositionUpdate", function(data, cb)
    if data.position then
        hudPosition = data.position
        
        -- Save to localStorage via NUI (already handled by HUD.vue)
        -- We just need to track server-side if needed
        TriggerEvent("Client:HUD:PositionChanged", hudPosition)
    end
    
    cb({
        message = "ok",
        data = nil
    })
end)

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
