-- ====================================================================================--
-- Banking Callbacks - Server-side banking operations
-- ====================================================================================--

--- Open banking menu for a player
RegisterServerCallback({
    eventName = "Server:Bank:Open",
    eventCallback = function(source)
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
        TriggerClientEvent("Client:Banking:OpenMenu", source, {
            characterName = characterName,
            iban = iban or "N/A",
            balance = bankBalance,
            cash = cashAmount,
            transactions = transactions,
            favorites = favorites
        })
    end
})

--- Handle money transfer between characters
RegisterServerCallback({
    eventName = "Server:Bank:Transfer",
    eventCallback = function(source, data)
        local xPlayer = ig.data.GetPlayer(source)
        if not xPlayer then
            return false, "Player not found"
        end
        
        -- Validate input
        if not data or not data.targetIban or not data.amount then
            return false, "Invalid transfer data"
        end
        
        local targetIban = tostring(data.targetIban)
        local amount = tonumber(data.amount)
        local description = data.description or "Transfer"
        
        -- Validate amount
        if not amount or amount <= 0 then
            return false, "Invalid amount"
        end
        
        -- Check if player has sufficient funds
        local currentBalance = xPlayer.GetBank()
        if currentBalance < amount then
            return false, "Insufficient funds"
        end
        
        -- Check for self-transfer
        if xPlayer.GetIban() == targetIban then
            return false, "Cannot transfer to your own account"
        end
        
        -- Get target character
        local targetCharacter = ig.sql.char.GetByIban(targetIban)
        if not targetCharacter then
            return false, "Invalid IBAN - Account not found"
        end
        
        -- Perform transfer
        xPlayer.RemoveBank(amount)
        
        -- Check if target is online
        local targetPlayer = ig.data.GetPlayerByCharacterId(targetCharacter.Character_ID)
        if targetPlayer then
            -- Target is online, update directly
            targetPlayer.AddBank(amount)
            
            -- Notify target
            targetPlayer.Notify(string.format("You received $%s from %s", amount, xPlayer.GetFull_Name()), "green", 5000)
            
            -- Send transaction to target NUI
            TriggerClientEvent("Client:Banking:AddTransaction", targetPlayer.GetID(), {
                type = "Transfer In",
                description = string.format("From %s: %s", xPlayer.GetFull_Name(), description),
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
            description = string.format("To %s %s: %s", targetCharacter.First_Name, targetCharacter.Last_Name, description),
            amount = -amount
        })
        
        -- Log transaction for receiver
        ig.sql.banking.AddTransaction(targetCharacter.Character_ID, {
            type = "Transfer In",
            description = string.format("From %s: %s", xPlayer.GetFull_Name(), description),
            amount = amount
        })
        
        -- Update sender's NUI
        TriggerClientEvent("Client:Banking:UpdateBalance", source, { balance = xPlayer.GetBank() })
        TriggerClientEvent("Client:Banking:AddTransaction", source, {
            type = "Transfer Out",
            description = string.format("To %s %s: %s", targetCharacter.First_Name, targetCharacter.Last_Name, description),
            amount = -amount,
            date = os.date("%Y-%m-%d %H:%M:%S")
        })
        
        -- Notify sender
        xPlayer.Notify(string.format("Transfer successful: $%s to %s %s", amount, targetCharacter.First_Name, targetCharacter.Last_Name), "green", 5000)
        
        -- Security logging
        if ig.security and ig.security.LogPlayerTransaction then
            ig.security.LogPlayerTransaction(xPlayer, "bank_transfer", amount, "Transfer to " .. targetIban)
        end
        
        return true, "Transfer successful"
    end
})

