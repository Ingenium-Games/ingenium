-- ====================================================================================--
-- Drop Targets: Integrated targeting system for drop interactions
-- ====================================================================================--

CreateThread(function()
    -- Wait for ingenium exports to be available
    while not exports['ingenium'] do
        Wait(1000)
    end
    
    -- Add target interaction for drop models
    exports['ingenium']:AddModel(conf.drops.default_model, {
        {
            icon = 'fa-solid fa-box-open',
            label = 'Open Drop',
            action = function(entity)
                local netId = NetworkGetNetworkIdFromEntity(entity)
                if netId then
                    -- Open dual-panel inventory UI for the drop
                    TriggerEvent("Client:Inventory:OpenDual", netId, "Ground Drop")
                    
                    -- Notify server that drop is being accessed using secure callback
                    TriggerServerCallback({
                        eventName = 'Server:Drop:Access',
                        args = {netId},
                        callback = function(result)
                            if result and not result.success then
                                ig.debug.Error("Failed to access drop: " .. (result.error or "Unknown error"))
                            end
                        end
                    })
                end
            end,
        },
    })
    
    ig.log.Info("Drops", "Drop targets registered with ingenium targeting system")
end)
