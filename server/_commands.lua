-- ====================================================================================--

--[[
NOTES.
    -
    -
    -
]] --


-- ====================================================================================--



-- ====================================================================================--

ExecuteCommand("add_ace group.public command.switch allow")
RegisterCommand("switch", function(source, args, rawCommand)
    TriggerEvent("txaLogger:CommandExecuted", rawCommand) -- txAdmin logging Callback
    local src = source
    local p = promise.new()
    local xPlayer = c.data.GetPlayer(src)
    local Primary_ID = c.identifier(src)
    local Character_ID = xPlayer.GetCharacter_ID()
    -- Send the client/sever the events once the character has changed to inactive on the db. 
    TriggerClientEvent("Client:Character:Pre-Switch")
    c.sql.char.SetActive(Character_ID, false, function()
        c.data.RemovePlayer(src)
        p:resolve()
    end)
    --
    Citizen.Await(p)
    Citizen.Wait((c.sec * 4500))
    TriggerClientEvent("Client:Character:OpeningMenu", src)
    TriggerEvent("Server:Character:List", src, Primary_ID)
    -- Events to handle character removeal.
    TriggerClientEvent("Client:Character:Switch")
    TriggerEvent("Server:Character:Switch")
end, true)

-- ====================================================================================--

ExecuteCommand("add_ace group.admin command.ban allow")
RegisterCommand("ban", function(source, args, rawCommand)
    TriggerEvent("txaLogger:CommandExecuted", rawCommand) -- txAdmin logging Callback
    local src = source
    if (args[1] == src) then
        TriggerClientEvent("Client:Notify", src, "You cannot /ban yourself.")
    else
        local Primary_ID = c.identifier(args[1])
        local xPlayer = c.data.GetPlayer(args[1])
        local ban = true -- should probably add a check but meh.
        c.sql.user.SetBan(Primary_ID, ban, function()
            xPlayer.Kick("You have been banned.")
            TriggerClientEvent("Client:Notify", src, "TargetID: " .. args[1] .. ", has been banned.")
        end)
    end
end, true)

-- ====================================================================================--

ExecuteCommand("add_ace group.admin command.kick allow")
RegisterCommand("kick", function(source, args, rawCommand)
    TriggerEvent("txaLogger:CommandExecuted", rawCommand) -- txAdmin logging Callback
    local src = source
    if (args[1] == src) then
        TriggerClientEvent("Client:Notify", src, "You cannot /kick yourself.")
    else
        local xPlayer = c.data.GetPlayer(args[1])
        xPlayer.Kick("You have been kicked.")
        TriggerClientEvent("Client:Notify", src, "TargetID: " .. args[1] .. ", has been kicked.")
    end
end, true)

-- ====================================================================================--

ExecuteCommand("add_ace group.mod command.setjob allow")
RegisterCommand("setjob", function(source, args, rawCommand)
    TriggerEvent("txaLogger:CommandExecuted", rawCommand) -- txAdmin logging Callback
    local src = source
    if c.job.Exist(args[2], args[3]) then
        local xPlayer = c.data.GetPlayer(args[1])
        xPlayer.SetJob(args[2], args[3])
        TriggerClientEvent("Client:Notify", src, "Set ID:"..args[1]..", as Job: "..args[2]..", Grade: "..args[3]..".")
        TriggerClientEvent("Client:Notify", args[1], "Set ID:"..args[1]..", as Job: "..args[2]..", Grade: "..args[3]..".")
    else
        TriggerClientEvent("Client:Notify", src, "JobName: "..args[2].." or JobGrade: "..args[3]..", does not exist.")
        TriggerClientEvent("Client:Notify", args[1], "JobName: "..args[2].." or JobGrade: "..args[3]..", does not exist.")
    end
end, true)

-- ====================================================================================--

ExecuteCommand("add_ace group.mod command.tpm allow")
RegisterCommand("tpm", function(source, args, rawCommand)
    TriggerEvent("txaLogger:CommandExecuted", rawCommand) -- txAdmin logging Callback
    local src = source
    TriggerClientCallback({
        source = src,
        eventName = "TeleportOnMarker",
        args = {}
    })    
end, true)