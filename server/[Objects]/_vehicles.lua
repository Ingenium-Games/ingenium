-- ====================================================================================--

c.vehicle = {} -- function level
c.vehicles = exports["ig.dump"]:GetVehicles()
c.vdex = {} -- the index/store for currently used vehciles prior to writing to db.
--[[
NOTES.
    - Some natives use entity
    - Some natives use NetworkID.
    - Network ID should be for the server and entity for the individual user is different.
    - data getters within the _data file.
]]--

-- ====================================================================================--

---@param net integer "Network ID 16 bit integer"
function c.vehicle.Find(net)
    for k,v in ipairs(c.vdex) do
        if k == net and type(v) == "table" then
            return true
        end
    end
    return false
end

---@param plate string "Plate of vehicle."
function c.vehicle.GetByPlate(plate)
    for k,v in pairs(c.vdex) do
        if v.Plate == plate then
            return v
        end
    end 
    return false
end

function c.vehicle.GetDumpedHashes()
    local t = {}
    for k,v in pairs(c.vehicles) do
        table.insert(t, v.SignedHash)
    end 
    
    print(c.table.Dump(t))
    return t
end