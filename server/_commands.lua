-- ====================================================================================--
-- PUBLIC
-- ====================================================================================--

RegisterCommand("accounts", function(source, args, rawCommand)
    local src = tonumber(source)
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        TriggerClientEvent('Client:Notify', src, "Cash : $" .. xPlayer.GetCash())
        TriggerClientEvent('Client:Notify', src, "Bank : $" .. xPlayer.GetBank())
    end
end, false)

RegisterCommand("duty", function(source, args, rawCommand)
    local src = tonumber(source)
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer.OnDuty() then
        TriggerEvent('Server:Character:OffDuty', src)
    else
        TriggerEvent('Server:Character:OnDuty', src)    
    end
end, false)

-- Experimental
ExecuteCommand("add_ace group.public command.switch allow")
RegisterCommand("switch", function(source, args, rawCommand)
    local src = source
    local p = promise.new()
    local xPlayer = ig.data.GetPlayer(src)
    local Primary_ID = ig.func.identifier(src)
    local Character_ID = xPlayer.GetCharacter_ID()
    -- Send the client/sever the events once the character has changed to inactive on the db. 
    TriggerClientEvent("Client:Character:Pre-Switch")
    ig.sql.char.SetActive(Character_ID, false, function()
        ig.data.RemovePlayer(src)
        p:resolve()
    end)
    --
    Citizen.Await(p)
    Citizen.Wait((ig.sec * 4500))
    TriggerClientEvent("Client:Character:OpeningMenu", src)
    TriggerEvent("Server:Character:List", src, Primary_ID)
    -- Events to handle character removeal.
    TriggerClientEvent("Client:Character:Switch")
    TriggerEvent("Server:Character:Switch")
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

-- ====================================================================================--
-- MODERATOR
-- ====================================================================================--

ExecuteCommand("add_ace group.mod command.setjob allow")
RegisterCommand("setjob", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(args[1])
    if ig.job.Exist(args[2], args[3]) then
        xPlayer.SetJob(args[2], args[3])
        TriggerClientEvent("Client:Notify", src, "Set ID:"..args[1]..", as Job: "..args[2]..", Grade: "..args[3]..".")
        TriggerClientEvent("Client:Notify", args[1], "Set ID:"..args[1]..", as Job: "..args[2]..", Grade: "..args[3]..".")
    else
        TriggerClientEvent("Client:Notify", src, "JobName: "..args[2].." or JobGrade: "..args[3]..", does not exist.")
        TriggerClientEvent("Client:Notify", args[1], "JobName: "..args[2].." or JobGrade: "..args[3]..", does not exist.")
    end
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

ExecuteCommand("add_ace group.mod command.tpm allow")
RegisterCommand("tpm", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    TriggerClientCallback({
        source = src,
        eventName = "TeleportOnMarker",
        args = {}
    })    
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

ExecuteCommand("add_ace group.mod command.car allow")
RegisterCommand("car", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local ords = xPlayer.GetCoords()
    local entity = CreateVehicle(args[1], ords.x + 2.0, ords.y + 1.0, ords.z, ords.h, true, false)
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

ExecuteCommand("add_ace group.mod command.revive allow")
RegisterCommand("revive", function(source, args, rawCommand)
    if #args > 0 then
        local src = args[1]
        local xPlayer = ig.data.GetPlayer(src)
        local ords = xPlayer.GetCoords()    
        TriggerClientCallback({source = src, eventName="Revive", args={ords}})
    else
        local src = source
        local xPlayer = ig.data.GetPlayer(src)
        local ords = xPlayer.GetCoords()    
        TriggerClientCallback({source = src, eventName="Revive", args={ords}})
    end
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

ExecuteCommand("add_ace group.mod command.heal allow")
RegisterCommand("heal", function(source, args, rawCommand)
    if #args > 0 then
        local src = args[1]
        local xPlayer = ig.data.GetPlayer(src)
        local ords = xPlayer.GetCoords()    
        TriggerClientCallback({source = src, eventName="Heal", args={}})
    else
        local src = source
        local xPlayer = ig.data.GetPlayer(src)
        local ords = xPlayer.GetCoords()    
        TriggerClientCallback({source = src, eventName="Heal", args={}})
    end
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)


-- ====================================================================================--
-- ADMIN
-- ====================================================================================--

ExecuteCommand("add_ace group.admin command.ban allow")
RegisterCommand("ban", function(source, args, rawCommand)
    local src = source
    local xInvoke = ig.data.GetPlayer(src)
    local Primary_ID = ig.func.identifier(args[1])
    local xPlayer = ig.data.GetPlayer(args[1])
    local reason = { Reason = tostring(args[2]), Time = tostring(ig.func.Timestamp()), By = xInvoke.GetName(), }
    if (args[1] == src) then
        TriggerClientEvent("Client:Notify", src, "You cannot /ban yourself.")
    else
        local ban = true -- should probably add a check but meh.
        ig.sql.user.SetBan(Primary_ID, ban, reason, function()
            xPlayer.Kick("You have been banned.")
            TriggerClientEvent("Client:Notify", src, "TargetID: " .. args[1] .. ", has been banned.")
        end)
    end
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

ExecuteCommand("add_ace group.admin command.kick allow")
RegisterCommand("kick", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(args[1])
    if (args[1] == src) then
        TriggerClientEvent("Client:Notify", src, "You cannot /kick yourself.")
    else
        xPlayer.Kick("You have been kicked.")
        TriggerClientEvent("Client:Notify", src, "TargetID: " .. args[1] .. ", has been kicked.")
    end
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

ExecuteCommand("add_ace group.admin command.bring allow")
RegisterCommand("bring", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local trg = tonumber(args[1])
    local zPlayer = ig.data.GetPlayer(trg)
    local ords = xPlayer.GetCoords()
    zPlayer.SetCoords({x = ords.x + 1, y = ords.y + 1, z = ords.z, h = ords.h})
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " on: "..zPlayer.GetName().." by "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

ExecuteCommand("add_ace group.admin command.return allow")
RegisterCommand("return", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local trg = tonumber(args[1])
    local zPlayer = ig.data.GetPlayer(trg)
    local tbl = zPlayer.GetOldCoords()
    zPlayer.SetCoords(tbl)
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " on: "..zPlayer.GetName().." by: "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)

ExecuteCommand("add_ace group.admin command.freeze allow")
RegisterCommand("freeze", function(source, args, rawCommand)
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    local trg = tonumber(args[1])
    local zPlayer = ig.data.GetPlayer(trg)
    local bool = zPlayer.GetFrozen()
    zPlayer.SetFrozen(not bool)
    TriggerEvent("txaLogger:CommandExecuted", rawCommand.. " on: "..zPlayer.GetName().." by: "..xPlayer.GetName()) -- txAdmin logging Callback
end, true)


