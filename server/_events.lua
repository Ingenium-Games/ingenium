-- ====================================================================================--
-- Event handlers (ig.event initialized in server/_var.lua)
-- ====================================================================================--

-- Registry to store registered events and their allowed jobs
ig.event._eventRegistry = {}

--- Gets the current event registry
---@return table Event registry with events and their jobs
function ig.event.GetEventRegistry()
    return ig.event._eventRegistry
end

--- Gets the current event registry
---@return table Event registry with events and their jobs
function ig.event.GenerateRegistryLog()
    if conf.events.generateRegistry then
        ig.json.Write('job_events', ig.event._eventRegistry)
        ig.log.Debug("Server", "Event registry generated and saved to job_events.json, Dont forget to make client sided handles!")
    end
end

--- func desc
---@param job string|table "Jobname(s) used for role permissions - can be string or array of strings"
---@param name string "The final argument of the event"
---@param cb function "The function to call post event being triggered and once confirmed user is able to action event."
function ig.event.AddInteractJobEvent(job, name, cb)
    local eventname = ("Server:Interact:%s"):format(name)
    
    -- Handle job as array or string
    local jobs = {}
    if type(job) == "table" then
        jobs = job
    elseif type(job) == "string" then
        jobs = {job}
    else
        -- Invalid type, return false
        return false
    end
    
    -- Execute command for each job
    for _, j in ipairs(jobs) do
        ExecuteCommand(("add_ace job.%s Server:Interact:%s allow"):format(j, name))
    end
    
    -- Register the event in our registry
    ig.event._eventRegistry[name] = jobs
    
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
