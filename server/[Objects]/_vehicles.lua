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
        if (not found) then
            if data.Parked then
                local Coords = json.decode(data.Coords)
                local Condition = json.decode(data.Condition)
                local Modificaitons = json.decode(data.Modificaitons)
                if (c.func.GetClosestPlayer(vec3(Coords.x,Coords.y,Coords.z), distance)) then
                    Citizen.CreateThread(function()
                        --
                        local entity = CreateVehicle(data.Model, Coords.x, Coords.y, Coords.z, Coords.h, true, false)
                        while (not DoesEntityExist(entity)) or (NetworkGetNetworkIdFromEntity(entity) == 0) do
                            Wait(0)
                        end
                        
                        --
                        local ped = GetPedInVehicleSeat(entity, -1)
                        if (ped and DoesEntityExist(ped) and not IsPedAPlayer(ped)) then
                            DeleteEntity(ped)
                        end

                        --
                        SetEntityCoords(entity, vec3(Coords.x, Coords.y, Coords.z))
                        SetEntityHeading(entity, Coords.h)

                        --
                        SetVehicleDoorsLocked(entity, Condition[7])
                        SetVehicleNumberPlateText(entity, Modificaitons[1])

                        --
                        c.data.AddVehicle(NetworkGetNetworkIdFromEntity(entity), c.class.OwnedVehicle, NetworkGetNetworkIdFromEntity(entity), data)
                    end)
                end
            end
        end
	end
end