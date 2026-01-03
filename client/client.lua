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
                -- Grab the Items prior to characters loading, this way any checks wont impact them
                local items = TriggerServerCallback({eventName = "GetItems", args = {}})
                ig.item.SetItems(items)
                --
                local doors = TriggerServerCallback({eventName = "GetDoors", args = {}})
                ig.door.SetDoors(doors)
                ig.door.AddDoorsToSystem(doors)
                --                
                local objects = TriggerServerCallback({eventName = "GetObjects", args = {}})
                ig.objects.SetObjects(objects)
                ig.objects.AddToEnviroment(objects)
                --        

                ig.ipl.LoadConfigurations()
            end)
            --
            return
        end
    end
end)

