local GetCar = RegisterServerCallback({
    eventName = "GetCar",
    eventCallback = function(source, plate)
        local data = ig.sql.veh.GetByPlate(plate)[1]
        return data
    end
})

local GetCars = RegisterServerCallback({
    eventName = "GetCars",
    eventCallback = function(source, character_id)
        local xPlayer = ig.data.GetPlayer(source)
        local data = ig.sql.veh.GetAll(xPlayer.GetCharacter_ID())
        return data
    end
})

local EnsurePlayerVehicle = RegisterServerCallback({
    eventName = "EnsurePlayerVehicle",
    eventCallback = function(source, data, spot)
        local entity = CreateVehicle(data.Model, spot.x, spot.y, spot.z, spot.h, true, false)
        
        -- Optimized: Use more efficient waiting with frame budget
        local startTime = GetGameTimer()
        local timeout = 3000
        
        while not DoesEntityExist(entity) do
            local elapsed = GetGameTimer() - startTime
            if elapsed >= timeout then
                ig.funig.Debug_1("Timeout reached on creating vehicle")
                return false, false
            end
            -- Wait 10ms to balance CPU usage with responsiveness
            Citizen.Wait(10)
        end
        
        local net = NetworkGetNetworkIdFromEntity(entity)
        ig.data.AddVehicle(net, ig.class.OwnedVehicle, net, data)
        return net
    end
})

local ParkingBill = RegisterServerCallback({
    eventName = "ParkingBill",
    eventCallback = function(source)
        local amount = 5
        local xPlayer = ig.data.GetPlayer(source)
        local xJob = ig.data.GetJob("city")
        if xPlayer.GetBank() < amount then
            return false
        else
            xPlayer.RemoveBank(amount)
            xJob.AddBank(amount)
            return true
        end
    end
})