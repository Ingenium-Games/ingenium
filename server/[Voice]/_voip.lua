-- ====================================================================================--
-- Ingenium VOIP - Server-Side Voice Management
-- ====================================================================================--
ig.voip = ig.voip or {}
ig.voip.server = {}
-- ====================================================================================--

--- Storage for player voice data
---@type table<number, table> Player voice data indexed by server ID
local playerVoiceData = {}

--- Storage for active radio channels
---@type table<number, table> Active radio channels and their members
local radioChannels = {}

--- Storage for active calls
---@type table<number, table> Active calls indexed by server ID
local activeCalls = {}

--- Storage for active connections
---@type table<number, table> Active connections indexed by server ID
local activeConnections = {}

--- Storage for active admin calls
---@type table<number, table> Active admin calls indexed by admin server ID
local adminCalls = {}

--- Grid storage for proximity voice
---@type table<string, table> Players in each grid cell
local voiceGrid = {}

-- ====================================================================================--
-- Player Voice Data Management
-- ====================================================================================--

--- Initialize voice data for a player
---@param playerId number The server ID of the player
function ig.voip.server.InitializePlayer(playerId)
    if not playerId then
        return
    end
    
    local player = Player(playerId)
    if not player then
        return
    end
    
    -- Initialize player voice data (internal tracking)
    playerVoiceData[playerId] = {
        voiceMode = conf.voip.defaultMode or 2,
        radioChannel = 0,
        radioTransmitting = false,
        inCall = false,
        callTarget = nil,
        inConnection = false,
        connectionId = nil,
        inAdminCall = false,
        adminCallSource = nil,
        isTalking = false,
        gridX = 0,
        gridY = 0
    }
    
    -- Note: Player class now handles statebag initialization during character creation
    -- The statebags are already set via xPlayer methods when character is loaded
    -- We only need to ensure they have defaults if not already set
    
    ig.voip.Debug(("Initialized voice for player %d"):format(playerId))
end

--- Cleanup voice data for a player
---@param playerId number The server ID of the player
function ig.voip.server.CleanupPlayer(playerId)
    if not playerId then
        return
    end
    
    -- Remove from radio channel
    if playerVoiceData[playerId] and playerVoiceData[playerId].radioChannel > 0 then
        ig.voip.server.LeaveRadioChannel(playerId, playerVoiceData[playerId].radioChannel)
    end
    
    -- End any active calls
    if playerVoiceData[playerId] and playerVoiceData[playerId].inCall then
        ig.voip.server.EndCall(playerId)
    end
    
    -- End any active connections
    if playerVoiceData[playerId] and playerVoiceData[playerId].inConnection then
        ig.voip.server.EndConnection(playerId)
    end
    
    -- End any admin calls
    if adminCalls[playerId] then
        ig.voip.server.EndAdminCall(playerId)
    end
    
    -- Remove from grid
    ig.voip.server.RemoveFromGrid(playerId)
    
    -- Clear player data
    playerVoiceData[playerId] = nil
    
    ig.voip.Debug(("Cleaned up voice for player %d"):format(playerId))
end

-- ====================================================================================--
-- Voice Mode Management
-- ====================================================================================--

--- Set player's voice mode
---@param playerId number The server ID of the player
---@param modeIndex number The voice mode index (1-based)
function ig.voip.server.SetVoiceMode(playerId, modeIndex)
    if not playerId or not playerVoiceData[playerId] then
        return
    end
    
    local mode = ig.voip.GetVoiceMode(modeIndex)
    if not mode then
        return
    end
    
    -- Try to get xPlayer first (if character is loaded)
    local xPlayer = ig.data.GetPlayer(playerId)
    if xPlayer then
        -- Use player class method
        xPlayer.SetVoiceMode(modeIndex)
    else
        -- Fallback to direct state setting if xPlayer not available
        local player = Player(playerId)
        if player then
            player.state:set("VoiceMode", modeIndex, true)
            player.state:set("VoiceDistance", mode.distance, true)
        end
    end
    
    playerVoiceData[playerId].voiceMode = modeIndex
    
    ig.voip.Debug(("Player %d set voice mode to %d (%s)"):format(playerId, modeIndex, mode.name))
