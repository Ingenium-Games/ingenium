--[[
    Queue Admin Commands
    
    Provides administrative commands for managing the queue system
]]--

-- Helper function to check if player has admin or moderator permissions
local function HasAdminPermission(src, requireAdmin)
    if src == 0 then return true end  -- Console always has permission
    
    local licenseId = ig.func.identifier(src)
    if not licenseId then return false end
    
    local ace = ig.sql.FetchScalar(
        "SELECT `Ace` FROM `users` WHERE `License_ID` = ? LIMIT 1;",
        {licenseId}
    )
    
    if not ace then return false end
    
    if requireAdmin then
        return ace == "admin"
    else
        return ace == "admin" or ace == "moderator"
    end
end

-- Helper function to send message (console or player)
local function SendMessage(src, message, isError)
    if src == 0 then
        local color = isError and "^1" or "^3"
        print(color .. message .. "^7")
    else
        TriggerClientEvent("chat:addMessage", src, {
            color = isError and {255, 0, 0} or {255, 165, 0},
            args = {"[Queue]", message}
        })
    end
end

-- Command: View current queue
RegisterCommand("queue:list", function(source, args, rawCommand)
    local src = source
    
    -- Check admin permission
    if not HasAdminPermission(src, false) then
        SendMessage(src, "You don't have permission to use this command", true)
        return
    end
    
    -- Get queue list
    local queueList = ig.queue.GetQueueList()
    local queueSize = ig.queue.GetQueueSize()
    
    if queueSize == 0 then
        if src == 0 then
            print("^3[Queue] No players in queue^7")
        else
            TriggerClientEvent("chat:addMessage", src, {
                color = {255, 165, 0},
                args = {"[Queue]", "No players in queue"}
            })
        end
        return
    end
    
    if src == 0 then
        print(("^3[Queue] Current queue (%d players):^7"):format(queueSize))
        for _, player in ipairs(queueList) do
            print(("  %d. %s (Priority: %d, Time: %ds, ID: %s)"):format(
                player.position,
                player.name,
                player.priority,
                player.queueTime,
                player.ids[1]
            ))
        end
    else
        TriggerClientEvent("chat:addMessage", src, {
            color = {255, 165, 0},
            args = {"[Queue]", ("Current queue (%d players):"):format(queueSize)}
        })
        
        for _, player in ipairs(queueList) do
            TriggerClientEvent("chat:addMessage", src, {
                color = {200, 200, 200},
                args = {"", ("  %d. %s (Priority: %d, Time: %ds)"):format(
                    player.position,
                    player.name,
                    player.priority,
                    player.queueTime
                )}
            })
        end
    end
end, false)

