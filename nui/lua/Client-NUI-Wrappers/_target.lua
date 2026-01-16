-- ====================================================================================--
-- TARGET CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for target/interaction system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.target.Show(targetData, actions)  => Client:NUI:TargetShow
--   - ig.nui.target.Hide()                     => Client:NUI:TargetHide
--
-- ====================================================================================--

if not ig.nui then ig.nui = {} end
if not ig.nui.target then ig.nui.target = {} end

-- Show target menu
-- Called from: Target system when player looks at interactive entity
function ig.nui.target.Show(targetData, actions)
    local focusTarget = true
    
    if targetData and targetData.focus ~= nil then
        focusTarget = targetData.focus
    end
    
    ig.ui.Send("Client:NUI:TargetShow", {
        entity = targetData and targetData.entity or 0,
        entityType = targetData and targetData.entityType or "unknown",
        label = targetData and targetData.label or "Interact",
        actions = actions or {}
    }, focusTarget)
end

-- Hide target menu
-- Called from: Target close callback or client code
function ig.nui.target.Hide()
    ig.ui.Send("Client:NUI:TargetHide", {}, false)
end

ig.log.Info("Client-NUI-Wrappers", "Target wrapper functions loaded")
