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
        if k == net then
            return true
        end
    end
    return false
end

function c.vehicle.Add(net, vehicle)
    if not c.vehicle.Find(net) then
        c.vdex[net] = vehicle
    end
    c.debug(c.table.Dump(c.vdex))
end

function c.vehicle.CleanUp()
    for k,v in pairs(c.vdex) do
        if not DoesEntityExist(NetworkGetEntityFromNetworkId(k)) then
            table.remove(c.vdex, k)
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