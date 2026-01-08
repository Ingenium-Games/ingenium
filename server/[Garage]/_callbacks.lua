local GetCar = exports["ig.core"]:RegisterServerCallback({
    eventName = "GetCar",
    eventCallback = function(source, plate)
        local data = c.sql.veh.GetByPlate(plate)[1]
        return data
    end
})

local GetCars = exports["ig.core"]:RegisterServerCallback({
    eventName = "GetCars",
    eventCallback = function(source, character_id)
        local xPlayer = c.data.GetPlayer(source)
        local data = c.sql.veh.GetAll(xPlayer.GetCharacter_ID())
        return data
    end
})

local EnsurePlayerVehicle = exports["ig.core"]:RegisterServerCallback({
    eventName = "EnsurePlayerVehicle",
    eventCallback = function(source, data, spot)
        local entity = CreateVehicle(data.Model, spot.x, spot.y, spot.z, spot.h, true, false)
        
        -- Optimized: Use more efficient waiting with frame budget
        local startTime = GetGameTimer()
        local timeout = 3000
        
        while not DoesEntityExist(entity) do
            local elapsed = GetGameTimer() - startTime
            if elapsed >= timeout then
                c.func.Debug_1("Timeout reached on creating vehicle")
                return false, false
            end
            -- Wait 10ms to balance CPU usage with responsiveness
            Citizen.Wait(10)
        end
        
        local net = NetworkGetNetworkIdFromEntity(entity)
        c.data.AddVehicle(net, c.class.OwnedVehicle, net, data)
        return net
    end
})

local ParkingBill = exports["ig.core"]:RegisterServerCallback({
    eventName = "ParkingBill",
    eventCallback = function(source)
        local amount = 5
        local xPlayer = c.data.GetPlayer(source)
        local xJob = c.data.GetJob("city")
        if xPlayer.GetBank() < amount then
            return false
        else
            xPlayer.RemoveBank(amount)
            xJob.AddBank(amount)
            return true
        end
    end
})