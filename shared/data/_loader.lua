-- ====================================================================================--
-- Game Data Loader
-- Loads JSON data files for tattoos, weapons, vehicles, mod kits, and items
-- Migrated from ig.dump for better performance and integration
-- ====================================================================================--

-- ====================================================================================--
-- Game Data Tables
-- ====================================================================================--
c.tattoos = {}
c.weapons = {}
c.vehicles = {}
c.modkits = {}
c.itemdata = {}

---@class TattooData
---@field hash number
---@field collection string
---@field localizedName string
---@field zone string
---@field gender string

---@class WeaponData
---@field hash number
---@field displayName string
---@field weaponType string
---@field damage number
---@field ammoType string
---@field components table
---@field tintCount number

---@class VehicleData
---@field hash number
---@field displayName string
---@field manufacturer string
---@field class string
---@field seats number
---@field type string

---@class ModKitData
---@field [number] table<string, any>

---@class ItemData
---@field name string
---@field displayName string
---@field description string
---@field weight number
---@field type string
---@field stackable boolean
---@field maxStack number
---@field icon string
---@field usable boolean
---@field sellPrice number
---@field buyPrice number

-- Load JSON data files
local function LoadDataFile(filename)
    local file = LoadResourceFile(GetCurrentResourceName(), 'shared/data/' .. filename)
    if not file then
        print('^1[ig.core] Failed to load data file: ' .. filename .. '^0')
        return {}
    end
    
    local success, data = pcall(json.decode, file)
    if not success then
        print('^1[ig.core] Failed to parse JSON in file: ' .. filename .. '^0')
        return {}
    end
    
    return data or {}
end

-- Initialize data on resource start
Citizen.CreateThread(function()
    print('^2[ig.core] Loading game data...^0')
    
    local startTime = GetGameTimer()
    
    -- Load all data files
    c.tattoos = LoadDataFile('tattoos.json')
    c.weapons = LoadDataFile('weapons.json')
    c.vehicles = LoadDataFile('vehicles.json')
    c.modkits = LoadDataFile('modkits.json')
    c.itemdata = LoadDataFile('items.json')
    
    -- Count loaded items
    local counts = {
        tattoos = 0,
        weapons = 0,
        vehicles = 0,
        modkits = 0,
        items = 0
    }
    
    for _ in pairs(c.tattoos) do counts.tattoos = counts.tattoos + 1 end
    for _ in pairs(c.weapons) do counts.weapons = counts.weapons + 1 end
    for _ in pairs(c.vehicles) do counts.vehicles = counts.vehicles + 1 end
    for _ in pairs(c.modkits) do counts.modkits = counts.modkits + 1 end
    for _ in pairs(c.itemdata) do counts.items = counts.items + 1 end
    
    local loadTime = GetGameTimer() - startTime
    
    print('^2[ig.core] Data loaded in ' .. loadTime .. 'ms:^0')
    print('^3  - Tattoos: ' .. counts.tattoos .. '^0')
    print('^3  - Weapons: ' .. counts.weapons .. '^0')
    print('^3  - Vehicles: ' .. counts.vehicles .. '^0')
    print('^3  - Mod Kits: ' .. counts.modkits .. '^0')
    print('^3  - Items: ' .. counts.items .. '^0')
end)
