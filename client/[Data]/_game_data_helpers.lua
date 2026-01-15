--[[
    Game Data Helper Functions (Client-side)
    Requests data from server authority via callbacks
    Clients cache data locally for performance
--]]

-- Local caches (populated on-demand from server)
local tattooCache = nil
local weaponCache = nil
local vehicleCache = nil
local modkitCache = nil

-- ============================================
-- TATTOO HELPERS (Client)
-- ============================================

---Get all tattoo data (cached from server)
---@param callback function Callback function(tattoos)
function ig.tattoo.GetAll(callback)
    if not ig.tattoo then
        ig.tattoo = {}
    end
    if tattooCache then
        if callback then callback(tattooCache) end
    else
        ig.callback.Async('ig:GameData:GetTattoos', function(data)
            tattooCache = data
            if callback then callback(data) end
        end)
    end
end

---Get tattoos by zone
---@param zone string Zone name
---@param callback function Callback function(tattoos)
function ig.tattoo.GetByZone(zone, callback)
    ig.callback.Async('ig:GameData:GetTattoosByZone', function(data)
        callback(data)
    end, zone)
end

---Clear tattoo cache (force refresh from server)
function ig.tattoo.ClearCache()
    tattooCache = nil
end


-- ============================================
-- WEAPON HELPERS (Client)
-- ============================================

---Get all weapon data (cached from server)
---@param callback function Callback function(weapons)
function ig.weapon.GetAll(callback)
    if weaponCache then
        callback(weaponCache)
    else
        ig.callback.Async('ig:GameData:GetWeapons', function(data)
            weaponCache = data
            callback(data)
        end)
    end
end

---Get weapon by hash (from cache)
---@param hash number Weapon hash
---@return table|nil Weapon data or nil
function ig.weapon.GetByHash(hash)
    if not weaponCache then return nil end
    return weaponCache[tostring(hash)]
end

---Get weapon display name
---@param hash number Weapon hash
---@return string Display name or "Unknown"
function ig.weapon.GetDisplayName(hash)
    if not weaponCache then return "Unknown" end
    local weapon = weaponCache[tostring(hash)]
    return weapon and weapon.label or "Unknown"
end

---Clear weapon cache (force refresh from server)
function ig.weapon.ClearCache()
    weaponCache = nil
end


-- ============================================
-- VEHICLE HELPERS (Client)
-- ============================================

---Get all vehicle data (cached from server)
---@param callback function Callback function(vehicles)
function ig.vehicle.GetAll(callback)
    if vehicleCache then
        callback(vehicleCache)
    else
        ig.callback.Async('ig:GameData:GetVehicles', function(data)
            vehicleCache = data
            callback(data)
        end)
    end
end

---Get vehicle by hash
---@param hash number Vehicle hash
---@param callback function Callback function(vehicle)
function ig.vehicle.GetByHash(hash, callback)
    if vehicleCache and vehicleCache[tostring(hash)] then
        callback(vehicleCache[tostring(hash)])
    else
        ig.callback.Async('ig:GameData:GetVehicleByHash', function(data)
            callback(data)
        end, hash)
    end
end

---Get vehicle display name (from cache)
---@param hash number Vehicle hash
---@return string Display name or "Unknown"
function ig.vehicle.GetDisplayName(hash)
    if not vehicleCache then return "Unknown" end
    local vehicle = vehicleCache[tostring(hash)]
    return vehicle and vehicle.label or "Unknown"
end

---Clear vehicle cache (force refresh from server)
function ig.vehicle.ClearCache()
    vehicleCache = nil
end


-- ============================================
-- MODKIT HELPERS (Client)
-- ============================================

---Get all modkit data (cached from server)
---@param callback function Callback function(modkits)
function ig.modkit.GetAll(callback)
    if modkitCache then
        callback(modkitCache)
    else
        ig.callback.Async('ig:GameData:GetModkits', function(data)
            modkitCache = data
            callback(data)
        end)
    end
end

---Get modkit for vehicle
---@param vehicleHash number Vehicle hash
---@param callback function Callback function(modkit)
function ig.modkit.GetForVehicle(vehicleHash, callback)
    ig.callback.Async('ig:GameData:GetModkitForVehicle', function(data)
        callback(data)
    end, vehicleHash)
end

---Clear modkit cache (force refresh from server)
function ig.modkit.ClearCache()
    modkitCache = nil
end

ig.log.Info('GAMEDATA', 'Client-side helpers loaded')
