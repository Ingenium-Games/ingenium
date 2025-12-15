--[[
    Game Data Helper Functions (Server-side)
    Provides query and validation functions for tattoos, weapons, vehicles, and modkits
    Server is the authority - clients request data via callbacks
--]]

-- ============================================
-- TATTOO HELPERS
-- ============================================

---Get all tattoo data
---@return table All tattoos data
function c.tattoo.GetAll()
    return c.tattoos
end

---Get tattoo data by hash
---@param hash number Tattoo hash
---@return table|nil Tattoo data or nil if not found
function c.tattoo.GetByHash(hash)
    return c.tattoos[tostring(hash)]
end

---Get tattoos by zone
---@param zone string Zone name (e.g., "ZONE_HEAD", "ZONE_TORSO")
---@return table Array of tattoos for the zone
function c.tattoo.GetByZone(zone)
    local result = {}
    for _, tattoo in pairs(c.tattoos) do
        if tattoo.zone == zone then
            table.insert(result, tattoo)
        end
    end
    return result
end

---Get tattoos by collection
---@param collection string Collection hash
---@return table Array of tattoos in the collection
function c.tattoo.GetByCollection(collection)
    local result = {}
    for _, tattoo in pairs(c.tattoos) do
        if tattoo.collection == collection then
            table.insert(result, tattoo)
        end
    end
    return result
end

---Check if tattoo is for male character
---@param hash number Tattoo hash
---@return boolean True if for male
function c.tattoo.IsMale(hash)
    local tattoo = c.tattoo.GetByHash(hash)
    return tattoo and (tattoo.gender == "male" or tattoo.gender == "both")
end

---Check if tattoo is for female character
---@param hash number Tattoo hash
---@return boolean True if for female
function c.tattoo.IsFemale(hash)
    local tattoo = c.tattoo.GetByHash(hash)
    return tattoo and (tattoo.gender == "female" or tattoo.gender == "both")
end


-- ============================================
-- WEAPON HELPERS
-- ============================================

---Get all weapon data
---@return table All weapons data
function c.weapon.GetAll()
    return c.weapons
end

---Get weapon data by hash
---@param hash number Weapon hash
---@return table|nil Weapon data or nil if not found
function c.weapon.GetByHash(hash)
    return c.weapons[tostring(hash)]
end

---Get weapon data by name
---@param name string Weapon name (e.g., "weapon_pistol")
---@return table|nil Weapon data or nil if not found
function c.weapon.GetByName(name)
    for _, weapon in pairs(c.weapons) do
        if weapon.name:lower() == name:lower() then
            return weapon
        end
    end
    return nil
end

---Get weapons by category
---@param category string Category (e.g., "Pistol", "Rifle", "Melee")
---@return table Array of weapons in category
function c.weapon.GetByCategory(category)
    local result = {}
    for _, weapon in pairs(c.weapons) do
        if weapon.category == category then
            table.insert(result, weapon)
        end
    end
    return result
end

---Get weapon display name
---@param hash number Weapon hash
---@return string Display name or "Unknown"
function c.weapon.GetDisplayName(hash)
    local weapon = c.weapon.GetByHash(hash)
    return weapon and weapon.label or "Unknown"
end

---Check if weapon is melee
---@param hash number Weapon hash
---@return boolean True if melee weapon
function c.weapon.IsMelee(hash)
    local weapon = c.weapon.GetByHash(hash)
    return weapon and weapon.category == "Melee"
end


-- ============================================
-- VEHICLE HELPERS
-- ============================================

---Get all vehicle data
---@return table All vehicles data
function c.vehicle.GetAll()
    return c.vehicles
end

---Get vehicle data by hash
---@param hash number Vehicle hash
---@return table|nil Vehicle data or nil if not found
function c.vehicle.GetByHash(hash)
    return c.vehicles[tostring(hash)]
end

