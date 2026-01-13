-- ====================================================================================--
-- Setters for this need something almost global as functions didnt work dynamically within the callbacks?
ig.weapon = {}
-- _weapons.lua
ig._weapon = nil
ig._weaponname = nil

-- Weapon categories lookup table (populated during initialization)
ig._weaponCategories = {}

-- Weapon components lookup table (populated during initialization)
-- Structure: {weaponHash} = {component1, component2, ...}
ig._weaponComponents = {}
-- ====================================================================================--

function ig.weapon.Get()
    return ig._weapon
end

function ig.weapon.GetComponents()
    return ig._components
end

function ig.weapon.GetName()
    return ig._weaponname
end

--- Initialize weapon data from server including categories and components
--- Builds tables of allowed weapons and their components based on configured categories from weapons.json
--- Can accept pre-fetched weapon data to avoid redundant server calls
---@param weaponsData table|nil "Optional pre-fetched weapon data from server. If nil, will fetch from server."
function ig.weapon.InitializeWeaponData(weaponsData)
    local function ProcessWeaponData(data)
        if not data then
            ig.log.Error("WeaponInit", "Failed to load weapon data from server")
            return
        end
        
        local conf = GetResourceKvpString("Config:forcedAnimations")
        local config = conf and json.decode(conf) or {}
        local allowedCategories = config.allowedWeaponCategories or {
            "GROUP_UNARMED",
            "GROUP_MELEE"
        }
        
        -- Build allowed categories lookup
        local categoryLookup = {}
        for _, category in ipairs(allowedCategories) do
            categoryLookup[category] = true
        end
        
        -- Build weapon table of allowed weapons based on categories
        ig._weaponCategories = {}
        ig._weaponComponents = {}
        local categoryCount = 0
        local componentCount = 0
        
        for hashStr, weaponInfo in pairs(data) do
            local category = weaponInfo.Category
            local hash = tonumber(weaponInfo.Hash) or tonumber(hashStr)
            
            if hash then
                -- Process weapon categories
                if category and categoryLookup[category] then
                    ig._weaponCategories[hash] = category
                    categoryCount = categoryCount + 1
                end
                
                -- Process weapon components (only store if components exist and is not empty)
                if weaponInfo.Components and next(weaponInfo.Components) ~= nil then
                    ig._weaponComponents[hash] = weaponInfo.Components
                    componentCount = componentCount + 1
                end
            end
        end
        
        ig.log.Info("WeaponInit", "Initialized %d weapon categories and %d weapons with components", categoryCount, componentCount)
    end
    
    -- If weapon data is provided, use it directly
    if weaponsData then
        ProcessWeaponData(weaponsData)
    else
        -- Otherwise fetch from server
        ig.weapon.GetAll(function(data)
            ProcessWeaponData(data)
        end)
    end
end

--- Get initialized weapon categories table
--- Returns hash -> category mapping for all allowed weapons
function ig.weapon.GetInitializedCategories()
    return ig._weaponCategories
end

--- Check if a weapon hash is in the allowed categories
function ig.weapon.IsAllowedCategory(weaponHash)
    return ig._weaponCategories[weaponHash] ~= nil
end

--- Get weapon components by hash
--- Returns the components table for a weapon, or nil if weapon has no components
---@param weaponHash number "The weapon hash"
---@return table|nil "Components table or nil"
function ig.weapon.GetWeaponComponents(weaponHash)
    return ig._weaponComponents[weaponHash]
end

--- Check if a weapon has components
---@param weaponHash number "The weapon hash"
---@return boolean "True if weapon has components, false otherwise"
function ig.weapon.HasWeaponComponents(weaponHash)
    return ig._weaponComponents[weaponHash] ~= nil
end

--- Get all weapons with components
--- Returns the complete components lookup table
---@return table "Components lookup table"
function ig.weapon.GetAllWeaponComponents()
    return ig._weaponComponents
end