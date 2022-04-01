-- ====================================================================================--
c.event = {}
c.events = {}
--[[
NOTES
    -
]] --
-- ====================================================================================--

--- func desc
---@param job string "Jobname used fro role permissions"
---@param name string "The final argument f the event"
---@param cb function "The function to call post event being triggered and once confirmed user is able to action event."
function c.event.AddInteractJobEvent(job, name, cb)
    local eventname = ("Server:Interact:%s"):format(name)
    if not c.events[eventname] then
        --
        table.insert(c.events, eventname)
        --
        ExecuteCommand(("add_ace job.%s Server:Interact:%s allow"):format(job,name))
        RegisterNetEvent(eventname, function(...)
            -- Invoker
            local src = source
            -- Does Invoker have permissions to trigger this event, ig.target checks thier job prior to permiting
            if IsPlayerAceAllowed(src, eventname) then
                -- Do Actions...
                cb(...)
            else
                c.eventban(src, eventname)
            end
        end)
        return eventname
    else
        print("event name already taken")
    end
end