-- Command: Send alert to players in queue
RegisterCommand("queue:alert", function(source, args, rawCommand)
    local src = source
    
    -- Check admin permission
    if not HasAdminPermission(src, false) then
        SendMessage(src, "You don't have permission to use this command", true)
        return
    end
    
    if #args < 1 then
        if src == 0 then
            print("^1[Queue] Usage: queue:alert <message> [duration in seconds]^7")
        else
            TriggerClientEvent("chat:addMessage", src, {
                color = {255, 0, 0},
                args = {"[Queue]", "Usage: queue:alert <message> [duration in seconds]"}
            })
        end
        return
    end
    
    -- Get message (all args except last if it's a number)
    local duration = 30
    local messageArgs = {}
    
    for i, arg in ipairs(args) do
        if i == #args and tonumber(arg) then
            duration = tonumber(arg)
        else
            table.insert(messageArgs, arg)
        end
    end
    
    local message = table.concat(messageArgs, " ")
    
    if #message == 0 then
        if src == 0 then
            print("^1[Queue] Message cannot be empty^7")
        else
            TriggerClientEvent("chat:addMessage", src, {
                color = {255, 0, 0},
                args = {"[Queue]", "Message cannot be empty"}
            })
        end
        return
    end
    
    -- Send alert
    ig.queue.SendAlert(message, duration)
    
    if src == 0 then
        print(("^2[Queue] Alert sent: %s (duration: %ds)^7"):format(message, duration))
    else
        TriggerClientEvent("chat:addMessage", src, {
            color = {0, 255, 0},
            args = {"[Queue]", ("Alert sent: %s (duration: %ds)"):format(message, duration)}
        })
    end
end, false)

-- Command: Remove player from queue
RegisterCommand("queue:remove", function(source, args, rawCommand)
    local src = source
    
    -- Check admin permission
    if not HasAdminPermission(src, false) then
        SendMessage(src, "You don't have permission to use this command", true)
        return
    end
    
    if #args < 1 then
        if src == 0 then
            print("^1[Queue] Usage: queue:remove <player_id|position>^7")
        else
            TriggerClientEvent("chat:addMessage", src, {
                color = {255, 0, 0},
                args = {"[Queue]", "Usage: queue:remove <player_id|position>"}
            })
        end
        return
    end
    
    local identifier = args[1]
    local queueList = ig.queue.GetQueueList()
    
    -- Check if it's a position number
    local position = tonumber(identifier)
    if position then
        if position < 1 or position > #queueList then
            if src == 0 then
                print("^1[Queue] Invalid position^7")
            else
                TriggerClientEvent("chat:addMessage", src, {
                    color = {255, 0, 0},
                    args = {"[Queue]", "Invalid position"}
                })
            end
            return
        end
        
        local player = queueList[position]
        local removed = ig.queue.RemovePlayer(player.ids)
        
        if removed then
            if src == 0 then
                print(("^2[Queue] Removed %s from queue^7"):format(player.name))
            else
                TriggerClientEvent("chat:addMessage", src, {
                    color = {0, 255, 0},
                    args = {"[Queue]", ("Removed %s from queue"):format(player.name)}
                })
            end
        else
            if src == 0 then
                print("^1[Queue] Failed to remove player^7")
            else
                TriggerClientEvent("chat:addMessage", src, {
                    color = {255, 0, 0},
                    args = {"[Queue]", "Failed to remove player"}
                })
            end
        end
    else
        -- Try to find by ID
        local found = false
        for _, player in ipairs(queueList) do
            local idArray = player.identifiers.array()
            for _, id in ipairs(idArray) do
                if string.find(id, identifier) then
                    local removed = ig.queue.RemovePlayer(player.identifiers)
                    if removed then
                        if src == 0 then
                            print(("^2[Queue] Removed %s from queue^7"):format(player.name))
                        else
                            TriggerClientEvent("chat:addMessage", src, {
                                color = {0, 255, 0},
                                args = {"[Queue]", ("Removed %s from queue"):format(player.name)}
                            })
                        end
                        found = true
                        break
                    end
                end
            end
            if found then break end
        end
        
        if not found then
            if src == 0 then
                print("^1[Queue] Player not found in queue^7")
            else
                TriggerClientEvent("chat:addMessage", src, {
                    color = {255, 0, 0},
                    args = {"[Queue]", "Player not found in queue"}
                })
            end
        end
    end
end, false)

-- Command: Initiate graceful shutdown
RegisterCommand("queue:shutdown", function(source, args, rawCommand)
    local src = source
    
    -- Check admin permission (admin only for shutdown)
    if not HasAdminPermission(src, true) then
        SendMessage(src, "You don't have permission to use this command (admin only)", true)
        return
    end
    
    local reason = "Server restart in progress"
    local delay = 30
    
    if #args >= 1 then
        -- Check if last arg is a number (delay)
        local lastArg = args[#args]
        if tonumber(lastArg) then
            delay = tonumber(lastArg)
            table.remove(args, #args)
        end
        
        if #args > 0 then
            reason = table.concat(args, " ")
        end
    end
    
    ig.queue.InitiateShutdown(reason, delay)
    
    if src == 0 then
        print(("^3[Queue] Shutdown initiated: %s (delay: %ds)^7"):format(reason, delay))
    else
        TriggerClientEvent("chat:addMessage", src, {
            color = {255, 165, 0},
            args = {"[Queue]", ("Shutdown initiated: %s (delay: %ds)"):format(reason, delay)}
        })
    end
end, false)

-- Help command
RegisterCommand("queue:help", function(source, args, rawCommand)
    local src = source
    
    local helpText = {
        "^3=== Queue System Commands ===^7",
        "^2queue:list^7 - View all players in queue",
        "^2queue:alert <message> [duration]^7 - Send alert to players in queue",
        "^2queue:remove <player_id|position>^7 - Remove a player from queue",
        "^2queue:shutdown [reason] [delay]^7 - Initiate graceful shutdown (admin only)",
        "^2queue:help^7 - Show this help message",
        "^3============================^7"
    }
    
    if src == 0 then
        for _, line in ipairs(helpText) do
            print(line)
        end
    else
        for _, line in ipairs(helpText) do
            TriggerClientEvent("chat:addMessage", src, {
                color = {255, 255, 255},
                args = {"", line}
            })
        end
    end
end, false)

print("^2[Queue] Admin commands loaded^7")
