QConfig = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
QConfig.Priority = {

}

-- require people to run steam
QConfig.RequireSteam = false

-- "whitelist" only server
QConfig.PriorityOnly = false

-- disables hardcap, should keep this true
QConfig.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
QConfig.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
QConfig.QueueTimeOut = 90

-- will give players temporary priority when they disconnect and when they start loading in
QConfig.EnableGrace = false

-- how much priority power grace time will give
QConfig.GracePower = 5

-- how long grace time lasts in seconds
QConfig.GraceTime = 480

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
QConfig.JoinDelay = 5000

-- will show how many people have temporary priority in the connection message
QConfig.ShowTemp = false

-- simple localization
QConfig.Language = {
    joining = "Joining",
    connecting = "Connecting",
    idrr = "Error couldn't retrieve any of your id's, try restarting.",
    err = "There was an error",
    pos = "You are %d/%d in queue :%s",
    connectingerr = "Error adding you to connecting list",
    timedout = "Error Timed out?",
    wlonly = "You must be whitelisted to join this server",
    steam = "Error steam must be running"
}