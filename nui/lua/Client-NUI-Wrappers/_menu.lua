-- ====================================================================================--
-- MENU CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for menu system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.menu.Show(items, options)     => Client:NUI:MenuShow
--   - ig.nui.menu.Hide()                   => Client:NUI:MenuHide
--
-- ====================================================================================--

-- Show menu with items
-- Called from: Client code to display menu
function ig.nui.menu.Show(items, options)
    local focusMenu = true
    if options and options.focus ~= nil then
        focusMenu = options.focus
    end
    
    ig.ui.Send("Client:NUI:MenuShow", {
        items = items or {},
        title = options and options.title or "Menu",
        position = options and options.position or "center"
    }, focusMenu)
end

-- Hide menu
-- Called from: Client code or menu close callback
function ig.nui.menu.Hide()
    ig.ui.Send("Client:NUI:MenuHide", {}, false)
end

ig.log.Info("Client-NUI-Wrappers", "Menu wrapper functions loaded")
