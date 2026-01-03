-- ====================================================================================--
ig.stats = conf.default.stats
ig.status = {}
-- ====================================================================================--

local _min = 0.00
local _max = 100.00
local _hunger = ig.sec * 3.25
local _thirst = ig.sec * 2
local _stress = ig.sec * 4.25

-- ====================================================================================--

function ig.status.GetHealth()
    return GetEntityHealth(PlayerPedId())
end

function ig.status.SetHealth(health)
    SetEntityHealth(PlayerPedId(), health)
end

function ig.status.GetMaxHealth()
    return GetEntityMaxHealth(PlayerPedId())
end

function ig.status.SelfDamageHealth()
    local health = ig.status.GetHealth()
    ig.status.SetHealth((health - conf.default.selfdamage))
end

-- ====================================================================================--

function ig.status.GetArmour()
    return GetPedArmour(PlayerPedId())
end

function ig.status.SetArmour(armour)
    SetPedArmour(PlayerPedId(), armour)
end

function ig.status.AddArmour(armour)
    AddArmourToPed(PlayerPedId(), armour)
end

function ig.status.AddArmourToAmount(amount)
    local current = ig.status.GetArmour()
    if current < amount then
        ig.status.SetArmour(amount)
    end
end

-- ====================================================================================--

function ig.status.GetHunger()
    return ig.stats.Hunger
end

function ig.status.SetHunger(v)
    ig.stats.Hunger = v
end

function ig.status.AddHunger(v)
    local val = ig.check.Number(v, _min, _max)
    local calc = ig.stats.Hunger + val
    if calc >= 100 then
        ig.stats.Hunger = _max
    else
        ig.stats.Hunger = ig.math.Decimals(ig.stats.Hunger + val, 2)
    end
end

function ig.status.RemoveHunger(v)
    local val = ig.check.Number(v, _min, _max)
    local calc = ig.stats.Hunger - val
    if calc <= 0 then
        ig.stats.Hunger = _min
        ig.status.SelfDamageHealth()
    else
        ig.stats.Hunger = ig.math.Decimals(ig.stats.Hunger - val, 2)
    end
end

-- ====================================================================================--

function ig.status.GetThirst()
    return ig.stats.Thirst
end

function ig.status.SetThirst(v)
    ig.stats.Thirst = v
end

function ig.status.AddThirst(v)
    local val = ig.check.Number(v, _min, _max)
    local calc = ig.stats.Thirst + val
    if calc >= 100 then
        ig.stats.Thirst = _max
    else
        ig.stats.Thirst = ig.math.Decimals(ig.stats.Thirst + val, 2)
    end
end

function ig.status.RemoveThirst(v)
    local val = ig.check.Number(v, _min, _max)
    local calc = ig.stats.Thirst - val
    if calc <= 0 then
        ig.stats.Thirst = _min
        ig.status.SelfDamageHealth()
    else
        ig.stats.Thirst = ig.math.Decimals(ig.stats.Thirst - val, 2)
    end
end

-- ====================================================================================--

function ig.status.GetStress()
    return ig.stats.Stress
end

function ig.status.SetStress(v)
    ig.stats.Stress = v
end

function ig.status.AddStress(v)
    local val = ig.check.Number(v, _min, _max)
    local calc = ig.stats.Stress + val
    if calc >= 100 then
        ig.stats.Stress = _max
        ig.status.SelfDamageHealth()
    else
        ig.stats.Stress = ig.math.Decimals(ig.stats.Stress + val, 2)
    end
end

function ig.status.RemoveStress(v)
    local val = ig.check.Number(v, _min, _max)
    local calc = ig.stats.Stress - val
    if calc <= 0 then
        ig.stats.Stress = _min
    else
        ig.stats.Stress = ig.math.Decimals(ig.stats.Stress - val, 2)
    end
end

-- ====================================================================================--

function ig.status.StartHungerDecrease()
    local function Do()
        if ig.data.GetLoadedStatus() then
            local default = (1 * ig.modifier.GetHungerModifier()) / 100
            ig.status.RemoveHunger(default)
            SetTimeout(_hunger, Do)
        else
            -- this is to break the loop if switching between characters.
            return
        end
    end
    --
    SetTimeout(_hunger, Do)
end

function ig.status.StartThirstDecrease()
    local function Do()
        if ig.data.GetLoadedStatus() then
            local default = (1 * ig.modifier.GetThirstModifier()) / 100
            ig.status.RemoveThirst(default)
            SetTimeout(_thirst, Do)
        else
            -- this is to break the loop if switching between characters.
            return
        end
    end
    --
    SetTimeout(_thirst, Do)
end

