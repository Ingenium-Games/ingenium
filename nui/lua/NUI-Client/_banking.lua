-- ====================================================================================--
-- BANKING NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for banking/financial operations.
--
-- NUI sends these messages:
--   - NUI:Client:BankingClose    => Banking menu was closed
--   - NUI:Client:BankingTransfer => Player initiated money transfer
--   - NUI:Client:BankingDeposit  => Player deposited cash
--   - NUI:Client:BankingWithdraw => Player withdrew cash
--
-- ====================================================================================--

-- Player closes banking menu
-- Sent from: nui/src/components/Banking.vue
RegisterNUICallback('NUI:Client:BankingClose', function(data, cb)
    ig.log.Trace("Banking", "Banking menu closed")
    
    -- Close NUI and release focus
    SetNuiFocus(false, false)
    
    -- Trigger internal event for banking cleanup
    TriggerEvent("Client:Banking:Close")
    
    cb({ok = true})
end)

-- Player initiates money transfer
-- Sent from: nui/src/components/Banking.vue with recipient and amount
RegisterNUICallback('NUI:Client:BankingTransfer', function(data, cb)
    if not data or not data.recipient or not data.amount then
        ig.log.Error("Banking", "NUI:Client:BankingTransfer: missing transfer data")
        cb({ok = false, error = "Missing transfer data"})
        return
    end
    
    local amount = tonumber(data.amount) or 0
    ig.log.Trace("Banking", "Transfer initiated: " .. amount .. " to " .. data.recipient)
    
    -- Send transfer request to server
    TriggerServerEvent("Server:Banking:Transfer", data.recipient, amount)
    
    cb({ok = true})
end)

-- Player deposits cash into bank account
-- Sent from: nui/src/components/Banking.vue with amount
RegisterNUICallback('NUI:Client:BankingDeposit', function(data, cb)
    if not data or not data.amount then
        ig.log.Error("Banking", "NUI:Client:BankingDeposit: missing amount data")
        cb({ok = false, error = "Missing amount"})
        return
    end
    
    local amount = tonumber(data.amount) or 0
    ig.log.Trace("Banking", "Deposit initiated: " .. amount)
    
    -- Send deposit request to server
    TriggerServerEvent("Server:Banking:Deposit", amount)
    
    cb({ok = true})
end)

-- Player withdraws cash from bank account
-- Sent from: nui/src/components/Banking.vue with amount
RegisterNUICallback('NUI:Client:BankingWithdraw', function(data, cb)
    if not data or not data.amount then
        ig.log.Error("Banking", "NUI:Client:BankingWithdraw: missing amount data")
        cb({ok = false, error = "Missing amount"})
        return
    end
    
    local amount = tonumber(data.amount) or 0
    ig.log.Trace("Banking", "Withdrawal initiated: " .. amount)
    
    -- Send withdrawal request to server
    TriggerServerEvent("Server:Banking:Withdraw", amount)
    
    cb({ok = true})
end)

ig.log.Info("NUI-Client", "Banking callbacks registered")
