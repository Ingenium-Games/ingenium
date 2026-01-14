-- ====================================================================================--
-- Ingenium VOIP - Client-Side Voice Management
-- ====================================================================================--
ig.voip = ig.voip or {}
ig.voip.client = {}
-- ====================================================================================--

--- Local player voice state
local localVoiceState = {
    voiceMode = conf.voip.defaultMode or 2,
    voiceDistance = 8.0,
    isTalking = false,
    radioChannel = 0,
    radioTransmitting = false,
    inCall = false,
    callTarget = nil,
    inConnection = false,
    connectionId = nil,
    inAdminCall = false,
    adminCallSource = nil,
    voiceTargets = {},
    lastUpdate = 0
}

--- Voice channel IDs for MumbleSetVoiceChannel
local VOICE_CHANNEL = {
    PROXIMITY = 1,
    RADIO = 2,
    CALL = 3,
    CONNECTION = 4,
    ADMIN = 5
}

-- ====================================================================================--
-- Mumble/Voice Natives Management
-- ====================================================================================--

--- Initialize Mumble voice system
function ig.voip.client.InitializeMumble()
    -- Enable Mumble voice
    MumbleSetActive(true)
    
    -- Set voice volume
    MumbleSetVoiceVolume(1.0)
    
    -- Clear all voice targets initially
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.PROXIMITY)
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.RADIO)
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.CALL)
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.CONNECTION)
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.ADMIN)
    
    -- Set default channel to proximity
    MumbleSetVoiceChannel(VOICE_CHANNEL.PROXIMITY)
    
    -- Configure audio settings
    if conf.voip.audio3D then
        MumbleSetAudioInputDistance(localVoiceState.voiceDistance)
    end
    
    ig.voip.Debug("Mumble voice system initialized")
end

--- Update voice targets for proximity voice
function ig.voip.client.UpdateProximityTargets()
    local playerId = PlayerId()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local mode = ig.voip.GetVoiceMode(localVoiceState.voiceMode)
    
    if not mode then
        return
    end
    
    local maxDistance = mode.distance
    local targets = {}
    
    -- Get all players
    local allPlayers = GetActivePlayers()
    
    for _, otherPlayer in ipairs(allPlayers) do
        if otherPlayer ~= playerId then
            local otherPed = GetPlayerPed(otherPlayer)
            if otherPed and DoesEntityExist(otherPed) then
                local otherCoords = GetEntityCoords(otherPed)
                local distance = #(playerCoords - otherCoords)
                
                -- Check if within voice range
                if distance <= maxDistance then
                    local otherServerId = GetPlayerServerId(otherPlayer)
                    
                    -- Check routing bucket isolation
                    if conf.voip.routingBucketIsolation then
                        local myBucket = GetPlayerRoutingBucket(playerId)
                        local otherBucket = GetPlayerRoutingBucket(otherPlayer)
                        if myBucket ~= otherBucket then
                            goto continue
                        end
                    end
                    
                    -- Apply distance-based volume
                    local volume = 1.0
                    if distance > maxDistance - conf.voip.fadeDistance then
                        -- Fade out at edge of range
                        local fadeRatio = (maxDistance - distance) / conf.voip.fadeDistance
                        volume = fadeRatio
                    end
                    
                    -- Apply vehicle muffling
                    if conf.voip.vehicleMuffling then
                        local myVehicle = GetVehiclePedIsIn(playerPed, false)
                        local otherVehicle = GetVehiclePedIsIn(otherPed, false)
                        
                        if myVehicle ~= 0 and otherVehicle ~= 0 and myVehicle ~= otherVehicle then
                            -- Both in different vehicles - muffle
                            volume = volume * 0.4
                        elseif (myVehicle ~= 0 and otherVehicle == 0) or (myVehicle == 0 and otherVehicle ~= 0) then
                            -- One in vehicle, one not - partial muffle
                            volume = volume * 0.6
                        end
                    end
                    
                    -- Apply building muffling (simplified)
                    if conf.voip.buildingMuffling then
                        local myInterior = GetInteriorFromEntity(playerPed)
                        local otherInterior = GetInteriorFromEntity(otherPed)
                        
                        if myInterior ~= otherInterior and (myInterior ~= 0 or otherInterior ~= 0) then
                            -- Different interiors or one inside/one outside
                            volume = volume * 0.3
                        end
                    end
                    
                    table.insert(targets, {
                        serverId = otherServerId,
                        volume = volume
                    })
                end
                
                ::continue::
            end
        end
    end
    
    -- Update Mumble voice targets
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.PROXIMITY)
    for _, target in ipairs(targets) do
        MumbleAddVoiceTargetPlayerByServerId(VOICE_CHANNEL.PROXIMITY, target.serverId)
        -- Note: Volume per-player is not supported in all FiveM versions
        -- May need to use overall volume instead
    end
    
    localVoiceState.voiceTargets = targets