function ig.status.StartStressIncrease()
    local function Do()
        if ig.data.GetLoadedStatus() then
            local sitting = exports["sit"]:IsSitting()
            local laying = exports["sit"]:IsLaying()
            if (not sitting) and (not laying) then
                local default = (1 * ig.modifier.GetStressModifier()) / 100
                ig.status.AddStress(default)
            elseif sitting then
                local default = 0.95
                ig.status.RemoveStress(default)
            elseif laying then
                local default = 3.45
                ig.status.RemoveStress(default)
            end
            SetTimeout(_stress, Do)
        else
            -- this is to break the loop if switching between characters.
            return
        end
    end
    --
    SetTimeout(_stress, Do)
end

-- ====================================================================================--

function ig.status.SetPlayer()
    local ply = PlayerId()
    local ped = PlayerPedId()
    --
    -- Set to max prior to getting data from xplayer table.
    SetEntityHealth(ped, 150)
    SetPlayerMaxArmour(ply, 100)
    --
    -- These will be usesd in healing items.
    SetPlayerHealthRechargeLimit(ply, 0)
    SetPlayerHealthRechargeMultiplier(ply, 0)
    SetPedSuffersCriticalHits(ped, true) --  Headshot ratios boi.
    --
    -- This may be true if you take like 50kgs of cocaine.
    SetPlayerInvincible(ply, false)
    --
    -- time to gain our data from the server.
    ig.status.SetHealth(LocalPlayer.state.Health)
    ig.status.SetArmour(LocalPlayer.state.Armour)
    ig.status.SetHunger(LocalPlayer.state.Hunger)
    ig.status.SetThirst(LocalPlayer.state.Thirst)
    ig.status.SetStress(LocalPlayer.state.Stress)
    -- Begin Routines / Timeouts
    ig.status.StartHungerDecrease()
    ig.status.StartThirstDecrease()
    if GetResourceState("sit") ~= "started" then
        ig.func.Debug_1("[WARNING] Sit resource is not running. Stress decrease while sitting/laying will not function.")
    elseif GetResourceState("sit") == "started" then
        ig.status.StartStressIncrease()
    end
end

--[[
Things to make into variables for items or buffs.


SetPlayerHealthRechargeLimit(ply, 0)
SetPlayerHealthRechargeMultiplier(ply, 0)

    x, 1.00 - 1.49
SetRunSprintMultiplierForPlayer(player,multiplier)
    x, 1.00 - 1.49
SetSwimMultiplierForPlayer(player,multiplier)

ShakeGameplayCam(shakeName, intensity)
DEATH_FAIL_IN_EFFECT_SHAKE
DRUNK_SHAKE
FAMILY5_DRUG_TRIP_SHAKE
HAND_SHAKE
JOLT_SHAKE
LARGE_EXPLOSION_SHAKE
MEDIUM_EXPLOSION_SHAKE
SMALL_EXPLOSION_SHAKE
ROAD_VIBRATION_SHAKE
SKY_DIVING_SHAKE
VIBRATE_SHAKE

]] --

--[[

Callbacks for status aliments
NUI icons for aliments or buffs.
timer to recieve end to be elivered from server.

]] --

-- Quicker
function ig.status.SetHaste(bool, dec)
    local ped = PlayerPedId()
    if bool then
        if not dec then
            dec = 2.0
        end
        local dec = ig.math.Decimals(dec, 1)
        if dec >= 1.0 then
            SetPedMoveRateOverride(ped, dec)
        end
    else
        SetPedMoveRateOverride(ped, 1.0)
    end
end

-- Slower
function ig.status.SetSlow(bool, dec)
    local ped = PlayerPedId()
    if bool then
        if not dec then
            dec = 0.5
        end
        local dec = ig.math.Decimals(dec, 1)
        if dec <= 1.0 then
            SetPedMoveRateOverride(ped, dec)
        end
    else
        SetPedMoveRateOverride(ped, 1.0)
    end
end

-- set ingmae vision styles
function ig.status.SetVision(style)

end

-- tick damage
function ig.status.SetBleed(bool, dec)

end

-- tick damage
function ig.status.SetPoison(bool, dec)

end

-- tick damage
function ig.status.SetBurn(bool, dec)

end

-- tick damage
function ig.status.SetWithdrawls(bool, dec)

end

function ig.status.SetInjury(bool, dec)

end

-- One of three, first person only, third person only, out of body experiance. FP, TP, OB
function ig.status.Camera(type)

end

-- Notmal, Static, Micky Mouse.
function ig.status.Sound(type)

end

-- Really fuck your camera up.
function ig.status.Bobble(bool)

end

function ig.status.WalkType(type)

end
