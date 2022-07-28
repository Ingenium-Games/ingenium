-- ====================================================================================--

-- player is the state used for _user.lua and _character.lua as they are merged into one.
if not c.sbch then
    c.sbch = {}
end
-- c.sbch.
-- ====================================================================================--
c.sbch.player = {}
--

c.sbch.player.IsWanted = AddStateBagChangeHandler("IsWanted", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:IsWanted", src)
end)
--

c.sbch.player.IsSupporter = AddStateBagChangeHandler("IsSupporter", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:IsSupporter", src)
end)
--

c.sbch.player.IsDead = AddStateBagChangeHandler("IsDead", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:IsDead", src)
    --
    local xPlayer = c.data.GetPlayer(src)
    if value == false then
        c.sql.char.SetDead(xPlayer.GetCharacter_ID(), false, {RevivedAt = c.func.TimeStamp()})
    end
end)
--

c.sbch.player.IsCuffed = AddStateBagChangeHandler("IsCuffed", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:IsCuffed", src)
end)
-- 

c.sbch.player.IsEscorted = AddStateBagChangeHandler("IsEscorted", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:IsEscorted", src)
end)
--    

c.sbch.player.IsEscorting = AddStateBagChangeHandler("IsEscorting", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:IsEscorting", src)
end)
--

c.sbch.player.IsSwimming = AddStateBagChangeHandler("IsSwimming", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:IsSwimming", src)
end)
--

-- ====================================================================================--

-- BANKING
c.sbch.player.Bank = AddStateBagChangeHandler("Bank", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:Bank", src)
end)
--
-- BANKING
c.sbch.player.Cash = AddStateBagChangeHandler("Cash", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    TriggerClientEvent("Client:RunChecks:Cash", src)
end)
--

-- ====================================================================================--
