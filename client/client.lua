-- ====================================================================================--

-- ====================================================================================--
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
                local initData = TriggerServerCallback({
                    eventName = "GetInitializationData",
                    args = {}
                })
                
                -- Load Items
                if initData and initData.items then
                    ig.item.SetItems(initData.items)
                end
                
                -- Load Doors
                if initData and initData.doors then
                    ig.door.SetDoors(initData.doors)
                    ig.door.AddDoorsToSystem(initData.doors)
                end
                
                -- Load Objects
                if initData and initData.objects then
                    ig.objects.SetObjects(initData.objects)
                    ig.objects.AddToEnviroment(initData.objects)
                end
                
                -- Load Weapons and initialize weapon data (categories and components) for forced animations
                if initData and initData.weapons then
                    ig.weapon.InitializeWeaponData(initData.weapons)
                else
                    -- Fallback if batched request returns nil for weapons
                    ig.weapon.InitializeWeaponData()
                end
                
                --        
                ig.ipl.LoadConfigurations()
                --
                ig.vehicle.InitializeClient()
            end)
            --
            return
        end
    end
end)

