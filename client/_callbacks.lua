-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
--[[
NOTES.
    -
    -
    -
]]--
math.randomseed(c.Seed)
-- ====================================================================================--
-- https://github.com/pitermcflebor/pmc-callbacks (MIT LICENSE)

--[[
MIT License

Copyright (c) 2020 PiterMcFlebor

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

RegisterNetEvent('Callback:Client')
AddEventHandler('Callback:Client', function(eventName, ...)
    local p = promise.new()

    TriggerEvent(('__CB:Client:%s'):format(eventName), function(...)
        p:resolve({...})
    end, ...)

    local result = Citizen.Await(p)
    TriggerServerEvent(('Callback:Server:%s'):format(eventName), table.unpack(result))
end)

function c.TriggerServerCallback(eventName, ...)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))

    local p = promise.new()
    local ticket = GetGameTimer()

    RegisterNetEvent(('Callback:Client:%s:%s'):format(eventName, ticket))
    local e = AddEventHandler(('Callback:Client:%s:%s'):format(eventName, ticket), function(...)
        p:resolve({...})
    end)

    TriggerServerEvent('Callback:Server', eventName, ticket, ...)

    local result = Citizen.Await(p)
    RemoveEventHandler(e)
    return table.unpack(result)
end

function c.RegisterClientCallback(eventName, fn)
    assert(type(eventName) == 'string', 'Invalid Lua type at argument #1, expected string, got ' .. type(eventName))
    assert(type(fn) == 'function', 'Invalid Lua type at argument #2, expected function, got ' .. type(fn))

    AddEventHandler(('__CB:Client:%s'):format(eventName), function(cb, ...)
        cb(fn(...))
    end)
end

-- ====================================================================================--


-- Vehicle Condition
c.RegisterClientCallback("GetVehicleCondition", function(entity) 
    return c.GetVehicleCondition(entity)
end)

c.RegisterClientCallback("SetVehicleCondition", function(entity, con) 
    c.SetVehicleCondition(entity, con)
    return true
end)

-- Vehicle Modifications
c.RegisterClientCallback("GetVehicleModifications", function(entity) 
    return c.GetVehicleModifications(entity)
end)

c.RegisterClientCallback("SetVehicleModifications", function(entity, mods) 
    c.SetVehicleModifications(entity, mods)
    return true
end)

