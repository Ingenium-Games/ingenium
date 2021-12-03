-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
-- player is the state used for _user.lua and _character.lua as they are merged into one.
if not c.cookies then
    c.cookies = {}
end
c.cookies.player = {}
-- ====================================================================================--
--

c.cookies.player.IsWanted = AddStateBagChangeHandler('IsWanted', nil, function(bagName, key, value, _, _)
    local src = tonumber(bagName:gsub('player:', ''))
    TriggerClientEvent("Client:RunChecks:IsWanted", src)
end)
--

c.cookies.player.IsSupporter = AddStateBagChangeHandler('IsSupporter', nil, function(bagName, key, value, _, _)
    local src = tonumber(bagName:gsub('player:', ''))
    TriggerClientEvent("Client:RunChecks:IsSupporter", src)
end)
--

c.cookies.player.IsDead = AddStateBagChangeHandler('IsDead', nil, function(bagName, key, value, _, _)
    local src = tonumber(bagName:gsub('player:', ''))
    TriggerClientEvent("Client:RunChecks:IsDead", src)
end)
--

c.cookies.player.IsCuffed = AddStateBagChangeHandler('IsCuffed', nil, function(bagName, key, value, _, _)
    local src = tonumber(bagName:gsub('player:', ''))
    TriggerClientEvent("Client:RunChecks:IsCuffed", src)
end)
-- 

c.cookies.player.IsEscorted = AddStateBagChangeHandler('IsEscorted', nil, function(bagName, key, value, _, _)
    local src = tonumber(bagName:gsub('player:', ''))
    TriggerClientEvent("Client:RunChecks:IsEscorted", src)
end)
--    

c.cookies.player.IsEscorting = AddStateBagChangeHandler('IsEscorting', nil, function(bagName, key, value, _, _)
    local src = tonumber(bagName:gsub('player:', ''))
    TriggerClientEvent("Client:RunChecks:IsEscorting", src)
end)
--

c.cookies.player.IsSwimming = AddStateBagChangeHandler('IsSwimming', nil, function(bagName, key, value, _, _)
    local src = tonumber(bagName:gsub('player:', ''))
    TriggerClientEvent("Client:RunChecks:IsSwimming", src)
end)
