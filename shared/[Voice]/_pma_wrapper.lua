-- ====================================================================================--
-- PMA-Voice Compatibility Wrapper
-- This file provides exports that match pma-voice exports for backward compatibility
-- Allows resources built for pma-voice to work with Ingenium VOIP
-- ====================================================================================--

--- Note: This wrapper maps pma-voice exports to Ingenium VOIP functions
--- Some features may have different implementations but maintain similar behavior

-- ====================================================================================--
-- Client-Side Exports (if client context)
-- ====================================================================================--

if IsDuplicityVersion() == 0 then
    -- Client-side exports
    
    --- Set voice property
    ---@param property string The property name
    ---@param value any The property value
    exports("setVoiceProperty", function(property, value)
        if property == "radioEnabled" then
            if value then
                -- Enable radio (channel 0 means no channel but radio capability exists)
                -- Actual channel joining happens via setRadioChannel
            else
                ig.voip.client.LeaveRadioChannel()
            end
        elseif property == "callVolume" then
            -- Set call volume (Ingenium uses Mumble volume system)
            -- This is handled internally
        elseif property == "radioVolume" then
            -- Set radio volume (handled internally)
        elseif property == "micClicks" then
            -- Microphone click sounds (can be implemented in radio system)
        end
    end)
    
    --- Get voice property
    ---@param property string The property name
    ---@return any The property value
    exports("getVoiceProperty", function(property)
        if property == "radioEnabled" then
            -- Check if in any radio channel
            return LocalPlayer.state.RadioFrequency and LocalPlayer.state.RadioFrequency > 0
        elseif property == "radioChannel" then
            return LocalPlayer.state.RadioFrequency or 0
        elseif property == "voiceMode" then
            return LocalPlayer.state.VoiceMode or conf.voip.defaultMode
        elseif property == "isTalking" then
            return LocalPlayer.state.IsTalking or false
        end
        return nil
    end)
    
    --- Set radio channel
    ---@param channel number The radio channel (0 to disable)
    exports("setRadioChannel", function(channel)
        if channel == 0 or channel == nil then
            ig.voip.client.LeaveRadioChannel()
        else
            ig.voip.client.JoinRadioChannel(channel)
        end
    end)
    
    --- Set call channel
    ---@param channel number The call channel
    exports("setCallChannel", function(channel)
        -- Ingenium uses server-managed calls
        -- This is a simplified wrapper
        if channel == 0 or channel == nil then
            TriggerServerEvent("ingenium:voip:endCall")
        else
            TriggerServerEvent("ingenium:voip:startCall", channel)
        end
    end)
    
    --- Add player to call
    ---@param targetServerId number The target player's server ID
    exports("addPlayerToCall", function(targetServerId)
        TriggerServerEvent("ingenium:voip:startCall", targetServerId)
    end)
    
    --- Remove player from call
    ---@param targetServerId number The target player's server ID
    exports("removePlayerFromCall", function(targetServerId)
        TriggerServerEvent("ingenium:voip:endCall")
    end)
    
    --- Set talking state on radio
    ---@param talking boolean Whether talking
    exports("setRadioTalking", function(talking)
        ig.voip.client.SetRadioTransmitting(talking)
    end)
    
    --- Set talking state on call
    ---@param talking boolean Whether talking
    exports("setCallTalking", function(talking)
        -- Call talking is automatic in Ingenium based on active channel
    end)
    
    --- Set voice target
    ---@param target table|number Target player(s)
    exports("setVoiceTarget", function(target)
        -- Ingenium manages voice targets automatically based on proximity and channels
        -- This is a no-op for compatibility
    end)
    
    --- Get players in radio channel
    ---@return table Array of player server IDs
    exports("getPlayersInRadioChannel", function()
        -- Would require server-side state tracking
        -- Return empty for now as this is typically server-managed
        return {}
    end)
    
    --- Toggle voice range (cycle voice modes)
    exports("toggleVoiceRange", function()
        ig.voip.client.NextVoiceMode()
    end)
    
    --- Set voice range
    ---@param range number The range index
    exports("setVoiceRange", function(range)
        ig.voip.client.SetVoiceMode(range)
    end)
    
    --- Get voice range
    ---@return number The current voice range index
    exports("getVoiceRange", function()
        return ig.voip.client.GetVoiceMode()
    end)
    
    --- Check if player is talking
    ---@return boolean True if talking
    exports("isTalking", function()
        return ig.voip.client.IsTalking()
    end)
    
    --- Clear radio channel
    exports("clearRadioChannel", function()
        ig.voip.client.LeaveRadioChannel()
    end)
    
    --- Remove player from radio
    ---@param targetServerId number The target player's server ID
    exports("removePlayerFromRadio", function(targetServerId)
        -- Server-managed in Ingenium
        TriggerServerEvent("ingenium:voip:removeFromRadio", targetServerId)
    end)
    
    --- Update radio towers (proximity-based radio enhancement)
    ---@param towers table Array of tower positions
    exports("updateRadioTowers", function(towers)
        -- Radio towers feature not implemented in base Ingenium VOIP
        -- Can be added as an enhancement
    end)

