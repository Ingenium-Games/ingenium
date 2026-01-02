-- ====================================================================================--
-- ig.ipl - Ingenium IPL (Interior Prop List) Management
-- Handles loading and unloading of game interiors with zone-based triggers
-- ====================================================================================--

-- Initialize the ig.ipl namespace
ig.ipl = {}
ig.ipls = {}

-- ====================================================================================--
-- IPL Registry - Stores all registered IPL configurations
-- ====================================================================================--
local iplRegistry = {}
local activeIPLs = {}

-- ====================================================================================--
-- Configuration Loader
-- ====================================================================================--

--- Load IPL configurations from conf.ipls
function ig.ipls.LoadConfigurations()
	if not conf or not conf.ipls then
		print("[ig.ipls] Warning: No IPL configurations found in conf.ipls")
		return
	end
	
	local count = 0
	for key, config in pairs(conf.ipls) do
		if type(config) == "table" and config.name then
			ig.ipls.Register(config)
			count = count + 1
		end
	end
	
	if count > 0 then
		print("[ig.ipls] Loaded " .. count .. " IPL configurations from conf.ipls")
	end
end

-- ====================================================================================--
-- Core IPL Functions
-- ====================================================================================--

--- Load an IPL by name
--@param iplName string "The IPL identifier to load"
function ig.ipl.Load(iplName)
	if type(iplName) ~= "string" then
		print("[ig.ipl] Error: IPL name must be a string")
		return false
	end
	
	RequestIpl(iplName)
	activeIPLs[iplName] = true
	return true
end

--- Unload an IPL by name
--@param iplName string "The IPL identifier to unload"
function ig.ipl.Unload(iplName)
	if type(iplName) ~= "string" then
		print("[ig.ipl] Error: IPL name must be a string")
		return false
	end
	
	RemoveIpl(iplName)
	activeIPLs[iplName] = nil
	return true
end

--- Check if an IPL is currently loaded
--@param iplName string "The IPL identifier to check"
--@return boolean
function ig.ipl.IsLoaded(iplName)
	return activeIPLs[iplName] == true
end

--- Load multiple IPLs at once
--@param iplNames table "Array of IPL identifiers"
function ig.ipl.LoadMultiple(iplNames)
	if type(iplNames) ~= "table" then
		print("[ig.ipl] Error: IPL names must be a table")
		return false
	end
	
	for _, iplName in ipairs(iplNames) do
		ig.ipl.Load(iplName)
	end
	return true
end

--- Unload multiple IPLs at once
--@param iplNames table "Array of IPL identifiers"
function ig.ipl.UnloadMultiple(iplNames)
	if type(iplNames) ~= "table" then
		print("[ig.ipl] Error: IPL names must be a table")
		return false
	end
	
	for _, iplName in ipairs(iplNames) do
		ig.ipl.Unload(iplName)
	end
	return true
end

-- ====================================================================================--
-- IPL Registry System
-- ====================================================================================--

--- Register an IPL configuration with optional zone triggers
--@param config table "IPL configuration: {name, ipls, zone, autoload}"
function ig.ipls.Register(config)
	if not config or not config.name then
		print("[ig.ipls] Error: IPL config must have a name")
		return false
	end
	
	local iplConfig = {
		name = config.name,
		ipls = config.ipls or {},
		zone = config.zone, -- Optional zone configuration
		autoload = config.autoload or false,
		loaded = false,
		zoneHandler = nil
	}
	
	iplRegistry[config.name] = iplConfig
	
	-- Auto-load if specified
	if iplConfig.autoload then
		ig.ipls.LoadByName(config.name)
	end
	
	return true
end