end

--- Update voice targets for radio
function ig.voip.client.UpdateRadioTargets()
    if localVoiceState.radioChannel <= 0 then
        MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.RADIO)
        return
    end
    
    -- Radio targets are managed server-side and communicated via statebags
    -- For now, we'll use a simple implementation
    -- In a full implementation, the server would track radio channel members
    -- and communicate them to clients
    
    ig.voip.Debug(("Radio channel %d active"):format(localVoiceState.radioChannel))
end

--- Update voice targets for call
function ig.voip.client.UpdateCallTargets()
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.CALL)
    
    if localVoiceState.inCall and localVoiceState.callTarget then
        MumbleAddVoiceTargetPlayerByServerId(VOICE_CHANNEL.CALL, localVoiceState.callTarget)
        ig.voip.Debug(("Call active with player %d"):format(localVoiceState.callTarget))
    end
end

--- Update voice targets for connection
function ig.voip.client.UpdateConnectionTargets()
    -- Connection system would integrate with web-based voice
    -- This is a placeholder for future implementation
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.CONNECTION)
end

--- Update voice targets for admin call
function ig.voip.client.UpdateAdminCallTargets()
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.ADMIN)
    
    if localVoiceState.inAdminCall and localVoiceState.adminCallSource then
        MumbleAddVoiceTargetPlayerByServerId(VOICE_CHANNEL.ADMIN, localVoiceState.adminCallSource)
        ig.voip.Debug(("Admin call active from player %d"):format(localVoiceState.adminCallSource))
    end
end

-- ====================================================================================--
-- Voice Mode Management
-- ====================================================================================--

--- Set voice mode
---@param modeIndex number The voice mode index (1-based)
function ig.voip.client.SetVoiceMode(modeIndex)
    local mode = ig.voip.GetVoiceMode(modeIndex)
    if not mode then
        return
    end
    
    localVoiceState.voiceMode = modeIndex
    localVoiceState.voiceDistance = mode.distance
    
    -- Update local player state
    LocalPlayer.state:set("VoiceMode", modeIndex, true)
    LocalPlayer.state:set("VoiceDistance", mode.distance, true)
    
    -- Update audio distance
    if conf.voip.audio3D then
        MumbleSetAudioInputDistance(mode.distance)
    end
    
    ig.voip.Debug(("Voice mode set to %d (%s, %.1fm)"):format(modeIndex, mode.name, mode.distance))
    
    -- Trigger event for UI updates
    TriggerEvent("ingenium:voip:modeChanged", modeIndex, mode)
end

--- Cycle to next voice mode
function ig.voip.client.NextVoiceMode()
    local nextMode = ig.voip.GetNextVoiceMode(localVoiceState.voiceMode)
    ig.voip.client.SetVoiceMode(nextMode)
end

--- Cycle to previous voice mode
function ig.voip.client.PreviousVoiceMode()
    local prevMode = ig.voip.GetPreviousVoiceMode(localVoiceState.voiceMode)
    ig.voip.client.SetVoiceMode(prevMode)
end

--- Get current voice mode
---@return number The current voice mode index
function ig.voip.client.GetVoiceMode()
    return localVoiceState.voiceMode
end

-- ====================================================================================--
-- Radio System
-- ====================================================================================--

--- Join radio channel
---@param channel number The radio channel number
function ig.voip.client.JoinRadioChannel(channel)
    if not ig.voip.IsValidRadioChannel(channel) then
        ig.voip.Debug(("Invalid radio channel: %d"):format(channel))
        return
    end
    
    localVoiceState.radioChannel = channel
    LocalPlayer.state:set("RadioFrequency", channel, true)
    
    ig.voip.Debug(("Joined radio channel %d"):format(channel))
    TriggerEvent("ingenium:voip:radioJoined", channel)
