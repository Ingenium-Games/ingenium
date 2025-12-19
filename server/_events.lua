-- ====================================================================================--
ig.event = {}
-- ====================================================================================--

--- func desc
---@param job string "Jobname used fro role permissions"
---@param name string "The final argument f the event"
---@param cb function "The function to call post event being triggered and once confirmed user is able to action event."
function ig.event.AddInteractJobEvent(job, name, cb)
    local eventname = ("Server:Interact:%s"):format(name)
    ExecuteCommand(("add_ace job.%s Server:Interact:%s allow"):format(job, name))
    RegisterNetEvent(eventname, function(options)
        local src = source
        local o = options
        -- Does Invoker have permissions to trigger this event, ig.target checks thier job prior to permiting
        if IsPlayerAceAllowed(src, eventname) then
            -- Do Actions...
            cb(src, o)
        else
            ig.func.Eventban(src, eventname)
        end
    end)
    return eventname
end