---Get vehicle data by name
---@param name string Vehicle model name
---@return table|nil Vehicle data or nil if not found
function c.vehicle.GetByName(name)
    for _, vehicle in pairs(c.vehicles) do
        if vehicle.name:lower() == name:lower() then
            return vehicle
        end
    end
    return nil
end

---Get vehicles by class
---@param class string Vehicle class (e.g., "Sports", "Super", "SUV")
---@return table Array of vehicles in class
function c.vehicle.GetByClass(class)
    local result = {}
    for _, vehicle in pairs(c.vehicles) do
        if vehicle.class == class then
            table.insert(result, vehicle)
        end
    end
    return result
end

---Get vehicles by manufacturer
---@param manufacturer string Manufacturer name
---@return table Array of vehicles by manufacturer
function c.vehicle.GetByManufacturer(manufacturer)
    local result = {}
    for _, vehicle in pairs(c.vehicles) do
        if vehicle.manufacturer == manufacturer then
            table.insert(result, vehicle)
        end
    end
    return result
end

---Get vehicle display name
---@param hash number Vehicle hash
---@return string Display name or "Unknown"
function c.vehicle.GetDisplayName(hash)
    local vehicle = c.vehicle.GetByHash(hash)
    return vehicle and vehicle.label or "Unknown"
end

---Check if vehicle is aircraft
---@param hash number Vehicle hash
---@return boolean True if aircraft
function c.vehicle.IsAircraft(hash)
    local vehicle = c.vehicle.GetByHash(hash)
    return vehicle and (vehicle.class == "Helicopters" or vehicle.class == "Planes")
end

---Check if vehicle is boat
---@param hash number Vehicle hash
---@return boolean True if boat
function c.vehicle.IsBoa(hash)
    local vehicle = c.vehicle.GetByHash(hash)
    return vehicle and vehicle.class == "Boats"
end


-- ============================================
-- MODKIT HELPERS
-- ============================================

---Get all modkit data
---@return table All modkits data
function c.modkit.GetAll()
    return c.modkits
end

---Get modkit data by ID
---@param id number Modkit ID
---@return table|nil Modkit data or nil if not found
function c.modkit.GetByID(id)
    return c.modkits[tostring(id)]
end

---Get modkit for vehicle
---@param vehicleHash number Vehicle hash
---@return table|nil Modkit data or nil if not found
function c.modkit.GetForVehicle(vehicleHash)
    for _, modkit in pairs(c.modkits) do
        if modkit.vehicle_hash == vehicleHash then
            return modkit
        end
    end
    return nil
end

---Check if modkit exists for vehicle
---@param vehicleHash number Vehicle hash
---@return boolean True if modkit exists
function c.modkit.HasModkit(vehicleHash)
    return c.modkit.GetForVehicle(vehicleHash) ~= nil
end


-- ============================================
-- CLIENT CALLBACKS
-- Server distributes data to clients on request
-- ============================================

---Client callback: Get all tattoos
c.callback.Register('ig:GameData:GetTattoos', function(source)
    return c.tattoos
end)

---Client callback: Get tattoos by zone
c.callback.Register('ig:GameData:GetTattoosByZone', function(source, zone)
    return c.tattoo.GetByZone(zone)
end)

---Client callback: Get all weapons
c.callback.Register('ig:GameData:GetWeapons', function(source)
    return c.weapons
end)

---Client callback: Get all vehicles
c.callback.Register('ig:GameData:GetVehicles', function(source)
    return c.vehicles
end)

---Client callback: Get vehicle by hash
c.callback.Register('ig:GameData:GetVehicleByHash', function(source, hash)
    return c.vehicle.GetByHash(hash)
end)

---Client callback: Get all modkits
c.callback.Register('ig:GameData:GetModkits', function(source)
    return c.modkits
end)

---Client callback: Get modkit for vehicle
c.callback.Register('ig:GameData:GetModkitForVehicle', function(source, vehicleHash)
    return c.modkit.GetForVehicle(vehicleHash)
end)

print('^2[Game Data] Server-side helpers and callbacks loaded^7')
