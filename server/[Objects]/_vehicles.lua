--
ig.vehicle = {} -- function level
ig.vehicles = {} -- loaded past / present players

-- ====================================================================================--
-- Vehicles - ig.vdex = Object Table with xVehicle as referance obj, ig.vehicle = function table

ig.vdex = {} -- the index/store for currently generated vehicles

---@param net integer "Network ID 16 bit integer"
function ig.vehicle.FindVehicle(net)
    for k, v in pairs(ig.vdex) do
        if v then
            if v.Net == net then
                return true, v, k
            end
        end
    end
    return false, false, false
end

---@param plate string "Plate of vehicle."
function ig.vehicle.FindVehicleFromPlate(plate)
    for k, v in pairs(ig.vdex) do
        if (v and v.Plate == plate) then
            return true
        end
    end
    return false
end

---@param plate string "Plate of vehicle."
function ig.vehicle.GetVehicleByPlate(plate)
    for k, v in pairs(ig.vdex) do
        if v then
            if v.Plate == plate then
                return v
            end
        end
    end
    return false
end

--- func desc
---@wiki:ignore
---@param net any
---@param cb any
function ig.vehicle.AddVehicle(net, cb, ...)
    -- local aa, bb, cc = ig.vehicle.FindVehicle(net)
    -- if (not aa) then
        ig.vdex[tonumber(net)] = cb(...)
    -- end
end

--- func desc
---@wiki:ignore
---@param net any
---@param cb any
function ig.vehicle.SetVehicle(net, cb, ...)
    ig.vdex[tonumber(net)] = cb(...)
    return ig.vdex[tonumber(net)]
end

--- Get the xVehicle Data/Table
---@param net integer "Network ID 16 bit integer or Plate (8 char string)"
function ig.vehicle.GetVehicle(arg)
    if ig.vdex[tonumber(arg)] ~= false then
        return ig.vdex[tonumber(arg)]
    else
        ig.func.Debug_1("No Vehicle Found.")
        return false
    end
end

--- Get all xVehicles
function ig.vehicle.GetVehicles()
    return ig.vdex
end

-- Set to nil for garbage collection
--- func desc
---@wiki:ignore
---@param arg any
function ig.vehicle.RemoveVehicle(arg)
    if ig.vdex[tonumber(arg)] then
        ig.vdex[tonumber(arg)] = nil
    end
end
