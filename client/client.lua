-- ====================================================================================--

-- ====================================================================================--

-- Disable auto-spawn at startup to prevent players from spawning during character selection
exports.spawnmanager:setAutoSpawn(false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            --    
            TriggerServerEvent("Server:Queue:ConfirmedPlayer")
            ig.data.Initilize(function()
                --
                DisplayRadar(false)
                
                -- Batch initialization: Get all required data in a single server callback
                ig.log.Info("Client", "Requesting GetInitializationData from server...")
                local initData = ig.callback.Await("GetInitializationData")
                ig.log.Info("Client", "GetInitializationData response received: %s", initData and "YES" or "NIL")
                
                if initData then
                    -- Load Items
                    if initData.items then
                        ig.item.SetItems(initData.items)
                    end
                    
                    -- Load Doors
                    if initData.doors then
                        ig.door.SetDoors(initData.doors)
                        ig.door.AddDoorsToSystem(initData.doors)
                    end
                    
                    -- Load Objects
                    if initData.objects then
                        ig.objects = initData.objects
                    end
                    
                    -- Load Tattoos
                    if initData.tattoos then
                        ig.tattoos = initData.tattoos
                    end
                    
                    -- Load Appearance Data
                    if initData.peds then
                        ig.peds = initData.peds
                    end
                    
                    if initData.appearance_constants then
                        ig.appearance_constants = initData.appearance_constants
                    end
                    
                    -- Load Weapons and initialize weapon data (categories and components) for forced animations
                    if initData.weapons then
                        ig.weapon.InitializeWeaponData(initData.weapons)
                    else
                        -- Fallback if batched request returns nil for weapons
                        ig.weapon.InitializeWeaponData()
                    end
                    
                    --        
                    ig.ipl.LoadConfigurations()
                    --
                    ig.vehicle.InitializeClient()
                end
            end)
            --
            return
        end
    end
end)

