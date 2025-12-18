-- ====================================================================================--
-- Game Data Helper Functions
-- Provides easy access and validation for game data
-- ====================================================================================--

-- ============================================
-- TATTOO HELPERS
-- ============================================

---Get tattoo data by hash
---@param hash number
---@return TattooData|nil
function ig.GetTattooData(hash)
    return ig.data.tattoos[hash]
end

---Get all tattoos for a specific zone
---@param zone string @"ZONE_HEAD", "ZONE_TORSO", "ZONE_LEFT_ARM", etig.
---@return table<number, TattooData>
function ig.GetTattoosByZone(zone)
    local result = {}
    for hash, data in pairs(ig.data.tattoos) do
        if data.zone == zone then
            result[hash] = data
        end
    end
    return result
end

---Get all tattoos from a specific collection
---@param collection string @"mpbeach_overlays", "mpbusiness_overlays", etig.
---@return table<number, TattooData>
function ig.GetTattoosByCollection(collection)
    local result = {}
    for hash, data in pairs(ig.data.tattoos) do
        if data.collection == collection then
            result[hash] = data
        end
    end
    return result
end

---Get all tattoos for a specific gender
---@param gender string @"male" or "female"
---@return table<number, TattooData>
function ig.GetTattoosByGender(gender)
    local result = {}
    for hash, data in pairs(ig.data.tattoos) do
        if data.gender == gender or data.gender == "unisex" then
            result[hash] = data
        end
    end
    return result
end

---Validate if a tattoo exists and matches criteria
---@param hash number
---@param zone string|nil
---@param gender string|nil
---@return boolean, string|nil @valid, error message
function ig.ValidateTattoo(hash, zone, gender)
    local data = ig.data.tattoos[hash]
    
    if not data then
        return false, "Tattoo hash does not exist"
    end
    
    if zone and data.zone ~= zone then
        return false, "Tattoo zone mismatch (expected: " .. zone .. ", got: " .. data.zone .. ")"
    end
    
    if gender and data.gender ~= gender and data.gender ~= "unisex" then
        return false, "Tattoo gender mismatch (expected: " .. gender .. ", got: " .. data.gender .. ")"
    end
    
    return true
end

-- ============================================
-- WEAPON HELPERS
-- ============================================

---Get weapon data by hash
---@param hash number
---@return WeaponData|nil
function ig.GetWeaponData(hash)
    return ig.data.weapons[hash]
end

---Get all weapons of a specific type
---@param weaponType string @"Pistol", "Rifle", "SMG", "Shotgun", "Sniper", "Melee", etig.
---@return table<number, WeaponData>
function ig.GetWeaponsByType(weaponType)
    local result = {}
    for hash, data in pairs(ig.data.weapons) do
        if data.weaponType == weaponType then
            result[hash] = data
        end
    end
    return result
end

---Validate if a weapon exists
---@param hash number
---@return boolean, string|nil @valid, error message
function ig.ValidateWeapon(hash)
    local data = ig.data.weapons[hash]
    
    if not data then
        return false, "Weapon hash does not exist"
    end
    
    return true
end

---Check if a component is compatible with a weapon
---@param weaponHash number
---@param componentHash number
---@return boolean
function ig.IsWeaponComponentCompatible(weaponHash, componentHash)
    local data = ig.data.weapons[weaponHash]
    
    if not data or not data.components then
        return false
    end
    
    for _, component in ipairs(data.components) do
        if component.hash == componentHash then
            return true
        end
    end
    
    return false
end

-- ============================================
-- VEHICLE HELPERS
-- ============================================

---Get vehicle data by hash
---@param hash number
---@return VehicleData|nil
function ig.GetVehicleData(hash)
    return ig.data.vehicles[hash]
end

---Get vehicle data by model name
---@param model string
---@return VehicleData|nil
function ig.GetVehicleDataByModel(model)
    local hash = GetHashKey(model)
    return ig.data.vehicles[hash]
