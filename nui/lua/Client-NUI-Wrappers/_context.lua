-- ====================================================================================--
-- CONTEXT MENU CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for context menu system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.context.Show(options, actions)  => Client:NUI:ContextShow
--   - ig.nui.context.Hide()                  => Client:NUI:ContextHide
--
-- ====================================================================================--

if not ig.nui then ig.nui = {} end
if not ig.nui.context then ig.nui.context = {} end

-- Show context menu
-- Called from: Client code (targeting, interactions)
function ig.nui.context.Show(options, actions)
    local focusContext = true
    
    if options and options.focus ~= nil then
        focusContext = options.focus
    end
    
    ig.ui.Send("Client:NUI:ContextShow", {
        options = options or {},
        actions = actions or {},
        x = options and options.x or 0,
        y = options and options.y or 0
    }, focusContext)
end

-- Hide context menu
-- Called from: Client code or context close callback
function ig.nui.context.Hide()
    ig.ui.Send("Client:NUI:ContextHide", {}, false)
end

ig.log.Info("Client-NUI-Wrappers", "Context menu wrapper functions loaded")
