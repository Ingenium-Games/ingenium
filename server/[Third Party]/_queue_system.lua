--[[
    Ingenium Queue System
    
    A comprehensive queue management system with:
    - Adaptive card UI for queue position updates
    - Discord role-based priority
    - Database supporter priority
    - Admin management commands
    - Graceful shutdown handling
    - Extensible connection steps
    
    MIT License (based on Nick78111's ConnectQueue)
    Modified and enhanced for Ingenium Games
]]--

-- Initialize queue namespace
ig.queue = ig.queue or {}

-- Queue state management
local QueueState = {
    playerQueue = {},           -- Players waiting in queue
    connectingPlayers = {},     -- Players currently connecting
    connectedPlayers = {},      -- Players who have connected
    shutdownMode = false,       -- Server shutdown in progress
    connectionSteps = {},       -- Extensible connection steps
    queueAlerts = {}           -- Admin alerts for players in queue
}

-- Configuration
local QueueConfig = {
    maxPlayers = QueueConf.MaxPlayers,
    debugMode = QueueConf.Debug,
    displayQueue = QueueConf.DisplayQueue,
    queueTimeout = QueueConf.QueueTimeout,
    connectTimeout = QueueConf.ConnectTimeout,
    graceEnabled = QueueConf.GraceEnabled,
    gracePower = QueueConf.GracePower,
    graceTime = QueueConf.GraceTime,
    updateInterval = QueueConf.UpdateInterval,
    requireSteam = QueueConf.RequireSteam,
    priorityOnly = QueueConf.PriorityOnly
}

-- Temporary priority storage (for grace period)
local tempPriority = {}

-- Connection steps registry
local connectionSteps = {}

-- Admin alerts storage
local adminAlerts = {}

--------------------------------------------------------------------------------
-- Utility Functions
--------------------------------------------------------------------------------

local function DebugPrint(msg)
    if QueueConfig.debugMode then
        print(("^3[QUEUE]: ^7%s^7"):format(tostring(msg)))
    end
end

local function GetPlayerIds(src)
    local ids = GetPlayerIdentifiers(src)
    local endpoint = GetPlayerEndpoint(src)
    
    if not ids or #ids == 0 then
        if endpoint then
            ids = {"ip:" .. endpoint}
        else
            return nil
        end
    end
    
    return ids
end

local function GetSteamId(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        if string.sub(id, 1, 6) == "steam:" then
            return id
        end
    end
    return nil
end

local function GetLicenseId(src)
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids) do
        if string.sub(id, 1, 8) == "license:" then
            return id
        end
    end
    return nil
end

--------------------------------------------------------------------------------
-- Adaptive Card Functions
--------------------------------------------------------------------------------

local function CreateQueueCard(position, queueSize, queueTime, estimatedWait, hasAlert)
    local alert = hasAlert and adminAlerts[1] or nil
    
    local body = {
        DeferralCards.CardElement:TextBlock({
            text = "🎮 Ingenium Server",
            size = "Large",
            weight = "Bolder",
            horizontalAlignment = "Center",
            color = "Accent"
        }),
        DeferralCards.CardElement:TextBlock({
            text = "━━━━━━━━━━━━━━━━━━━━━━",
            horizontalAlignment = "Center",
            isSubtle = true
        }),
        DeferralCards.Container:FactSet({
            facts = {
                DeferralCards.Container:Fact({
                    title = "Queue Position:",
                    value = string.format("%d / %d", position, queueSize)
                }),
                DeferralCards.Container:Fact({
                    title = "Time in Queue:",
                    value = queueTime
                }),
                DeferralCards.Container:Fact({
                    title = "Estimated Wait:",
                    value = estimatedWait
                })
            }
        }),
        DeferralCards.CardElement:TextBlock({
            text = "━━━━━━━━━━━━━━━━━━━━━━",
            horizontalAlignment = "Center",
            isSubtle = true
        })
    }
    
    -- Add admin alert if present
    if alert then
        table.insert(body, DeferralCards.CardElement:TextBlock({
            text = "📢 Server Message",
            size = "Medium",
            weight = "Bolder",
            horizontalAlignment = "Center",
            color = "Attention"
        }))
        table.insert(body, DeferralCards.CardElement:TextBlock({
            text = alert.message,
            horizontalAlignment = "Center",
            wrap = true,
            color = "Attention"
        }))
        table.insert(body, DeferralCards.CardElement:TextBlock({
            text = "━━━━━━━━━━━━━━━━━━━━━━",
            horizontalAlignment = "Center",
            isSubtle = true
        }))
    end
    
    -- Add connection steps if any are registered
    for _, step in ipairs(connectionSteps) do
        if step.showInQueue then
            table.insert(body, DeferralCards.CardElement:TextBlock({
                text = step.title,
                size = "Medium",
                weight = "Bolder",
                horizontalAlignment = "Left"
            }))
            table.insert(body, DeferralCards.CardElement:TextBlock({
                text = step.description,
                horizontalAlignment = "Left",
                wrap = true,
                isSubtle = true
            }))
        end
    end
    
    -- Add helpful information
    table.insert(body, DeferralCards.CardElement:TextBlock({
        text = "Please wait patiently. The queue moves automatically.",
        horizontalAlignment = "Center",
        size = "Small",
        isSubtle = true,
        wrap = true
    }))
    
    local card = DeferralCards.Card:Create({
        body = body
    })
    
    return json.encode(card)
end

local function CreateConnectingCard(stepIndex, totalSteps, stepTitle, stepDescription)
    local body = {
        DeferralCards.CardElement:TextBlock({
            text = "🎮 Connecting to Ingenium",
            size = "Large",
            weight = "Bolder",
            horizontalAlignment = "Center",
            color = "Good"
        }),
        DeferralCards.CardElement:TextBlock({
            text = "━━━━━━━━━━━━━━━━━━━━━━",
            horizontalAlignment = "Center",
            isSubtle = true
        }),
        DeferralCards.CardElement:TextBlock({
            text = string.format("Step %d of %d", stepIndex, totalSteps),
            horizontalAlignment = "Center",
            size = "Medium",
            weight = "Bolder"
        }),
        DeferralCards.CardElement:TextBlock({
            text = stepTitle,
            horizontalAlignment = "Center",
            size = "Large",
            color = "Accent"
        }),
        DeferralCards.CardElement:TextBlock({
            text = stepDescription,
            horizontalAlignment = "Center",
            wrap = true
        })
    }
    
    local card = DeferralCards.Card:Create({
        body = body
    })
    
    return json.encode(card)
end

--------------------------------------------------------------------------------
-- Priority System
--------------------------------------------------------------------------------

local function GetDatabasePriority(src)
    local licenseId = GetLicenseId(src)
    if not licenseId then return 0 end
    
    -- Check if player is a supporter from database
    local supporter = ig.sql.FetchScalar(
        "SELECT `Supporter` FROM `users` WHERE `License_ID` = ? LIMIT 1;",
        {licenseId}
    )
    
    if supporter and tonumber(supporter) == 1 then
        return QueueConf.SupporterPriority
    end
    
    return 0
end

local function GetDiscordPriority(src, callback)
    if not conf.discord.priority_enabled then
        callback(0)
        return
    end
    
    local discordId = ig.discord.GetDiscordId(src)
    if not discordId then
        callback(0)
        return
    end
    
    -- Get Discord roles and check for priority
    ig.discord.HasRole(src, "", function(hasRole, roles)
        local highestPriority = 0
        
        if conf.discord.priority_roles then
            for _, priorityRole in ipairs(conf.discord.priority_roles) do
                for _, userRole in ipairs(roles) do
                    if userRole == priorityRole.id then
                        if priorityRole.power > highestPriority then
                            highestPriority = priorityRole.power
                        end
                    end
                end
            end
        end
        
        callback(highestPriority)
    end)
end

local function GetTempPriority(ids)
    for _, id in ipairs(ids) do
        local temp = tempPriority[id]
        if temp and os.time() < temp.endTime then
            return temp.power
        end
    end
    return 0
end

local function GetTotalPriority(src, ids, callback)
    local dbPriority = GetDatabasePriority(src)
    local tempPriority = GetTempPriority(ids)
    
    GetDiscordPriority(src, function(discordPriority)
        -- Use the highest priority from all sources
        local totalPriority = math.max(dbPriority, discordPriority, tempPriority)
        callback(totalPriority)
    end)
end

local function AddTempPriority(ids, power, duration)
    if not ids or not power or not duration then return end
    
    local endTime = os.time() + duration
    
    for _, id in ipairs(ids) do
        tempPriority[id] = {
            power = power,
            endTime = endTime
        }
    end
    
    DebugPrint(("Added temporary priority (power: %d, duration: %ds) for %s"):format(
        power, duration, ids[1]
    ))
end

--------------------------------------------------------------------------------
-- Queue Management
--------------------------------------------------------------------------------

local function FindPlayerInQueue(ids)
    for index, player in ipairs(QueueState.playerQueue) do
        for _, queueId in ipairs(player.ids) do
            for _, searchId in ipairs(ids) do
                if queueId == searchId then
                    return index, player
                end
            end
        end
    end
    return nil, nil
end

local function AddToQueue(src, ids, name, priority, deferrals)
    local existingIndex = FindPlayerInQueue(ids)
    if existingIndex then
        -- Update existing entry
        QueueState.playerQueue[existingIndex].source = src
        QueueState.playerQueue[existingIndex].deferrals = deferrals
        QueueState.playerQueue[existingIndex].timeout = 0
        return
    end
    
    local player = {
        source = src,
        ids = ids,
        name = name,
        priority = priority,
        joinTime = os.time(),
        timeout = 0,
        deferrals = deferrals
    }
    
    -- Insert player in queue based on priority
    local insertPos = #QueueState.playerQueue + 1
    
    if priority > 0 then
        for i, queuedPlayer in ipairs(QueueState.playerQueue) do
            if not queuedPlayer.priority or queuedPlayer.priority < priority then
                insertPos = i
                break
            end
        end
    end
    
    table.insert(QueueState.playerQueue, insertPos, player)
    
    DebugPrint(("Added %s [%s] to queue at position %d (priority: %d)"):format(
        name, ids[1], insertPos, priority
    ))
end

local function RemoveFromQueue(ids)
    local index = FindPlayerInQueue(ids)
    if index then
        local player = QueueState.playerQueue[index]
        table.remove(QueueState.playerQueue, index)
        DebugPrint(("Removed %s from queue"):format(player.name))
        return true
    end
    return false
end

local function GetQueuePosition(ids)
    local index = FindPlayerInQueue(ids)
    return index
end

--------------------------------------------------------------------------------
-- Connection Management
--------------------------------------------------------------------------------

local function AddToConnecting(ids, player)
    table.insert(QueueState.connectingPlayers, {
        ids = ids,
        name = player.name,
        source = player.source,
        connectTime = os.time(),
        timeout = 0
    })
end

local function RemoveFromConnecting(ids)
    for index, player in ipairs(QueueState.connectingPlayers) do
        for _, connId in ipairs(player.ids) do
            for _, searchId in ipairs(ids) do
                if connId == searchId then
                    table.remove(QueueState.connectingPlayers, index)
                    return true
                end
            end
        end
    end
    return false
end

local function CanPlayerConnect()
    local currentPlayers = #GetPlayers()
    local connecting = #QueueState.connectingPlayers
    return (currentPlayers + connecting) < QueueConfig.maxPlayers
end

--------------------------------------------------------------------------------
-- Connection Steps System
--------------------------------------------------------------------------------

function ig.queue.RegisterConnectionStep(stepConfig)
    if not stepConfig.id or not stepConfig.title then
        DebugPrint("^1Error: Connection step must have id and title^7")
        return false
    end
    
    table.insert(connectionSteps, {
        id = stepConfig.id,
        title = stepConfig.title,
        description = stepConfig.description or "",
        showInQueue = stepConfig.showInQueue or false,
        handler = stepConfig.handler or function(src, cb) cb(true) end
    })
    
    DebugPrint(("Registered connection step: %s"):format(stepConfig.title))
    return true
end

local function ProcessConnectionSteps(src, deferrals, callback)
    local currentStep = 1
    local totalSteps = #connectionSteps + 1 -- +1 for base connection
    
    local function processNextStep()
        if currentStep > #connectionSteps then
            callback(true)
            return
        end
        
        local step = connectionSteps[currentStep]
        
        -- Show connection card
        deferrals.presentCard(CreateConnectingCard(
            currentStep,
            totalSteps,
            step.title,
            step.description
        ))
        
        -- Execute step handler
        step.handler(src, function(success, errorMsg)
            if not success then
                callback(false, errorMsg or ("Failed at step: %s"):format(step.title))
                return
            end
            
            currentStep = currentStep + 1
            Citizen.Wait(100)
            processNextStep()
        end)
    end
    
    if #connectionSteps > 0 then
        processNextStep()
    else
        callback(true)
    end
end

--------------------------------------------------------------------------------
-- Admin Commands
--------------------------------------------------------------------------------

function ig.queue.SendAlert(message, duration)
    if not message then return false end
    
    duration = duration or 30 -- Default 30 seconds
    
    local alert = {
        message = message,
        timestamp = os.time(),
        duration = duration
    }
    
    table.insert(adminAlerts, alert)
    
    DebugPrint(("Admin alert added: %s"):format(message))
    
    -- Auto-remove after duration
    SetTimeout(duration * 1000, function()
        for i, a in ipairs(adminAlerts) do
            if a.timestamp == alert.timestamp then
                table.remove(adminAlerts, i)
                break
            end
        end
    end)
    
    return true
end

function ig.queue.GetQueueSize()
    return #QueueState.playerQueue
end

function ig.queue.GetQueueList()
    local list = {}
    for i, player in ipairs(QueueState.playerQueue) do
        table.insert(list, {
            position = i,
            name = player.name,
            priority = player.priority,
            queueTime = os.time() - player.joinTime,
            ids = player.ids
        })
    end
    return list
end

function ig.queue.RemovePlayer(ids)
    local removed = RemoveFromQueue(ids)
    if removed then
        RemoveFromConnecting(ids)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Graceful Shutdown
--------------------------------------------------------------------------------

function ig.queue.InitiateShutdown(reason, delay)
    QueueState.shutdownMode = true
    reason = reason or "Server restart in progress"
    delay = delay or 30
    
    DebugPrint(("Shutdown initiated: %s (delay: %ds)"):format(reason, delay))
    
    -- Alert all players in queue
    ig.queue.SendAlert(
        ("⚠️ %s\n\nPlease rejoin in %d seconds"):format(reason, delay),
        delay
    )
    
    -- After delay, clear the queue
    SetTimeout(delay * 1000, function()
        for _, player in ipairs(QueueState.playerQueue) do
            if player.deferrals then
                player.deferrals.done(reason)
            end
        end
        
        QueueState.playerQueue = {}
        DebugPrint("Queue cleared due to shutdown")
    end)
end

--------------------------------------------------------------------------------
-- Main Queue Handler
--------------------------------------------------------------------------------

function ig.queue.HandleConnection(name, setKickReason, deferrals)
    local src = source
    local ids = GetPlayerIds(src)
    local connectTime = os.time()
    
    if not ids then
        deferrals.done(_L("queue_idrr"))
        DebugPrint(("Rejected %s - Could not retrieve IDs"):format(name))
        return
    end
    
    -- Check for shutdown mode
    if QueueState.shutdownMode then
        deferrals.done("Server is restarting. Please try again shortly.")
        return
    end
    
    -- Check for Steam requirement (if not already checked in deferrals)
    if QueueConfig.requireSteam and not GetSteamId(src) then
        deferrals.done(_L("queue_steam"))
        return
    end
    -- Get player priority (combines DB supporter + Discord + temp priority)
    GetTotalPriority(src, ids, function(priority)
        -- Add to queue
        AddToQueue(src, ids, name, priority, deferrals)
        
        local position = GetQueuePosition(ids)
        
        -- If server has space and player is first in queue, connect immediately
        if CanPlayerConnect() and position == 1 then
            -- Process connection steps
            ProcessConnectionSteps(src, deferrals, function(success, errorMsg)
                if not success then
                    deferrals.done(errorMsg or "Connection failed")
                    RemoveFromQueue(ids)
                    return
                end
                
                AddToConnecting(ids, QueueState.playerQueue[position])
                RemoveFromQueue(ids)
                
                -- Add grace period priority for reconnection
                if QueueConfig.graceEnabled then
                    AddTempPriority(ids, QueueConfig.gracePower, QueueConfig.graceTime)
                end
                
                deferrals.done()
                DebugPrint(("Player %s connected"):format(name))
            end)
            return
        end
        
        -- Player must wait in queue
        local function updateQueueCard()
            position = GetQueuePosition(ids)
            
            if not position then
                deferrals.done("Removed from queue")
                return
            end
            
            local queueTime = os.time() - connectTime
            local queueTimeStr = string.format(
                "%02d:%02d:%02d",
                math.floor(queueTime / 3600),
                math.floor((queueTime % 3600) / 60),
                queueTime % 60
            )
            
            -- Estimate wait time (rough calculation)
            local avgWaitPerPlayer = 30 -- seconds
            local estimatedWait = (position - 1) * avgWaitPerPlayer
            local estimatedWaitStr = string.format(
                "~%d min",
                math.max(1, math.floor(estimatedWait / 60))
            )
            
            local hasAlert = #adminAlerts > 0
            
            deferrals.presentCard(CreateQueueCard(
                position,
                #QueueState.playerQueue,
                queueTimeStr,
                estimatedWaitStr,
                hasAlert
            ))
            
            -- Check if player can connect now
            if CanPlayerConnect() and position == 1 then
                -- Process connection steps
                ProcessConnectionSteps(src, deferrals, function(success, errorMsg)
                    if not success then
                        deferrals.done(errorMsg or "Connection failed")
                        RemoveFromQueue(ids)
                        return
                    end
                    
                    AddToConnecting(ids, QueueState.playerQueue[position])
                    RemoveFromQueue(ids)
                    
                    if QueueConfig.graceEnabled then
                        AddTempPriority(ids, QueueConfig.gracePower, QueueConfig.graceTime)
                    end
                    
                    deferrals.done()
                    DebugPrint(("Player %s connected"):format(name))
                end)
            else
                -- Continue waiting
                SetTimeout(QueueConfig.updateInterval, updateQueueCard)
            end
        end
        
        -- Start queue updates
        updateQueueCard()
    end)
end

--------------------------------------------------------------------------------
-- Queue Maintenance Thread
--------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        
        -- Clean up timed out players in queue
        for i = #QueueState.playerQueue, 1, -1 do
            local player = QueueState.playerQueue[i]
            local endpoint = GetPlayerEndpoint(player.source)
            
            if not endpoint then
                player.timeout = player.timeout + 1
            else
                player.timeout = 0
            end
            
            if player.timeout >= QueueConfig.queueTimeout then
                DebugPrint(("Removing %s from queue (timeout)"):format(player.name))
                table.remove(QueueState.playerQueue, i)
            end
        end
        
        -- Clean up timed out players in connecting list
        for i = #QueueState.connectingPlayers, 1, -1 do
            local player = QueueState.connectingPlayers[i]
            player.timeout = player.timeout + 1
            
            if player.timeout >= QueueConfig.connectTimeout then
                DebugPrint(("Removing %s from connecting list (timeout)"):format(player.name))
                table.remove(QueueState.connectingPlayers, i)
            end
        end
        
        -- Clean up expired temp priorities
        for id, temp in pairs(tempPriority) do
            if os.time() >= temp.endTime then
                tempPriority[id] = nil
            end
        end
        
        -- Update server name with queue count if enabled
        if QueueConfig.displayQueue then
            local queueCount = #QueueState.playerQueue
            if queueCount > 0 then
                SetConvar("sv_hostname", ("[%d in queue] %s"):format(
                    queueCount,
                    GetConvar("sv_hostname"):gsub("%[%d+ in queue%] ", "")
                ))
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- Player Events
--------------------------------------------------------------------------------

RegisterServerEvent("Server:Queue:ConfirmedPlayer")
AddEventHandler("Server:Queue:ConfirmedPlayer", function()
    local src = source
    local ids = GetPlayerIds(src)
    
    if not QueueState.connectedPlayers[src] then
        QueueState.connectedPlayers[src] = true
        RemoveFromQueue(ids)
        RemoveFromConnecting(ids)
        DebugPrint(("Player %s confirmed connection"):format(GetPlayerName(src)))
    end
end)

AddEventHandler("playerDropped", function(reason)
    local src = source
    local ids = GetPlayerIds(src)
    
    if QueueState.connectedPlayers[src] then
        QueueState.connectedPlayers[src] = nil
        
        -- Add grace period priority for reconnection
        if QueueConfig.graceEnabled then
            AddTempPriority(ids, QueueConfig.gracePower, QueueConfig.graceTime)
        end
        
        DebugPrint(("Player %s disconnected: %s"):format(GetPlayerName(src), reason))
    end
    
    RemoveFromQueue(ids)
    RemoveFromConnecting(ids)
end)

--------------------------------------------------------------------------------
-- Resource Lifecycle
--------------------------------------------------------------------------------

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        -- Graceful shutdown of queue
        for _, player in ipairs(QueueState.playerQueue) do
            if player.deferrals then
                player.deferrals.done("Queue system is restarting")
            end
        end
        DebugPrint("Queue system stopped")
    end
end)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        DebugPrint("Queue system started")
        
        -- Backwards compatibility
        ig.queue.Join = ig.queue.HandleConnection
    end
end)

DebugPrint("^2Queue system module loaded^7")
