-- ====================================================================================--
conf = {}
-- ====================================================================================--
conf.sec = 1000 -- in MS
conf.min = 60 * conf.sec
conf.hour = 60 * conf.min
conf.day = 24 * conf.hour
-- ====================================================================================--

-- Logging configuration
conf.log = conf.log or {}
conf.log.enabled = false -- console logging default: OFF
conf.log.level = "trace" -- default to the most verbose so file logging captures all levels
conf.log.writeToFile = true -- file logging default: ON
conf.log.levels = { error=true, warn=true, info=true, debug=true, trace=true } -- optional table: { error=true, warn=true, info=true, debug=true, trace=true }
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
    -- If you want to change it, please dont bother me with possible errors or issues. XD
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
conf.instancedefault = 0 -- Please do not change.
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
    -- Takes the server time, and change it based on 1 to 23 hours.
    -- please only put positive numbers in... 
    -- Eg you are in utc 00:00 but want it to run on Australian Eastern Standard time, so add 10 hours.
]]--
conf.altertime = 0
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
--[[
WEAPON THREAD CONFIGURATION:
    -- Timing intervals for weapon system threads
    -- [1] Ammo sync interval - how often to sync ammo counts to server (milliseconds)
    -- [2] Shot cooldown - wait time after shot to avoid double-counting (milliseconds)
    -- [3] Reload duration - wait during reload animation (milliseconds)
]]--
conf.weapon = {}
conf.weapon.ammoSyncInterval = 2.5 * conf.sec   -- 2.5 seconds between periodic ammo syncs
conf.weapon.shotCooldown = 115                  -- 115ms wait after shot
conf.weapon.reloadDuration = 1.25 * conf.sec    -- 1.25 seconds reload wait
--[[
RP THREAD CONFIGURATION:
    -- Timing intervals for RP mode feature threads
    -- [1] Idle camera check interval (milliseconds)
    -- [2] NPC weapon drop check interval (milliseconds)
    -- [3] Control state idle check interval (milliseconds)
]]--
conf.rp = {}
conf.rp.idleCameraInterval = 5 * conf.sec       -- 5 seconds between idle camera checks
conf.rp.npcWeaponInterval = 2.5 * conf.sec      -- 2.5 seconds between NPC weapon checks
conf.rp.controlIdleInterval = 100               -- 100ms when no special states active
--[[
VEHICLE PERSISTENCE CONFIGURATION:
    -- Controls how parked vehicles are handled
    -- [1] enablePersistence - Enable/disable entire persistence system
    -- [2] parkingMode - "place" (stay in spot) or "garage" (disappear until taken out)
    -- [3] Protected while parked - If parkingMode="place", vehicles can't be damaged/deleted
    -- [4] Auto-respawn on join - Respawn garaged vehicles when owner joins
]]--
conf.persistence = {}
conf.persistence.enablePersistence = true       -- Enable vehicle persistence system
conf.persistence.parkingMode = "place"          -- "place" = stays in world | "garage" = disappears until taken out
conf.persistence.protectParkedVehicles = true   -- Prevent damage/deletion while parked (if parkingMode="place")
conf.persistence.autoRespawnOnJoin = false      -- Auto-respawn garaged vehicles when owner joins
conf.persistence.logging = {
    enabled = false                             -- Enable persistence system logging
}
-- ====================================================================================--
conf.resourcename = GetCurrentResourceName()
conf.consolechannel = "script:"..tostring(conf.resourcename)
conf.lock = nil