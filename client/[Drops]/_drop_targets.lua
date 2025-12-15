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
                icon = 'fa-solid fa-hand-holding',
                label = 'Pick Up Items',
                action = function(entity)
                    local netId = NetworkGetNetworkIdFromEntity(entity)
                    if netId then
                        TriggerServerEvent('Server:Item:Pickup', netId)
                    end
                end,
            },
        },
        distance = 2.0,
    })
    
    c.func.Debug_1("Drop targets registered with ig.target")
end)
