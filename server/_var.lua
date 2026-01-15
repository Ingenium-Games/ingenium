-- ====================================================================================--
-- Server Namespace Initialization
-- Centralizes all table declarations for server-side code
-- ====================================================================================--
-- Seed random number generator (uses global math, which may be GLM if loaded)
if math.randomseed then
    math.randomseed(GetGameTimer())
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

-- Server state flags
ig._running = false
ig._loading = true
ig._dataloaded = false

-- ====================================================================================--
-- Core System Tables
-- ====================================================================================--
ig.data = {}           -- Core data functions
ig.func = {}           -- Generic functions
ig.event = {}          -- Event handlers
ig.time = {}           -- Time and cron functions
ig.cron = {}           -- Cron job functions
ig.crons = {}          -- Active cron jobs
ig.inst = {}           -- Instance management
ig.persistance = {}    -- Persistence layer
ig.persistant = {}     -- Persistent data

-- ====================================================================================--
-- Security and Validation
-- ====================================================================================--
ig.security = {}       -- Transaction security
ig.validation = {}     -- Data validation
ig.validation.HandleExploit = nil             -- Exploit handling function


-- ====================================================================================--
-- Player and Object Management
-- ====================================================================================--
ig.player = {}         -- Player functions
ig.players = {}        -- Active players list
ig.pdex = {}           -- Player index (by source)

ig.npc = {}            -- NPC functions
ig.npcs = {}           -- Active NPCs
ig.ndex = {}           -- NPC index

ig.job = {}            -- Job functions
ig.jobs = {}           -- Job definitions
ig.jdex = {}           -- Job index

ig.object = {}         -- Object functions
ig.objects = {}        -- Active objects
ig.odex = {}           -- Object index

-- ====================================================================================--
-- Vehicle Management
-- ====================================================================================--
ig.vehicle = {}        -- Vehicle functions
ig.vehicles = {}       -- Vehicle data
ig.vdex = {}           -- Vehicle index
ig.vehicleCache = {}   -- In-memory vehicle cache (plate -> vehicle data)

-- ====================================================================================--
-- Data Storage and Persistence
-- ====================================================================================--
ig.item = {}           -- Item functions
ig.items = {}          -- Item data
ig.note = {}           -- Note functions
ig.pick = {}           -- Pickup functions
ig.picks = {}          -- Pickup data
ig.gsr = {}            -- GSR (gunshot residue) functions
ig.gsrs = {}           -- GSR data
ig.active_drops = {}   -- Currently active drops
ig.name = {}           -- Name functions
ig.names = {}          -- Name data
ig.tattoo = {}         -- Tattoo functions
ig.tattoos = {}        -- Tattoo data
ig.weapon = {}         -- Weapon functions
ig.weapons = {}        -- Weapon data
ig.modkit = {}         -- Modkit functions
ig.modkits = {}        -- Modkit data
ig.door = {}
ig.doors = {}          -- Door data

-- ====================================================================================--
-- Banking and Economy
-- ====================================================================================--
ig.bank = {}           -- Banking functions
ig.tebex = {}          -- Tebex integration

-- ====================================================================================--
-- OneSync and Synchronization
-- ====================================================================================--
ig.sbch = {}           -- Statebag change handler

-- ====================================================================================--
-- Third Party Integration
-- ====================================================================================--
ig.discord = {}        -- Discord integration

-- ====================================================================================--
-- Sub-table Variables (Data Storage)
-- ====================================================================================--
ig.sql = {}
ig.sql.bank = {}                              -- Bank data functions
ig.sql.gen = {}                               -- General SQL functions
ig.sql.char = {}                              -- Character SQL functions
ig.sql.jobs = {}                              -- Jobs SQL functions
ig.sql.save = {}                              -- Save data SQL functions
ig.sql.user = {}                              -- User SQL functions
ig.sql.veh = {}                               -- Vehicle SQL functions

ig.voip.server = {}                           -- Server voice data

ig.sbch.player = {}                           -- Statebag player handlers

-- ====================================================================================--
-- Note: GLM (Math Library) is initialized on shared side (shared/_ig.lua)
-- It is automatically available globally as math after shared/_ig.lua loads
-- ====================================================================================