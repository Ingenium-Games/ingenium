-- ====================================================================================--
-- Client Namespace Initialization
-- Centralizes all table declarations for client-side code
-- ====================================================================================--
-- Seed random number generator (uses global math, which may be GLM if loaded)
if math.randomseed then
    math.randomseed(GetNetworkTime())
end
ig = ig or {}

-- ====================================================================================--
-- Configuration and State
-- ====================================================================================--
ig.imagehost = conf.imagehost
ig.sec = conf.sec
ig.min = conf.min
ig.hour = conf.hour
ig.day = conf.day
ig.locale = conf.locale

-- Client state flags
ig._loaded = false
ig._character = nil

-- ====================================================================================--
-- DECLARE ALL PARENT TABLES FIRST (before assigning sub-properties)
-- ====================================================================================--

-- Alphabetized Core System Tables
ig.ace = {}            -- ACE permission functions
ig.aces = {}           -- ACE permissions data
ig.affiliation = {}    -- Affiliation/faction system
ig.ammo = {}           -- Ammo functions
ig.animation = {}      -- Animation functions
ig.appearance = {}     -- Appearance functions
ig.appearance_constants = {} -- Appearance constants (eye colors, face features, etc)
ig.blip = {}           -- Blip functions
ig.blips = {}          -- Blip data
ig.callback = {}       -- Callback system
ig.camera = {}         -- Camera functions
ig.cameras = {}        -- Camera data
ig.chat = {}           -- Chat functions
ig.chats = {}          -- Chat messages
ig.data = {}           -- Data management
ig.death = {}          -- Death handling
ig.door = {}           -- Door functions
ig.doors = {}          -- Door data
ig.drop = {}           -- Drop functions
ig.func = {}           -- Generic functions
ig.fx = {}             -- Effects/graphics functions
ig.inventory = {}      -- Inventory functions
ig.ipl = {}            -- IPL functions
ig.ipls = {}           -- IPL data
ig.item = {}           -- Item functions
ig.marker = {}         -- Marker functions
ig.markers = {}        -- Marker data
ig.modkit = {}         -- Modkit functions
ig.modkits = {}        -- Modkit data
ig.modifier = {}       -- Modifier functions
ig.nui = {}            -- NUI system
ig.object = {}         -- Object functions
ig.objects = {}        -- Object data
ig.oldmodifiers = {}   -- Old modifiers cache
ig.peds = {}           -- Ped data (character models)
ig.persistance = {}    -- Persistence functions
ig.screenshot = {}     -- Screenshot system
ig.skill = {}          -- Skill functions
ig.state = {}          -- State functions
ig.states = {}         -- State data
ig.status = {}         -- Status effects
ig.target = {}         -- Target/interaction system
ig.tattoo = {}         -- Tattoo functions
ig.tattoos = {}        -- Tattoo data
ig.text = {}           -- Text display
ig.time = {}           -- Time system (client)
ig.trait = {}          -- Trait functions
ig.traits = {}         -- Trait data
ig.ui = {}             -- UI system
ig.vehicle = {}        -- Vehicle functions
ig.vehicles = {}       -- Vehicle data
ig.voip = {}           -- Voice system
ig.weather = {}        -- Weather system
ig.weapon = {}         -- Weapon functions
ig.zone = {}           -- Zone management wrapper

-- Data Storage
ig._ammo = {           -- Ammo tracking
    ["9mm"]=0,
    ["5.56mm"]=0,
    ["7.62mm"]=0,
    ["20g"]=0,
    [".223"]=0,
    [".308"]=0
}
ig._ammotype = nil     -- Current ammo type
ig._inventory = {}     -- Inventory data
ig._skills = {}        -- Skill data
ig._vehicle_persistence = {} -- Vehicle persistence
ig._weapon = nil       -- Current weapon
ig._weaponCategories = {}    -- Weapon category lookup
ig._weaponComponents = {}    -- Weapon components lookup
ig._weaponname = nil   -- Current weapon name

-- ====================================================================================--
-- NOW assign sub-table properties (all parent tables exist)
-- ====================================================================================--
ig.items = false

-- IPL sub-tables
ig.ipls.active = {}    -- Active IPLs
ig.ipls.inactive = {}  -- Inactive IPLs

-- NUI sub-tables
ig.nui.banking = {}    -- Banking wrapper functions (Phase 3.5)
ig.nui.character = {}  -- Character wrapper functions
ig.nui.chat = {}       -- Chat wrapper functions (Phase 3.5)
ig.nui.context = {}    -- Context wrapper functions (Phase 3.5)
ig.nui.garage = {}     -- Garage wrapper functions (Phase 3.5)
ig.nui.hud = {}        -- HUD wrapper functions (Phase 3.5)
ig.nui.input = {}      -- Input wrapper functions (Phase 3.5)
ig.nui.inventory = {}  -- Inventory wrapper functions (Phase 3.5)
ig.nui.menu = {}       -- Menu wrapper functions (Phase 3.5)
ig.nui.notify = {}     -- Notification wrapper functions (Phase 3.5)
ig.nui.target = {}     -- Target wrapper functions (Phase 3.5)


-- Vehicle sub-properties
ig.vehicles.currentVehicle = 0      -- Currently occupied vehicle
ig.vehicles.currentSeat = -1        -- Current seat in vehicle
ig.vehicle.locateBlips = {}         -- Active locate blips

-- Voice sub-tables
ig.voip.client = {}                 -- Client voice data

-- Zone sub-properties
ig.zone.Poly = nil                  -- PolyZone class
ig.zone.Box = nil                   -- BoxZone class
ig.zone.Circle = nil                -- CircleZone class
ig.zone.Entity = nil                -- EntityZone class
ig.zone.Combo = nil                 -- ComboZone class
ig.zone.GetPlayerPosition = nil     -- PolyZone utility
ig.zone.GetPlayerHeadPosition = nil -- PolyZone utility
ig.zone.EnsureMetatable = nil       -- PolyZone utility

-- ====================================================================================--