--- Load a registered IPL configuration by name
--@param name string "The registered IPL configuration name"
function ig.ipls.LoadByName(name)
	local config = iplRegistry[name]
	if not config then
		print("[ig.ipls] Error: IPL configuration '" .. name .. "' not found")
		return false
	end
	
	if config.loaded then
		return true
	end
	
	-- Load all IPLs in the configuration
	if config.ipls and #config.ipls > 0 then
		ig.ipl.LoadMultiple(config.ipls)
	end
	
	config.loaded = true
	
	-- Set up zone handler if zone configuration exists and not already set up
	if config.zone and ig.zone and not config.zoneHandler then
		ig.ipls.SetupZoneHandler(name, config.zone)
	end
	
	return true
end

--- Unload a registered IPL configuration by name
--@param name string "The registered IPL configuration name"
function ig.ipls.UnloadByName(name)
	local config = iplRegistry[name]
	if not config then
		print("[ig.ipls] Error: IPL configuration '" .. name .. "' not found")
		return false
	end
	
	if not config.loaded then
		return true
	end
	
	-- Unload all IPLs in the configuration
	if config.ipls and #config.ipls > 0 then
		ig.ipl.UnloadMultiple(config.ipls)
	end
	
	-- Destroy zone handler if it exists
	if config.zoneHandler then
		config.zoneHandler:destroy()
		config.zoneHandler = nil
	end
	
	config.loaded = false
	return true
end

--- Set up a zone handler for proximity-based IPL loading
--@param name string "The registered IPL configuration name"
--@param zoneConfig table "Zone configuration: {type, coords, radius/size, etc.}"
function ig.ipls.SetupZoneHandler(name, zoneConfig)
	local config = iplRegistry[name]
	if not config then
		print("[ig.ipls] Error: IPL configuration '" .. name .. "' not found")
		return false
	end
	
	-- Prevent duplicate zone handler setup
	if config.zoneHandler then
		print("[ig.ipls] Warning: Zone handler already exists for '" .. name .. "'")
		return false
	end
	
	if not zoneConfig or not zoneConfig.type then
		print("[ig.ipls] Error: Zone configuration must have a type")
		return false
	end
	
	local zone = nil
	
	-- Create zone based on type using ig.zone wrapper
	if zoneConfig.type == "circle" then
		zone = ig.zone.Circle:Create(
			zoneConfig.coords,
			zoneConfig.radius,
			{
				name = name .. "_zone",
				debugPoly = zoneConfig.debug or false
			}
		)
	elseif zoneConfig.type == "box" then
		zone = ig.zone.Box:Create(
			zoneConfig.coords,
			zoneConfig.length,
			zoneConfig.width,
			{
				name = name .. "_zone",
				heading = zoneConfig.heading or 0.0,
				minZ = zoneConfig.minZ,
				maxZ = zoneConfig.maxZ,
				debugPoly = zoneConfig.debug or false
			}
		)
	elseif zoneConfig.type == "poly" then
		zone = ig.zone.Poly:Create(
			zoneConfig.points,
			{
				name = name .. "_zone",
				minZ = zoneConfig.minZ,
				maxZ = zoneConfig.maxZ,
				debugPoly = zoneConfig.debug or false
			}
		)
	else
		print("[ig.ipls] Error: Unknown zone type '" .. zoneConfig.type .. "'")
		return false
	end
	
	-- Set up zone in/out callbacks for IPL loading/unloading
	-- Only set up dynamic loading callbacks if enabled
	if zone and zoneConfig.dynamicLoad then
		zone:onPlayerInOut(function(isInside)
			if isInside then
				-- Only load IPLs, don't trigger zone setup again
				if config.ipls and #config.ipls > 0 then
					ig.ipl.LoadMultiple(config.ipls)
				end
				config.loaded = true
			else
				-- Unload IPLs when leaving zone
				if config.ipls and #config.ipls > 0 then
					ig.ipl.UnloadMultiple(config.ipls)
				end
				config.loaded = false
			end
		end)
	end
	
	config.zoneHandler = zone
	return true
end

--- Get all registered IPL configurations
--@return table
function ig.ipls.GetAll()
	return iplRegistry
end

--- Get a specific IPL configuration
--@param name string "The registered IPL configuration name"
--@return table
function ig.ipls.Get(name)
	return iplRegistry[name]
end