end

-- ====================================================================================--
-- Server-Side Exports (if server context)
-- ====================================================================================--

if IsDuplicityVersion() == 1 then
    -- Server-side exports
    
    --- Set player radio channel
    ---@param playerId number The player's server ID
    ---@param channel number The radio channel
    exports("setPlayerRadioChannel", function(playerId, channel)
        if channel == 0 or channel == nil then
            ig.voip.server.LeaveRadioChannel(playerId, ig.voip.server.GetVoiceMode(playerId))
        else
            ig.voip.server.JoinRadioChannel(playerId, channel)
        end
    end)
    
    --- Remove player from radio channel
    ---@param playerId number The player's server ID
    exports("removePlayerFromRadioChannel", function(playerId)
        local currentChannel = ig.voip.server.GetVoiceMode(playerId)
        if currentChannel then
            ig.voip.server.LeaveRadioChannel(playerId, currentChannel)
        end
    end)
    
    --- Set player call channel
    ---@param playerId number The player's server ID
    ---@param targetId number The target player's server ID
    exports("setPlayerCallChannel", function(playerId, targetId)
        if targetId == 0 or targetId == nil then
            ig.voip.server.EndCall(playerId)
        else
            ig.voip.server.StartCall(playerId, targetId)
        end
    end)
    
    --- Add player to call
    ---@param playerId number The player's server ID
    ---@param targetId number The target player's server ID
    exports("addPlayerToCall", function(playerId, targetId)
        ig.voip.server.StartCall(playerId, targetId)
    end)
    
    --- Remove player from call
    ---@param playerId number The player's server ID
    exports("removePlayerFromCall", function(playerId)
        ig.voip.server.EndCall(playerId)
    end)
    
    --- Set player voice mode
    ---@param playerId number The player's server ID
    ---@param mode number The voice mode index
    exports("setPlayerVoiceMode", function(playerId, mode)
        ig.voip.server.SetVoiceMode(playerId, mode)
    end)
    
    --- Get player voice mode
    ---@param playerId number The player's server ID
    ---@return number|nil The voice mode index
    exports("getPlayerVoiceMode", function(playerId)
        return ig.voip.server.GetVoiceMode(playerId)
    end)
    
    --- Update player voice target
    ---@param playerId number The player's server ID
    ---@param targets table Array of target player server IDs
    exports("updatePlayerVoiceTarget", function(playerId, targets)
        -- Voice targets are managed automatically in Ingenium
        -- This is a no-op for compatibility
    end)
    
    --- Get players in radio channel
    ---@param channel number The radio channel
    ---@return table Array of player server IDs
    exports("getPlayersInRadioChannel", function(channel)
        -- Would need to track radio channel membership
        -- Return empty for now
        return {}
    end)
    
    --- Check if player is in radio channel
    ---@param playerId number The player's server ID
    ---@param channel number The radio channel
    ---@return boolean True if in channel
    exports("isPlayerInRadioChannel", function(playerId, channel)
        -- Would need to query player's current channel
        return false
    end)
    
    --- Set player muted
    ---@param playerId number The player's server ID
    ---@param muted boolean Whether to mute
    exports("setPlayerMuted", function(playerId, muted)
        -- Muting would be handled via FiveM's built-in mute
        MumbleSetPlayerMuted(playerId, muted)
    end)
    
    --- Set player voice target
    ---@param playerId number The player's server ID
    ---@param target number|table The target player(s)
    exports("setPlayerVoiceTarget", function(playerId, target)
        -- Managed automatically by Ingenium
    end)
    
    --- Add player to voice grid
    ---@param playerId number The player's server ID
    exports("addPlayerToGrid", function(playerId)
        -- Grid management is automatic in Ingenium
        local ped = GetPlayerPed(playerId)
        if ped and ped ~= 0 then
            local coords = GetEntityCoords(ped)
            ig.voip.server.UpdateGrid(playerId, coords.x, coords.y)
        end
    end)
    
    --- Remove player from voice grid
    ---@param playerId number The player's server ID
    exports("removePlayerFromGrid", function(playerId)
        ig.voip.server.RemoveFromGrid(playerId)
    end)
    
    --- Get players in proximity
    ---@param playerId number The player's server ID
    ---@param distance number The maximum distance
    ---@return table Array of player server IDs in proximity
    exports("getPlayersInProximity", function(playerId, distance)
        return ig.voip.server.GetPlayersInProximity(playerId, distance)
    end)

end

-- ====================================================================================--
ig.log.Info("Ingenium VOIP", "PMA-Voice compatibility wrapper loaded")
-- ====================================================================================--
