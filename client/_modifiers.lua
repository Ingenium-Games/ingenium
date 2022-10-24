-- ====================================================================================--

c.modifier = {} -- function level
c.modifiers = conf.default.modifiers
c.oldmodifiers = {}

-- ====================================================================================--

local _min = 1
local _max = 10
local _boost = 1

-- ====================================================================================--

--- Return the table of active modifiers. Table
function c.modifier.GetModifiers()
    return c.modifiers
end

--- Sets the table of active modifiers.
---@param t table "Typically passed from the server as an internal table."
function c.modifier.SetModifiers()
    if LocalPlayer.state.Modifiers ~= nil then
        c.modifiers = LocalPlayer.state.Modifiers
        c.func.Debug_2("[F] c.modifier.SetModifiers() LocalState Used")
        print(c.modifiers)
        print(c.table.Dump(c.modifiers))
    else
        c.modifiers = TriggerServerCallback({eventName = "GetModifiers"})
        c.func.Debug_2("[F] c.modifier.SetModifiers() Event Used")
    end
    c.oldmodifiers = c.modifiers
end

-- ====================================================================================--

--- Returns the Hunger modifier. Number
function c.modifier.GetHungerModifier()
    return c.modifiers.Hunger
end

--- Sets the Hunger modifier between (1,10).
---@param v number "Can only be a number."
function c.modifier.SetHungerModifier(v)
    c.oldmodifiers = c.modifiers
    c.modifiers.Hunger = c.check.Number(v, _min, _max)
    c.state.TriggerState("Hunger", c.modifiers.Hunger)
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function c.modifier.AddHungerModifier(v)
    c.oldmodifiers = c.modifiers
    c.modifiers.Hunger = c.check.Number((c.modifiers.Hunger + v),_min,_max)
    c.state.TriggerState("Hunger", c.modifiers.Hunger)
end

-- ====================================================================================--

--- returns the Thirst modifier. Number
function c.modifier.GetThirstModifier()
    return c.modifiers.Thirst
end

--- Sets the Thirst modifier between (1,10)
---@param v number "Can only be a number." 
function c.modifier.SetThirstModifier(v)
    c.oldmodifiers = c.modifiers
    c.modifiers.Thirst = c.check.Number(v, _min, _max)
    c.state.TriggerState("Thirst", c.modifiers.Thirst)
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function c.modifier.AddThirstModifier(v)
    c.oldmodifiers = c.modifiers
    c.modifiers.Thirst = c.check.Number((c.modifiers.Thirst + v),_min,_max)
    c.state.TriggerState("Thirst", c.modifiers.Thirst)
end

-- ====================================================================================--

--- Returns the Stress modifier. Number
function c.modifier.GetStressModifier()
    return c.modifiers.Stress
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function c.modifier.SetStressModifier(v)
    c.oldmodifiers = c.modifiers
    c.modifiers.Stress = c.check.Number(v, _min, _max)
    c.state.TriggerState("Stress", c.modifiers.Stress)
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function c.modifier.AddStressModifier(v)
    c.oldmodifiers = c.modifiers
    c.modifiers.Stress = c.check.Number((c.modifiers.Stress + v),_min,_max)
    c.state.TriggerState("Stress", c.modifiers.Stress)
end

-- ====================================================================================--

--- Returns the current degrade booster value. Number
function c.modifier.GetDegradeBoost()
    return _boost
end

--- Sets a degrade booster to help reduce the modifiers. Like a Debuff.
---@param v number "Can only be a number."
function c.modifier.SetDegradeBoost(v)
    local val = c.check.Number(v, _min, _max)
    _boost = val
end

--- Loop over the modifers and decrease them.
function c.modifier.DegradeModifiers()
    for k,v in pairs(c.modifiers) do    
        if v < _min then v = 1 end
        if v > _max then v = 10 end
        if v <= 10 and v > 1 then
            v = math.min(v - (1 * c.modifier.GetDegradeBoost()), 1)
        end
    end
end

-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(c.min * 10)
        c.modifier.DegradeModifiers()
    end
end)