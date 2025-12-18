--[[
    Game Data Helper Functions (Server-side)
    Provides query and validation functions for tattoos, weapons, vehicles, and modkits
    Server is the authority - clients request data via callbacks
--]]
ig.tattoo = {}
ig.tattoos = {}
-- ============================================
-- TATTOO HELPERS
-- ============================================

---Get all tattoo data
---@return table All tattoos data
function ig.tattoo.GetAll()
    return ig.tattoos
end

---Get tattoo data by hash
---@param hash number Tattoo hash
---@return table|nil Tattoo data or nil if not found
function ig.tattoo.GetByHash(hash)
    return ig.tattoos[tostring(hash)]
end

---Get tattoos by zone
---@param zone string Zone name (e.g., "ZONE_HEAD", "ZONE_TORSO")
---@return table Array of tattoos for the zone
function ig.tattoo.GetByZone(zone)
    local result = {}
    for _, tattoo in pairs(ig.tattoos) do
        if tattoo.zone == zone then
            table.insert(result, tattoo)
        end
    end
    return result
end

---Get tattoos by collection
---@param collection string Collection hash
---@return table Array of tattoos in the collection
function ig.tattoo.GetByCollection(collection)
    local result = {}
    for _, tattoo in pairs(ig.tattoos) do
        if tattoo.collection == collection then
            table.insert(result, tattoo)
        end
    end
    return result
end

---Check if tattoo is for male character
---@param hash number Tattoo hash
---@return boolean True if for male
function ig.tattoo.IsMale(hash)
    local tattoo = ig.tattoo.GetByHash(hash)
    return tattoo and (tattoo.gender == "male" or tattoo.gender == "both")
end

---Check if tattoo is for female character
---@param hash number Tattoo hash
---@return boolean True if for female
function ig.tattoo.IsFemale(hash)
    local tattoo = ig.tattoo.GetByHash(hash)
    return tattoo and (tattoo.gender == "female" or tattoo.gender == "both")
end


-- ============================================
-- WEAPON HELPERS
-- ============================================

---Get all weapon data
---@return table All weapons data
function ig.weapon.GetAll()
    return ig.weapons
end

---Get weapon data by hash
---@param hash number Weapon hash
---@return table|nil Weapon data or nil if not found
function ig.weapon.GetByHash(hash)
    return ig.weapons[tostring(hash)]
end

---Get weapon data by name
---@param name string Weapon name (e.g., "weapon_pistol")
---@return table|nil Weapon data or nil if not found
function ig.weapon.GetByName(name)
    for _, weapon in pairs(ig.weapons) do
        if weapon.name:lower() == name:lower() then
            return weapon
        end
    end
    return nil
end

---Get weapons by category
---@param category string Category (e.g., "Pistol", "Rifle", "Melee")
---@return table Array of weapons in category
function ig.weapon.GetByCategory(category)
    local result = {}
    for _, weapon in pairs(ig.weapons) do
        if weapon.category == category then
            table.insert(result, weapon)
        end
    end
    return result
end

---Get weapon display name
---@param hash number Weapon hash
---@return string Display name or "Unknown"
function ig.weapon.GetDisplayName(hash)
    local weapon = ig.weapon.GetByHash(hash)
    return weapon and weapon.label or "Unknown"
end

---Check if weapon is melee
---@param hash number Weapon hash
---@return boolean True if melee weapon
function ig.weapon.IsMelee(hash)
    local weapon = ig.weapon.GetByHash(hash)
    return weapon and weapon.category == "Melee"
end


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


-- ============================================
-- CLIENT CALLBACKS
-- Server distributes data to clients on request
-- ============================================

---Client callback: Get all tattoos
ig.callback.Register('ig:GameData:GetTattoos', function(source)
    return ig.tattoos
end)

---Client callback: Get tattoos by zone
ig.callback.Register('ig:GameData:GetTattoosByZone', function(source, zone)
    return ig.tattoo.GetByZone(zone)
end)

---Client callback: Get all weapons
ig.callback.Register('ig:GameData:GetWeapons', function(source)
    return ig.weapons
end)

---Client callback: Get all vehicles
ig.callback.Register('ig:GameData:GetVehicles', function(source)
    return ig.vehicles
end)

---Client callback: Get vehicle by hash
ig.callback.Register('ig:GameData:GetVehicleByHash', function(source, hash)
    return ig.vehicle.GetByHash(hash)
end)

---Client callback: Get all modkits
ig.callback.Register('ig:GameData:GetModkits', function(source)
    return ig.modkits
end)

---Client callback: Get modkit for vehicle
ig.callback.Register('ig:GameData:GetModkitForVehicle', function(source, vehicleHash)
    return ig.modkit.GetForVehicle(vehicleHash)
end)

print('^2[Game Data] Server-side helpers and callbacks loaded^7')
