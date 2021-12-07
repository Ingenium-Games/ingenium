-- ====================================================================================--

if not c.sql then c.sql = {} end
--
c.sql.jobs = {}
--[[
NOTES.
    - All sql querys should have a call back as a function at the end to chain code execution upon completion.
    - All data should be encoded or decoded here, if possible. the fetchALL commands are decoded in the _data.lua
]] --

-- ====================================================================================--

--- Takes Job information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function c.sql.jobs.GetAll(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM `jobs`', {
    }, function(data)
        for i=1, #data, 1 do
            local i = data[i]
            if not c.jobs[i.Name] then
                c.jobs[i.Name] = {}
                c.jobs[i.Name].Label = i.Label
                c.jobs[i.Name].Grades = {}
            end
            c.jobs[i.Name].Grades[i.Grade] = {["Grade_Label"] = i.Grade_Label, ["Grade_Salary"] = i.Grade_Salary}
        end
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
end

--- Takes Job_Accounts information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function c.sql.jobs.Setup(cb)
    local IsBusy = true
    MySQL.Async.fetchAll('SELECT * FROM `job_accounts`', {
    }, function(data)
            for k,v in pairs(c.jobs) do
                local found = false
                for i=1, #data, 1 do
                    if data[i].Name == k then
                        found = true
                        break
                    end 
                end
                if not found then -- if not found within the job_accounts
                    MySQL.Async.execute('INSERT INTO `job_accounts` (`Name`, `Description`, `Boss`, `Members`, `Accounts`) VALUES (@Name, @Description, @Boss, @Members, @Accounts);', {
                        ['@Name'] = k,
                        ['@Description'] = v.Label.." : Description for role here.",
                        ['@Boss'] = "Not Owned",
                        ['@Members'] = json.encode({}),
                        ['@Accounts'] = json.encode(conf.default.jobaccounts),
                    }, function(_data)
                        if _data then
                            --
                        end
                    end)
                end
            end
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
end

--- Takes Job information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function c.sql.jobs.Accounts(cb)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll('SELECT * FROM `job_accounts`', {
    }, function(data)
        for i=1, #data, 1 do
            local i = data[i]
            if not c.jobs[i.Name] then
                c.debug_1("Please run GetAll(), followed by Setup() before this...")
            end
            c.jobs[i.Name].Accounts = json.decode(i.Accounts)
            c.jobs[i.Name].Members = json.decode(i.Members)
            c.jobs[i.Name].Boss = i.Boss
            c.jobs[i.Name].Name = i.Name
            c.jobs[i.Name].Description = i.Description
        end
        IsBusy = false
    end)
    while IsBusy do
        Wait(0)
    end
    if cb then
        cb()
    end
end