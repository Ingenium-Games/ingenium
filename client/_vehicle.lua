-- ====================================================================================--
-- Helper Functions
-- ====================================================================================--
ig.vehicle = {}

--- Get current vehicle player is in
---@return number vehicle entity
function ig.vehicle.GetCurrentVehicle()
    return ig.vehicles.currentVehicle
end

--- Get current seat player is in
---@return number seat index (-1 = driver)
function ig.vehicle.GetCurrentSeat()
    return ig.vehicles.currentSeat
end

--- Check if player is in a vehicle
---@return boolean
function ig.vehicle.IsInVehicle()
    return currentVehicle ~= 0
end