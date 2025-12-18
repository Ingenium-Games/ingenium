-- ====================================================================================--
if not ig.sql then ig.sql = {} end
ig.sql.jobs = {}
-- ====================================================================================--

--- Takes Job information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function ig.sql.jobs.Generate(cb)
    local data = ig.sql.Query("SELECT * FROM `jobs`", {})
    for i=1, #data, 1 do
        local i = data[i]
        if not ig.jobs[i.Name] then
            ig.jobs[i.Name] = {}
            ig.jobs[i.Name].Label = i.Label
            ig.jobs[i.Name].Grades = {}
        end
        ig.jobs[i.Name].Grades[i.Grade] = {["Grade_Label"] = i.Grade_Label, ["Grade_Salary"] = i.Grade_Salary}
    end
    if cb then
        cb()
    end
end

--- Takes Job_Accounts information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function ig.sql.jobs.Setup(cb)
    local data = ig.sql.Query("SELECT * FROM `job_accounts`", {})
    for k,v in pairs(ig.jobs) do
        local found = false
        for i=1, #data, 1 do
            if data[i].Name == k then
                found = true
                break
            end 
        end
        if not found then -- if not found within the job_accounts
            ig.sql.Insert(
                "INSERT INTO `job_accounts` (`Name`, `Description`, `Boss`, `Members`, `Accounts`) VALUES (?, ?, ?, ?, ?);",
                {k, v.Label.." : Description for role here.", "Not Owned", json.encode({}), json.encode(conf.default.jobaccounts)},
                function(insertId)
                    -- Insert completed
                end)
        end
    end
    if cb then
        cb()
    end
end

--- Takes Job information from the Database and imports it into the Server Upon the Initialise() function.
---@param cb function "Callback function if any, called after the SQL statement."
function ig.sql.jobs.Accounts(cb)
    local data = ig.sql.Query("SELECT * FROM `job_accounts`", {})
    for i=1, #data, 1 do
        local i = data[i]
        if not ig.jobs[i.Name] then
            ig.funig.Debug_1("Please run GetAll(), followed by Setup() before this...")
        end
        ig.jobs[i.Name].Accounts = json.decode(i.Accounts)
        ig.jobs[i.Name].Members = json.decode(i.Members)
        ig.jobs[i.Name].Boss = i.Boss
        ig.jobs[i.Name].Name = i.Name
        ig.jobs[i.Name].Description = i.Description
    end
    if cb then
        cb()
    end
end