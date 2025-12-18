-- ====================================================================================--
ig.gsr = {} -- function level
ig.gsrs = {} -- dropped items table
-- ====================================================================================--
 
--[[    
        {
            [ID] = {
                ["Coords"] = {0,0,0} -- Vecotr3
                ["Cash"] = NUMBER
                ["Model"] = hash
                ["Serial"] = SERIAL_ID
                ["Time"] = TIME  -- os.time() when created.
            },

        }
]]--
    
--- func desc
---@param . any
function ig.gsr.Load()
    if ig.json.Exists(conf.file.gsr) then
        ig.gsrs = ig.json.Read(conf.file.gsr)
    else
        ig.gsrs = {}
        ig.json.Write(conf.file.gsr, ig.gsrs)
    end
    ig.gsr.Update()
end


--- func desc
function ig.gsr.Update()
    local function Do()
        ig.json.Write(conf.file.gsr, ig.gsrs)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param data any
function ig.gsr.Add(data)
    if type(data) == "table" then
        table.insert(ig.gsrs, data)
    else
        ig.funig.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function ig.gsr.Exist(id)
    if ig.gsrs[id] then
        return true
    end
    return false
end

--- func desc
function ig.gsr.Clean()
    if type(ig.gsrs) == "table" then
        for k,v in pairs(ig.gsrs) do
            if v then
                if (os.time() - v.Time) >= conf.file.cleanup then
                    table.remove(ig.gsrs, k)            
                end
            end
        end
    end
end

--- func desc
function ig.gsr.CleanUp()
    local function Do()
        ig.gsr.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end