-- ====================================================================================--
-- Vue Inventory System - Client-Side Integration
-- ====================================================================================--

local inventoryOpen = false
local currentExternalNetId = nil

-- Export current external inventory for live update detection
exports('GetCurrentExternalInventory', function()
    return currentExternalNetId
end)

-- ====================================================================================--
-- Event Handlers for Opening Inventory
-- ====================================================================================--

---
-- Open dual-panel inventory (player + external entity)
-- @param externalNetId Network ID of the external entity (vehicle, object, NPC, player)
-- @param externalTitle Title to display for external inventory
RegisterNetEvent("Client:Inventory:OpenDual")
AddEventHandler("Client:Inventory:OpenDual", function(externalNetId, externalTitle)
    -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end

    if inventoryOpen then return end
    
    local playerInventory = ig.inventory.GetInventory()
    
    -- Get external inventory via callback using ig.callback wrapper
    local externalInventory = ig.callback.Await("GetInventory", externalNetId)
    
    if externalInventory then
        inventoryOpen = true
        currentExternalNetId = externalNetId
        
        -- Send data to Vue NUI
        SendNUIMessage({
            message = "Client:NUI:InventoryOpenDual",
            data = {
                playerInventory = playerInventory,
                externalInventory = externalInventory,
                externalTitle = externalTitle or "Storage",
                externalNetId = externalNetId,
                playerMaxSlots = 50,
                externalMaxSlots = 50
            }
        })
        
        SetNuiFocus(true, true)
    end
end)

---
-- Open single-panel inventory (player only)
RegisterNetEvent("Client:Inventory:OpenSingle")
AddEventHandler("Client:Inventory:OpenSingle", function()
    -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end

    if inventoryOpen then return end
    
    local playerInventory = ig.inventory.GetInventory()
    
    inventoryOpen = true
    currentExternalNetId = nil
    
    -- Send data to Vue NUI
    SendNUIMessage({
        message = "Client:NUI:InventoryOpenSingle",
        data = {
            playerInventory = playerInventory,
            playerMaxSlots = 50
        }
    })
    
    SetNuiFocus(true, true)
end)

---
-- Close inventory from server
RegisterNetEvent("Client:Inventory:Close")
AddEventHandler("Client:Inventory:Close", function()
    -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end

    if not inventoryOpen then return end
    
    SendNUIMessage({
        message = "Client:NUI:InventoryClose",
        data = {}
    })
    
    SetNuiFocus(false, false)
    inventoryOpen = false
    currentExternalNetId = nil
end)

---
-- Update inventory from server (live updates)
RegisterNetEvent("Client:Inventory:Update")
AddEventHandler("Client:Inventory:Update", function(playerInventory, externalInventory)
    -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end

    if not inventoryOpen then return end
    
    SendNUIMessage({
        message = "Client:NUI:InventoryUpdate",
        data = {
            playerInventory = playerInventory,
            externalInventory = externalInventory
        }
    })
end)

-- ====================================================================================--
-- NUI Callbacks - CONSOLIDATED IN NUI-Client
-- ====================================================================================--
-- Inventory callbacks have been moved to nui/lua/NUI-Client/_inventory.lua
-- This file now contains wrapper functions and exports only
-- ====================================================================================--

-- ====================================================================================--
-- Keybind for Opening Inventory - RegisterKeyMapping Implementation
-- ====================================================================================--

--- Open inventory command handler
RegisterCommand('openInventory', function()
    if not inventoryOpen and ig.data.IsPlayerLoaded() then
        TriggerEvent("Client:Inventory:OpenSingle")
    end
end, false)

-- Register the key mapping with FiveM
-- Users can customize this in their FiveM keybinding settings
if conf.inventory.allowHotkey and conf.inventory.openKey then
    RegisterKeyMapping(
        'openInventory',
        'Open Inventory',
        'keyboard',
        conf.inventory.openKey:lower()
    )
    
    ig.log.Info("Inventory", string.format("Inventory hotkey registered: %s", conf.inventory.openKey))
else
    ig.log.Warn("Inventory", "Inventory hotkey disabled by configuration")
end

-- ====================================================================================--
-- Exports
-- ====================================================================================--

---
-- Export function to open dual inventory
exports("OpenDualInventory", function(netId, title)
    TriggerEvent("Client:Inventory:OpenDual", netId, title)
    TriggerEvent("Client:NUI:InventoryOpenDual", netId, title)
end)

---
-- Export function to open single inventory
exports("OpenSingleInventory", function()
    TriggerEvent("Client:Inventory:OpenSingle")
end)
