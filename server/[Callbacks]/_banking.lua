-- ====================================================================================--
-- Banking Callbacks - Server-side banking operations
-- ====================================================================================--

if not ig.callback then
    ig.callback = {}
end

--- Open banking menu for a player
--- @param source number Player server ID
ig.callback.OpenBanking = function(source)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        return
    end
    
    -- Get character banking data
    local bankBalance = xPlayer.GetBank()
    local cashAmount = xPlayer.GetCash()
    local characterName = xPlayer.GetFull_Name()
    local iban = xPlayer.GetIban()
    
    -- Get transaction history (last 50 transactions)
    local transactions = ig.sql.banking.GetTransactions(xPlayer.GetCharacter_ID(), 50)
    
    -- Get favorites
    local favorites = ig.sql.banking.GetFavorites(xPlayer.GetCharacter_ID())
    
    -- Send data to client
    TriggerClientEvent("banking:openMenu", source, {
        characterName = characterName,
        iban = iban or "N/A",
        balance = bankBalance,
        cash = cashAmount,
        transactions = transactions,
        favorites = favorites
    })
end

--- Handle money transfer between characters
--- @param data table Transfer data {targetIban: string, amount: number, description: string}
--- @param cb function Callback function
ig.callback.BankingTransfer = function(source, data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        cb(false, "Player not found")
        return
    end
    
    -- Validate input
    if not data or not data.targetIban or not data.amount then
        cb(false, "Invalid transfer data")
        return
    end
    
    local targetIban = tostring(data.targetIban)
    local amount = tonumber(data.amount)
    local description = data.description or "Transfer"
    
    -- Validate amount
    if not amount or amount <= 0 then
        cb(false, "Invalid amount")
        return
    end
    
    -- Check if player has sufficient funds
    local currentBalance = xPlayer.GetBank()
    if currentBalance < amount then
        cb(false, "Insufficient funds")
        return
    end
    
    -- Check for self-transfer
    if xPlayer.GetIban() == targetIban then
        cb(false, "Cannot transfer to your own account")
        return
    end
    
    -- Get target character
    local targetCharacter = ig.sql.char.GetByIban(targetIban)
    if not targetCharacter then
        cb(false, "Invalid IBAN - Account not found")
        return
    end
    
    -- Perform transfer
    xPlayer.RemoveBank(amount)
    
    -- Check if target is online
    local targetPlayer = ig.data.GetPlayerByCharacterId(targetCharacter.Character_ID)
    if targetPlayer then
        -- Target is online, update directly
        targetPlayer.AddBank(amount)
        
        -- Notify target
        targetPlayer.Notify("You received $" .. amount .. " from " .. xPlayer.GetFull_Name(), "green", 5000)
        
        -- Send transaction to target NUI
        TriggerClientEvent("banking:addTransaction", targetPlayer.GetID(), {
            type = "Transfer In",
            description = "From " .. xPlayer.GetFull_Name() .. ": " .. description,
            amount = amount,
            date = os.date("%Y-%m-%d %H:%M:%S")
        })
    else
        -- Target is offline, update via SQL
        ig.sql.banking.AddBankOffline(targetCharacter.Character_ID, amount)
    end
    
    -- Log transaction for sender
    ig.sql.banking.AddTransaction(xPlayer.GetCharacter_ID(), {
        type = "Transfer Out",
        description = "To " .. targetCharacter.First_Name .. " " .. targetCharacter.Last_Name .. ": " .. description,
        amount = -amount,
        targetIban = targetIban
    })
    
    -- Log transaction for receiver
    ig.sql.banking.AddTransaction(targetCharacter.Character_ID, {
        type = "Transfer In",
        description = "From " .. xPlayer.GetFull_Name() .. ": " .. description,
        amount = amount,
        sourceIban = xPlayer.GetIban()
    })
    
    -- Update sender's NUI
    TriggerClientEvent("banking:updateBalance", source, { balance = xPlayer.GetBank() })
    TriggerClientEvent("banking:addTransaction", source, {
        type = "Transfer Out",
        description = "To " .. targetCharacter.First_Name .. " " .. targetCharacter.Last_Name .. ": " .. description,
        amount = -amount,
        date = os.date("%Y-%m-%d %H:%M:%S")
    })
    
    -- Notify sender
    xPlayer.Notify("Transfer successful: $" .. amount .. " to " .. targetCharacter.First_Name .. " " .. targetCharacter.Last_Name, "green", 5000)
    
    -- Security logging
    if ig.security and ig.security.LogPlayerTransaction then
        ig.security.LogPlayerTransaction(xPlayer, "bank_transfer", amount, "Transfer to " .. targetIban)
    end
    
    cb(true, "Transfer successful")
end

--- Handle cash withdrawal
--- @param data table Withdrawal data {amount: number}
--- @param cb function Callback function
ig.callback.BankingWithdraw = function(source, data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        cb(false, "Player not found")
        return
    end
    
    -- Validate input
    if not data or not data.amount then
        cb(false, "Invalid withdrawal data")
        return
    end
    
    local amount = tonumber(data.amount)
    
    -- Validate amount
    if not amount or amount <= 0 then
        cb(false, "Invalid amount")
        return
    end
    
    -- Check if player has sufficient funds
    local currentBalance = xPlayer.GetBank()
    if currentBalance < amount then
        cb(false, "Insufficient funds")
        return
    end
    
    -- Perform withdrawal
    xPlayer.RemoveBank(amount)
    xPlayer.AddCash(amount)
    
    -- Log transaction
    ig.sql.banking.AddTransaction(xPlayer.GetCharacter_ID(), {
        type = "Withdrawal",
        description = "ATM Withdrawal",
        amount = -amount
    })
    
    -- Update NUI
    TriggerClientEvent("banking:updateBalance", source, { balance = xPlayer.GetBank() })
    TriggerClientEvent("banking:updateCash", source, { cash = xPlayer.GetCash() })
    TriggerClientEvent("banking:addTransaction", source, {
        type = "Withdrawal",
        description = "ATM Withdrawal",
        amount = -amount,
        date = os.date("%Y-%m-%d %H:%M:%S")
    })
    
    -- Notify player
    xPlayer.Notify("Withdrawal successful: $" .. amount, "green", 3000)
    
    -- Security logging
    if ig.security and ig.security.LogPlayerTransaction then
        ig.security.LogPlayerTransaction(xPlayer, "bank_withdrawal", amount, "ATM Withdrawal")
    end
    
    cb(true, "Withdrawal successful")
end

--- Handle cash deposit
--- @param data table Deposit data {amount: number}
--- @param cb function Callback function
ig.callback.BankingDeposit = function(source, data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        cb(false, "Player not found")
        return
    end
    
    -- Validate input
    if not data or not data.amount then
        cb(false, "Invalid deposit data")
        return
    end
    
    local amount = tonumber(data.amount)
    
    -- Validate amount
    if not amount or amount <= 0 then
        cb(false, "Invalid amount")
        return
    end
    
    -- Check if player has sufficient cash
    local currentCash = xPlayer.GetCash()
    if currentCash < amount then
        cb(false, "Insufficient cash")
        return
    end
    
    -- Perform deposit
    xPlayer.RemoveCash(amount)
    xPlayer.AddBank(amount)
    
    -- Log transaction
    ig.sql.banking.AddTransaction(xPlayer.GetCharacter_ID(), {
        type = "Deposit",
        description = "ATM Deposit",
        amount = amount
    })
    
    -- Update NUI
    TriggerClientEvent("banking:updateBalance", source, { balance = xPlayer.GetBank() })
    TriggerClientEvent("banking:updateCash", source, { cash = xPlayer.GetCash() })
    TriggerClientEvent("banking:addTransaction", source, {
        type = "Deposit",
        description = "ATM Deposit",
        amount = amount,
        date = os.date("%Y-%m-%d %H:%M:%S")
    })
    
    -- Notify player
    xPlayer.Notify("Deposit successful: $" .. amount, "green", 3000)
    
    -- Security logging
    if ig.security and ig.security.LogPlayerTransaction then
        ig.security.LogPlayerTransaction(xPlayer, "bank_deposit", amount, "ATM Deposit")
    end
    
    cb(true, "Deposit successful")
end

--- Add a favorite payee
--- @param data table Favorite data {iban: string, name: string}
--- @param cb function Callback function
ig.callback.BankingAddFavorite = function(source, data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        cb(false, "Player not found")
        return
    end
    
    -- Validate input
    if not data or not data.iban or not data.name then
        cb(false, "Invalid favorite data")
        return
    end
    
    local iban = tostring(data.iban)
    local name = tostring(data.name)
    
    -- Verify IBAN exists
    local targetCharacter = ig.sql.char.GetByIban(iban)
    if not targetCharacter then
        cb(false, "Invalid IBAN")
        return
    end
    
    -- Add favorite
    local success = ig.sql.banking.AddFavorite(xPlayer.GetCharacter_ID(), {
        iban = iban,
        name = name
    })
    
    if success then
        cb(true, "Favorite added")
    else
        cb(false, "Failed to add favorite")
    end
end

--- Remove a favorite payee
--- @param data table Favorite data {iban: string}
--- @param cb function Callback function
ig.callback.BankingRemoveFavorite = function(source, data, cb)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        cb(false, "Player not found")
        return
    end
    
    -- Validate input
    if not data or not data.iban then
        cb(false, "Invalid favorite data")
        return
    end
    
    local iban = tostring(data.iban)
    
    -- Remove favorite
    local success = ig.sql.banking.RemoveFavorite(xPlayer.GetCharacter_ID(), iban)
    
    if success then
        cb(true, "Favorite removed")
    else
        cb(false, "Failed to remove favorite")
    end
end
