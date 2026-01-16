-- ====================================================================================--
-- HUD CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for HUD system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.hud.Show(options)         => Client:NUI:HUDShow
--   - ig.nui.hud.Hide()                => Client:NUI:HUDHide
--   - ig.nui.hud.Update(hudData)       => Client:NUI:HUDUpdate
--   - ig.nui.hud.UpdateElement(key, value) => Client:NUI:HUDUpdateElement
--
-- ====================================================================================--

if not ig.nui then ig.nui = {} end
if not ig.nui.hud then ig.nui.hud = {} end

-- Show HUD
-- Called from: Client code to display HUD
function ig.nui.hud.Show(options)
    local focusHud = false  -- HUD doesn't require focus
    
    if options and options.focus ~= nil then
        focusHud = options.focus
    end
    
    ig.ui.Send("Client:NUI:HUDShow", {
        position = options and options.position or "bottom-left",
        scale = options and options.scale or 1.0
    }, focusHud)
end

-- Hide HUD
-- Called from: Client code or HUD toggle
function ig.nui.hud.Hide()
    ig.ui.Send("Client:NUI:HUDHide", {}, false)
end

-- Update entire HUD data
-- Called from: Status/stat updates
function ig.nui.hud.Update(hudData)
    ig.ui.Send("Client:NUI:HUDUpdate", {
        health = hudData and hudData.health or 100,
        armor = hudData and hudData.armor or 0,
        hunger = hudData and hudData.hunger or 100,
        thirst = hudData and hudData.thirst or 100,
        stress = hudData and hudData.stress or 0,
        cash = hudData and hudData.cash or 0,
        bank = hudData and hudData.bank or 0,
        job = hudData and hudData.job or "Unemployed",
        jobGrade = hudData and hudData.jobGrade or 0
    }, false)
end

-- Update specific HUD element
-- Called from: Individual stat changes
function ig.nui.hud.UpdateElement(key, value)
    ig.ui.Send("Client:NUI:HUDUpdateElement", {
        element = key,
        value = value
    }, false)
end

ig.log.Info("Client-NUI-Wrappers", "HUD wrapper functions loaded")
