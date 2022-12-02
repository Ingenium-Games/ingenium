-- ====================================================================================--
c.state = {} -- functions
c.states = {} -- table of potential states to become etc.
-- ====================================================================================--

---- Add States to the Table prior to being locked on server boot.
---@param name string "The name of the state like 'Hungry'"
---@param description string "You feel your stomach ache a little."
---@param value number "You feel your stomach ache a little."
---@param effect function "Any change to the screen on the users end"
---@param action function "Any change to the screen on the users end"
function c.state.AddState(name, value, description, effects, actions)
    if not c.states[name] then
        c.states[name] = {}
        c.states[name][value] = {
            ["description"] = description,
            ["effect"] = effects,
            ["action"] = actions
        }
    else
        c.states[name][value] = {
            ["description"] = description,
            ["effect"] = effects,
            ["action"] = actions
        }
    end
end

function c.state.ChangeAction(name, value, cb)
    if not cb then
        cb = function()
        end
    end
    if c.states[name][value] then
        c.states[name][value]["action"] = cb()
    else
        c.func.Debug_1("The states action: " .. name .. " does not exist, please add state prior to action.")
    end
end

function c.state.ChangeEffect(name, value, cb)
    if not cb then
        cb = function()
        end
    end
    if c.states[name][value] then
        c.states[name][value]["effect"] = cb()
    else
        c.func.Debug_1("The states effect: " .. name .. " does not exist, please add state prior to effect.")
    end
end

---- To action based on the key and value of various modifiers or other tasks.
---@param name string "The name of the State"
---@param value number "The number of the State containing values"
function c.state.TriggerState(name, value)
    c.state.TriggerEffect(name, value)
    c.state.TriggerAction(name, value)
end

function c.state.TriggerEffect(name, value)
    if type(c.states[name][value].effect) == "function" then
        c.states[name][value].effect()
    end
end

function c.state.TriggerAction(name, value)
    if type(c.states[name][value].action) == "function" then
        c.states[name][value].action()
    end
end

--[[
    Example of adding states for all 1-10 levels of hunger and thirst and stress,
    Note, the effect or action can be a function to alter stuff. be creative. if no function is present nothing will occour, 
    so the below will just display once the users status updates from the client side modifier update from the server packet. 
]]--

local H = {
    [1] = {"1", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [2] = {"2", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [3] = {"3", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [4] = {"4", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [5] = {"5", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [6] = {"6", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [7] = {"7", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [8] = {"8", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [9] = {"9", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [10] = {"10", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end}
}

local T = {
    [1] = {"1", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [2] = {"2", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [3] = {"3", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [4] = {"4", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [5] = {"5", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [6] = {"6", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [7] = {"7", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [8] = {"8", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [9] = {"9", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [10] = {"10", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end}
}

local S = {
    [1] = {"1", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [2] = {"2", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [3] = {"3", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [4] = {"4", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [5] = {"5", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [6] = {"6", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [7] = {"7", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [8] = {"8", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [9] = {"9", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end},
    [10] = {"10", function()
        print("this is a effect")
    end, function()
        print("this is a action")
    end}
}

for k, v in pairs(H) do
    c.state.AddState("Hunger", k, v[1] or nil, v[2] or nil, v[3] or nil)
end

for k, v in pairs(T) do
    c.state.AddState("Thirst", k, v[1] or nil, v[2] or nil, v[3] or nil)
end

for k, v in pairs(S) do
    c.state.AddState("Stress", k, v[1] or nil, v[2] or nil, v[3] or nil)
end

-- c.func.Debug_1(c.table.Dump(c.states.Hunger))