end

--- Get player's current voice mode
---@param playerId number The server ID of the player
---@return number|nil The voice mode index or nil
function ig.voip.server.GetVoiceMode(playerId)
    if not playerId or not playerVoiceData[playerId] then
        return nil
    end
    return playerVoiceData[playerId].voiceMode
end

-- ====================================================================================--
-- Radio System
-- Note: Radio channels work ACROSS routing buckets by design. This allows dispatch,
-- emergency services, and other systems to communicate regardless of instance.
-- If routing bucket isolation for radio is desired, implement filtering at the 
-- client-side voice target level.
-- ====================================================================================--

--- Join a radio channel
---@param playerId number The server ID of the player
---@param channel number The radio channel number
---@return boolean True if successfully joined
function ig.voip.server.JoinRadioChannel(playerId, channel)
    if not playerId or not playerVoiceData[playerId] then
        return false
    end
    
    if not ig.voip.IsValidRadioChannel(channel) then
        return false
    end
    
    -- Leave current channel if in one (handle directly to avoid recursion)
    local currentChannel = playerVoiceData[playerId].radioChannel
    if currentChannel > 0 then
        -- Remove from current channel
        if radioChannels[currentChannel] then
            radioChannels[currentChannel][playerId] = nil
            
            -- Remove empty channels
            if next(radioChannels[currentChannel]) == nil then
                radioChannels[currentChannel] = nil
            end
        end
    end
    
    -- Initialize channel if doesn't exist
    if not radioChannels[channel] then
        radioChannels[channel] = {}
    end
    
    -- Add player to channel
    radioChannels[channel][playerId] = true
    playerVoiceData[playerId].radioChannel = channel
    
    -- Use xPlayer method if available
    local xPlayer = ig.data.GetPlayer(playerId)
    if xPlayer then
        xPlayer.SetRadioFrequency(channel)
    else
        local player = Player(playerId)
        if player then
            player.state:set("RadioFrequency", channel, true)
        end
    end
    
    ig.voip.Debug(("Player %d joined radio channel %d"):format(playerId, channel))
    return true
end

--- Leave a radio channel
---@param playerId number The server ID of the player
---@param channel number The radio channel number
function ig.voip.server.LeaveRadioChannel(playerId, channel)
    if not playerId or not playerVoiceData[playerId] then
        return
    end
    
    if radioChannels[channel] then
        radioChannels[channel][playerId] = nil
        
        -- Remove empty channels
        if next(radioChannels[channel]) == nil then
            radioChannels[channel] = nil
        end
    end
    
    playerVoiceData[playerId].radioChannel = 0
    playerVoiceData[playerId].radioTransmitting = false
    
    -- Use xPlayer methods if available
    local xPlayer = ig.data.GetPlayer(playerId)
    if xPlayer then
        xPlayer.SetRadioFrequency(0)
        xPlayer.SetRadioTransmitting(false)
    else
        local player = Player(playerId)
        if player then
            player.state:set("RadioFrequency", 0, true)
            player.state:set("RadioTransmitting", false, true)
        end
    end
    
    ig.voip.Debug(("Player %d left radio channel %d"):format(playerId, channel))
end

--- Set radio transmitting state
---@param playerId number The server ID of the player
---@param transmitting boolean Whether the player is transmitting
function ig.voip.server.SetRadioTransmitting(playerId, transmitting)
    if not playerId or not playerVoiceData[playerId] then
        return
    end
    
    playerVoiceData[playerId].radioTransmitting = transmitting
    
    -- Use xPlayer method if available
    local xPlayer = ig.data.GetPlayer(playerId)
    if xPlayer then
        xPlayer.SetRadioTransmitting(transmitting)
    else
        local player = Player(playerId)
        if player then
            player.state:set("RadioTransmitting", transmitting, true)
        end
    end
end

-- ====================================================================================--
-- Call System
-- Note: Phone calls work ACROSS routing buckets by design. This allows players to
-- communicate via phone regardless of their physical location or instance.
-- ====================================================================================--

