-- ====================================================================================--

c.note = {} -- function level
c.notes = false -- dropped items table

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
function c.note.Load()
    if c.json.Exists(conf.file.notes) then
        local file = c.json.Read(conf.file.notes)
        c.notes = file
    else
        c.notes = {}
        c.json.Write(conf.file.notes, c.notes)
    end
    c.note.Update()
end

--- func desc
function c.note.Update()
    local function Do()
        c.json.Write(conf.file.notes, c.notes)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param data any
function c.note.Add(data)
    if type(data) == "table" then
        table.insert(c.notes, data)
    else
        c.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function c.note.Exist(id)
    if c.notes[id] then
        return true
    end
    return false
end

--- func desc
function c.note.Clean()
    if type(c.notes) == "table" then
        for k,v in pairs(c.notes) do
            if v then
                if (os.time() - v.Time) >= conf.file.cleanup then
                    table.remove(c.notes, k)            
                end
            end
        end
    end    
end

--- func desc
function c.note.CleanUp()
    local function Do()
        c.note.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end