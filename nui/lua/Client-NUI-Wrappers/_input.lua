-- ====================================================================================--
-- INPUT CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for input/dialog system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.input.Show(label, placeholder, options)  => Client:NUI:InputShow
--   - ig.nui.input.Hide()                             => Client:NUI:InputHide
--
-- ====================================================================================--

-- Show input dialog
-- Called from: Client code to request user input
function ig.nui.input.Show(label, placeholder, options)
    local focusInput = true
    local maxLength = 500
    
    if options then
        if options.focus ~= nil then
            focusInput = options.focus
        end
        if options.maxLength then
            maxLength = options.maxLength
        end
    end
    
    ig.ui.Send("Client:NUI:InputShow", {
        label = label or "Enter text",
        placeholder = placeholder or "",
        maxLength = maxLength
    }, focusInput)
end

-- Hide input dialog
-- Called from: Client code or input close callback
function ig.nui.input.Hide()
    ig.ui.Send("Client:NUI:InputHide", {}, false)
end

ig.log.Info("Client-NUI-Wrappers", "Input wrapper functions loaded")