--- Start a call between two players
---@param callerId number The server ID of the caller
---@param targetId number The server ID of the target
---@return boolean True if call was successfully started
function ig.voip.server.StartCall(callerId, targetId)
    if not callerId or not targetId then
        return false
    end
    
    if not playerVoiceData[callerId] or not playerVoiceData[targetId] then
        return false
    end
    
    -- Check if either player is already in a call
    if playerVoiceData[callerId].inCall or playerVoiceData[targetId].inCall then
        return false
    end
    
    -- Set call state for both players
    activeCalls[callerId] = {target = targetId, startTime = os.time()}
    activeCalls[targetId] = {target = callerId, startTime = os.time()}
    
    playerVoiceData[callerId].inCall = true
    playerVoiceData[callerId].callTarget = targetId
    playerVoiceData[targetId].inCall = true
    playerVoiceData[targetId].callTarget = callerId
    
    -- Update statebags using xPlayer methods if available
    local xCaller = ig.data.GetPlayer(callerId)
    local xTarget = ig.data.GetPlayer(targetId)
    
    if xCaller then
        xCaller.SetInCall(true)
        xCaller.SetCallActive(true)
    else
        local caller = Player(callerId)
        if caller then
            caller.state:set("InCall", true, true)
            caller.state:set("CallActive", true, true)
        end
    end
    
    if xTarget then
        xTarget.SetInCall(true)
        xTarget.SetCallActive(true)
    else
        local target = Player(targetId)
        if target then
            target.state:set("InCall", true, true)
            target.state:set("CallActive", true, true)
        end
    end
    
    ig.voip.Debug(("Call started between player %d and %d"):format(callerId, targetId))
    return true
end

--- End a call for a player
---@param playerId number The server ID of the player
function ig.voip.server.EndCall(playerId)
    if not playerId or not playerVoiceData[playerId] then
        return
    end
    
    local targetId = playerVoiceData[playerId].callTarget
    
    -- Clear caller's call state
    activeCalls[playerId] = nil
    playerVoiceData[playerId].inCall = false
    playerVoiceData[playerId].callTarget = nil
    
    local xPlayer = ig.data.GetPlayer(playerId)
    if xPlayer then
        xPlayer.SetInCall(false)
        xPlayer.SetCallActive(false)
    else
        local player = Player(playerId)
        if player then
            player.state:set("InCall", false, true)
            player.state:set("CallActive", false, true)
        end
    end
    
    -- Clear target's call state if exists
    if targetId and playerVoiceData[targetId] then
        activeCalls[targetId] = nil
        playerVoiceData[targetId].inCall = false
        playerVoiceData[targetId].callTarget = nil
        
        local xTarget = ig.data.GetPlayer(targetId)
        if xTarget then
            xTarget.SetInCall(false)
            xTarget.SetCallActive(false)
        else
            local target = Player(targetId)
            if target then
                target.state:set("InCall", false, true)
                target.state:set("CallActive", false, true)
            end
        end
    end
    
    ig.voip.Debug(("Call ended for player %d"):format(playerId))
end

-- ====================================================================================--
-- Connection System
-- ====================================================================================--

--- Start a web connection for a player
---@param playerId number The server ID of the player
---@param connectionId string The unique connection ID
---@return boolean True if connection was successfully started
function ig.voip.server.StartConnection(playerId, connectionId)
    if not playerId or not playerVoiceData[playerId] then
        return false
    end
    
    if not connectionId then
        return false
    end
    
    activeConnections[playerId] = {
        connectionId = connectionId,
        startTime = os.time()
    }
    
    playerVoiceData[playerId].inConnection = true
    playerVoiceData[playerId].connectionId = connectionId
    
    local xPlayer = ig.data.GetPlayer(playerId)
    if xPlayer then
        xPlayer.SetInConnection(true)
        xPlayer.SetConnectionActive(true)
    else
        local player = Player(playerId)
        if player then
            player.state:set("InConnection", true, true)
            player.state:set("ConnectionActive", true, true)
        end
    end
    
    ig.voip.Debug(("Connection started for player %d (ID: %s)"):format(playerId, connectionId))
    return true
