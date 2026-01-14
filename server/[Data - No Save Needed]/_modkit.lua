-- ====================================================================================--
ig.modkit = {} -- function level
ig.modkits = {} -- names table to be imported from Names.json
-- ====================================================================================--

--- func desc
---@wiki:ignore 
---@param . any
function ig.modkit.Load()
    if ig.json.Exists(conf.file.modkits) then
        local file = ig.json.Read(conf.file.modkits)
        ig.modkits = file
    end
end

-- ============================================
-- MODKIT HELPERS
-- ============================================

---Get all modkit data
---@return table All modkits data
function ig.modkit.GetAll()
    return ig.modkits
end

---Get modkit data by ID
---@param id number Modkit ID
---@return table|nil Modkit data or nil if not found
function ig.modkit.GetByID(id)
    return ig.modkits[tostring(id)]
end

---Get modkit for vehicle
---@param vehicleHash number Vehicle hash
---@return table|nil Modkit data or nil if not found
function ig.modkit.GetForVehicle(vehicleHash)
    for _, modkit in pairs(ig.modkits) do
        if modkit.vehicle_hash == vehicleHash then
            return modkit
        end
    end
    return nil
end

---Check if modkit exists for vehicle
---@param vehicleHash number Vehicle hash
---@return boolean True if modkit exists
function ig.modkit.HasModkit(vehicleHash)
    return ig.modkit.GetForVehicle(vehicleHash) ~= nil
end
