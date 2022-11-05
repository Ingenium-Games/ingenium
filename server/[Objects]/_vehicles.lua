-- ====================================================================================--

c.vehicle = {} -- function level
c.vehicles = {}
c.vdex = {} -- vehicles...

-- ====================================================================================--

--[[
{
[1] = {
    ['Coords'] = {"x":0.00,"y":0.00,"z":0.00,"h":0.00},
    ['Parked'] = true,
    ['Garage'] = A,
    ['ID'] = 1,
    ['Mileage'] = 0,
    ['Plate'] = lux773ie,
    ['Model'] = openwheel1,
    ['Fuel'] = 100,
    ['Impound'] = false,
    ['Condition'] = [1000.0,1000.0,1000.0,1000.0,14.0,65.0,1,[],[],[],
    ['Wanted'] = false,
    ['Inventory'] = [],
    ['Keys'] = [],
    ['Updated'] = 1667615839,
    ['Character_ID'] = wv5g1v159t4ek574o827x0z58hekjs8n0ro75k81de589glub2,
    ['Modifications'] = ["lux773ie",'[]',27,27,0,0,[255,255,255],[255,255,255],8,156,[255,255,255],255,[255,0,255],[false,false,false,false],'[[1,0],[2,0],[3,0],[4,0],[5,0],[6,0]',10,false,false,false,false,0,-1,-1,-1],
    },
}
]]--

function c.vehicle.Generate(timeout, distance)
	for id, data in pairs(c.vehicles) do
        local found = c.data.FindVehicleFromPlate(data.Plate)
        print(found)
        if (not found) then
            print(data.Parked)
            if (not data.Parked) then
                print(data.Plate)
                local Coords = json.decode(data.Coords)
                if (c.func.GetClosestPlayer(vec3(Coords.x,Coords.y,Coords.z), distance)) then
                    print('closest')
                    -- vehicle not found, spawn it when player is close
                    Citizen.CreateThread(function()
                        local entity, net = c.func.CreateVehicle(data.Model, Coords.x, Coords.y, Coords.z, Coords.h, data)
                        SetVehicleNumberPlateText(entity, data.Plate)
                        print('created')
                    end)
                end
            end
        end
	end
end

function c.vehicle.SyncCheck()
    c.sql.veh.Generate()
    Citizen.Wait(5000)
    for id, data in pairs(c.vehicles) do
        local Coords = json.decode(data.Coords)
        local xVehicle = c.data.GetVehicleByPlate(data.Plate)
        if xVehicle then
            local EntityCoords = xVehicle.GetCoords()
            if EntityCoords ~= Coords then
                xVehicle.SetUpdated()
            end
        end
    end
end