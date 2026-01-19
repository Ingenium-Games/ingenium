-- ====================================================================================--
-- Job Management Commands (requires ACE permissions)
-- ====================================================================================--

--- Create a new job (Developer/Admin only)
---@param source number Player source
---@param args table Command arguments {jobName, label, description}
RegisterCommand("createjob", function(source, args)
    -- Check ACE permission
    if not IsPlayerAceAllowed(source, "command.createjob") then
        TriggerClientEvent("Client:Notify", source, "You do not have permission to create jobs.", "red", 5000)
        return
    end
    
    -- Validate arguments
    if #args < 2 then
        TriggerClientEvent("Client:Notify", source, "Usage: /createjob [jobName] [label] [description]", "orange", 5000)
        return
    end
    
    local jobName = args[1]:lower()
    local label = args[2]
    local description = table.concat(args, " ", 3) or "No description provided"
    
    -- Check if job already exists
    if ig.jobs[jobName] then
        TriggerClientEvent("Client:Notify", source, "Job '" .. jobName .. "' already exists!", "red", 5000)
        return
    end
    
    -- Create new job structure
    local newJob = {
        label = label,
        description = description,
        boss = nil,
        grades = {
            ["Employee"] = {
                org = label,
                rank = 1,
                pay = 15,
                isBoss = false
            },
            ["Manager"] = {
                org = label,
                rank = 2,
                pay = 25,
                isBoss = false
            },
            ["Owner"] = {
                org = label,
                rank = 3,
                pay = 35,
                isBoss = true
            }
        },
        members = {},
        prices = {},
        locations = {
            sales = {},
            delivery = {},
            safe = nil
        },
        memos = {},
        settings = {
            showFinancials = true,
            allowEmployeeActions = true
        }
    }
    
    -- Add to runtime jobs table
    ig.jobs[jobName] = newJob
    
    -- Save to JSON file
    ig.json.Write(conf.file.jobs, ig.jobs)
    
    -- Create job object in jdex
    ig.jdex[jobName] = ig.class.Job({
        Name = jobName,
        Label = label,
        Description = description,
        Boss = nil,
        Grades = newJob.grades,
        Members = {},
        Prices = {},
        Locations = newJob.locations,
        Memos = {},
        Settings = newJob.settings,
        Inventory = json.encode({}),
        Stock = json.encode({}),
        Updated = ig.func.Timestamp()
    })
    
    -- Log action
    ig.log.Info("Job", "Created new job: " .. jobName .. " (" .. label .. ") by source " .. source)
    
    -- Notify admin
    TriggerClientEvent("Client:Notify", source, "Successfully created job: " .. label, "green", 5000)
    
end, false)

--- Add ACE permission for createjob command
-- Add to server.cfg: add_ace group.admin command.createjob allow

--- Delete a job (Developer/Admin only)
---@param source number Player source
---@param args table Command arguments {jobName}
RegisterCommand("deletejob", function(source, args)
    -- Check ACE permission
    if not IsPlayerAceAllowed(source, "command.deletejob") then
        TriggerClientEvent("Client:Notify", source, "You do not have permission to delete jobs.", "red", 5000)
        return
    end
    
    -- Validate arguments
    if #args < 1 then
        TriggerClientEvent("Client:Notify", source, "Usage: /deletejob [jobName]", "orange", 5000)
        return
    end
    
    local jobName = args[1]:lower()
    
    -- Prevent deleting core jobs
    if jobName == "none" or jobName == "police" or jobName == "medic" then
        TriggerClientEvent("Client:Notify", source, "Cannot delete core job: " .. jobName, "red", 5000)
        return
    end
    
    -- Check if job exists
    if not ig.jobs[jobName] then
        TriggerClientEvent("Client:Notify", source, "Job '" .. jobName .. "' does not exist!", "red", 5000)
        return
    end
    
    -- Remove from runtime tables
    ig.jobs[jobName] = nil
    ig.jdex[jobName] = nil
    
    -- Save to JSON file
    ig.json.Write(conf.file.jobs, ig.jobs)
    
    -- Log action
    ig.log.Info("Job", "Deleted job: " .. jobName .. " by source " .. source)
    
    -- Notify admin
    TriggerClientEvent("Client:Notify", source, "Successfully deleted job: " .. jobName, "green", 5000)
    
    -- TODO: Handle players currently employed at this job (reassign to "none")
    
end, false)

--- Add ACE permission for deletejob command
-- Add to server.cfg: add_ace group.admin command.deletejob allow

--- List all jobs (Admin only)
---@param source number Player source
RegisterCommand("listjobs", function(source, args)
    -- Check ACE permission
    if not IsPlayerAceAllowed(source, "command.listjobs") then
        TriggerClientEvent("Client:Notify", source, "You do not have permission to list jobs.", "red", 5000)
        return
    end
    
    local count = 0
    local jobList = "^3Available Jobs:^0\n"
    
    for jobName, jobData in pairs(ig.jobs) do
        count = count + 1
        local label = jobData.label or jobName
        local memberCount = jobData.members and #jobData.members or 0
        jobList = jobList .. string.format("  %d. %s (%s) - %d members\n", count, label, jobName, memberCount)
    end
    
    print(jobList)
    TriggerClientEvent("Client:Notify", source, "Job list printed to server console (F8)", "green", 5000)
    
end, false)

--- Add ACE permission for listjobs command
-- Add to server.cfg: add_ace group.admin command.listjobs allow

-- ====================================================================================--
-- Exports for other resources
-- ====================================================================================--

--- Export: Create job dynamically
---@param jobName string Job identifier
---@param jobData table Job structure
exports("CreateJob", function(jobName, jobData)
    if not jobName or not jobData then
        return false, "Missing required parameters"
    end
    
    if ig.jobs[jobName] then
        return false, "Job already exists"
    end
    
    -- Add to runtime
    ig.jobs[jobName] = jobData
    
    -- Save to file
    ig.json.Write(conf.file.jobs, ig.jobs)
    
    -- Create job object
    ig.jdex[jobName] = ig.class.Job({
        Name = jobName,
        Label = jobData.label,
        Description = jobData.description,
        Boss = jobData.boss,
        Grades = jobData.grades,
        Members = jobData.members or {},
        Prices = jobData.prices or {},
        Locations = jobData.locations or {sales = {}, delivery = {}, safe = nil},
        Memos = jobData.memos or {},
        Settings = jobData.settings or {showFinancials = true, allowEmployeeActions = true},
        Inventory = json.encode({}),
        Stock = json.encode({}),
        Updated = ig.func.Timestamp()
    })
    
    ig.log.Info("Job", "Dynamically created job: " .. jobName)
    return true, "Job created successfully"
end)

--- Export: Delete job dynamically
---@param jobName string Job identifier
exports("DeleteJob", function(jobName)
    if not jobName then
        return false, "Missing job name"
    end
    
    -- Prevent deleting core jobs
    if jobName == "none" or jobName == "police" or jobName == "medic" then
        return false, "Cannot delete core job"
    end
    
    if not ig.jobs[jobName] then
        return false, "Job does not exist"
    end
    
    -- Remove from runtime
    ig.jobs[jobName] = nil
    ig.jdex[jobName] = nil
    
    -- Save to file
    ig.json.Write(conf.file.jobs, ig.jobs)
    
    ig.log.Info("Job", "Dynamically deleted job: " .. jobName)
    return true, "Job deleted successfully"
end)
