-- ====================================================================================--
conf = {}
-- ====================================================================================--
conf.sec = 1000
conf.min = 60 * conf.sec
conf.hour = 60 * conf.min
conf.day = 24 * conf.hour
-- ====================================================================================--
--[[
DEBUG :
    -- Up to you if you want to see whats going on or not.
    -- error is for critical errors that should always be logged
    -- _1 is most common ways of tracking at top level functions (INFO)
    -- _2 is for state and class generation, to prevent console spam (DEBUG)
    -- _3 is alterations of state, event triggers etc (TRACE)
]]--
conf.error = true
conf.debug_1 = true
conf.debug_2 = false
conf.debug_3 = true
--[[
GENERIC :
    [1] Map name.
    [2] Game mode. Use RP/GG/KOTH etc etc
]]--
conf.mapname = "Los Santos"
conf.gamemode = "RP"
--[[
LOCALISATION/INTERNATIONALISATION also known as.. i18n :
    -- Standard language selection.
]]--
conf.locale = "en"
--[[
ACE PERMISSIONS :
    -- The permissions are done inside the DB, so every time the User joins the ace gets set at the user level, 
    -- the default level to assign to the DB on a new user joining is...
]]--
conf.ace = "public" 
--[[
PRIMARY_ID :
    -- This will be what you choose to identify as the owner of the characters table within the DB.
    -- You can use any however I would leave it as the license as you need a legal copy of GTAV to
    -- play FiveM anyway, so everyone has a rockstar id, hence the license. But, up to you.
    -- "fivem:" / "steam:" / "discord:" / "license:" / "ip:"
]]--
conf.identifier = "license:"
--[[
UPDATE TIMES :
    [1] Client updates the server every...
    [2] Server updates the Database every...
    [3] Server to Check players table every...
    [4] Vehicle saves (less critical, parked state)
    [5] Job account saves (rarely change)
    [6] Object saves (world persistence)
]]--
conf.clientsync = 35 * conf.sec
conf.charactersync = 55 * conf.sec
conf.serversync = 1.5 * conf.min
conf.playersync = 2 * conf.min
conf.revivesync = conf.min
conf.vehiclesync = 5 * conf.min      -- Vehicles save less frequently
conf.jobsync = 10 * conf.min         -- Jobs change infrequently
conf.objectsync = 5 * conf.min       -- Objects change less often
-- Recommended to not touch this one.
-- As entities being removed from onesync trigger and event to clean up their respective tables, this is only used to ensure the data quaity of the tables, a checker if you will that will garbage collect as needed.
conf.cleanup = 5 * conf.min
--[[
SPAWN LOCATION : Airport.
]]--
conf.spawn = {
    x = -1037.71,
    y = -2736.13,
    z = 13.74,
    h = 328.82,
}
--[[
SCREENSHOTS :
    -- Host URL like 
]]--
conf.imagehost = ""
conf.imagetoken = ""
--[[
INSTANCE/ROUTINGBUCKET :
    -- Default world for all players.
]]--
conf.instancedefault = 0 --
--[[
BANK START AMOUNT :
    -- What do you want in your bank accounts?
]]--
conf.startingloan = 0
conf.bankoverdraw = 10
--[[
BANK LOANS TIMES TO PAY: 
    -- Repayment Time to take money from bank account
    -- Loan interest calculation time to apply interest.
]]--
conf.loanpayment = {h = 12, m = 0}
conf.loaninterest = {h = 15, m = 0}
--[[
PLAYER HUNGER / THIRST / HP / ARMOUR: 
    -- Values and times.
]]--
conf.hungertime = conf.min * 4.1
conf.thirsttime = conf.min * 3.2
conf.nui = {}
conf.nui.sync = 200
--[[
TIMEZONE ADJUSTMENT: 
    -- Takes the server time, and change it based on 1 - 23 hours. 
]]--
conf.altertime = 0
--[[
JOBS AND DEFAULTS
    -- DEFAULT STARTING BALANCES FOR ALL JOBS IPON INITIAL CREATION
    -- Take money from Job account to pay staff?
    -- Use the job center rather than have all jobs whitelisted. (Not really intended outside of private servers, private might do seasonal things, and offer different ways of setting up bosses etig.)
    -- Permit jobs to be able to go off duty to not get paid for service while online.
    -- The time taken serverside to do pay runs.
]]--
conf.enablejobpayroll = true
conf.enablejobcenter = false
conf.enableduty = true
conf.paycycle = conf.min * 15
--[[
CALLBACK SECURITY:
    -- Ticket validation settings for secure callbacks
    -- [1] Ticket validity duration (how long before a ticket expires)
    -- [2] Ticket length (number of characters in generated tickets)
    -- [3] Rate limiting enabled (set to false to disable)
    -- [4] Maximum callback requests per second per player
    -- [5] Rate limit window duration
    -- [6] Cleanup interval for expired tickets and stale data
    -- [7] Stale data threshold (inactivity period before cleanup)
]]--
conf.callback = {}
conf.callback.ticketValidity = 30 * conf.sec    -- 30 seconds
conf.callback.ticketLength = 20                 -- 20 character tickets
conf.callback.rateLimitEnabled = true           -- Enable rate limiting
conf.callback.maxRequestsPerSecond = 10         -- Max 10 requests/second per player
conf.callback.rateLimitWindow = 1 * conf.sec    -- 1 second window
conf.callback.cleanupInterval = 60 * conf.sec   -- Cleanup every 60 seconds
conf.callback.staleThreshold = 60 * conf.sec    -- 60 seconds of inactivity
--[[
DROP SYSTEM CONFIGURATION
]]--
conf.drops = {}
conf.drops.cleanup_enabled = false              -- Do not auto-delete old drops by default
conf.drops.cleanup_time = 30 * conf.min         -- Time before cleanup if enabled (30 minutes)
conf.drops.default_model = `v_ret_gc_box1`      -- Default prop model (backticks auto-hash)
conf.drops.active_timeout = 5 * conf.min        -- Time before moving back to ig.drops if no players nearby
-- ====================================================================================--
conf.consolechannel = "script:"..tostring(GetCurrentResourceName())
conf.lock = nil