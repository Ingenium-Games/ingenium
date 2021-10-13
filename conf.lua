-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
conf = {}
-- Just some time, because fuck maths.
conf.sec = 1000
conf.min = 60 * conf.sec
conf.hour = 60 * conf.min
conf.day = 24 * conf.hour
-- ====================================================================================--
conf.url = {}
conf.url.version = "https://raw.githubusercontent.com/Ingenium-Games/ig.core/main/version.txt"
conf.url.discordchannel_1 = "Example"
--[[
DEBUG :
    -- Up to you if you want to see whats going on or not, or open the DevTools. Scrub.
]]--
conf.debug = true
--[[
GENERIC :
    [1] Map name.
    [2] Game Type.
]]--
conf.mapname = 'Los Santos'
conf.gametype = 'Role Play'
--[[
LOCALISATION/INTERNATIONALISATION also known as.. i18n :
    -- Standard language selection.
]]--
conf.locale = 'en'
--[[
ACE PERMISSIONS :
    -- The permissions are done inside the DB, so every time the User joins the ace gets set at the user level, the default level to assign to the DB on a new user joining is...
]]--
conf.ace = 'public' 
--[[
PRIMARY_ID :
    -- This will be what you choose to identify as the owner of the characters table within the DB.
    -- You can use any however I would leave it as the license as you need a legal copy of GTAV to
    -- play FiveM anyway, so everyone has a rockstar id, hence the license. But, up to you.
    -- 'fivem:' / 'steam:' / 'discord:' / 'license:' / 'ip:'
]]--
conf.identifier = 'license:'
--[[
UPDATE TIMES :
    [1] Client updates the server every...
    [2] Server updates the Database every...
    [3] Server to Check players table every...
]]--
conf.clientsync = 20 * conf.sec
conf.serversync = 1.5 * conf.min
conf.playersync = 3 * conf.min
-- Recommended to not touch this one.
-- As entities being removed from onesync trigger and event to clean up their respective tables, this is only used to ensure the data quaity of the tables, a checker if you will that will garbage collect as needed.
conf.cleanup = 5 * conf.min
--[[
SPAWN LOCATION : Airport.
]]--
conf.spawn = {
    x = -1050.30,
    y = -2740.95,
    z = 14.6
}
--[[
DEFERALS :
    [1] Force the user name of joining player to be alpha numeric characters only. No '<_-(.</?\)' etc.
    [2] Use Discord for your community?  https://forum.cfx.re/t/discordroles-a-proper-attempt-this-time/1579427 
    [3] Discord role to confirm the player is apart of the required guild.
]]--
conf.forcename = true
conf.discordperms = true
conf.discordrole = '834191331844030524'
--[[
SCREENSHOTS :
    -- Host URL like 
]]--
conf.imagehost = ''
conf.imagetoken = ''
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
conf.defaulthealth = 400 --(DOUBE BOI)
conf.defaultarmour = 300 --(Oh Baby a TRIPPLE)
conf.hungertime = conf.min * 4.1
conf.thirsttime = conf.min * 3.2
conf.clientnuisync = conf.sec
--[[
TIMEZONE ADJUSTMENT: 
    -- Takes the server time, and change it based on -23,23 hours. 
    -- You can do greater, but it will break your game.
]]--
conf.altertime = -6
--[[
JOBS AND DEFAULTS
    -- DEFAULT STARTING BALANCES FOR ALL JOBS IPON INITIAL CREATION
    -- Take money from Job account to pay staff?
    -- Use the job center rather than have all jobs whitelisted. (Not really intended outside of private servers, private might do seasonal things, and offer different ways of setting up bosses etc.)
    -- Permit jobs to be able to go off duty to not get paid for service while online.
    -- The time taken serverside to do pay runs.
]]--
conf.enablejobpayroll = true
conf.enablejobcenter = true
conf.enableduty = true
conf.paycycle = conf.min * 15

-- ====================================================================================--



conf.consolechannel = "script:"..tostring(GetCurrentResourceName())
conf.lock = nil