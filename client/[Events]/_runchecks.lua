-- ====================================================================================--
-- Client Run Checks - State Bag Change Handlers
-- These events are triggered from server/[Onesync]/_sbch.lua when StateBags change
-- Server enforces state updates to prevent client manipulation
-- ====================================================================================--

-- ====================================================================================--
-- Player State Checks
-- ====================================================================================--

--- IsWanted State Check
--- Triggered when the player's wanted status changes
RegisterNetEvent("Client:RunChecks:IsWanted")
AddEventHandler("Client:RunChecks:IsWanted", function()
        -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local wanted = LocalPlayer.state.IsWanted
    -- Handle wanted status changes
    -- Example: Update UI, trigger wanted effects, etig.
    if wanted then
        -- Player is now wanted
        ig.log.Trace("Status", "Player is now wanted")
    else
        -- Player is no longer wanted
        ig.log.Trace("Status", "Player wanted status cleared")
    end
end)

--- IsSupporter State Check
--- Triggered when the player's supporter status changes
RegisterNetEvent("Client:RunChecks:IsSupporter")
AddEventHandler("Client:RunChecks:IsSupporter", function()
        -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local isSupporter = LocalPlayer.state.IsSupporter
    -- Handle supporter status changes
    -- Example: Enable supporter features, update UI, etig.
    if isSupporter then
        ig.log.Trace("Status", "Player is now a supporter")
    else
        ig.log.Trace("Status", "Player supporter status removed")
    end
end)

--- IsDead State Check
--- Triggered when the player's death status changes
RegisterNetEvent("Client:RunChecks:IsDead")
AddEventHandler("Client:RunChecks:IsDead", function()
        -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local isDead = LocalPlayer.state.IsDead
    -- Handle death status changes
    -- Example: Show death screen, respawn options, etig.
    if isDead then
        ig.log.Debug("STATUS", "Player died")
        -- Death handling is already in client/_death.lua
    else
        ig.log.Debug("STATUS", "Player revived")
        -- Revive handling
    end
end)

--- IsCuffed State Check
--- Triggered when the player's cuffed status changes
RegisterNetEvent("Client:RunChecks:IsCuffed")
AddEventHandler("Client:RunChecks:IsCuffed", function()
            -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local isCuffed = LocalPlayer.state.IsCuffed
    -- Handle cuffed status changes
    -- Example: Restrict movement, play animations, etig.
    if isCuffed then
        ig.log.Trace("Status", "Player cuffed")
        -- Apply cuffed effects
        local ped = PlayerPedId()
        SetEnableHandcuffs(ped, true)
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
    else
        ig.log.Trace("Status", "Player uncuffed")
        -- Remove cuffed effects
        local ped = PlayerPedId()
        SetEnableHandcuffs(ped, false)
    end
end)

--- IsEscorted State Check
--- Triggered when the player's escorted status changes
RegisterNetEvent("Client:RunChecks:IsEscorted")
AddEventHandler("Client:RunChecks:IsEscorted", function()
            -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local isEscorted = LocalPlayer.state.IsEscorted
    -- Handle escorted status changes
    -- Example: Attach to escorting player, restrict actions, etig.
    if isEscorted then
        ig.log.Trace("Status", "Player is being escorted")
        -- Handle escort attachment
    else
        ig.log.Trace("Status", "Player is no longer being escorted")
        -- Detach from escort
    end
end)

--- IsEscorting State Check
--- Triggered when the player's escorting status changes
RegisterNetEvent("Client:RunChecks:IsEscorting")
AddEventHandler("Client:RunChecks:IsEscorting", function()
            -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local isEscorting = LocalPlayer.state.IsEscorting
    -- Handle escorting status changes
    -- Example: Attach escorted player, restrict actions, etig.
    if isEscorting then
        ig.log.Trace("Status", "Player is escorting someone")
        -- Handle escort attachment
    else
        ig.log.Trace("Status", "Player stopped escorting")
        -- Detach escorted player
    end
end)

--- IsSwimming State Check
--- Triggered when the player's swimming status changes
RegisterNetEvent("Client:RunChecks:IsSwimming")
AddEventHandler("Client:RunChecks:IsSwimming", function()
            -- Security: Prevent external resource invocation
    if GetInvokingResource() ~= conf.resourcename then
        CancelEvent()
        return
    end
    --
    local isSwimming = LocalPlayer.state.IsSwimming
    -- Handle swimming status changes
    -- Example: Apply swimming effects, update UI, etig.
    if isSwimming then
        ig.log.Trace("Status", "Player is swimming")
    else
        ig.log.Trace("Status", "Player stopped swimming")
    end
end)


