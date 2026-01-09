-- ====================================================================================--
-- Banking SQL Functions
-- ====================================================================================--

if not ig.sql.banking then
    ig.sql.banking = {}
end

--- Get transaction history for a character
--- @param characterId string Character ID
--- @param limit number Number of transactions to retrieve
--- @return table Transaction history
function ig.sql.banking.GetTransactions(characterId, limit)
    limit = limit or 50
    
    local query = [[
        SELECT `Type`, `Description`, `Amount`, `Date` 
        FROM `banking_transactions` 
        WHERE `Character_ID` = ? 
        ORDER BY `Date` DESC 
        LIMIT ?
    ]]
    
    local result = ig.sql.Query(query, {characterId, limit})
    
    if result and #result > 0 then
        local transactions = {}
        for i = 1, #result do
            table.insert(transactions, {
                type = result[i].Type,
                description = result[i].Description,
                amount = tonumber(result[i].Amount),
                date = result[i].Date
            })
        end
        return transactions
    end
    
    return {}
end

--- Add a transaction record
--- @param characterId string Character ID
--- @param transaction table Transaction data {type: string, description: string, amount: number}
function ig.sql.banking.AddTransaction(characterId, transaction)
    local query = [[
        INSERT INTO `banking_transactions` 
        (`Character_ID`, `Type`, `Description`, `Amount`, `Date`) 
        VALUES (?, ?, ?, ?, NOW())
    ]]
    
    ig.sql.Insert(query, {
        characterId,
        transaction.type,
        transaction.description,
        transaction.amount
    })
end

--- Get favorites for a character
--- @param characterId string Character ID
--- @return table Array of favorites
function ig.sql.banking.GetFavorites(characterId)
    local char = ig.sql.char.Get(characterId)
    if not char or not char.Banking_Favorites then
        return {}
    end
    
    local favorites = json.decode(char.Banking_Favorites)
    if type(favorites) ~= "table" then
        return {}
    end
    
    return favorites
end

--- Add a favorite
--- @param characterId string Character ID
--- @param favorite table Favorite data {iban: string, name: string}
--- @return boolean Success status
function ig.sql.banking.AddFavorite(characterId, favorite)
    local favorites = ig.sql.banking.GetFavorites(characterId)
    
    -- Check if already exists
    for i = 1, #favorites do
        if favorites[i].iban == favorite.iban then
            return false
        end
    end
    
    -- Add new favorite
    table.insert(favorites, {
        iban = favorite.iban,
        name = favorite.name
    })
    
    -- Update database
    local query = [[
        UPDATE `characters` 
        SET `Banking_Favorites` = ? 
        WHERE `Character_ID` = ?
    ]]
    
    ig.sql.Update(query, {json.encode(favorites), characterId})
    return true
end

--- Remove a favorite
--- @param characterId string Character ID
--- @param iban string IBAN to remove
--- @return boolean Success status
function ig.sql.banking.RemoveFavorite(characterId, iban)
    local favorites = ig.sql.banking.GetFavorites(characterId)
    
    -- Find and remove
    for i = #favorites, 1, -1 do
        if favorites[i].iban == iban then
            table.remove(favorites, i)
            
            -- Update database
            local query = [[
                UPDATE `characters` 
                SET `Banking_Favorites` = ? 
                WHERE `Character_ID` = ?
            ]]
            
            ig.sql.Update(query, {json.encode(favorites), characterId})
            return true
        end
    end
    
    return false
end

--- Add bank balance to offline character
--- @param characterId string Character ID
--- @param amount number Amount to add
function ig.sql.banking.AddBankOffline(characterId, amount)
    local query = [[
        UPDATE `characters` 
        SET `Accounts` = JSON_SET(`Accounts`, '$.Bank', 
            CAST(JSON_EXTRACT(`Accounts`, '$.Bank') AS DECIMAL(10,2)) + ?)
        WHERE `Character_ID` = ?
    ]]
    
    ig.sql.Update(query, {amount, characterId})
end
