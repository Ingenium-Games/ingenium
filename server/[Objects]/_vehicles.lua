--
ig.vehicle = ig.vehicle or {}
-- Vehicles management (ig.vehicles, ig.vdex initialized in server/_var.lua)

-- ====================================================================================--
-- Vehicles - ig.vdex = Object Table with xVehicle as referance obj, ig.vehicle = function table


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

--- Adds a new Vehicle instance to the vehicle index
---@param net integer "Network ID (16-bit integer)"
---@param cb function "Callback function to instantiate Vehicle class"
---@param ... any "Arguments to pass to callback function"
function ig.vehicle.AddVehicle(net, cb, ...)
    -- local aa, bb, cc = ig.vehicle.FindVehicle(net)
    -- if (not aa) then
        ig.vdex[tonumber(net)] = cb(...)
    -- end
end

--- Sets/replaces a Vehicle instance in the vehicle index
---@param net integer "Network ID (16-bit integer)"
---@param cb function "Callback function to instantiate Vehicle class"
---@param ... any "Arguments to pass to callback function"
---@return table The created vehicle instance
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
        ig.log.Debug("VEHICLE", "No Vehicle Found.")
        return false
    end
end

--- Get all xVehicles
function ig.vehicle.GetVehicles()
    return ig.vdex
end

--- Removes a vehicle from the index by setting it to nil for garbage collection
---@param arg integer|string "Network ID (16-bit integer) or vehicle plate"
function ig.vehicle.RemoveVehicle(arg)
    if ig.vdex[tonumber(arg)] then
        ig.vdex[tonumber(arg)] = nil
    end
end