end

--- Leave radio channel
function ig.voip.client.LeaveRadioChannel()
    local oldChannel = localVoiceState.radioChannel
    localVoiceState.radioChannel = 0
    localVoiceState.radioTransmitting = false
    
    LocalPlayer.state:set("RadioFrequency", 0, true)
    LocalPlayer.state:set("RadioTransmitting", false, true)
    
    MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.RADIO)
    
    ig.voip.Debug(("Left radio channel %d"):format(oldChannel))
    TriggerEvent("ingenium:voip:radioLeft", oldChannel)
end

--- Set radio transmitting state
---@param transmitting boolean Whether transmitting
function ig.voip.client.SetRadioTransmitting(transmitting)
    if localVoiceState.radioChannel <= 0 then
        return
    end
    
    localVoiceState.radioTransmitting = transmitting
    LocalPlayer.state:set("RadioTransmitting", transmitting, true)
    
    -- Switch to radio channel when transmitting
    if transmitting then
        MumbleSetVoiceChannel(VOICE_CHANNEL.RADIO)
    else
        MumbleSetVoiceChannel(VOICE_CHANNEL.PROXIMITY)
    end
    
    TriggerEvent("ingenium:voip:radioTransmit", transmitting)
end

-- ====================================================================================--
-- Call System
-- ====================================================================================--

--- Handle call state change (from statebag)
---@param inCall boolean Whether in call
function ig.voip.client.HandleCallStateChange(inCall)
    localVoiceState.inCall = inCall
    
    if inCall then
        -- Get call target from statebag
        local callTarget = LocalPlayer.state.CallTarget
        if callTarget then
            localVoiceState.callTarget = callTarget
            ig.voip.client.UpdateCallTargets()
            
            -- Switch to call channel
            MumbleSetVoiceChannel(VOICE_CHANNEL.CALL)
        end
    else
        localVoiceState.callTarget = nil
        MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.CALL)
        
        -- Switch back to proximity
        MumbleSetVoiceChannel(VOICE_CHANNEL.PROXIMITY)
    end
    
    TriggerEvent("ingenium:voip:callStateChanged", inCall)
end

-- ====================================================================================--
-- Connection System
-- ====================================================================================--

--- Handle connection state change (from statebag)
---@param inConnection boolean Whether in connection
function ig.voip.client.HandleConnectionStateChange(inConnection)
    localVoiceState.inConnection = inConnection
    
    if inConnection then
        local connectionId = LocalPlayer.state.ConnectionId
        if connectionId then
            localVoiceState.connectionId = connectionId
            ig.voip.client.UpdateConnectionTargets()
        end
    else
        localVoiceState.connectionId = nil
        MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.CONNECTION)
    end
    
    TriggerEvent("ingenium:voip:connectionStateChanged", inConnection)
end

-- ====================================================================================--
-- Admin Call System
-- ====================================================================================--

--- Handle admin call state change (from statebag)
---@param inAdminCall boolean Whether in admin call
function ig.voip.client.HandleAdminCallStateChange(inAdminCall)
    localVoiceState.inAdminCall = inAdminCall
    
    if inAdminCall then
        -- Admin calls are always audible, prioritize them
        local adminSource = LocalPlayer.state.AdminCallSource
        if adminSource then
            localVoiceState.adminCallSource = adminSource
            ig.voip.client.UpdateAdminCallTargets()
            
            -- Admin calls use a separate channel for priority
            MumbleSetVoiceChannel(VOICE_CHANNEL.ADMIN)
        end
    else
        localVoiceState.adminCallSource = nil
        MumbleClearVoiceTargetPlayers(VOICE_CHANNEL.ADMIN)
        
        -- Switch back to proximity or current active channel
        if localVoiceState.inCall then
            MumbleSetVoiceChannel(VOICE_CHANNEL.CALL)
        else
            MumbleSetVoiceChannel(VOICE_CHANNEL.PROXIMITY)
        end
    end
    
    TriggerEvent("ingenium:voip:adminCallStateChanged", inAdminCall)
end

-- ====================================================================================--
-- Talking Indicator
-- ====================================================================================--

