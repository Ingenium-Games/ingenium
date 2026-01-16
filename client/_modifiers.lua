-- ====================================================================================--
-- Modifiers (ig.modifier, ig.oldmodifiers initialized in client/_var.lua)
ig.modifiers = conf.default.modifiers
-- ====================================================================================--
local _min = 1
local _max = 10
local _boost = 1
-- ====================================================================================--

--- Return the table of active modifiers. Table
function ig.modifier.GetModifiers()
    return ig.modifiers
end

--- Sets the table of active modifiers.
---@param t table "Typically passed from the server as an internal table."
function ig.modifier.SetModifiers()
    if LocalPlayer.state.Modifiers ~= nil then
        ig.modifiers = LocalPlayer.state.Modifiers
        ig.log.Debug("Modifiers", "SetModifiers() using LocalState")
        -- print(ig.modifiers)
        -- print(ig.table.Dump(ig.modifiers))
    else
        ig.modifiers = ig.callback.Await("GetModifiers")
        ig.log.Debug("Modifiers", "SetModifiers() using Event")
    end
    ig.oldmodifiers = ig.modifiers
end

-- ====================================================================================--

--- Returns the Hunger modifier. Number
function ig.modifier.GetHungerModifier()
    return ig.modifiers.Hunger
end

--- Sets the Hunger modifier between (1,10).
---@param v number "Can only be a number."
function ig.modifier.SetHungerModifier(v)
    ig.oldmodifiers = ig.modifiers
    ig.modifiers.Hunger = ig.check.Number(v, _min, _max)
    ig.state.TriggerState("Hunger", ig.modifiers.Hunger)
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function ig.modifier.AddHungerModifier(v)
    ig.oldmodifiers = ig.modifiers
    ig.modifiers.Hunger = ig.check.Number((ig.modifiers.Hunger + v),_min,_max)
    ig.state.TriggerState("Hunger", ig.modifiers.Hunger)
end

-- ====================================================================================--

--- returns the Thirst modifier. Number
function ig.modifier.GetThirstModifier()
    return ig.modifiers.Thirst
end

--- Sets the Thirst modifier between (1,10)
---@param v number "Can only be a number." 
function ig.modifier.SetThirstModifier(v)
    ig.oldmodifiers = ig.modifiers
    ig.modifiers.Thirst = ig.check.Number(v, _min, _max)
    ig.state.TriggerState("Thirst", ig.modifiers.Thirst)
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function ig.modifier.AddThirstModifier(v)
    ig.oldmodifiers = ig.modifiers
    ig.modifiers.Thirst = ig.check.Number((ig.modifiers.Thirst + v),_min,_max)
    ig.state.TriggerState("Thirst", ig.modifiers.Thirst)
end

-- ====================================================================================--

--- Returns the Stress modifier. Number
function ig.modifier.GetStressModifier()
    return ig.modifiers.Stress
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function ig.modifier.SetStressModifier(v)
    ig.oldmodifiers = ig.modifiers
    ig.modifiers.Stress = ig.check.Number(v, _min, _max)
    ig.state.TriggerState("Stress", ig.modifiers.Stress)
end

--- Sets the Stress modifier between (1,10).
---@param v number "Can only be a number."
function ig.modifier.AddStressModifier(v)
    ig.oldmodifiers = ig.modifiers
    ig.modifiers.Stress = ig.check.Number((ig.modifiers.Stress + v),_min,_max)
    ig.state.TriggerState("Stress", ig.modifiers.Stress)
end

-- ====================================================================================--

--- Returns the current degrade booster value. Number
function ig.modifier.GetDegradeBoost()
    return _boost
end

--- Sets a degrade booster to help reduce the modifiers. Like a Debuff.
---@param v number "Can only be a number."
function ig.modifier.SetDegradeBoost(v)
    local val = ig.check.Number(v, _min, _max)
    _boost = val
end

--- Loop over the modifers and decrease them.
function ig.modifier.DegradeModifiers()
    local modified = false
    for k,v in pairs(ig.modifiers) do    
        if v < _min then 
            ig.modifiers[k] = 1
            modified = true
        end
        if v > _max then 
            ig.modifiers[k] = 10
            modified = true
        end
        if v <= 10 and v > 1 then
            ig.modifiers[k] = math.max(v - (1 * ig.modifier.GetDegradeBoost()), 1)
            modified = true
        end
    end
    -- Trigger state update if any modifier was changed
    if modified then
        for k,v in pairs(ig.modifiers) do
            ig.state.TriggerState(k, v)
        end
    end
end

-- ====================================================================================--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(ig.min * 10)
        ig.modifier.DegradeModifiers()
    end
end)