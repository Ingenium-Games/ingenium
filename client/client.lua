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
                
                -- Load static reference data from local JSON files (distributed via fxmanifest)
                ig.log.Info("Client", "Loading static reference data from local files...")
                
                -- Load peds (character models)
                ig.peds = ig.json.Load('peds') or {}
                ig.log.Debug("Client", "Loaded %d peds from local file", ig.table.SizeOf(ig.peds))
                
                -- Load tattoos
                ig.tattoos = ig.json.Load('tattoos') or {}
                ig.log.Debug("Client", "Loaded %d tattoo entries from local file", ig.table.SizeOf(ig.tattoos))
                
                -- Load appearance constants
                ig.appearance_constants = ig.json.Load('appearance-constants') or {}
                ig.log.Debug("Client", "Loaded appearance constants from local file")
                
                -- Load weapons 
                ig.weapons = ig.json.Load('weapons') or {}
                ig.log.Debug("Client", "Loaded %d weapons from local file", ig.table.SizeOf(ig.weapons))
                
                -- Load vehicles
                ig.vehicles = ig.json.Load('vehicles') or {}
                ig.log.Debug("Client", "Loaded %d vehicles from local file", ig.table.SizeOf(ig.vehicles))
                
                -- Load items
                ig.items = ig.json.Load('items') or {}
                ig.log.Debug("Client", "Loaded %d items from local file", ig.table.SizeOf(ig.items))

                -- Protect static reference data from client-side modification
                ig.peds = ig.table.MakeReadOnly(ig.peds, "ig.peds")
                ig.tattoos = ig.table.MakeReadOnly(ig.tattoos, "ig.tattoos")
                ig.appearance_constants = ig.table.MakeReadOnly(ig.appearance_constants, "ig.appearance_constants")
                ig.weapons = ig.table.MakeReadOnly(ig.weapons, "ig.weapons")
                ig.vehicles = ig.table.MakeReadOnly(ig.vehicles, "ig.vehicles")
                ig.items = ig.table.MakeReadOnly(ig.items, "ig.items")
                
                ig.log.Info("Client", "Static reference data loaded and protected")
                
                -- Now request only DYNAMIC runtime data from server
                ig.log.Info("Client", "Requesting dynamic runtime data from server...")
                local initData = ig.callback.Await("GetInitializationData")
                ig.log.Info("Client", "GetInitializationData response received: %s", initData and "YES" or "NIL")
                
                if initData then
                    -- Load Doors (dynamic state: locked/unlocked)
                    if initData.doors then
                        ig.door.SetDoors(initData.doors)
                        ig.door.AddDoorsToSystem(initData.doors)
                        ig.log.Debug("Client", "Loaded %d doors with current state", ig.table.SizeOf(initData.doors))
                    end
                    
                    -- Load spawned Objects (dynamic: current objects in world)
                    if initData.objects then
                        ig.objects = initData.objects
                        ig.log.Debug("Client", "Loaded %d spawned objects", ig.table.SizeOf(initData.objects))
                    end
                    --         
                end

                -- END OF DATA STATIC AND DYNAMIC LOADING

                ig.ipl.LoadConfigurations()
                --
                ig.vehicle.InitializeClient()
                --
                ig.weapon.InitializeWeaponData(ig.weapons)
            end)
            --
            return
        end
    end
end)

