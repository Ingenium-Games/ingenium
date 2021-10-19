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

---@param plate string "Plate of vehicle."
function c.vehicle.GetByPlate(plate)
    for k,v in pairs(c.vdex) do
        if v.Plate == plate then
            return v
        end
    end 
    return false
end

---@param net integer "Network ID 16 bit integer"
function c.vehicle.Find(net)
    for k,v in ipairs(c.vdex) do
        if k == net and type(v) == "table" then
            return true
        end
    end
    return false
end


-- Runs off net id's within the table
function c.vehicle.CleanOne(net)
    local ent = NetworkGetEntityFromNetworkId(net)
    if not DoesEntityExist(ent) then
        table.remove(c.vdex, net)
    end
end

-- Runs off net id's within the table
function c.vehicle.CleanAll()
    for k,v in ipairs(c.vdex) do
        -- Check the entities do not exist.
        if not DoesEntityExist(v.Entity) then
            table.remove(c.vdex, k)
        end
    end
end

function c.vehicle.CleanUp()
    local function Do()
        c.vehicle.CleanAll()
        SetTimeout(conf.cleanup, Do)
    end
    SetTimeout(conf.cleanup, Do)
end