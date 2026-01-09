-- ====================================================================================--
-- RP Mode Control Restrictions Thread
-- Handles control disabling based on player state (cuffed, frozen, escorted, dead, swimming)
-- Migrated and optimized from ig.base/client/[RP]/_threads.lua
-- ====================================================================================--

-- Only load if in RP mode
if conf.gamemode ~= "RP" then
    return
end

-- ====================================================================================--
-- Per-Frame Control Restriction Thread
-- Disables controls based on player state
-- ====================================================================================--

Citizen.CreateThread(function()
    -- Cache previous states to avoid unnecessary operations
    local prevStates = {
        isDead = false,
        isFrozen = false,
        isCuffed = false,
        isEscorted = false,
        isEscorting = false,
        isSwimming = false
    }
    
    while true do
        local ped = PlayerPedId()
        local ply = PlayerId()
        
        if ig.data.IsPlayerLoaded() then
            -- Get current player states
            local isDead = LocalPlayer.state.IsDead
            local isFrozen = LocalPlayer.state.IsFrozen
            local isCuffed = LocalPlayer.state.IsCuffed
            local isEscorted = LocalPlayer.state.IsEscorted
            local isEscorting = LocalPlayer.state.IsEscorting
            local isSwimming = LocalPlayer.state.IsSwimming
            
            -- Only do per-frame updates when states require it
            local needsPerFrame = isDead or isCuffed or isEscorted or isFrozen or isSwimming or isEscorting
            
            if needsPerFrame then
                Wait(0) -- Per-frame when states require control management
            else
                Wait(100) -- Check every 100ms when no special states active
            end
            
            -- ====================================================================================--
            -- Death State Controls
            -- ====================================================================================--
            if isDead then
                DisableAllControlActions(0)
                DisableAllControlActions(2)
                -- Allow chat and essential controls
                EnableControlAction(2, 199, true) -- Pause Menu (P)
                EnableControlAction(2, 200, true) -- Pause Menu Accept
            else
                EnableAllControlActions(0)
                EnableAllControlActions(2)
            end
            
            -- ====================================================================================--
            -- Swimming State Controls
            -- ====================================================================================--
            if isSwimming then
                DisableAllControlActions(2)
                -- Allow essential controls while swimming
                EnableControlAction(2, 199, true) -- Pause Menu (P)
                EnableControlAction(2, 200, true) -- Pause Menu Accept
            else
                EnableAllControlActions(2)
            end
            
            -- ====================================================================================--
            -- Cuffed State Controls
            -- ====================================================================================--
            if isCuffed then
                -- Disable weapon firing
                DisablePlayerFiring(ped, true)
                
                -- Force unarmed if player has weapon out
                if IsPedArmed(ped, 7) then
                    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                end
                
                -- Prevent ragdoll while cuffed (keeps animations clean)
                if CanPedRagdoll(ped) then
                    SetPedCanRagdoll(ped, false)
                end
                
                -- Disable specific controls
                DisableControlAction(0, 23, true)   -- F (Enter Vehicle)
                DisableControlAction(0, 288, true)  -- F1 (Interaction Menu)
                DisableControlAction(0, 243, true)  -- ~ (Console)
                DisableControlAction(0, 106, true)  -- VehicleMouseControlOverride
                DisableControlAction(0, 140, true)  -- Melee Attack Light
                DisableControlAction(0, 141, true)  -- Melee Attack Heavy
                DisableControlAction(0, 142, true)  -- Melee Attack Alternate
                DisableControlAction(0, 37, true)   -- SELECT_WEAPON (Tab)
            else
                -- Re-enable ragdoll when not cuffed
                if not CanPedRagdoll(ped) then
                    SetPedCanRagdoll(ped, true)
                end
            end
            
            -- ====================================================================================--
            -- Escorted/Frozen State Controls
            -- ====================================================================================--
            if isEscorted or isFrozen then
                -- Disable weapon firing
                DisablePlayerFiring(ped, true)
                
                -- Force unarmed
                if IsPedArmed(ped, 7) then
                    SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                end
                
                -- Disable movement and interaction controls
                DisableControlAction(0, 23, true)   -- F (Enter Vehicle)
                DisableControlAction(0, 106, true)  -- VehicleMouseControlOverride
                DisableControlAction(0, 140, true)  -- Melee Attack Light
                DisableControlAction(0, 141, true)  -- Melee Attack Heavy
                DisableControlAction(0, 142, true)  -- Melee Attack Alternate
                DisableControlAction(0, 37, true)   -- SELECT_WEAPON (Tab)
                DisableControlAction(2, 32, true)   -- W (Move Forward)
                DisableControlAction(0, 33, true)   -- S (Move Backward)
                DisableControlAction(0, 34, true)   -- A (Move Left)
                DisableControlAction(0, 35, true)   -- D (Move Right)
                DisableControlAction(0, 59, true)   -- INPUT_VEH_MOVE_LR
                DisableControlAction(0, 60, true)   -- INPUT_VEH_MOVE_UD
                DisableControlAction(2, 31, true)   -- Move Up/Down
            end
            
            -- ====================================================================================--
            -- Escorting State Controls
            -- ====================================================================================--
            if isEscorting then
                -- Restrict specific actions while escorting
                DisableControlAction(0, 20, true)   -- Z (Crouch)
                DisableControlAction(0, 22, true)   -- X (Prone)
            end
            
        else
            -- Player not loaded, wait longer
            Wait(500)
        end
    end
end)

-- ====================================================================================--
-- Death Visual Effects Thread
-- Handles screen effects when player dies
-- ====================================================================================--

local deathFxActive = false

Citizen.CreateThread(function()
    while true do
        if ig.data.IsPlayerLoaded() then
            Wait(500) -- Check every 500ms
            
            local isDead = LocalPlayer.state.IsDead
            
            if isDead and not deathFxActive then
                -- Player just died, start death effects
                ig.fx.StartDeath()
                deathFxActive = true
                ig.func.Debug_2("Death FX started")
            elseif not isDead and deathFxActive then
                -- Player revived, stop death effects
                ig.fx.StopDeath()
                deathFxActive = false
                ig.func.Debug_2("Death FX stopped")
            end
        else
            -- Player not loaded
            Wait(500)
        end
    end
end)

-- ====================================================================================--
