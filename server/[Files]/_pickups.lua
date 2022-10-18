-- ====================================================================================--

c.pick = {} -- function level
c.picks = false -- dropped items table

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
function c.pick.Load()
    if c.json.Exists(conf.file.pickups) then
        local file = c.json.Read(conf.file.pickups)
        c.picks = file
    else
        c.picks = {}
        c.json.Write(conf.file.pickups, c.picks)
        c.pick.Update()
    end
end

--- func desc
function c.pick.Update()
    local function Do()
        c.json.Write(conf.file.pickups, c.picks)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param data any
function c.pick.Add(data)
    if type(data) == "table" then
        table.insert(c.picks, data)
    else
        c.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function c.pick.Exist(id)
    if c.picks[id] then
        return true
    end
    return false
end

--- func desc
function c.pick.Clean()
    if type(c.picks) == "table" then
        for k,v in pairs(c.picks) do
            if v then        
                if (os.time() - v.Time) >= conf.file.cleanup then
                    table.remove(c.picks, k)            
                end
            end
        end
    end
end

--- func desc
function c.pick.CleanUp()
    local function Do()
        c.pick.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end