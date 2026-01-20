
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function(Coords, Appearance)
    ig.log.Info("Character", "Character loaded - initializing systems")
    local ped = PlayerPedId()
    --
    exports.spawnmanager:setAutoSpawn(false)
    --
    ig.func.FadeOut(1000)
    ig.func.IsBusyPleaseWait(2500)
    --
    if conf.gamemode == "RP" then
        -- Set RP-specific native configurations
        SetMaxWantedLevel(0)
        SetPedMinGroundTimeForStungun(ped, 12500)
        SetCanAttackFriendly(ped, true, false)
        NetworkSetFriendlyFireOption(true)
        SetWeaponsNoAutoswap(true)
        SetWeaponsNoAutoreload(true)
        RemoveMultiplayerHudCash()
    end
    -- Ensure ped is visible, not frozen, and can move
    if DoesEntityExist(ped) then
        -- Reset position or mark at airport or config spawn location
        SetEntityCoords(ped, Coords["x"], Coords["y"], Coords["z"])
        SetEntityHeading(ped, Coords["h"])
        --
        SetEntityVisible(ped, true, false)
        SetEntityInvincible(ped, false)
        FreezeEntityPosition(ped, false)
        SetPedCanRagdoll(ped, true)
        ig.log.Debug("Character", "Ped visibility and physics enabled")
    end
    -- Apply appearance using the appearance system
    if Appearance and ig.appearance and ig.appearance.SetAppearance then
        ig.appearance.SetAppearance(Appearance)
        ig.log.Info("Character", "Appearance applied from server")
    end
    -- CRITICAL: Wait for StateBag synchronization with state verification
    -- Instead of hardcoded 5-second wait, verify state is actually synced
    local maxWait = 0
    local timeStep = 50  -- Check every 50ms
    local timeout = 5000 -- Max 5 seconds
    --
    local function checkStateSync()
        local state = Entity(ped).state
        -- Check if critical state fields are synced from server
        if state and state.Health then
            ig.log.Info("Character", "StateBag sync confirmed - Health: " .. tostring(state.Health))
            return true
        end
        return false
    end
    -- Wait with verification instead of hardcoded delay
    while not checkStateSync() and maxWait < timeout do
        SetTimeout(timeStep, function() end)
        maxWait = maxWait + timeStep
    end
    --
    if maxWait >= timeout then
        ig.log.Warn("Character", "State sync timeout after 5 seconds, proceeding anyway")
    else
        ig.log.Trace("Character", "State sync verified in " .. maxWait .. "ms")
    end
    -- Initialize all character systems
    ig.data.SetLoadedStatus(true)
    ig.chat.AddSuggestions()
    ig.data.SetLocale()
    ig.skill.SetSkills()
    ig.status.SetPlayer()
    ig.modifier.SetModifiers()
    -- Notify server that client is fully ready
    -- NOTE: This tells server that ped is fully initialized and state is - Will force update Instance or bucket to last known bucket or instance.
    TriggerServerEvent("Server:Character:Ready")
    -- Trigger internal event for other resources
    TriggerEvent("Client:Character:Ready")
    --
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    --
    ig.func.FadeIn(2500)
end)

-- ====================================================================================--
-- STAGE 6: Character Ready & Game State
-- ====================================================================================--

-- Called after Client:Character:Loaded completes
-- Character is fully loaded, all systems initialized, ready to play
RegisterNetEvent("Client:Character:Ready")
AddEventHandler("Client:Character:Ready", function()
    ig.log.Info("Character", "Character fully ready - initializing gameplay")

end)

-- ====================================================================================--
-- STAGE 7: Character State Management (Switch/Logout)
-- ====================================================================================--

-- Called before switching to another character (logout)
RegisterNetEvent("Client:Character:Pre-Switch")
AddEventHandler("Client:Character:Pre-Switch", function()
    ig.log.Info("Character", "Preparing character switch")
    
    ig.func.FadeOut(1000)
    
    SetTimeout(1000, function()
        ig.func.FadeIn(2000)
    end)
end)

-- Called when player is switching characters
-- Cleans up character-specific data and state
RegisterNetEvent("Client:Character:Switch")
AddEventHandler("Client:Character:Switch", function()
    ig.log.Info("Character", "Character switch initiated - cleaning up")
    
    ig.data.SetLoadedStatus(false)
    
    -- Clean up character-specific resources
    -- Add cleanup hooks here for other resources
end)

-- Called when player goes off-duty (job toggle)
RegisterNetEvent("Client:Character:OffDuty")
AddEventHandler("Client:Character:OffDuty", function()
    if conf.enableduty then
        ig.log.Trace("Character", "Character went off-duty")
        -- Add off-duty specific logic here
    else
        ig.log.Trace("Character", "Off-duty disabled in configuration")
    end
end)

-- Called when player goes on-duty (job toggle)
RegisterNetEvent("Client:Character:OnDuty")
AddEventHandler("Client:Character:OnDuty", function(job)
    if conf.enableduty then
        ig.log.Trace("Character", "Character went on-duty for job: " .. (job or "unknown"))
        -- Add on-duty specific logic here
    else
        ig.log.Trace("Character", "On-duty disabled in configuration")
    end
end)

-- Called when player's job is updated
RegisterNetEvent("Client:Character:SetJob")
AddEventHandler("Client:Character:SetJob", function(name, grade)
    ig.log.Trace("Character", "Job updated: " .. name .. " (Grade: " .. grade .. ")")
    -- Add job-specific logic here
end)

-- ====================================================================================--
-- STAGE 8: Character Death & Events
-- ====================================================================================--

-- Called when character dies
RegisterNetEvent("Client:Character:Death")
AddEventHandler("Client:Character:Death", function(data)
    ig.log.Warn("Character", "Character death event triggered")
    
    if data and data.Log then
        local agro = data.Log.Source
        local cause = data.Cause or "Unknown"
        
        ig.log.Trace("Character", "Death cause: " .. cause .. " (Source: " .. agro .. ")")
        
        if cause == "Weapon" then
            -- Handle weapon death
        elseif cause == "Vehicle" then
            -- Handle vehicle death
        elseif cause == "Object" then
            -- Handle object death
        end
    end
end)

-- Receive and apply appearance from server after character ready
RegisterNetEvent("Client:Character:SetAppearance")
AddEventHandler("Client:Character:SetAppearance", function(appearance)
    if not appearance then 
        ig.log.Warn("Character", "SetAppearance called with no appearance data")
        return 
    end
    
    local ped = PlayerPedId()
    if not ped or ped == 0 then 
        ig.log.Error("Character", "SetAppearance: Invalid ped")
        return 
    end
    
    -- Apply the appearance
    if ig.appearance and ig.appearance.SetAppearance then
        ig.appearance.SetAppearance(appearance)
        ig.log.Info("Character", "Appearance applied via SetAppearance event")
    else
        ig.log.Error("Character", "Appearance system not available")
    end
    
    -- Ensure ped is visible and not frozen
    SetEntityVisible(ped, true, false)
    SetEntityInvincible(ped, false)
    FreezeEntityPosition(ped, false)
    SetPedCanRagdoll(ped, true)
    
    ig.log.Debug("Character", "Ped visibility and physics restored")
end)
