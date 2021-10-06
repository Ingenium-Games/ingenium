-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.vehicle = {} -- function level
c.vehicles = {} -- database pull - If ever used?	
c.vdex = {} -- the index/store for currently used vehciles prior to writing to db.
--[[
NOTES.
    - Some natives use entity
    - Some natives use NetworkID.
    - Network ID should be for the server and entity for the individual user is different.
    - data getters within the _data file.
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

function c.vehicle.Find(net)
    for k,v in pairs(c.vdex) do
        if v == net then
            return true
        end
    end
    return false
end

function c.vehicle.Add(net, vehicle)
    if not c.vehicle.Find(net) then
        table.insert(c.vdex, net)
        c.vdex[net] = vehicle
    end
end

function c.vehicle.CleanUp()
    for k,v in pairs(c.vdex) do
        if not DoesEntityExist(NetworkGetEntityFromNetworkId(v)) then
            table.remove(c.vdex, v)
        end
    end
end

function c.vehicle.GetByPlate(plate)
    for k,v in pairs(c.vdex) do
        if v.Plate == plate then
            return v
        end
    end 
    return false
end