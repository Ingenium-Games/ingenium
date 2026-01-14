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
    
    -- Get external inventory via callback
    TriggerServerCallback({
        eventName = "GetInventory",
        args = {externalNetId},
        callback = function(externalInventory)
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
        end
    })
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
-- NUI Callbacks
-- ====================================================================================--

---
-- Handle inventory close from NUI
RegisterNUICallback("NUI:Client:InventoryClose", function(data, cb)
    inventoryOpen = false
    SetNuiFocus(false, false)
    
    local playerInventory = data.playerInventory or {}
    local externalInventory = data.externalInventory or {}
    local externalNetId = data.externalNetId
    
    -- Send to server for validation and saving
    if externalNetId then
        -- Dual inventory
        TriggerServerCallback({
            eventName = "OrganizeInventories",
            args = {externalNetId, playerInventory, externalInventory},
            callback = function(success)
                if success then
                    ig.log.Info("Inventory", "Inventory saved successfully")
                else
                    ig.log.Error("Inventory", "Inventory save failed")
                end
            end
        })
    else
        -- Single inventory (player only)
        TriggerServerCallback({
            eventName = "OrganizeInventory",
            args = {GetPlayerPed(-1), playerInventory},
            callback = function(success)
                if success then
                    ig.log.Info("Inventory", "Inventory saved successfully")
                else
                    ig.log.Error("Inventory", "Inventory save failed")
                end
            end
        })
    end
    
    currentExternalNetId = nil
    
    cb({
        message = "ok",
        data = nil
    })
end)

---
-- Handle item actions (Use, Give, Drop)
RegisterNUICallback("NUI:Client:InventoryAction", function(data, cb)
    local action = data.action
    local item = data.item
    local position = data.position
    local panelId = data.panelId
    
    if action == "use" then
        -- Use item
        TriggerServerCallback({
            eventName = "UseItem",
            args = {position},
            callback = function(success)
                if success then
                    -- Item was consumed, update UI
                    TriggerEvent("Client:Inventory:Update", ig.inventory.GetInventory(), nil)
                    TriggerEvent("Client:NUI:InventoryUpdate", ig.inventory.GetInventory(), nil)
                end
            end
        })
    elseif action == "give" then
        -- Give item to nearby player
        -- This would typically open a player selector
        TriggerEvent("Client:Inventory:GiveItem", item, position)
        TriggerEvent("Client:NUI:InventoryGiveItem", item, position)
    elseif action == "drop" then
        -- Drop item on ground
        local playerCoords = GetEntityCoords(PlayerPedId())
        TriggerServerCallback({
            eventName = "DropItem",
            args = {position, playerCoords},
            callback = function(success)
                if success then
                    -- Item was dropped, update UI
                    TriggerEvent("Client:Inventory:Update", ig.inventory.GetInventory(), nil)
                    TriggerEvent("Client:NUI:InventoryUpdate", ig.inventory.GetInventory(), nil)
                end
            end
        })
    end
    
    cb({
        message = "ok",
        data = nil
    })
end)

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
