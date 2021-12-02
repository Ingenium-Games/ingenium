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
function c.event.AddInteractJobEvent(job, name, cb)
    local eventname = ("Server:Interact:%s:%s"):format(name,job)
    if not c.events[eventname] then
        --
        table.insert(c.events, eventname)
        --
        ExecuteCommand(("add_ace job.%s Server:Interact:%s:%s allow"):format(job,name,job))
        RegisterNetEvent(eventname, function(o)
            -- Invoker
            local src = source
            -- Server side entity
            local entity = NetworkGetEntityFromNetworkId(o.net)
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