-- ====================================================================================--
-- Drop Targets: ig.target integration for drop interactions
-- ====================================================================================--

CreateThread(function()
    -- Wait for target export to be available
    while not exports['ig.target'] do
        Wait(1000)
    end
    
    -- Add target interaction for drop models
    exports['ig.target']:AddModel(conf.drops.default_model, {
        options = {
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
                                    print("^1Failed to access drop: " .. (result.error or "Unknown error") .. "^0")
                                end
                            end
                        })
                    end
                end,
            },
        },
        distance = 2.0,
    })
    
    ig.func.Debug_1("Drop targets registered with ig.target")
end)
