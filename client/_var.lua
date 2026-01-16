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

-- Core System Tables
ig.data = {}           -- Data management
ig.func = {}           -- Generic functions
ig.callback = {}       -- Callback system

-- Character and Appearance
ig.appearance = {}     -- Appearance functions
ig.affiliation = {}    -- Affiliation/faction system

-- Item and Inventory Management
ig.item = {}           -- Item functions
ig.inventory = {}      -- Inventory functions
ig._inventory = {}     -- Inventory data

ig.status = {}         -- Status effects
ig._ammo = {           -- Ammo tracking
    ["9mm"]=0,
    ["5.56mm"]=0,
    ["7.62mm"]=0,
    ["20g"]=0,
    [".223"]=0,
    [".308"]=0
}

-- Weapon System
ig.weapon = {}         -- Weapon functions
ig._weapon = nil       -- Current weapon
ig._weaponname = nil   -- Current weapon name
ig._weaponCategories = {}    -- Weapon category lookup
ig._weaponComponents = {}    -- Weapon components lookup
ig.ammo = {}           -- Ammo functions
ig._ammotype = nil     -- Current ammo type

-- Door and Object Management
ig.door = {}           -- Door functions
ig.doors = {}          -- Door data
ig.object = {}         -- Object functions
ig.objects = {}        -- Object data

-- Tattoo System
ig.tattoo = {}         -- Tattoo functions
ig.tattoos = {}        -- Tattoo data

-- Appearance System
ig.appearance_constants = {} -- Appearance constants (eye colors, face features, etc)
ig.peds = {}           -- Ped data (character models)

-- Skills and Traits
ig.skill = {}          -- Skill functions
ig._skills = {}        -- Skill data
ig.trait = {}          -- Trait functions
ig.traits = {}         -- Trait data

-- Vehicle System
ig.vehicle = {}        -- Vehicle functions
ig.vehicles = {}       -- Vehicle data

-- Positioning and Zones
ig.zone = {}           -- Zone management wrapper
ig.state = {}          -- State functions
ig.states = {}         -- State data

-- Visual Effects and UI
ig.blip = {}           -- Blip functions
ig.blips = {}          -- Blip data
ig.marker = {}         -- Marker functions
ig.markers = {}        -- Marker data
ig.camera = {}         -- Camera functions
ig.cameras = {}        -- Camera data
ig.fx = {}             -- Effects/graphics functions
ig.text = {}           -- Text display
ig.chat = {}           -- Chat functions
ig.chats = {}          -- Chat messages
ig.ui = {}             -- UI system
ig.nui = {}            -- NUI system
ig.nui.character = {}
ig.nui.menu = {}       -- Menu wrapper functions (Phase 3.5)
ig.nui.input = {}      -- Input wrapper functions (Phase 3.5)
ig.nui.context = {}    -- Context wrapper functions (Phase 3.5)
ig.nui.chat = {}       -- Chat wrapper functions (Phase 3.5)
ig.nui.banking = {}    -- Banking wrapper functions (Phase 3.5)
ig.nui.inventory = {}  -- Inventory wrapper functions (Phase 3.5)
ig.nui.garage = {}     -- Garage wrapper functions (Phase 3.5)
ig.nui.target = {}     -- Target wrapper functions (Phase 3.5)
ig.nui.hud = {}        -- HUD wrapper functions (Phase 3.5)
ig.nui.notify = {}     -- Notification wrapper functions (Phase 3.5)


-- Item Drops and Pickups
ig.drop = {}           -- Drop functions

-- Player Status and States
ig.death = {}          -- Death handling
ig.modifier = {}       -- Modifier functions
ig.oldmodifiers = {}   -- Old modifiers cache
ig.animation = {}      -- Animation functions

-- IPL and World Management
ig.ipl = {}            -- IPL functions
ig.ipls = {}           -- IPL data
ig.weather = {}        -- Weather system
ig.time = {}           -- Time system (client)

-- Persistence and Data Saving
ig.persistance = {}    -- Persistence functions
ig._vehicle_persistence = {} -- Vehicle persistence

-- Chat and Security
ig.ace = {}            -- ACE permission functions
ig.aces = {}           -- ACE permissions data

-- Admin and Debug Tools
ig.screenshot = {}     -- Screenshot system

-- Target System (Interaction)
ig.target = {}         -- Target/interaction system

-- Game Data and Modkits
ig.modkit = {}         -- Modkit functions
ig.modkits = {}        -- Modkit data

-- Voice System
ig.voip = {}           -- Voice system

-- ====================================================================================--
-- NOW assign sub-table properties (all parent tables exist)
-- ====================================================================================--

-- IPL sub-tables
ig.ipls.active = {}    -- Active IPLs
ig.ipls.inactive = {}  -- Inactive IPLs

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