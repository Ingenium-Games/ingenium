-- ====================================================================================--
ig.note = {} -- function level
ig.notes = false -- dropped items table
-- ====================================================================================--
    
--[[    
        {
            [ID] = {   
                ["Coords"] = {0,0,0} -- Vecotr3
                ["Note"] = Multiline String
                ["Time"] = TIME  -- os.time() when created.
                ["Event"] = Trigger()
            },

        }
]]--

--- func desc
function ig.note.Load()
    if ig.json.Exists(conf.file.notes) then
        local file = ig.json.Read(conf.file.notes)
        ig.notes = file
    else
        ig.notes = {}
        ig.json.Write(conf.file.notes, ig.notes)
    end
    ig.note.Update()
end

--- func desc
function ig.note.Update()
    local function Do()
        ig.json.Write(conf.file.notes, ig.notes)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param data any
function ig.note.Add(data)
    if type(data) == "table" then
        table.insert(ig.notes, data)
    else
        ig.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function ig.note.Exist(id)
    if ig.notes[id] then
        return true
    end
    return false
end

--- func desc
function ig.note.Clean()
    if type(ig.notes) == "table" then
        for k,v in pairs(ig.notes) do
            if v then
                if (os.time() - v.Time) >= conf.file.cleanup then
                    table.remove(ig.notes, k)            
                end
            end
        end
    end    
end

--- func desc
function ig.note.CleanUp()
    local function Do()
        ig.note.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end