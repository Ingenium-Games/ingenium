-- ====================================================================================--
-- INVENTORY CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for inventory system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client event handlers:
--   - ig.nui.inventory.Show(inventoryData, options)  => Client:NUI:InventoryShow
--   - ig.nui.inventory.Hide()                        => Client:NUI:InventoryHide
--   - ig.nui.inventory.Update(inventoryData)         => Client:NUI:InventoryUpdate
--
-- ====================================================================================--

if not ig.nui then ig.nui = {} end
if not ig.nui.inventory then ig.nui.inventory = {} end

-- Show inventory
-- Called from: Client code to display player inventory
function ig.nui.inventory.Show(inventoryData, options)
    local focusInventory = true
    local dualMode = false
    
    if options then
        if options.focus ~= nil then
            focusInventory = options.focus
        end
        if options.dualMode ~= nil then
            dualMode = options.dualMode
        end
    end
    
    ig.ui.Send("Client:NUI:InventoryShow", {
        playerInventory = inventoryData and inventoryData.player or {},
        externalInventory = dualMode and (inventoryData and inventoryData.external or {}) or nil,
        maxSlots = inventoryData and inventoryData.maxSlots or 20,
        dualMode = dualMode
    }, focusInventory)
end

-- Hide inventory
-- Called from: Inventory close callback or client code
function ig.nui.inventory.Hide()
    ig.ui.Send("Client:NUI:InventoryHide", {}, false)
end

-- Update inventory display
-- Called from: Server callbacks when inventory changes
function ig.nui.inventory.Update(inventoryData)
    ig.ui.Send("Client:NUI:InventoryUpdate", {
        playerInventory = inventoryData and inventoryData.player or {},
        externalInventory = inventoryData and inventoryData.external or nil
    }, false)
end

ig.log.Info("Client-NUI-Wrappers", "Inventory wrapper functions loaded")