end

---Get all vehicles of a specific class
---@param class string @"Sports", "Super", "SUV", "Sedan", etig.
---@return table<number, VehicleData>
function ig.GetVehiclesByClass(class)
    local result = {}
    for hash, data in pairs(ig.data.vehicles) do
        if data.class == class then
            result[hash] = data
        end
    end
    return result
end

---Get all vehicles by manufacturer
---@param manufacturer string @"Benefactor", "Vapid", "Dewbauchee", etig.
---@return table<number, VehicleData>
function ig.GetVehiclesByManufacturer(manufacturer)
    local result = {}
    for hash, data in pairs(ig.data.vehicles) do
        if data.manufacturer == manufacturer then
            result[hash] = data
        end
    end
    return result
end

---Get all vehicles by type
---@param vehType string @"automobile", "bike", "boat", "helicopter", etig.
---@return table<number, VehicleData>
function ig.GetVehiclesByType(vehType)
    local result = {}
    for hash, data in pairs(ig.data.vehicles) do
        if data.type == vehType then
            result[hash] = data
        end
    end
    return result
end

---Validate if a vehicle exists
---@param hash number
---@return boolean, string|nil @valid, error message
function ig.ValidateVehicle(hash)
    local data = ig.data.vehicles[hash]
    
    if not data then
        return false, "Vehicle hash does not exist"
    end
    
    return true
end

-- ============================================
-- MOD KIT HELPERS
-- ============================================

---Get mod kit data for a vehicle
---@param vehicleHash number
---@return ModKitData|nil
function ig.GetModKitData(vehicleHash)
    return ig.data.modkits[vehicleHash]
end

---Get available mods for a specific mod type on a vehicle
---@param vehicleHash number
---@param modType number @0-49 (see mod types)
---@return table|nil
function ig.GetVehicleMods(vehicleHash, modType)
    local modKit = ig.data.modkits[vehicleHash]
    
    if not modKit then
        return nil
    end
    
    return modKit[tostring(modType)]
end

---Validate if a mod is compatible with a vehicle
---@param vehicleHash number
---@param modType number
---@param modIndex number
---@return boolean, string|nil @valid, error message
function ig.ValidateVehicleMod(vehicleHash, modType, modIndex)
    local mods = ig.GetVehicleMods(vehicleHash, modType)
    
    if not mods then
        return false, "Vehicle does not have this mod type"
    end
    
    if not mods.items or not mods.items[modIndex] then
        return false, "Mod index does not exist for this vehicle"
    end
    
    return true
end

-- ============================================
-- ITEM HELPERS
-- ============================================

---Get item data by name
---@param itemName string
---@return ItemData|nil
function ig.GetItemData(itemName)
    return ig.data.items[itemName]
end

---Get all items of a specific type
---@param itemType string @"food", "drink", "weapon", "tool", etig.
---@return table<string, ItemData>
function ig.GetItemsByType(itemType)
    local result = {}
    for name, data in pairs(ig.data.items) do
        if data.type == itemType then
            result[name] = data
        end
    end
    return result
end

---Get all usable items
---@return table<string, ItemData>
function ig.GetUsableItems()
    local result = {}
    for name, data in pairs(ig.data.items) do
        if data.usable then
            result[name] = data
        end
    end
    return result
end

---Validate if an item exists
---@param itemName string
---@return boolean, string|nil @valid, error message
function ig.ValidateItem(itemName)
    local data = ig.data.items[itemName]
    
    if not data then
        return false, "Item does not exist"
    end
    
    return true
end

---Calculate total weight of items
---@param items table<string, number> @{itemName = quantity}
---@return number
function ig.CalculateInventoryWeight(items)
    local totalWeight = 0
    
    for itemName, quantity in pairs(items) do
        local itemData = ig.data.items[itemName]
        if itemData then
            totalWeight = totalWeight + (itemData.weight * quantity)
        end
    end
    
    return totalWeight
end
