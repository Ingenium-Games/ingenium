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
function c.event.AddRestrictedEvent(job, name, cb)
    local eventname = ("Server:Interact:%s"):format(name)
    if not c.events[eventname] then
        c.events[eventname] = true
        ExecuteCommand(("add_ace job.%s 'event.Server:Interact:%s' allow"):format(job,name))
        RegisterNetEvent(eventname, function(o)
            -- Invoker
            local src = source
            local xPlayer = c.data.GetPlayer(src)
            -- Options Passed
            local o = o
            local net = o.net
            local job = o.job
            local type = o.type
            local event = o.event
            local label = o.label
            -- Target
            -- Server side entity
            local entity = NetworkGetEntityFromNetworkId(net)
            -- 
            -- Does Invoker have permissions to trigger this event, ig.target checks thier job prior to permiting
            if xPlayer.EventAllowed(event) then
                -- Do Actions...
                --[[    
                    local src = source -- The ID of the person triggering the event
                    local entity = entity -- Server Sided Entity
                    local o = o -- the options table passed to the event
                        local net = o.net -- the net id of the entity triggering the event
                        local job = o.job -- the job required 
                        local type = o.type -- the entity type
                        local event = o.event -- the event name
                        local label = o.label -- the label
                ]]--
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