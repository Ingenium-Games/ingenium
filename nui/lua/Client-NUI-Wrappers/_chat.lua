-- ====================================================================================--
-- CHAT CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for chat system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.chat.Show(options)     => Client:NUI:ChatShow
--   - ig.nui.chat.Hide()            => Client:NUI:ChatHide
--   - ig.nui.chat.AddMessage(author, message, color) => Client:NUI:ChatAddMessage
--   - ig.nui.chat.Clear()           => Client:NUI:ChatClear
--
-- ====================================================================================--

if not ig.nui then ig.nui = {} end
if not ig.nui.chat then ig.nui.chat = {} end

-- Show chat input
-- Called from: Keybind or client code
function ig.nui.chat.Show(options)
    local focusChat = true
    
    if options and options.focus ~= nil then
        focusChat = options.focus
    end
    
    ig.ui.Send("Client:NUI:ChatShow", {
        placeholder = options and options.placeholder or "Say something..."
    }, focusChat)
end

-- Hide chat
-- Called from: Chat close or ESC key
function ig.nui.chat.Hide()
    ig.ui.Send("Client:NUI:ChatHide", {}, false)
end

-- Add message to chat
-- Called from: Server or client events
function ig.nui.chat.AddMessage(author, message, color)
    ig.ui.Send("Client:NUI:ChatAddMessage", {
        author = author or "System",
        text = message or "",
        color = color or {255, 255, 255}
    }, false)
end

-- Clear all chat messages
-- Called from: Commands or client code
function ig.nui.chat.Clear()
    ig.ui.Send("Client:NUI:ChatClear", {}, false)
end

ig.log.Info("Client-NUI-Wrappers", "Chat wrapper functions loaded")
