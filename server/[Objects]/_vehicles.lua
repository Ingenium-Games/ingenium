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


function c.vehicle.GetVehicles()
    return c.vehicles
end

function c.vehicle.SetVehicles(veh)
    c.vehicles = veh
end

function c.vehicle.Generate(distance)
    for id, data in pairs(c.vehicle.GetVehicles()) do
        if (not data.Spawned) then
            local Model = data.Model
            local Coords = json.decode(data.Coords)
            local Condition = json.decode(data.Condition)
            local Modificaitons = json.decode(data.Modificaitons)
            local db = c.sql.veh.GetByPlate(data.Plate)
            local ply = c.func.GetClosestPlayer(vec3(Coords.x, Coords.y, Coords.z), distance)
            if (ply) then
                Citizen.CreateThread(function()
                    --
                    local entity, net = c.func.CreateVehicle(data.Model, Coords.x, Coords.y, Coords.z, Coords.h, db)
                    --
                    if not entity then
                        local _, net = TriggerClientCallback({source = ply, eventName = "EnsurePersistantVehicle", args = {Model, Coords}})
                        c.data.AddVehicle(net, c.class.OwnedVehicle, net, db)
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
        if (id and c.vehicles[id]) then
            c.vehicles[id].Spawned = true
            if (not DoesEntityExist(vehicle)) then
                c.vehicles[id].Spawned = false
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
    if (id and c.vehicles[id]) then
        if not recent[id] then
            local xVehicle = c.data.GetVehicle(net)
            c.sql.save.Vehicle(xVehicle, function()
                recent[id] = true
            end)
        end
    else
        local xVehicle = c.data.GetVehicle(net)
        local data = {
            Character_ID = xVehicle.GetOwner(),
            Model = xVehicle.GetModel(),
            Plate = xVehicle.GetPlate(),
            Coords = xVehicle.GetCoords(),
            Condition = json.encode(condition),
            Modifications = json.encode(modifications)
        }
        --
        c.sql.veh.Add(data, function()
            local data = c.sql.veh.GetByPlate(xVehicle.Plate)
            xVehicle.SetID(data.ID)
            xVehicle.SetCondition(json.decode(data.Condition))
            xVehicle.SetModifications(json.decode(data.Modifications))
            c.vehicles[data.ID] = data
            c.vehicles[data.ID].Spawned = true
        end)
    end
end)


]] --