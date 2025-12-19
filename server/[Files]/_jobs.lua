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
