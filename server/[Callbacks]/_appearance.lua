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
        local pricing = ig.appearance.GetPricing(jobName)
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
        local totalCost, itemizedCosts = ig.appearance.CalculateCost(jobName, oldAppearance, newAppearance)
        
        -- If no cost, allow free change
        if totalCost <= 0 then
            return {
                success = true,
                cost = 0,
                message = "Appearance updated (no charge)"
            }
        end
        
        -- Check if player has enough money
        -- TODO: Integrate with your economy system
        -- The following is a placeholder implementation
        local player = ig.func.GetPlayer(source)
        if not player then
            return {
                success = false,
                cost = totalCost,
                message = "Player not found"
            }
        end
        
        -- TODO: Replace with actual economy system
        -- Example: local playerCash = player.cash or 0
        -- Example: if playerCash < totalCost then return error end
        -- Example: player.cash = player.cash - totalCost
        -- Example: ig.func.SavePlayer(source, player)
        
        -- For now, allow all purchases (implement economy integration above)
        return {
            success = true,
            cost = totalCost,
            itemizedCosts = itemizedCosts,
            message = string.format("Appearance updated. Cost: $%d (not charged - integrate economy system)", totalCost)
        }
    end
})

print('^2[Server] Appearance callbacks loaded^0')
