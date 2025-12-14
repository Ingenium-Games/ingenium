-- ====================================================================================--
-- Enhanced Inventory Validation System
-- Server-Side Security Module
-- 
-- @module InventoryValidator
-- @author ig.core Development Team
-- @version 1.0.0
-- @description Provides comprehensive validation to prevent inventory exploits
--              including item duplication, quantity manipulation, and item injection
-- ====================================================================================--

local InventoryValidator = {}

-- ====================================================================================--
-- Core Validation Functions
-- ====================================================================================--

---
-- Calculate total quantities of all item types in an inventory
-- @param inventory table - Inventory array to analyze
-- @return table - Map of item names to total quantities
function InventoryValidator.GetItemQuantities(inventory)
    local quantities = {}
    
    for _, slot in ipairs(inventory) do
        if slot and slot.Item then
            local itemName = slot.Item
            local quantity = tonumber(slot.Quantity) or 0
            
            if quantities[itemName] then
                quantities[itemName] = quantities[itemName] + quantity
            else
                quantities[itemName] = quantity
            end
        end
    end
    
    return quantities
end

---
-- Validate that an item exists in the game's item database
-- @param itemName string - Name of the item to check
-- @return boolean - True if item exists, false otherwise
function InventoryValidator.IsValidItem(itemName)
    -- Type check to prevent nil or non-string values
    if type(itemName) ~= "string" or itemName == "" then
        return false
    end
    
    return c.items[itemName] ~= nil
end

---
-- Validate individual inventory slot data
-- NOTE: This focuses on high-level exploit prevention.
--       Low-level type checking and weapon validation is handled by UnpackInventory.
-- @param slot table - Inventory slot to validate
-- @return boolean - True if valid, false otherwise
-- @return string - Error message if invalid
function InventoryValidator.ValidateSlot(slot)
    -- Empty slot is valid
    if not slot or not slot.Item then
        return true, nil
    end
    
    -- Check if item exists in database (exploit prevention)
    if not InventoryValidator.IsValidItem(slot.Item) then
        return false, "Invalid item: " .. tostring(slot.Item)
    end
    
    -- Validate quantity is a positive number (exploit prevention)
    local quantity = tonumber(slot.Quantity)
    if not quantity or quantity < 1 then
        return false, "Invalid quantity for " .. slot.Item .. ": " .. tostring(slot.Quantity)
    end
    
    -- Prevent extremely large quantities that could cause overflow or performance issues
    if quantity > 999999 then
        return false, "Quantity exceeds maximum limit for " .. slot.Item .. ": " .. tostring(quantity)
    end
    
    -- Validate quality upper bound (UnpackInventory handles lower bound and type checking)
    local quality = tonumber(slot.Quality)
    if quality and quality > 100 then
        return false, "Quality exceeds maximum for " .. slot.Item .. ": " .. tostring(quality)
    end
    
    -- Note: Type checking (number validation) is handled by UnpackInventory
    -- Note: Weapon stacking is handled by UnpackInventory
    -- Note: Quality <= 0 cleanup is handled by UnpackInventory
    
    return true, nil
end

---
-- Validate that combined inventories don't exceed original totals
-- @param beforePlayer table - Player inventory before operation
-- @param beforeExternal table - External inventory before operation (can be nil)
-- @param afterPlayer table - Player inventory after operation
-- @param afterExternal table - External inventory after operation (can be nil)
-- @return boolean - True if valid, false if exploit detected
-- @return string - Detailed error message if invalid
function InventoryValidator.ValidateInventoryIntegrity(beforePlayer, beforeExternal, afterPlayer, afterExternal)
    -- Get quantities before operation
    local beforePlayerQty = InventoryValidator.GetItemQuantities(beforePlayer or {})
    local beforeExternalQty = InventoryValidator.GetItemQuantities(beforeExternal or {})
    
    -- Combine before quantities
    local beforeTotal = {}
    for item, qty in pairs(beforePlayerQty) do
        beforeTotal[item] = qty
    end
    for item, qty in pairs(beforeExternalQty) do
        beforeTotal[item] = (beforeTotal[item] or 0) + qty
    end
    
    -- Get quantities after operation
    local afterPlayerQty = InventoryValidator.GetItemQuantities(afterPlayer or {})
    local afterExternalQty = InventoryValidator.GetItemQuantities(afterExternal or {})
    
    -- Combine after quantities
    local afterTotal = {}
    for item, qty in pairs(afterPlayerQty) do
        afterTotal[item] = qty
    end
    for item, qty in pairs(afterExternalQty) do
        afterTotal[item] = (afterTotal[item] or 0) + qty
    end
    
    -- Check for new items that didn't exist before (item injection)
    for item, _ in pairs(afterTotal) do
        if not beforeTotal[item] then
            return false, ("Item injection detected: %s was not present before operation"):format(item)
        end
    end
    
    -- Check for quantity increases (duplication)
    for item, afterQty in pairs(afterTotal) do
        local beforeQty = beforeTotal[item] or 0
        
        if afterQty > beforeQty then
            return false, ("Item duplication detected: %s quantity increased from %d to %d"):format(
                item, beforeQty, afterQty
            )
        end
    end
    
    -- Check for items that disappeared without valid mechanic
    -- (This is allowed as items can be consumed/dropped, but we log it)
    for item, beforeQty in pairs(beforeTotal) do
        local afterQty = afterTotal[item] or 0
        if afterQty < beforeQty then
            c.func.Debug_1(("Item quantity decreased: %s from %d to %d"):format(
                item, beforeQty, afterQty
            ))
        end
    end
    
    return true, nil
end

---
-- Validate entire inventory array
-- @param inventory table - Inventory to validate
-- @return boolean - True if all slots valid, false otherwise
-- @return string - Error message if invalid
function InventoryValidator.ValidateInventory(inventory)
    if type(inventory) ~= "table" then
        return false, "Inventory must be a table"
    end
    
    for index, slot in ipairs(inventory) do
        local valid, error = InventoryValidator.ValidateSlot(slot)
        if not valid then
            return false, ("Slot %d: %s"):format(index, error)
        end
    end
    
    return true, nil
end

---
-- Security action: Log and ban player for exploit attempt
-- @param source number - Player source ID
-- @param reason string - Detailed reason for ban
function InventoryValidator.LogAndBanExploiter(source, reason)
    -- Sanitize reason to prevent log injection
    local sanitizedReason = tostring(reason):gsub("[\r\n]", " "):sub(1, 500)
    
    local xPlayer = c.data.GetPlayer(source)
    if xPlayer then
        local logMessage = ("[INVENTORY EXPLOIT] Player: %s (%s) | Reason: %s"):format(
            xPlayer.Name,
            xPlayer.Character_ID,
            sanitizedReason
        )
        
        -- Log to server console
        print("^1" .. logMessage .. "^7")
        
        -- Log to database/file if available
        TriggerEvent("txaLogger:CommandExecuted", logMessage)
        
        -- Use existing ban function
        c.func.Eventban(source, "Inventory manipulation detected: " .. sanitizedReason)
    else
        DropPlayer(source, "Inventory manipulation detected: " .. sanitizedReason)
    end
end

-- Maintain backward compatibility
InventoryValidator.HandleExploit = InventoryValidator.LogAndBanExploiter

-- ====================================================================================--
-- Export Module
-- ====================================================================================--

return InventoryValidator