--- Handle cash withdrawal
RegisterServerCallback({
    eventName = "Server:Bank:Withdraw",
    eventCallback = function(source, data)
        local xPlayer = ig.data.GetPlayer(source)
        if not xPlayer then
            return false, "Player not found"
        end
        
        -- Validate input
        if not data or not data.amount then
            return false, "Invalid withdrawal data"
        end
        
        local amount = tonumber(data.amount)
        
        -- Validate amount
        if not amount or amount <= 0 then
            return false, "Invalid amount"
        end
        
        -- Check if player has sufficient funds
        local currentBalance = xPlayer.GetBank()
        if currentBalance < amount then
            return false, "Insufficient funds"
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
        TriggerClientEvent("Client:Banking:UpdateBalance", source, { balance = xPlayer.GetBank() })
        TriggerClientEvent("Client:Banking:UpdateCash", source, { cash = xPlayer.GetCash() })
        TriggerClientEvent("Client:Banking:AddTransaction", source, {
            type = "Withdrawal",
            description = "ATM Withdrawal",
            amount = -amount,
            date = os.date("%Y-%m-%d %H:%M:%S")
        })
        
        -- Notify player
        xPlayer.Notify(string.format("Withdrawal successful: $%s", amount), "green", 3000)
        
        -- Security logging
        if ig.security and ig.security.LogPlayerTransaction then
            ig.security.LogPlayerTransaction(xPlayer, "bank_withdrawal", amount, "ATM Withdrawal")
        end
        
        return true, "Withdrawal successful"
    end
})

--- Handle cash deposit
RegisterServerCallback({
    eventName = "Server:Bank:Deposit",
    eventCallback = function(source, data)
        local xPlayer = ig.data.GetPlayer(source)
        if not xPlayer then
            return false, "Player not found"
        end
        
        -- Validate input
        if not data or not data.amount then
            return false, "Invalid deposit data"
        end
        
        local amount = tonumber(data.amount)
        
        -- Validate amount
        if not amount or amount <= 0 then
            return false, "Invalid amount"
        end
        
        -- Check if player has sufficient cash
        local currentCash = xPlayer.GetCash()
        if currentCash < amount then
            return false, "Insufficient cash"
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
        TriggerClientEvent("Client:Banking:UpdateBalance", source, { balance = xPlayer.GetBank() })
        TriggerClientEvent("Client:Banking:UpdateCash", source, { cash = xPlayer.GetCash() })
        TriggerClientEvent("Client:Banking:AddTransaction", source, {
            type = "Deposit",
            description = "ATM Deposit",
            amount = amount,
            date = os.date("%Y-%m-%d %H:%M:%S")
        })
        
        -- Notify player
        xPlayer.Notify(string.format("Deposit successful: $%s", amount), "green", 3000)
        
        -- Security logging
        if ig.security and ig.security.LogPlayerTransaction then
            ig.security.LogPlayerTransaction(xPlayer, "bank_deposit", amount, "ATM Deposit")
        end
        
        return true, "Deposit successful"
    end
})

--- Add a favorite payee
RegisterServerCallback({
    eventName = "Server:Bank:AddFavorite",
    eventCallback = function(source, data)
        local xPlayer = ig.data.GetPlayer(source)
        if not xPlayer then
            return false, "Player not found"
        end
        
        -- Validate input
        if not data or not data.iban or not data.name then
            return false, "Invalid favorite data"
        end
        
        local iban = tostring(data.iban)
        local name = tostring(data.name)
        
        -- Verify IBAN exists
        local targetCharacter = ig.sql.char.GetByIban(iban)
        if not targetCharacter then
            return false, "Invalid IBAN"
        end
        
        -- Add favorite
        local success = ig.sql.banking.AddFavorite(xPlayer.GetCharacter_ID(), {
            iban = iban,
            name = name
        })
        
        if success then
            return true, "Favorite added"
        else
            return false, "Failed to add favorite"
        end
    end
})

--- Remove a favorite payee
RegisterServerCallback({
    eventName = "Server:Bank:RemoveFavorite",
    eventCallback = function(source, data)
        local xPlayer = ig.data.GetPlayer(source)
        if not xPlayer then
            return false, "Player not found"
        end
        
        -- Validate input
        if not data or not data.iban then
            return false, "Invalid favorite data"
        end
        
        local iban = tostring(data.iban)
        
        -- Remove favorite
        local success = ig.sql.banking.RemoveFavorite(xPlayer.GetCharacter_ID(), iban)
        
        if success then
            return true, "Favorite removed"
        else
            return false, "Failed to remove favorite"
        end
    end
})