end

--- End a web connection for a player
---@param playerId number The server ID of the player
function ig.voip.server.EndConnection(playerId)
    if not playerId or not playerVoiceData[playerId] then
        return
    end
    
    activeConnections[playerId] = nil
    playerVoiceData[playerId].inConnection = false
    playerVoiceData[playerId].connectionId = nil
    
    local xPlayer = ig.data.GetPlayer(playerId)
    if xPlayer then
        xPlayer.SetInConnection(false)
        xPlayer.SetConnectionActive(false)
    else
        local player = Player(playerId)
        if player then
            player.state:set("InConnection", false, true)
            player.state:set("ConnectionActive", false, true)
        end
    end
    
    ig.voip.Debug(("Connection ended for player %d"):format(playerId))
end

-- ====================================================================================--
-- Admin Call System (Permission-gated)
-- Note: Admin calls work ACROSS routing buckets by design. This allows administrators
-- to communicate with players regardless of their instance for support purposes.
-- ====================================================================================--

--- Start an admin call to a target player
---@param adminId number The server ID of the admin
---@param targetId number The server ID of the target player
---@return boolean True if admin call was successfully started
function ig.voip.server.StartAdminCall(adminId, targetId)
    if not adminId or not targetId then
        return false
    end
    
    -- Check if admin has permission
    if not IsPlayerAceAllowed(adminId, conf.voip.adminCallAce) then
        ig.voip.Debug(("Player %d attempted admin call without permission"):format(adminId))
        return false
    end
    
    if not playerVoiceData[adminId] or not playerVoiceData[targetId] then
        return false
    end
    
    -- Initialize admin call
    if not adminCalls[adminId] then
        adminCalls[adminId] = {}
    end
    
    adminCalls[adminId][targetId] = {
        startTime = os.time()
    }
    
    playerVoiceData[targetId].inAdminCall = true
    playerVoiceData[targetId].adminCallSource = adminId
    
    -- Update target's statebag using xPlayer method (server-only, permission checked)
    local xTarget = ig.data.GetPlayer(targetId)
    if xTarget then
        xTarget.SetInAdminCall(true, adminId)
    else
        local target = Player(targetId)
        if target then
            target.state:set("InAdminCall", true, true)
        end
    end
    
    ig.voip.Debug(("Admin call started from %d to %d"):format(adminId, targetId))
    return true
end

--- End an admin call
---@param adminId number The server ID of the admin
---@param targetId number|nil The server ID of the target (if nil, ends all admin calls from this admin)
function ig.voip.server.EndAdminCall(adminId, targetId)
    if not adminId then
        return
    end
    
    if not adminCalls[adminId] then
        return
    end
    
    -- End specific target or all targets
    if targetId then
        if adminCalls[adminId][targetId] then
            adminCalls[adminId][targetId] = nil
            
            if playerVoiceData[targetId] then
                playerVoiceData[targetId].inAdminCall = false
                playerVoiceData[targetId].adminCallSource = nil
                
                local xTarget = ig.data.GetPlayer(targetId)
                if xTarget then
                    xTarget.SetInAdminCall(false, adminId)
                else
                    local target = Player(targetId)
                    if target then
                        target.state:set("InAdminCall", false, true)
                    end
                end
            end
        end
    else
        -- End all admin calls from this admin
        for tgtId, _ in pairs(adminCalls[adminId]) do
            if playerVoiceData[tgtId] then
                playerVoiceData[tgtId].inAdminCall = false
                playerVoiceData[tgtId].adminCallSource = nil
                
                local xTarget = ig.data.GetPlayer(tgtId)
                if xTarget then
                    xTarget.SetInAdminCall(false, adminId)
                else
                    local target = Player(tgtId)
                    if target then
                        target.state:set("InAdminCall", false, true)
                    end
                end
            end
        end
        adminCalls[adminId] = nil
    end
    
    ig.voip.Debug(("Admin call ended from %d"):format(adminId))
end

-- ====================================================================================--
-- Grid System for Proximity Voice
-- ====================================================================================--

