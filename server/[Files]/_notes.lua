-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.note = {} -- function level
c.notes = false -- dropped items table
--[[
NOTES.
    -
    -
    -
]] --

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

function c.note.Load()
    if c.json.Exists(conf.file.notes) then
        local file = c.json.Read(conf.file.notes)
        c.notes = file
    else
        c.notes = {}
        c.json.Write(conf.file.notes, c.notes)
    end
end

function c.note.Add(data)
    local id = c.note.NewID()
    if type(data) == "table" then
        table.insert(c.notes, id)
        c.notes[id] = data
    else
        c.debug_1("Drop to be added, please check data sent.")
    end
end

function c.note.NewID()
    local found = false
    local new = nil
    repeat
        new = c.rng.chars(20)
        if c.notes[new] then
            found = true
        end
    until found == false 
    return new
end

function c.note.Exist(id)
    if c.notes[id] then
        return true
    end
    return false
end

function c.note.Clean()
    if type(c.notes) == "table" then
        for k,v in pairs(c.notes) do
            if v then
                if (v.Time - os.time()) <= conf.file.clean then
                    table.remove(c.notes, k)            
                end
            end
        end
    end    
end

function c.note.CleanUp()
    local function Do()
        c.note.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end