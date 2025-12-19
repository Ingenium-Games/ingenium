-- ====================================================================================--
ig.vehicle = {} -- function level
ig.vehicles = {}
ig.vdex = {} -- vehicles...
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
    ['Spawned'] = false,
    ['Condition'] = [1000.0,1000.0,1000.0,1000.0,14.0,65.0,1,[],[],[],
    ['Wanted'] = false,
    ['Inventory'] = [],
    ['Keys'] = [],
    ['Updated'] = 1667615839,
    ['Character_ID'] = wv5g1v159t4ek574o827x0z58hekjs8n0ro75k81de589glub2,
    ['Modifications'] = ["lux773ie",'[]',27,27,0,0,[255,255,255],[255,255,255],8,156,[255,255,255],255,[255,0,255],[false,false,false,false],'[[1,0],[2,0],[3,0],[4,0],[5,0],[6,0]',10,false,false,false,false,0,-1,-1,-1],
    },
}


function ig.vehicle.GetVehicles()
    return ig.vehicles
end

function ig.vehicle.SetVehicles(veh)
    ig.vehicles = veh
end

function ig.vehicle.Generate(distance)
    for id, data in pairs(ig.vehicle.GetVehicles()) do
        if (not data.Spawned) then
            local Model = data.Model
            local Coords = json.decode(data.Coords)
            local Condition = json.decode(data.Condition)
            local Modificaitons = json.decode(data.Modificaitons)
            local db = ig.sql.veh.GetByPlate(data.Plate)
            local ply = ig.func.GetClosestPlayer(vec3(Coords.x, Coords.y, Coords.z), distance)
            if (ply) then
                Citizen.CreateThread(function()
                    --
                    local entity, net = ig.func.CreateVehicle(data.Model, Coords.x, Coords.y, Coords.z, Coords.h, db)
                    --
                    if not entity then
                        local _, net = TriggerClientCallback({source = ply, eventName = "EnsurePersistantVehicle", args = {Model, Coords}})
                        ig.data.AddVehicle(net, ig.class.OwnedVehicle, net, db)
                    end
                end)
            end
        end
    end
end

AddStateBagChangeHandler("Spawned", nil, function(bagName, key, value, _unused, replicated)
    print("AddStateBagChangeHandler('Spawned')")
    if (bagName:find("entity:")) then
        local string = bagName:gsub("entity:", "")
        local net = tonumber(string)
        local vehicle = NetworkGetEntityFromNetworkId(net)
        local id = Entity(vehicle).state.ID
        if (id and ig.vehicles[id]) then
            ig.vehicles[id].Spawned = true
            if (not DoesEntityExist(vehicle)) then
                ig.vehicles[id].Spawned = false
            end
        end
    end
end)

local recent = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3500)
        recent = {}
    end
end)

-- triggered from client side to either update or insert a vehicle
RegisterNetEvent("Vehicle:Update", function(net, model, modifications, condition)
    local vehicle = NetworkGetEntityFromNetworkId(net)
    if (not DoesEntityExist(vehicle) or GetEntityRoutingBucket(vehicle) ~= 0) then
        return
    end

    local id = Entity(vehicle).state.ID
    if (id and ig.vehicles[id]) then
        if not recent[id] then
            local xVehicle = ig.data.GetVehicle(net)
            ig.sql.save.Vehicle(xVehicle, function()
                recent[id] = true
            end)
        end
    else
        local xVehicle = ig.data.GetVehicle(net)
        local data = {
            Character_ID = xVehicle.GetOwner(),
            Model = xVehicle.GetModel(),
            Plate = xVehicle.GetPlate(),
            Coords = xVehicle.GetCoords(),
            Condition = json.encode(condition),
            Modifications = json.encode(modifications)
        }
        --
        ig.sql.veh.Add(data, function()
            local data = ig.sql.veh.GetByPlate(xVehicle.Plate)
            xVehicle.SetID(data.ID)
            xVehicle.SetCondition(json.decode(data.Condition))
            xVehicle.SetModifications(json.decode(data.Modifications))
            ig.vehicles[data.ID] = data
            ig.vehicles[data.ID].Spawned = true
        end)
    end
end)


]] --