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

local GetPeds = RegisterServerCallback({
    eventName = "ig:GameData:GetPeds",
    eventCallback = function(source)
        return ig.peds
    end
})

local GetPedsByGender = RegisterServerCallback({
    eventName = "ig:GameData:GetPedsByGender",
    eventCallback = function(source, gender)
        return ig.ped.GetByGender(gender)
    end
})

local GetPedsByType = RegisterServerCallback({
    eventName = "ig:GameData:GetPedsByType",
    eventCallback = function(source, pedType)
        return ig.ped.GetByType(pedType)
    end
})

local GetPedByHash = RegisterServerCallback({
    eventName = "ig:GameData:GetPedByHash",
    eventCallback = function(source, hash)
        return ig.ped.GetByHash(hash)
    end
})

local GetPedByName = RegisterServerCallback({
    eventName = "ig:GameData:GetPedByName",
    eventCallback = function(source, name)
        return ig.ped.GetByName(name)
    end
})

-- GetAppearanceConstants callback removed - duplicate of the one in server/[Callbacks]/_data.lua

local ValidateAppearance = RegisterServerCallback({
    eventName = "ig:Appearance:ValidateAppearance",
    eventCallback = function(source, appearance)
        return ig.appearance.ValidateAppearance(appearance)
    end
})
