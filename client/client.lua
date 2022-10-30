-- ====================================================================================--



-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if NetworkIsSessionStarted() then
            --    
            TriggerServerEvent("Server:Queue:ConfirmedPlayer")
            c.data.Initilize(function()
                --
                DisplayRadar(false)
                -- Grab the Items prior to characters loading, this way any checks wont impact them
                local items = TriggerServerCallback({eventName = "GetItems", args = {}})
                c.item.SetItems(items)
                --
                local doors = TriggerServerCallback({eventName = "GetDoors", args = {}})
                c.door.SetDoors(doors)
                c.door.AddDoorsToSystem(doors)
                --                
                local objects = TriggerServerCallback({eventName = "GetObjects", args = {}})
                c.objects.SetObjects(objects)
                c.objects.AddObjectsToEnviroment(objects)
                --        


            end)
            --
            return
        end
    end
end)

