-- ====================================================================================--
ig.job = {} -- Function Table
ig.jobs = {} -- DB Pull
ig.jdex = {} -- Job Index for xJobs functions.
-- ====================================================================================--

--- func desc
---@param str any
function ig.job.GetJob(str)
    return ig.jobs[str]
end

--- func desc
function ig.job.GetJobs()
    return ig.jobs
end

--- func desc
---@param name any
---@param grade any
function ig.job.IsBoss(name, grade)
    if (#ig.jobs[name].Grades == grade) then
        return true
    else
        return false
    end
end

local CurrentlyActive = {}

--- Return 
--- func desc
function ig.job.ActiveMembers()
    local tab = {}
    for k, v in ipairs(CurrentlyActive) do
        if v then
            if not tab[v.Name] then
                table.insert(tab, v.Name)
                tab[v.Name] = 1
            else
                tab[v.Name] = tab[v.Name] + 1
            end
        end
    end
    return tab
end

-- Testing purposes Only
exports("JobsOnline", ig.job.ActiveMembers())

--- 
---@param job string
---@param grade any
function ig.job.Exist(name, grade)
    if name and grade then
        if ig.jobs[tostring(name)].Grades[tonumber(grade)] then
            return true
        end
    end
    return false
end

--- Same as above.
---@param job string
---@param grade any
function ig.DoesJobExist(name, grade)
    return ig.job.Exist(name, grade)
end

RegisterNetEvent("Server:Character:OffDuty", function(req)
    local src = req or source
    local xPlayer = ig.data.GetPlayer(src)
    if conf.enableduty then
        CurrentlyActive[src] = "OffDuty"
        xPlayer.SetDuty(false)
        xPlayer.Notify("Off Duty")
        TriggerClientEvent("Client:Character:OffDuty", src)
    else
        ig.funig.Debug_1("Ability to go off duty has ben disabled.")
    end
end)

RegisterNetEvent("Server:Character:OnDuty", function(req)
    local src = req or source
    local xPlayer = ig.data.GetPlayer(src)
    if conf.enableduty then
        CurrentlyActive[src] = xPlayer.GetJob()
        xPlayer.SetDuty(true)
        xPlayer.Notify("On Duty")
        TriggerClientEvent("Client:Character:OnDuty", src, CurrentlyActive[src])
    else
        ig.funig.Debug_1("Ability to go on duty has ben disabled.")
    end
end)

-- req = source or number id calling event if internal
-- t = {name = "police", grade = 1}, Job and then Grade
AddEventHandler("Server:Character:SetJob", function(req, data)
    local src = req or source
    CurrentlyActive[src] = "OffDuty"
    -- print(ig.table.Dump(CurrentlyActive))
end)

-- cleanup the table to reduce crap.
AddEventHandler("playerDropped", function()
    local src = source
    CurrentlyActive[src] = false
end)

--- func desc
---@param bool boolean "Use the Job funds to pay all employees?" 
function ig.job.Payroll(bool)
    if ig.data.ArePlayersActive() then
        local xCity = ig.data.GetJob("city")
        for k, v in ipairs(CurrentlyActive) do
            if type(v) == "table" then
                -- CurrentlyActive[1] = [Name="popo",Grade=2,etc,etc]
                local xPlayer = ig.data.GetPlayer(k)
                if xPlayer then
                    if xPlayer.OnDuty() then
                        local xJob = ig.data.GetJob(CurrentlyActive[k].Name)
                        local pay = xJob.GetGradeSalery(v.Grade)
                        local tax = (pay / conf.default.tax) + 0.00
                        local net = pay - tax
                        --
                        xPlayer.AddBank(net)
                        if bool then
                            xJob.RemoveBank(pay)
                            xCity.AddBank(tax)
                        end
                    end
                end
            end
        end
        ig.funig.Debug_1("Jobs Payed.")
    end
end

--- func desc
---@param Job any
---@param Amount any
function ig.job.PayJob(Job, Amount)
    local xJob = ig.data.GetJob(Job)
    xJob.AddBank(Amount)
end

--- func desc
function ig.job.PayCycle()
    local function Do()
        ig.job.Payroll(conf.enablejobpayroll)
        -- Adding cleanup of empty or false records.
        for k, v in ipairs(CurrentlyActive) do
            -- Really make sure its a false record.
            if v == false then
                table.remove(CurrentlyActive, k)
            end
        end
        SetTimeout(conf.paycycle, Do)
    end
    SetTimeout(conf.paycycle, Do)
end
