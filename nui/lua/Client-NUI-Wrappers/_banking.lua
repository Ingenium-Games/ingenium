-- ====================================================================================--
-- BANKING CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for banking system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.banking.Show(bankData, options)  => Client:NUI:BankingShow
--   - ig.nui.banking.Hide()                   => Client:NUI:BankingHide
--
-- ====================================================================================--

-- Show banking menu
-- Called from: Client code when player opens bank/ATM
function ig.nui.banking.Show(bankData, options)
    local focusBanking = true
    
    if options and options.focus ~= nil then
        focusBanking = options.focus
    end
    
    ig.ui.Send("Client:NUI:BankingShow", {
        balance = bankData and bankData.balance or 0,
        cash = bankData and bankData.cash or 0,
        accountType = bankData and bankData.accountType or "personal",
        favorites = bankData and bankData.favorites or {},
        transactions = bankData and bankData.transactions or {}
    }, focusBanking)
end

-- Hide banking menu
-- Called from: Banking close callback or client code
function ig.nui.banking.Hide()
    ig.ui.Send("Client:NUI:BankingHide", {}, false)
end

ig.log.Info("Client-NUI-Wrappers", "Banking wrapper functions loaded")
