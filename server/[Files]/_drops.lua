-- ====================================================================================--
c.drop = {} -- function level
c.drops = false -- dropped items table
-- ====================================================================================--
    
--[[    
        {
            [ID] = {
                ["Coords"] = {0,0,0} -- Vecotr3
                ["Cash"] = NUMBER
                ["Inventory"] = {}
                ["Time"] = TIME  -- os.time() when created.
                ["Dropper"] = Character_ID
                ["Event"] = Trigger() 
            },

        }
]]--
    
function c.drop.Load()
    if c.json.Exists(conf.file.drops) then
        local file = c.json.Read(conf.file.drops)
        c.drops = file
    else
        c.drops = {}
        c.json.Write(conf.file.drops, c.drops)
    end
end

function c.drop.Add(data)
    local id = c.drop.NewID()
    if type(data) == "table" then
        table.insert(c.drops, id)
        c.drops[id] = data
    else
        c.debug_1("Drop to be added, please check data sent.")
    end
end

function c.drop.NewID()
    local found = false
    local new = nil
    repeat
        new = c.rng.chars(20)
        if c.drops[new] then
            found = true
        end
    until found == false 
    return new
end

function c.drop.Exist(id)
    if c.drops[id] then
        return true
    end
    return false
end

function c.drop.Clean()
    if type(c.drops) == "table" then
        for k,v in pairs(c.drops) do
            if v then        
                if (v.Time - os.time()) <= conf.file.clean then
                    table.remove(c.drops, k)            
                end
            end
        end
    end
end

function c.drop.CleanUp()
    local function Do()
        c.drop.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end