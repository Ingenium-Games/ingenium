-- ====================================================================================--

c.stats = conf.default.stats
c.status = {}

-- ====================================================================================--

local _min = 0.00
local _max = 100.00
local _hunger = c.sec * 3.25
local _thirst = c.sec * 2
local _stress = c.sec * 4.25

-- ====================================================================================--

function c.status.GetHealth()
    return GetEntityHealth(PlayerPedId())
end

function c.status.SetHealth(health)
    SetEntityHealth(PlayerPedId(), health)
end

function c.status.GetMaxHealth()
    return GetEntityMaxHealth(PlayerPedId())
end

function c.status.SelfDamageHealth()
    local health = c.status.GetHealth()
    c.status.SetHealth((health - conf.default.selfdamage))
end

-- ====================================================================================--

function c.status.GetArmour()
    return GetPedArmour(PlayerPedId())
end

function c.status.SetArmour(armour)
    SetPedArmour(PlayerPedId(), armour)
end

function c.status.AddArmour(armour)
    AddArmourToPed(PlayerPedId(), armour)
end

function c.status.AddArmourToAmount(amount)
    local current = c.status.GetArmour()
    if current < amount then
        c.status.SetArmour(amount)
    end
end

-- ====================================================================================--

function c.status.GetHunger()
    return c.stats.Hunger
end

function c.status.SetHunger(v)
    c.stats.Hunger = v
end

function c.status.AddHunger(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Hunger + val
    if calc >= 100 then
        c.stats.Hunger = _max
    else
        c.stats.Hunger = c.math.Decimals(c.stats.Hunger + val, 2)
    end
end

function c.status.RemoveHunger(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Hunger - val
    if calc <= 0 then
        c.stats.Hunger = _min
        c.status.SelfDamageHealth()
    else
        c.stats.Hunger = c.math.Decimals(c.stats.Hunger - val, 2)
    end
end

-- ====================================================================================--

function c.status.GetThirst()
    return c.stats.Thirst
end

function c.status.SetThirst(v)
    c.stats.Thirst = v
end

function c.status.AddThirst(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Thirst + val
    if calc >= 100 then
        c.stats.Thirst = _max
    else
        c.stats.Thirst = c.math.Decimals(c.stats.Thirst + val, 2)
    end
end

function c.status.RemoveThirst(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Thirst - val
    if calc <= 0 then
        c.stats.Thirst = _min
        c.status.SelfDamageHealth()
    else
        c.stats.Thirst = c.math.Decimals(c.stats.Thirst - val, 2)
    end
end

-- ====================================================================================--

function c.status.GetStress()
    return c.stats.Stress
end

function c.status.SetStress(v)
    c.stats.Stress = v
end

function c.status.AddStress(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Stress + val
    if calc >= 100 then
        c.stats.Stress = _max
        c.status.SelfDamageHealth()
    else
        c.stats.Stress = c.math.Decimals(c.stats.Stress + val, 2)
    end
end

function c.status.RemoveStress(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Stress - val
    if calc <= 0 then
        c.stats.Stress = _min
    else
        c.stats.Stress = c.math.Decimals(c.stats.Stress - val, 2)
    end
end

-- ====================================================================================--

function c.status.StartHungerDecrease()
    local function Do()
        if c.data.GetLoadedStatus() then
            local default = (1 * c.modifier.GetHungerModifier()) / 100
            c.status.RemoveHunger(default)
            SetTimeout(_hunger, Do)
        else
            -- this is to break the loop if switching between characters.
            return
        end
    end
    --
    SetTimeout(_hunger, Do)
end

function c.status.StartThirstDecrease()
    local function Do()
        if c.data.GetLoadedStatus() then
            local default = (1 * c.modifier.GetThirstModifier()) / 100
            c.status.RemoveThirst(default)
            SetTimeout(_thirst, Do)
        else
            -- this is to break the loop if switching between characters.
            return
        end
    end
    --
    SetTimeout(_thirst, Do)
end

function c.status.StartStressIncrease()
    local function Do()
        if c.data.GetLoadedStatus() then
            local sitting = exports["sit"]:IsSitting()
            local laying = exports["sit"]:IsLaying()
            if (not sitting) and (not laying) then
                local default = (1 * c.modifier.GetStressModifier()) / 100
                c.status.AddStress(default)
            elseif sitting then
                local default = 0.95
                c.status.RemoveStress(default)
            elseif laying then
                local default = 3.45
                c.status.RemoveStress(default)
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

function c.status.SetPlayer()
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
    c.status.SetHealth(LocalPlayer.state.Health)
    c.status.SetArmour(LocalPlayer.state.Armour)
    c.status.SetHunger(LocalPlayer.state.Hunger)
    c.status.SetThirst(LocalPlayer.state.Thirst)
    c.status.SetStress(LocalPlayer.state.Stress)
    -- Begin Routines / Timeouts
    c.status.StartHungerDecrease()
    c.status.StartThirstDecrease()
    c.status.StartStressIncrease()
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
function c.status.SetHaste(bool, dec)
    local ped = PlayerPedId()
    if bool then
        if not dec then
            dec = 2.0
        end
        local dec = c.math.Decimals(dec, 1)
        if dec >= 1.0 then
            SetPedMoveRateOverride(ped, dec)
        end
    else
        SetPedMoveRateOverride(ped, 1.0)
    end
end

-- Slower
function c.status.SetSlow(bool, dec)
    local ped = PlayerPedId()
    if bool then
        if not dec then
            dec = 0.5
        end
        local dec = c.math.Decimals(dec, 1)
        if dec <= 1.0 then
            SetPedMoveRateOverride(ped, dec)
        end
    else
        SetPedMoveRateOverride(ped, 1.0)
    end
end

-- set ingmae vision styles
function c.status.SetVision(style)

end

-- tick damage
function c.status.SetBleed(bool, dec)

end

-- tick damage
function c.status.SetPoison(bool, dec)

end

-- tick damage
function c.status.SetBurn(bool, dec)

end

-- tick damage
function c.status.SetWithdrawls(bool, dec)

end

function c.status.SetInjury(bool, dec)

end

-- One of three, first person only, third person only, out of body experiance. FP, TP, OB
function c.status.Camera(type)

end

-- Notmal, Static, Micky Mouse.
function c.status.Sound(type)

end

-- Really fuck your camera up.
function c.status.Bobble(bool)

end

function c.status.WalkType(type)

end

