-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.event = {}
c.events = {}
--[[
NOTES.
    -
    -
    -
]] --


-- ====================================================================================--

--- func desc
---@param job string "Jobname used fro role permissions"
---@param name string "The final argument f the event"
---@param cb function "Trigger event once confirmed user is able to action event."
function c.event.AddInteractEvent(job, name, cb)
    local eventname = ("Server:Interact:%s"):format(name)
    if not c.events[eventname] then
        --
        table.insert(c.events, eventname)
        --
        ExecuteCommand(("add_ace job.%s Server:Interact:%s allow"):format(job,name))
        RegisterNetEvent(eventname, function(o)
            -- Invoker
            local src = source
            local xPlayer = c.data.GetPlayer(src)
            -- Options Passed
            --[[
            local o = o
                local net = o.net
                local job = o.job
                local type = o.type
                local event = o.event
                local label = o.label
            ]]--
            -- Target
            -- Server side entity
            local entity = NetworkGetEntityFromNetworkId(net)
            -- 
            -- Does Invoker have permissions to trigger this event, ig.target checks thier job prior to permiting
            if IsPlayerAceAllowed(src, eventname) then
                -- Do Actions...
                cb(src, entity, o)
            else
                c.eventban(src, eventname)
            end
        end)
        return eventname
    else
        print("event name already taken")
    end
end