--- Check if local player is talking
---@return boolean True if talking
function ig.voip.client.IsTalking()
    return NetworkIsPlayerTalking(PlayerId())
end

--- Update talking state
function ig.voip.client.UpdateTalkingState()
    local talking = ig.voip.client.IsTalking()
    
    if talking ~= localVoiceState.isTalking then
        localVoiceState.isTalking = talking
        LocalPlayer.state:set("IsTalking", talking, true)
        TriggerEvent("ingenium:voip:talkingStateChanged", talking)
    end
end

-- ====================================================================================--
-- Main Update Thread
-- ====================================================================================--

--- Main VOIP update thread
Citizen.CreateThread(function()
    -- Wait for player to load
    while not NetworkIsPlayerActive(PlayerId()) do
        Citizen.Wait(100)
    end
    
    -- Initialize Mumble
    ig.voip.client.InitializeMumble()
    
    -- Set initial voice mode
    ig.voip.client.SetVoiceMode(conf.voip.defaultMode or 2)
    
    -- Main update loop
    while true do
        local currentTime = GetGameTimer()
        
        -- Update at configured rate
        if currentTime - localVoiceState.lastUpdate >= conf.voip.updateRate then
            localVoiceState.lastUpdate = currentTime
            
            -- Update proximity targets
            ig.voip.client.UpdateProximityTargets()
            
            -- Update talking state
            ig.voip.client.UpdateTalkingState()
        end
        
        Citizen.Wait(100) -- Check every 100ms, but only update targets at configured rate
    end
end)

-- ====================================================================================--
-- Key Bindings
-- ====================================================================================--

--- Register voice range key binding
if conf.voip.rangeKey then
    RegisterCommand("+voiceRange", function()
        ig.voip.client.NextVoiceMode()
    end, false)
    
    RegisterCommand("-voiceRange", function()
        -- Key released
    end, false)
    
    RegisterKeyMapping("+voiceRange", "Cycle Voice Range", "keyboard", conf.voip.rangeKey)
end

-- ====================================================================================--
-- Statebag Change Handlers
-- ====================================================================================--

--- Listen for InCall state changes
AddStateBagChangeHandler("InCall", ("player:%d"):format(GetPlayerServerId(PlayerId())), function(bagName, key, value, reserved, replicated)
    ig.voip.client.HandleCallStateChange(value)
end)

--- Listen for InConnection state changes
AddStateBagChangeHandler("InConnection", ("player:%d"):format(GetPlayerServerId(PlayerId())), function(bagName, key, value, reserved, replicated)
    ig.voip.client.HandleConnectionStateChange(value)
end)

--- Listen for InAdminCall state changes
AddStateBagChangeHandler("InAdminCall", ("player:%d"):format(GetPlayerServerId(PlayerId())), function(bagName, key, value, reserved, replicated)
    ig.voip.client.HandleAdminCallStateChange(value)
end)

-- ====================================================================================--
-- Exports
-- ====================================================================================--

--- Export: Get current voice mode
exports("VoiceGetMode", function()
    return ig.voip.client.GetVoiceMode()
end)

--- Export: Set voice mode
---@param modeIndex number The voice mode index
exports("VoiceSetMode", function(modeIndex)
    ig.voip.client.SetVoiceMode(modeIndex)
end)

--- Export: Cycle voice mode
exports("VoiceNextMode", function()
    ig.voip.client.NextVoiceMode()
end)

--- Export: Join radio channel
---@param channel number The radio channel
exports("VoiceJoinRadio", function(channel)
    ig.voip.client.JoinRadioChannel(channel)
end)

--- Export: Leave radio channel
exports("VoiceLeaveRadio", function()
    ig.voip.client.LeaveRadioChannel()
end)

--- Export: Set radio transmitting
---@param transmitting boolean Whether transmitting
exports("VoiceSetRadioTransmit", function(transmitting)
    ig.voip.client.SetRadioTransmitting(transmitting)
end)

--- Export: Check if talking
exports("VoiceIsTalking", function()
    return ig.voip.client.IsTalking()
end)

-- ====================================================================================--
if ig and ig.log and ig.log.Info then
    ig.log.Info("Ingenium VOIP", "Client-side voice system initialized")
else
    ig.debug.Info("Client-side voice system initialized")
end
-- ====================================================================================--
