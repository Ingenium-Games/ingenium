-- ====================================================================================--
-- player is the state used for _user.lua and _character.lua as they are merged into one.
ig.sbch = {}
-- ====================================================================================--
ig.sbch.player = {}
--
-- Typically these are invoked via the xplayer table to modify states as its the server, and people are acustomed to xplayer tables etig.
-- however the clients can also invoke state changes, like the dead version, so when they do this,
-- we run a check to see if its the same as the prior value before getting the server to update the data table.
-- the only one we dont is the isdead, as technically clients can say when they are alive or dead....

-- When a player loads in, all these are invoked as they are a nil state, therefore the change should trigger the refresh

ig.sbch.player.IsWanted = AddStateBagChangeHandler("IsWanted", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        if value ~= xPlayer.GetWanted() then
            xPlayer.SetWanted(true)
        end
        --
        TriggerClientEvent("Client:RunChecks:IsWanted", src)
        --
    end
end)
--

ig.sbch.player.IsSupporter = AddStateBagChangeHandler("IsSupporter", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        if value ~= xPlayer.GetSupporter() then
            xPlayer.SetSupporter(value)
        end
        --
        TriggerClientEvent("Client:RunChecks:IsSupporter", src)
        --
    end
end)
--

ig.sbch.player.IsDead = AddStateBagChangeHandler("IsDead", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        if value == false then
            -- We want to know when they were revived.
            ig.sql.char.SetDead(xPlayer.GetCharacter_ID(), value, {
                RevivedAt = ig.funig.Timestamp()
            })
            ig.sql.char.SetHealth(xPlayer.GetCharacter_ID(), 150)
            --
        else
            --
        end
        --
        TriggerClientEvent("Client:RunChecks:IsDead", src)
        --
    end

end)
--

ig.sbch.player.IsCuffed = AddStateBagChangeHandler("IsCuffed", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        if value ~= xPlayer.GetCuffed() then
            xPlayer.SetCuffed(value)
        end
        --
        TriggerClientEvent("Client:RunChecks:IsCuffed", src)
        --        
    end
end)
-- 

ig.sbch.player.IsEscorted = AddStateBagChangeHandler("IsEscorted", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        if value ~= xPlayer.GetEscorted() then
            xPlayer.SetEscorted(value)
        end
        --
        TriggerClientEvent("Client:RunChecks:IsEscorted", src)
        --    
    end
end)
--    

ig.sbch.player.IsEscorting = AddStateBagChangeHandler("IsEscorting", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        if value ~= xPlayer.GetEscorting() then
            xPlayer.SetEscorting(value)
        end
        --
        TriggerClientEvent("Client:RunChecks:IsEscorting", src)
        --
    end
end)
--

ig.sbch.player.IsSwimming = AddStateBagChangeHandler("IsSwimming", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        if value ~= xPlayer.GetSwimming() then
            xPlayer.SetSwimming(value)
        end
        --
        TriggerClientEvent("Client:RunChecks:IsSwimming", src)
        --
    end
end)
--

-- ====================================================================================--
--
-- BANKING
ig.sbch.player.Bank = AddStateBagChangeHandler("Bank", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        --
        TriggerClientEvent("Client:RunChecks:Bank", src)
        --
    end
end)
--
-- BANKING
ig.sbch.player.Cash = AddStateBagChangeHandler("Cash", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        --
        TriggerClientEvent("Client:RunChecks:Cash", src)
        --
    end
end)
--
-- Phone
ig.sbch.player.Phone = AddStateBagChangeHandler("Phone", nil, function(bagName, key, value, _, _)
    local src = bagName:gsub("player:", "")
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        if value ~= xPlayer.GetPhone() then
            xPlayer.SetPhone(value)
        end
        --
        TriggerClientEvent("Client:RunChecks:Phone", src)
        --
    end
end)
--



-- ====================================================================================--