--- Update player's position in the voice grid
---@param playerId number The server ID of the player
---@param x number The X coordinate
---@param y number The Y coordinate
function ig.voip.server.UpdateGrid(playerId, x, y)
    if not playerId or not playerVoiceData[playerId] then
        return
    end
    
    local gridX, gridY = ig.voip.GetGridCell(x, y)
    local oldGridX = playerVoiceData[playerId].gridX
    local oldGridY = playerVoiceData[playerId].gridY
    
    -- Only update if grid cell changed
    if gridX ~= oldGridX or gridY ~= oldGridY then
        -- Remove from old cell
        local oldKey = ("%d,%d"):format(oldGridX, oldGridY)
        if voiceGrid[oldKey] then
            voiceGrid[oldKey][playerId] = nil
            if next(voiceGrid[oldKey]) == nil then
                voiceGrid[oldKey] = nil
            end
        end
        
        -- Add to new cell
        local newKey = ("%d,%d"):format(gridX, gridY)
        if not voiceGrid[newKey] then
            voiceGrid[newKey] = {}
        end
        voiceGrid[newKey][playerId] = true
        
        playerVoiceData[playerId].gridX = gridX
        playerVoiceData[playerId].gridY = gridY
    end
end

--- Remove player from grid
---@param playerId number The server ID of the player
function ig.voip.server.RemoveFromGrid(playerId)
    if not playerId or not playerVoiceData[playerId] then
        return
    end
    
    local gridX = playerVoiceData[playerId].gridX
    local gridY = playerVoiceData[playerId].gridY
    local key = ("%d,%d"):format(gridX, gridY)
    
    if voiceGrid[key] then
        voiceGrid[key][playerId] = nil
        if next(voiceGrid[key]) == nil then
            voiceGrid[key] = nil
        end
    end
end

--- Check if two players are in the same routing bucket
---@param playerId number The first player's server ID
---@param otherPlayerId number The second player's server ID
---@return boolean True if players are in the same bucket or routing bucket isolation is disabled
local function IsInSameRoutingBucket(playerId, otherPlayerId)
    if not conf.voip.routingBucketIsolation then
        return true
    end
    
    local playerBucket = GetPlayerRoutingBucket(playerId)
    local otherBucket = GetPlayerRoutingBucket(otherPlayerId)
    
    return playerBucket == otherBucket
end

--- Get players in proximity
---@param playerId number The server ID of the player
---@param distance number The maximum distance
---@return table Array of player server IDs in proximity
function ig.voip.server.GetPlayersInProximity(playerId, distance)
    if not playerId or not playerVoiceData[playerId] then
        return {}
    end
    
    local ped = GetPlayerPed(playerId)
    if not ped or ped == 0 then
        return {}
    end
    
    local coords = GetEntityCoords(ped)
    local playersInProximity = {}
    
    if conf.voip.useGrid then
        -- Use grid-based search
        local gridX = playerVoiceData[playerId].gridX
        local gridY = playerVoiceData[playerId].gridY
        local cells = ig.voip.GetSurroundingGridCells(gridX, gridY)
        
        for _, cell in ipairs(cells) do
            local key = ("%d,%d"):format(cell.x, cell.y)
            if voiceGrid[key] then
                for otherPlayerId, _ in pairs(voiceGrid[key]) do
                    if otherPlayerId ~= playerId then
                        -- Check routing bucket isolation on server-side
                        if not IsInSameRoutingBucket(playerId, otherPlayerId) then
                            goto continue_grid
                        end
                        
                        local otherPed = GetPlayerPed(otherPlayerId)
                        if otherPed and otherPed ~= 0 then
                            local otherCoords = GetEntityCoords(otherPed)
                            local dist = #(coords - otherCoords)
                            if dist <= distance then
                                table.insert(playersInProximity, otherPlayerId)
                            end
                        end
                        
                        ::continue_grid::
                    end
                end
            end
        end
    else
        -- Brute force search (less efficient)
        local allPlayers = GetPlayers()
        for _, otherPlayerId in ipairs(allPlayers) do
            local otherId = tonumber(otherPlayerId)
            if otherId and otherId ~= playerId then
                -- Check routing bucket isolation on server-side
                if not IsInSameRoutingBucket(playerId, otherId) then
                    goto continue_brute
                end
                
                local otherPed = GetPlayerPed(otherId)
                if otherPed and otherPed ~= 0 then
                    local otherCoords = GetEntityCoords(otherPed)
                    local dist = #(coords - otherCoords)
                    if dist <= distance then
                        table.insert(playersInProximity, otherId)
                    end
                end
                
                ::continue_brute::
            end
        end
    end
    
    return playersInProximity
