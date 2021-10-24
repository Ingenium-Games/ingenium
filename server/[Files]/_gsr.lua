-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.gsr = {} -- function level
c.gsrs = {} -- dropped items table
--[[
NOTES.
    -
    -
    -
]] --
math.randomseed(c.Seed)
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
    
function c.gsr.Load()
    if c.json.Exists(conf.file.gsr) then
        c.gsrs = c.json.Read(conf.file.gsr)
    else
        c.gsrs = {}
        c.json.Write(conf.file.gsr, c.gsrs)
    end
end

function c.gsr.Add(data)
    local id = c.gsr.NewID()
    if type(data) == "table" then
        table.insert(c.gsrs, id)
        c.gsrs[id] = data
    else
        c.debug_1("Drop to be added, please check data sent.")
    end
end

function c.gsr.NewID()
    local found = false
    local new = nil
    repeat
        new = c.rng.chars(20)
        if c.gsrs[new] then
            found = true
        end
    until found == false 
    return new
end

function c.gsr.Exist(id)
    if c.gsrs[id] then
        return true
    end
    return false
end

function c.gsr.Clean()
    if type(c.gsrs) == "table" then
        for k,v in pairs(c.gsrs) do
            if v then
                if (v.Time - os.time()) <= conf.file.clean then
                    table.remove(c.gsrs, k)            
                end
            end
        end
    end
end

function c.gsr.CleanUp()
    local function Do()
        c.gsr.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end