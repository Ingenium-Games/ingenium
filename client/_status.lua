-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.stats = {    
    ["Hunger"] = 100, -- Min 0 Max 100
    ["Thirst"] = 100, -- Min 0 Max 100
    ["Stress"] = 0, -- Min 0 Max 100
    }
c.status = {}
--[[
NOTES.
    - As health and armour are natives for the game, we dont need to worry much about the
    - additions to them from items etc as we can set max values, and have a default min
    - of 0.
]]--

-- ====================================================================================--

local _min = 0
local _max = 100
local _hunger = c.min * 3.25
local _thirst = c.min * 2.35
local _stress = c.min * 5

-- ====================================================================================--

function c.status.GetHealth(ped)
    return GetEntityHealth(ped)
end

function c.status.SetHealth(ped, health)
    SetEntityHealth(ped, health)
end

-- ====================================================================================--

function c.status.GetArmour(ped)
    return GetPedArmour(ped)
end

function c.status.SetArmour(ped, armour)
    SetPedArmour(ped, armour)
end

function c.status.AddArmour(ped, armour)
    AddArmourToPed(ped, armour) 
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
        c.stats.Hunger = c.stats.Hunger + val
    end
end

function c.status.RemoveHunger(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Hunger - val
    if calc <= 0 then
        c.stats.Hunger = _min
    else 
        c.stats.Hunger = c.stats.Hunger - val
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
        c.stats.Thirst = c.stats.Thirst + val
    end
end

function c.status.RemoveThirst(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Thirst - val
    if calc <= 0 then
        c.stats.Thirst = _min
    else 
        c.stats.Thirst = c.stats.Thirst - val
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
    else 
        c.stats.Stress = c.stats.Stress + val
    end
end

function c.status.RemoveStress(v)
    local val = c.check.Number(v, _min, _max)
    local calc = c.stats.Stress - val
    if calc <= 0 then
        c.stats.Stress = _min
    else 
        c.stats.Stress = c.stats.Stress - val
    end
end

-- ====================================================================================--

function c.status.StartHungerDecrease()
    local function Do()
        local default = 1 * c.modifier.GetHungerModifier()
        c.status.RemoveHunger(default)
        SetTimeout(_hunger, Do)
    end
    SetTimeout(_hunger, Do)
end

function c.status.StartThirstDecrease()
    local function Do()
        local default = 1 * c.modifier.GetThirstModifier()
        c.status.RemoveThirst(default)
        SetTimeout(_thirst, Do)
    end
    SetTimeout(_thirst, Do)
end

function c.status.StartStressIncrease()
    local function Do()
        local default = 1 * c.modifier.GetStressModifier()
        c.status.AddStress(default)
        SetTimeout(_stress, Do)
    end
    SetTimeout(_stress, Do)
end

function c.status.SendNUI(ped)
    local function Do()
        local data = {Health = c.status.GetHealth(ped), Armour = c.status.GetArmour(ped), Hunger = c.status.GetHunger(), Thirst = c.status.GetThirst(), Stress = c.status.GetStress()}
        TriggerEvent("Client:Status", data)
        SetTimeout(c.sec, Do)
    end
    SetTimeout(c.sec, Do)
end

-- ====================================================================================--

function c.status.SetPlayer(data)
    local ped = PlayerPedId()
    local ply = PlayerId()
    --
    -- Set default hp to 400 on spawn
    SetPedMaxHealth(ped, conf.defaulthealth)
    c.status.SetHealth(ped, conf.defaulthealth)
    --
    -- Set default armour to 0 on spawn
    SetPlayerMaxArmour(ply, conf.defaultarmour)
    c.status.SetArmour(ped, 0)
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
    c.status.SetHealth(ped, (data.Health or conf.defaulthealth))
    c.status.SetArmour(ped, (data.Armour or conf.defaultarmour))
    c.status.SetHunger((data.Hunger or _max))
    c.status.SetThirst((data.Thirst or _max))
    c.status.SetStress((data.Stress or _min))
    -- Begin Routines / Timeouts
    c.status.StartHungerDecrease()
    c.status.StartThirstDecrease()
    c.status.StartStressIncrease()
    c.status.SendNUI(ped)
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

]]--



--[[

Callbacks for status aliments
NUI icons for aliments or buffs.
timer to recieve end to be elivered from server.

]]--

-- Quicker
function c.status.SetHaste(bool, dec)
    local ped = PlayerPedId()
    if bool then
        if not dec then dec = 2.0 end
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
        if not dec then dec = 0.5 end
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