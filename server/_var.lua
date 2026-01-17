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
ig.active_drops = {}   -- Currently active drops
ig.bank = {}           -- Banking functions
ig.callback = {}       -- Callback system
ig.chat = {}           -- Chat functions
ig.cron = {}           -- Cron job functions
ig.crons = {}          -- Active cron jobs
ig.data = {}           -- Core data functions
ig.discord = {}        -- Discord integration
ig.door = {}           -- Door functions
ig.doors = {}          -- Door data
ig.drop = {}           -- Drop functions
ig.drops = {}          -- Drop data
ig.event = {}          -- Event handlers
ig.file = {}           -- File operations
ig.func = {}           -- Generic functions
ig.garage = {}         -- Garage functions
ig.garages = {}        -- Garage data
ig.gsr = {}            -- GSR (gunshot residue) functions
ig.gsrs = {}           -- GSR data
ig.inst = {}           -- Instance management
ig.item = {}           -- Item functions
ig.items = {}          -- Item data
ig.job = {}            -- Job functions
ig.jdex = {}           -- Job index
ig.jobs = {}           -- Job definitions
ig.modkit = {}         -- Modkit functions
ig.modkits = {}        -- Modkit data
ig.name = {}           -- Name functions
ig.names = {}          -- Name data
ig.ndex = {}           -- NPC index
ig.note = {}           -- Note functions
ig.npc = {}            -- NPC functions
ig.npcs = {}           -- Active NPCs
ig.object = {}         -- Object functions
ig.objects = {}        -- Active objects
ig.odex = {}           -- Object index
ig.payroll = {}        -- Payroll functions
ig.ped = {}            -- Ped functions
ig.peds = {}           -- Ped data
ig.pdex = {}           -- Player index (by source)
ig.persistance = {}    -- Persistence layer
ig.persistent = {}     -- Persistent data
ig.pick = {}           -- Pickup functions
ig.picks = {}          -- Pickup data
ig.player = {}         -- Player functions
ig.players = {}        -- Active players list
ig.queue = {}          -- Queue system
ig.sbch = {}           -- Statebag change handler
ig.sbch.player = {}    -- Statebag player handlers
ig.screenshot = {}     -- Screenshot system
ig.security = {}       -- Transaction security
ig.tattoo = {}         -- Tattoo functions
ig.tattoos = {}        -- Tattoo data
ig.tebex = {}          -- Tebex integration
ig.time = {}           -- Time and cron functions
ig.validation = {}     -- Data validation
ig.validation.HandleExploit = nil             -- Exploit handling function
ig.vehicle = {}        -- Vehicle functions
ig.vehicleCache = {}   -- In-memory vehicle cache (plate -> vehicle data)
ig.vehicles = {}       -- Vehicle data
ig.vdex = {}           -- Vehicle index
ig.voip = ig.voip or {} -- Voice system (preserve shared functions like ig.voip.Debug)
ig.voip.server = {}    -- Server voice data
ig.weapon = {}         -- Weapon functions
ig.weapons = {}        -- Weapon data

-- ====================================================================================--
-- Sub-table Variables (Data Storage)
-- ====================================================================================--
ig.sql = {}            -- SQL functions namespace
ig.sql.bank = {}       -- Bank data functions
ig.sql.banking = {}    -- Banking functions
ig.sql.char = {}       -- Character SQL functions
ig.sql.gen = {}        -- General SQL functions
ig.sql.jobs = {}       -- Jobs SQL functions
ig.sql.save = {}       -- Save data SQL functions
ig.sql.user = {}       -- User SQL functions
ig.sql.veh = {}        -- Vehicle SQL functions
-- ====================================================================================--
-- Note: GLM (Math Library) is initialized on shared side (shared/_ig.lua)
-- It is automatically available globally as math after shared/_ig.lua loads
-- ====================================================================================