end

-- ====================================================================================--
-- Event Handlers
-- ====================================================================================--

--- Handle character ready (after character is fully loaded)
---@description Initialize VOIP only after character is ready, not on initial connection
AddEventHandler("Server:Character:Ready", function()
    local playerId = source
    -- Initialize VOIP for this player now that character is ready
    ig.voip.server.InitializePlayer(playerId)
    
    -- Get xPlayer and set initial voice mode
    local xPlayer = ig.data.GetPlayer(playerId)
    if xPlayer then
        -- Set default voice mode using player class method
        xPlayer.SetVoiceMode(conf.voip.defaultMode or 2)
    end
end)

--- Handle player character switch (cleanup old VOIP state)
AddEventHandler("Server:Character:Switch", function(playerId)
    local src = playerId or source
    -- Clean up VOIP state when switching characters
    ig.voip.server.CleanupPlayer(src)
end)

--- Handle player dropping
AddEventHandler("playerDropped", function()
    local playerId = source
    -- Clean up all VOIP state on disconnect
    ig.voip.server.CleanupPlayer(playerId)
end)

-- ====================================================================================--
-- Exports
-- ====================================================================================--

--- Export: Initialize player voice
---@param playerId number The server ID of the player
exports("VoiceInitializePlayer", function(playerId)
    ig.voip.server.InitializePlayer(playerId)
end)

--- Export: Set voice mode
---@param playerId number The server ID of the player
---@param modeIndex number The voice mode index
exports("VoiceSetMode", function(playerId, modeIndex)
    ig.voip.server.SetVoiceMode(playerId, modeIndex)
end)

--- Export: Join radio channel
---@param playerId number The server ID of the player
---@param channel number The radio channel
exports("VoiceJoinRadio", function(playerId, channel)
    return ig.voip.server.JoinRadioChannel(playerId, channel)
end)

--- Export: Leave radio channel
---@param playerId number The server ID of the player
---@param channel number The radio channel
exports("VoiceLeaveRadio", function(playerId, channel)
    ig.voip.server.LeaveRadioChannel(playerId, channel)
end)

--- Export: Start call
---@param callerId number The caller's server ID
---@param targetId number The target's server ID
exports("VoiceStartCall", function(callerId, targetId)
    return ig.voip.server.StartCall(callerId, targetId)
end)

--- Export: End call
---@param playerId number The server ID of the player
exports("VoiceEndCall", function(playerId)
    ig.voip.server.EndCall(playerId)
end)

--- Export: Start connection
---@param playerId number The server ID of the player
---@param connectionId string The connection ID
exports("VoiceStartConnection", function(playerId, connectionId)
    return ig.voip.server.StartConnection(playerId, connectionId)
end)

--- Export: End connection
---@param playerId number The server ID of the player
exports("VoiceEndConnection", function(playerId)
    ig.voip.server.EndConnection(playerId)
end)

--- Export: Start admin call
---@param adminId number The admin's server ID
---@param targetId number The target's server ID
exports("VoiceStartAdminCall", function(adminId, targetId)
    return ig.voip.server.StartAdminCall(adminId, targetId)
end)

--- Export: End admin call
---@param adminId number The admin's server ID
---@param targetId number|nil The target's server ID (nil to end all)
exports("VoiceEndAdminCall", function(adminId, targetId)
    ig.voip.server.EndAdminCall(adminId, targetId)
end)

-- ====================================================================================--
ig.log.Info("Ingenium VOIP", "Server-side voice system initialized")
-- ====================================================================================--
