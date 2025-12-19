-- ====================================================================================--
ig.pick = {} -- function level
ig.picks = false -- dropped items table
-- ====================================================================================--
    
--[[    
        {
            [ID] = {   
                ["Coords"] = {0,0,0} -- Vecotr3
                ["Model"] = hash
                ["Time"] = TIME  -- os.time() when created.
                ["Event"] = Trigger()
            },

        }
]]--
    
--- func desc
---@param . any
function ig.pick.Load()
    if ig.json.Exists(conf.file.pickups) then
        local file = ig.json.Read(conf.file.pickups)
        ig.picks = file
    else
        ig.picks = {}
        ig.json.Write(conf.file.pickups, ig.picks)
    end
    ig.pick.Update()
end

--- func desc
function ig.pick.Update()
    local function Do()
        ig.json.Write(conf.file.pickups, ig.picks)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param data any
function ig.pick.Add(data)
    if type(data) == "table" then
        table.insert(ig.picks, data)
    else
        ig.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function ig.pick.Exist(id)
    if ig.picks[id] then
        return true
    end
    return false
end

--- func desc
function ig.pick.Clean()
    if type(ig.picks) == "table" then
        for k,v in pairs(ig.picks) do
            if v then        
                if (os.time() - v.Time) >= conf.file.cleanup then
                    table.remove(ig.picks, k)            
                end
            end
        end
    end
end

--- func desc
function ig.pick.CleanUp()
    local function Do()
        ig.pick.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end