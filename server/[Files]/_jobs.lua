-- ====================================================================================--
ig.job = ig.job or {} -- function level
ig.jobs = ig.jobs or {} -- dropped items table
-- ====================================================================================--

--[[    
            {
                [UUID] = {
                    ["UUID"] = UUID String
                    ["NetID"] = Network ID
                    ["Coords"] = {x, y, z, h}
                    ["Model"] = Model hash
                    ["Inventory"] = [{Item, Quantity, Quality, Weapon, Meta}]
                    ["Created"] = Timestamp
                    ["Updated"] = Timestamp
                },
    
            }
    ]] --

--- func desc
---@param data any
function ig.job.Add(data)
    if type(data) == "table" then
        table.insert(ig.jobs, data)
    else
        ig.func.Debug_1("Job to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function ig.job.Exist(id)
    if ig.jobs[id] then
        return true
    end
    return false
end

--- func desc
function ig.job.Resync()
    local jobs = ig.jobs
    TriggerClientEvent("Client:Jobs:Update", -1, jobs)
end

-- ====================================================================================--
-- Enhanced Job System File Helpers (complement to _jobs.lua in [Objects])
-- ====================================================================================--

---Get all jobs
---@return table All jobs
function ig.job.GetAll()
    return ig.jobs
end

---Get job by name
---@param name string Job name
---@return table|nil Job data or nil
function ig.job.GetByName(name)
    return ig.jobs[name]
end

---Check if job exists
---@param name string Job name
---@param grade number|nil Grade (if checking specific grade)
---@return boolean True if exists
function ig.job.Exists(name, grade)
    if not ig.jobs[name] then
        return false
    end
    
    if grade then
        return ig.jobs[name].Grades and ig.jobs[name].Grades[grade] ~= nil
    end
    
    return true
end

---Get all job members
---@param jobName string Job name
---@return table Array of member IDs
function ig.job.GetMembers(jobName)
    local job = ig.jobs[jobName]
    if not job then
        return {}
    end
    
    return job.Members or {}
end

---Get online members of a job
---@param jobName string Job name
---@return table Array of online player objects
function ig.job.GetOnlineMembers(jobName)
    local result = {}
    
    for _, xPlayer in pairs(ig.pdex or {}) do
        if xPlayer and xPlayer.GetJob().Name == jobName then
            table.insert(result, xPlayer)
        end
    end
    
    return result
end

---Get online members by grade
---@param jobName string Job name
---@param grade number Grade level
---@return table Array of online player objects
function ig.job.GetOnlineMembersByGrade(jobName, grade)
    local result = {}
    
    for _, xPlayer in pairs(ig.pdex or {}) do
        if xPlayer then
            local job = xPlayer.GetJob()
            if job.Name == jobName and job.Grade == grade then
                table.insert(result, xPlayer)
            end
        end
    end
    
    return result
end

---Get boss players of a job
---@param jobName string Job name
---@return table Array of boss player objects
function ig.job.GetBosses(jobName)
    local job = ig.jobs[jobName]
    if not job then
        return {}
    end
    
    local maxGrade = #job.Grades
    return ig.job.GetOnlineMembersByGrade(jobName, maxGrade)
end

---Get grade information
---@param jobName string Job name
---@param grade number Grade level
---@return table|nil Grade data or nil
function ig.job.GetGradeInfo(jobName, grade)
    local job = ig.jobs[jobName]
    if not job or not job.Grades then
        return nil
    end
    
    return job.Grades[grade]
end

---Get grade name
---@param jobName string Job name
---@param grade number Grade level
---@return string Grade name or "Unknown"
function ig.job.GetGradeName(jobName, grade)
    local gradeInfo = ig.job.GetGradeInfo(jobName, grade)
    return gradeInfo and gradeInfo.Grade_Name or "Unknown"
end

---Get grade salary
---@param jobName string Job name
---@param grade number Grade level
---@return number Salary amount
function ig.job.GetGradeSalary(jobName, grade)
    local gradeInfo = ig.job.GetGradeInfo(jobName, grade)
    return gradeInfo and gradeInfo.Grade_Salary or 0
end

---Check if grade is boss
---@param jobName string Job name
---@param grade number Grade level
---@return boolean True if boss grade
function ig.job.IsBossGrade(jobName, grade)
    local job = ig.jobs[jobName]
    if not job or not job.Grades then
        return false
    end
    
    return grade == #job.Grades
end

---Get job count
---@return number Number of jobs
function ig.job.GetCount()
    local count = 0
    for _ in pairs(ig.jobs) do
        count = count + 1
    end
    return count
end

---Get jobs by type/category
---@param category string Category (e.g., "public", "private", "gang")
---@return table Array of jobs
function ig.job.GetByCategory(category)
    local result = {}
    
    for name, job in pairs(ig.jobs) do
        if job.Category == category then
            table.insert(result, {name = name, job = job})
        end
    end
    
    return result
end

---Get active duty count for job
---@param jobName string Job name
---@return number Number of on-duty members
function ig.job.GetOnDutyCount(jobName)
    local count = 0
    
    for _, xPlayer in pairs(ig.pdex or {}) do
        if xPlayer and xPlayer.GetJob().Name == jobName and xPlayer.OnDuty() then
            count = count + 1
        end
    end
    
    return count
end

---Get total member count (online + offline)
---@param jobName string Job name
---@return number Total members
function ig.job.GetTotalMemberCount(jobName)
    local job = ig.jobs[jobName]
    if not job or not job.Members then
        return 0
    end
    
    return #job.Members
end

---Get job statistics
---@param jobName string Job name
---@return table Statistics
function ig.job.GetStats(jobName)
    local job = ig.jobs[jobName]
    if not job then
        return nil
    end
    
    local online = #ig.job.GetOnlineMembers(jobName)
    local onDuty = ig.job.GetOnDutyCount(jobName)
    local total = ig.job.GetTotalMemberCount(jobName)
    
    return {
        name = jobName,
        totalMembers = total,
        onlineMembers = online,
        onDutyMembers = onDuty,
        grades = #(job.Grades or {}),
        safeBalance = job.Accounts and job.Accounts.Safe or 0,
        bankBalance = job.Accounts and job.Accounts.Bank or 0
    }
end

---Get all job statistics
---@return table Array of job statistics
function ig.job.GetAllStats()
    local result = {}
    
    for name, _ in pairs(ig.jobs) do
        local stats = ig.job.GetStats(name)
        if stats then
            table.insert(result, stats)
        end
    end
    
    -- Sort by online members (highest first)
    table.sort(result, function(a, b) return a.onlineMembers > b.onlineMembers end)
    
    return result
end

---Find jobs hiring (with open positions)
---@return table Array of jobs with open positions
function ig.job.GetHiring()
    local result = {}
    
    for name, job in pairs(ig.jobs) do
        if job.MaxMembers and #(job.Members or {}) < job.MaxMembers then
            table.insert(result, {
                name = name,
                job = job,
                openings = job.MaxMembers - #job.Members
            })
        end
    end
    
    return result
end

---Get richest jobs (by combined accounts)
---@param limit number|nil Number of results (default 10)
---@return table Array of richest jobs
function ig.job.GetRichest(limit)
    local limit = limit or 10
    local result = {}
    
    for name, job in pairs(ig.jobs) do
        if job.Accounts then
            local total = (job.Accounts.Safe or 0) + (job.Accounts.Bank or 0)
            table.insert(result, {
                name = name,
                job = job,
                totalWealth = total,
                safe = job.Accounts.Safe or 0,
                bank = job.Accounts.Bank or 0
            })
        end
    end
    
    -- Sort by wealth (highest first)
    table.sort(result, function(a, b) return a.totalWealth > b.totalWealth end)
    
    -- Limit results
    local limited = {}
    for i = 1, math.min(limit, #result) do
        table.insert(limited, result[i])
    end
    
    return limited
end

---Get job by boss character ID
---@param characterId string Character ID
---@return string|nil Job name or nil
function ig.job.GetByBoss(characterId)
    for name, job in pairs(ig.jobs) do
        if job.Boss == characterId then
            return name
        end
    end
    
    return nil
end

---Check if character is boss of any job
---@param characterId string Character ID
---@return boolean True if boss, string Job name or nil
function ig.job.IsBossOfAny(characterId)
    local jobName = ig.job.GetByBoss(characterId)
    return jobName ~= nil, jobName
end

---Get players eligible for payroll
---@param jobName string|nil Specific job or nil for all
---@return table Array of player data for payroll
function ig.job.GetPayrollEligible(jobName)
    local result = {}
    
    for _, xPlayer in pairs(ig.pdex or {}) do
        if xPlayer and xPlayer.OnDuty() then
            local job = xPlayer.GetJob()
            
            if not jobName or job.Name == jobName then
                local salary = ig.job.GetGradeSalary(job.Name, job.Grade)
                
                table.insert(result, {
                    player = xPlayer,
                    source = xPlayer.GetID(),
                    characterId = xPlayer.GetCharacter_ID(),
                    jobName = job.Name,
                    grade = job.Grade,
                    salary = salary
                })
            end
        end
    end
    
    return result
end

---Calculate total payroll for job
---@param jobName string Job name
---@return number Total payroll amount
function ig.job.CalculatePayroll(jobName)
    local eligible = ig.job.GetPayrollEligible(jobName)
    local total = 0
    
    for _, entry in ipairs(eligible) do
        total = total + entry.salary
    end
    
    return total
end

---Process payroll for job
---@param jobName string Job name
---@param useJobFunds boolean Use job bank account (true) or spawn money (false)
---@return number Number of players paid, number Total amount paid
function ig.job.ProcessPayroll(jobName, useJobFunds)
    local eligible = ig.job.GetPayrollEligible(jobName)
    local xJob = ig.data.GetJob(jobName)
    
    if not xJob then
        return 0, 0
    end
    
    local totalPaid = 0
    local playersPaid = 0
    
    for _, entry in ipairs(eligible) do
        local salary = entry.salary
        local tax = (salary / conf.default.tax) + 0.00
        local net = salary - tax
        
        -- Check if job has funds
        if useJobFunds then
            if xJob.GetBank() >= salary then
                entry.player.AddBank(net)
                xJob.RemoveBank(salary)
                
                -- Pay tax to city
                local xCity = ig.data.GetJob("city")
                if xCity then
                    xCity.AddBank(tax)
                end
                
                totalPaid = totalPaid + salary
                playersPaid = playersPaid + 1
            else
                ig.func.Debug_1("Job " .. jobName .. " has insufficient funds for payroll")
            end
        else
            -- Spawn money (no job funds check)
            entry.player.AddBank(net)
            totalPaid = totalPaid + salary
            playersPaid = playersPaid + 1
        end
    end
    
    ig.func.Debug_2("Payroll for " .. jobName .. ": Paid " .. playersPaid .. " players $" .. totalPaid)
    
    return playersPaid, totalPaid
end

---Search jobs
---@param searchTerm string Search term
---@return table Array of matching jobs
function ig.job.Search(searchTerm)
    local result = {}
    local lowerSearch = searchTerm:lower()
    
    for name, job in pairs(ig.jobs) do
        if name:lower():find(lowerSearch) or 
           (job.Label and job.Label:lower():find(lowerSearch)) then
            table.insert(result, {name = name, job = job})
        end
    end
    
    return result
end

---Resync job data to client
---@param source number Player source
---@param jobName string|nil Specific job or nil for all
function ig.job.Resync(source, jobName)
    if jobName then
        local job = ig.jobs[jobName]
        if job then
            TriggerClientEvent("Client:Job:Update", source, jobName, job)
        end
    else
        TriggerClientEvent("Client:Jobs:Sync", source, ig.jobs)
    end
end

---Validate job data
---@param jobData table Job data to validate
---@return boolean, string True if valid, or false with error
function ig.job.ValidateData(jobData)
    if type(jobData) ~= "table" then
        return false, "Job data must be a table"
    end
    
    -- Required fields
    if not jobData.Name or type(jobData.Name) ~= "string" then
        return false, "Missing or invalid Name"
    end
    
    if not jobData.Label or type(jobData.Label) ~= "string" then
        return false, "Missing or invalid Label"
    end
    
    if not jobData.Grades or type(jobData.Grades) ~= "table" or #jobData.Grades == 0 then
        return false, "Missing or invalid Grades"
    end
    
    return true, "Valid"
end