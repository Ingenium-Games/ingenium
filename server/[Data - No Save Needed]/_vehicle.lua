-- ====================================================================================--
-- Vehicles (ig.vehicle, ig.vehicles initialized in server/_var.lua)

-- ============================================
-- VEHICLE HELPERS
-- ============================================

---Get all vehicle data
---@return table All vehicles data
function ig.vehicle.GetAll()
    return ig.vehicles
end

---Get vehicle data by hash
---@param hash number Vehicle hash
---@return table|nil Vehicle data or nil if not found
function ig.vehicle.GetByHash(hash)
    return ig.vehicles[tostring(hash)]
end

---Get vehicle data by name
---@param name string Vehicle model name
---@return table|nil Vehicle data or nil if not found
function ig.vehicle.GetByName(name)
    for _, vehicle in pairs(ig.vehicles) do
        if vehicle.name:lower() == name:lower() then
            return vehicle
        end
    end
    return nil
end

---Get vehicles by class
---@param class string Vehicle class (e.g., "Sports", "Super", "SUV")
---@return table Array of vehicles in class
function ig.vehicle.GetByClass(class)
    local result = {}
    for _, vehicle in pairs(ig.vehicles) do
        if vehicle.class == class then
            table.insert(result, vehicle)
        end
    end
    return result
end

---Get vehicles by manufacturer
---@param manufacturer string Manufacturer name
---@return table Array of vehicles by manufacturer
function ig.vehicle.GetByManufacturer(manufacturer)
    local result = {}
    for _, vehicle in pairs(ig.vehicles) do
        if vehicle.manufacturer == manufacturer then
            table.insert(result, vehicle)
        end
    end
    return result
end

---Get vehicle display name
---@param hash number Vehicle hash
---@return string Display name or "Unknown"
function ig.vehicle.GetDisplayName(hash)
    local vehicle = ig.vehicle.GetByHash(hash)
    return vehicle and vehicle.label or "Unknown"
end

---Check if vehicle is aircraft
---@param hash number Vehicle hash
---@return boolean True if aircraft
function ig.vehicle.IsAircraft(hash)
    local vehicle = ig.vehicle.GetByHash(hash)
    return vehicle and (vehicle.class == "Helicopters" or vehicle.class == "Planes")
end

---Check if vehicle is boat
---@param hash number Vehicle hash
---@return boolean True if boat
function ig.vehicle.IsBoa(hash)
    local vehicle = ig.vehicle.GetByHash(hash)
    return vehicle and vehicle.class == "Boats"
end
