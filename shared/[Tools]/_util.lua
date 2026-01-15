-- ====================================================================================--
-- Shared Utility Functions (ig.util initialized in shared/_ig.lua)
-- Common helper functions to reduce code duplication
-- ====================================================================================--

--- Ensures a value is a table (converts single values to array)
--- Used to normalize API inputs that accept both single values and arrays
---@param value any Single value or table
---@return table Array containing the value(s)
function ig.util.EnsureTable(value)
    if type(value) ~= 'table' then 
        return { value } 
    end
    return value
end

--- Checks if a bone is valid and within distance threshold
--- Used for entity bone proximity checking in target systems
---@param entity number Entity ID
---@param bone number Bone index
---@param coords vector3 Player coordinates
---@param threshold number Distance threshold
---@return boolean True if bone is valid and within distance
function ig.util.CheckBoneDistance(entity, bone, coords, threshold)
    if bone and bone ~= -1 then
        local boneCoords = GetWorldPositionOfEntityBone(entity, bone)
        local dist = #(coords - boneCoords)
        return dist < threshold
    end
    return false
end

--- Checks if a vehicle is locked (status > 1)
--- Provides a cleaner semantic check for vehicle lock status
---@param vehicle number Vehicle entity ID
---@return boolean True if vehicle is locked
function ig.util.IsVehicleLocked(vehicle)
    return GetVehicleDoorLockStatus(vehicle) > 1
end

-- ====================================================================================--
