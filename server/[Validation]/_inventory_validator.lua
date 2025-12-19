-- ====================================================================================--
-- Enhanced Inventory Validation System
-- Server-Side Security Module
-- 
-- @module ig.validation
-- @author ingenium Development Team
-- @version 1.0.0
-- @description Provides comprehensive validation to prevent inventory exploits
--              including item duplication, quantity manipulation, and item injection
-- ====================================================================================--

ig.validation = {}

-- ====================================================================================--
-- Core Validation Functions
-- ====================================================================================--

---
-- Calculate total quantities of all item types in an inventory
-- @param inventory table - Inventory array to analyze
-- @return table - Map of item names to total quantities
function ig.validation.GetItemQuantities(inventory)
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
function ig.validation.IsValidItem(itemName)
    -- Type check to prevent nil or non-string values
    if type(itemName) ~= "string" or itemName == "" then
        return false
    end
    
    return ig.items[itemName] ~= nil
end

---
-- Validate individual inventory slot data (comprehensive validation)
-- This is the unified validation function that replaces the logic in UnpackInventory
-- @param slot table - Inventory slot to validate
-- @param index number - Slot index for error reporting
-- @return boolean - True if valid, false otherwise
-- @return string - Error message if invalid
function ig.validation.ValidateSlot(slot, index)
    -- Empty slot is valid
    if not slot or not slot.Item then
        return true, nil
    end
    
    local idx = index or 0
    
    -- Check if item exists in database (exploit prevention)
    if not ig.validation.IsValidItem(slot.Item) then
        return false, ("Slot %d: Invalid item: %s"):format(idx, tostring(slot.Item))
    end
    
    -- Validate quantity is a positive number with type checking
    local quantity = tonumber(slot.Quantity)
    if not quantity or type(slot.Quantity) ~= "number" or quantity < 1 then
        return false, ("Slot %d: Invalid quantity for %s: %s"):format(idx, slot.Item, tostring(slot.Quantity))
    end
    
    -- Prevent extremely large quantities that could cause overflow or performance issues
    if quantity > 999999 then
        return false, ("Slot %d: Quantity exceeds maximum limit for %s: %d"):format(idx, slot.Item, quantity)
    end
    
    -- Validate quality is a number with type checking
    local quality = tonumber(slot.Quality)
    if not quality or type(slot.Quality) ~= "number" then
        return false, ("Slot %d: Invalid quality type for %s: %s"):format(idx, slot.Item, tostring(slot.Quality))
    end
    
    -- Validate quality range (0-100)
    if quality < 0 or quality > 100 then
        return false, ("Slot %d: Quality out of range for %s: %d"):format(idx, slot.Item, quality)
    end
    
    -- Validate weapon flag consistency
    if slot.Weapon == true then
        local weaponHash = ig.item.IsWeapon(slot.Item)
        if type(weaponHash) ~= "string" then
            return false, ("Slot %d: Weapon flag mismatch for %s"):format(idx, slot.Item)
        end
        
        -- Weapons should not stack
        if quantity > 1 then
            return false, ("Slot %d: Weapon cannot have quantity > 1: %s"):format(idx, slot.Item)
        end
    end
    
    return true, nil
end

---
-- Validate entire inventory array
-- @param inventory table - Inventory to validate
-- @return boolean - True if all slots valid, false otherwise
-- @return string - Error message if invalid
function ig.validation.ValidateInventory(inventory)
    if type(inventory) ~= "table" then
        return false, "Inventory must be a table"
    end
    
    for index, slot in ipairs(inventory) do
        local valid, error = ig.validation.ValidateSlot(slot, index)
        if not valid then
            return false, error
        end
    end
    
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
function ig.validation.ValidateInventoryIntegrity(beforePlayer, beforeExternal, afterPlayer, afterExternal)
    -- Get quantities before operation
    local beforePlayerQty = ig.validation.GetItemQuantities(beforePlayer or {})
    local beforeExternalQty = ig.validation.GetItemQuantities(beforeExternal or {})
    
    -- Combine before quantities
    local beforeTotal = {}
    for item, qty in pairs(beforePlayerQty) do
        beforeTotal[item] = qty
    end
    for item, qty in pairs(beforeExternalQty) do
        beforeTotal[item] = (beforeTotal[item] or 0) + qty
    end
    
    -- Get quantities after operation
    local afterPlayerQty = ig.validation.GetItemQuantities(afterPlayer or {})
    local afterExternalQty = ig.validation.GetItemQuantities(afterExternal or {})
    
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
            ig.func.Debug_1(("Item quantity decreased: %s from %d to %d"):format(
                item, beforeQty, afterQty
            ))
        end
    end
    
    return true, nil
end

---
-- Security action: Log and ban player for exploit attempt
-- @param source number - Player source ID
-- @param reason string - Detailed reason for ban
function ig.validation.LogAndBanExploiter(source, reason)
    -- Sanitize reason to prevent log injection
    local sanitizedReason = tostring(reason):gsub("[\r\n]", " "):sub(1, 500)
    
    local xPlayer = ig.data.GetPlayer(source)
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
        ig.func.Eventban(source, "Inventory manipulation detected: " .. sanitizedReason)
    else
        DropPlayer(source, "Inventory manipulation detected: " .. sanitizedReason)
    end
end

---
-- Unified validation and unpacking function
-- This replaces the validation logic in UnpackInventory and provides a single point of failure
-- @param source number - Player source for error reporting (can be nil for non-player entities)
-- @param inventory table - Inventory array to validate and process
-- @return table - Processed inventory (with quality cleanup)
-- @return boolean - True if valid, false if exploit detected
-- @return string - Error message if invalid
function ig.validation.ValidateAndUnpack(source, inventory)
    local inv = inventory or {}
    local processed = {}
    
    -- Validate entire inventory first
    local valid, error = ig.validation.ValidateInventory(inv)
    if not valid then
        if source then
            ig.validation.LogAndBanExploiter(source, error)
        end
        return nil, false, error
    end
    
    -- Process and clean inventory
    for i = 1, #inv do
        processed[i] = {
            ["Item"] = inv[i]["Item"] or inv[i][1],
            ["Quantity"] = inv[i]["Quantity"] or inv[i][2],
            ["Quality"] = inv[i]["Quality"] or inv[i][3],
            ["Weapon"] = inv[i]["Weapon"] or inv[i][4],
            ["Meta"] = inv[i]["Meta"] or inv[i][5],
            ["Name"] = inv[i]["Name"] or inv[i][6]
        }
        
        -- If the Quality is below 0, destroy the item on unpacking
        if processed[i].Quality <= 0 then
            table.remove(processed, i)
        end
    end
    
    return processed, true, nil
end

-- ====================================================================================--
-- Backward compatibility
-- ====================================================================================--

-- Maintain backward compatibility with old HandleExploit name
ig.validation.HandleExploit = ig.validation.LogAndBanExploiter
