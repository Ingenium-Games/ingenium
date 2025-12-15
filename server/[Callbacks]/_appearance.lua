-- ====================================================================================--
-- Server-Side Appearance Callbacks
-- Handles server-side appearance operations including pricing
-- ====================================================================================--

-- ====================================================================================--
-- PRICING CALLBACKS
-- ====================================================================================--

---Get pricing data for a specific job
RegisterServerCallback({
    eventName = "Server:Appearance:GetPricing",
    eventCallback = function(source, jobName)
        local pricing = c.appearance.GetPricing(jobName)
        return pricing
    end
})

---Validate and process appearance purchase
---@param source number Player source
---@param jobName string|nil Job name for pricing
---@param oldAppearance table Original appearance
---@param newAppearance table New appearance to purchase
RegisterServerCallback({
    eventName = "Server:Appearance:ValidatePurchase",
    eventCallback = function(source, jobName, oldAppearance, newAppearance)
        -- Calculate cost
        local totalCost, itemizedCosts = c.appearance.CalculateCost(jobName, oldAppearance, newAppearance)
        
        -- If no cost, allow free change
        if totalCost <= 0 then
            return {
                success = true,
                cost = 0,
                message = "Appearance updated (no charge)"
            }
        end
        
        -- Check if player has enough money
        -- This is a placeholder - replace with your actual economy system
        local player = c.func.GetPlayer(source)
        if not player then
            return {
                success = false,
                cost = totalCost,
                message = "Player not found"
            }
        end
        
        -- Get player's cash (adjust this based on your economy system)
        local playerCash = player.cash or 0
        
        if playerCash < totalCost then
            return {
                success = false,
                cost = totalCost,
                message = string.format("Insufficient funds. Need $%d, have $%d", totalCost, playerCash)
            }
        end
        
        -- Deduct money (adjust this based on your economy system)
        -- player.cash = player.cash - totalCost
        -- c.func.SavePlayer(source, player)
        
        return {
            success = true,
            cost = totalCost,
            itemizedCosts = itemizedCosts,
            message = string.format("Appearance updated. Charged $%d", totalCost)
        }
    end
})

print('^2[Server] Appearance callbacks loaded^0')
