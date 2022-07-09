-- ====================================================================================--

c.gsr = {} -- function level
c.gsrs = {} -- dropped items table
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
        c.gsr.Update()
    end
end

function c.gsr.Update()
    local function Do()
        c.json.Write(conf.file.gsr, c.gsrs)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

function c.gsr.Add(data)
    if type(data) == "table" then
        table.insert(c.gsrs, data)
    else
        c.func.Debug_1("Drop to be added, please check data sent.")
    end
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
                if (os.time() - v.Time) >= conf.file.cleanup then
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