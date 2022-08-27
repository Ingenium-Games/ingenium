-- ====================================================================================--

c.job = {} -- Function Table
c.jobs = {} -- DB Pull
c.jdex = {} -- Job Index for xJobs functions.
--[[
NOTES.
    -
    -
    -
]]--

-- ====================================================================================--

function c.job.GetJob(str)
    return c.jobs[str]
end

function c.job.GetJobs()
    return c.jobs
end

function c.job.IsBoss(name,grade) 
    if (#c.jobs[name].Grades == grade) then 
        return true 
    else 
        return false 
    end
end

local CurrentlyActive = {}

--- Return 
function c.job.ActiveMembers()
    local tab = {}
    for k,v in ipairs(CurrentlyActive) do
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
exports("JobsOnline", c.job.ActiveMembers())

--- 
---@param job string
---@param grade any
function c.job.Exist(name, grade)
	if name and grade then
		if c.jobs[tostring(name)].Grades[tonumber(grade)] then
			return true
		end
	end
	return false
end

--- Same as above.
---@param job string
---@param grade any
function c.DoesJobExist(name, grade)
    return c.job.Exist(name, grade)
end

RegisterNetEvent("Server:Character:OffDuty", function(req)
    local src = req or source
    local xPlayer = c.data.GetPlayer(src)
    if conf.enableduty then
        CurrentlyActive[src] = "OffDuty"
        xPlayer.SetDuty(false)
        TriggerClientEvent("Client:Character:OffDuty", src)
    else
        c.func.Debug_1("Ability to go off duty has ben disabled.")
    end
end)

RegisterNetEvent("Server:Character:OnDuty", function(req)
    local src = req or source
    local xPlayer = c.data.GetPlayer(src)
    if conf.enableduty then
        CurrentlyActive[src] = xPlayer.GetJob()
        xPlayer.SetDuty(true)
        TriggerClientEvent("Client:Character:OnDuty", src, CurrentlyActive[src])
    else
        c.func.Debug_1("Ability to go on duty has ben disabled.")
    end
end)

-- req = source or number id calling event if internal
-- t = {name = "police", grade = 1}, Job and then Grade
AddEventHandler("Server:Character:SetJob", function(req, data)
    local src = req or source
    CurrentlyActive[src] = "OffDuty"
    -- print(c.table.Dump(CurrentlyActive))
end)

-- cleanup the table to reduce crap.
AddEventHandler("playerDropped", function()
    local src = source
    CurrentlyActive[src] = false
end)

--- func desc
---@param bool boolean "Use the Job funds to pay all employees?" 
function c.job.Payroll(bool)
    local xCity = c.data.GetJob("City")
    for k,v in ipairs(CurrentlyActive) do
        if type(v) == "table" then
            -- CurrentlyActive[1] = [Name="popo",Grade=2,etc,etc]
            local xPlayer = c.data.GetPlayer(k)
            if xPlayer then
                local xJob = c.data.GetJob(CurrentlyActive[k].Name)
                local pay = xJob.GetGradeSalery(v.Grade)
                local tax = (pay / conf.default.tax) + 0.00
                local net = pay - tax
                --
                xPlayer.AddBank(net)
                TriggerClientEvent("Client:Notify", k, "Recieved Payment: $"..net.." deposided confirmed, city tax applied of: $"..tax..".")
                if bool then
                    xJob.RemoveBank(pay)
                    xCity.AddBank(tax)
                end
            end
        elseif v == "OffDuty" then
            TriggerClientEvent("Client:Notify", k, "Payroll for active staff paid.")
        end
    end
    c.func.Debug_1("Jobs Payed.")
end

function c.job.PayJob(Job, Amount)
    local xJob = c.data.GetJob(Job)
    xJob.AddBank(Amount)
end

function c.job.PayCycle()
    local function Do()
        c.job.Payroll(conf.enablejobpayroll)     
        -- Adding cleanup of empty or false records.
        for k,v in ipairs(CurrentlyActive) do
            -- Really make sure its a false record.
            if v == false then
                table.remove(CurrentlyActive, k)
            end
        end
        SetTimeout(conf.paycycle, Do)
    end
    SetTimeout(conf.paycycle, Do)
end
