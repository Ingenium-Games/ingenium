-- ====================================================================================--
-- Game Data Loader
-- Loads JSON data files for tattoos, weapons, vehicles, mod kits, and items
-- Migrated from ig.dump for better performance and integration
-- ====================================================================================--

-- ====================================================================================--
-- Game Data Tables
-- ====================================================================================--
ig.tattoos = {}
ig.weapons = {}
ig.vehicles = {}
ig.modkits = {}
ig.itemdata = {}

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
        print('^1[ingenium] Failed to load data file: ' .. filename .. '^0')
        return {}
    end
    
    local success, data = pcall(json.decode, file)
    if not success then
        print('^1[ingenium] Failed to parse JSON in file: ' .. filename .. '^0')
        return {}
    end
    
    return data or {}
end

-- Initialize data on resource start
Citizen.CreateThread(function()
    print('^2[ingenium] Loading game data...^0')
    
    local startTime = GetGameTimer()
    
    -- Load all data files
    ig.tattoos = LoadDataFile('tattoos.json')
    ig.weapons = LoadDataFile('weapons.json')
    ig.vehicles = LoadDataFile('vehicles.json')
    ig.modkits = LoadDataFile('modkits.json')
    ig.itemdata = LoadDataFile('items.json')
    
    -- Count loaded items
    local counts = {
        tattoos = 0,
        weapons = 0,
        vehicles = 0,
        modkits = 0,
        items = 0
    }
    
    for _ in pairs(ig.tattoos) do counts.tattoos = counts.tattoos + 1 end
    for _ in pairs(ig.weapons) do counts.weapons = counts.weapons + 1 end
    for _ in pairs(ig.vehicles) do counts.vehicles = counts.vehicles + 1 end
    for _ in pairs(ig.modkits) do counts.modkits = counts.modkits + 1 end
    for _ in pairs(ig.itemdata) do counts.items = counts.items + 1 end
    
    local loadTime = GetGameTimer() - startTime
    
    print('^2[ingenium] Data loaded in ' .. loadTime .. 'ms:^0')
    print('^3  - Tattoos: ' .. counts.tattoos .. '^0')
    print('^3  - Weapons: ' .. counts.weapons .. '^0')
    print('^3  - Vehicles: ' .. counts.vehicles .. '^0')
    print('^3  - Mod Kits: ' .. counts.modkits .. '^0')
    print('^3  - Items: ' .. counts.items .. '^0')
    
    -- Protect data tables from modification
    ig.tattoos = ig.table.MakeReadOnly(ig.tattoos, "ig.tattoos")
    ig.weapons = ig.table.MakeReadOnly(ig.weapons, "ig.weapons")
    ig.vehicles = ig.table.MakeReadOnly(ig.vehicles, "ig.vehicles")
    ig.modkits = ig.table.MakeReadOnly(ig.modkits, "ig.modkits")
    ig.itemdata = ig.table.MakeReadOnly(ig.itemdata, "ig.itemdata")
    
    print('^2[ingenium] Game data tables protected from modification^0')
end)
