-- ====================================================================================--
--  MIT License : Ingenium-Games (Twiitchter) : https://www.ingenium.games
-- ====================================================================================--
c.pick = {} -- function level
c.picks = false -- dropped items table
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
                ["Model"] = hash
                ["Time"] = TIME  -- os.time() when created.
                ["Event"] = Trigger()
            },

        }
]]--
    
function c.pick.Load()
    if c.json.Exists(conf.file.pickups) then
        local file = c.json.Read(conf.file.pickups)
        c.picks = file
    else
        c.picks = {}
        c.json.Write(conf.file.pickups, c.picks)
    end
end

function c.pick.Add(data)
    local id = c.pick.NewID()
    if type(data) == "table" then
        table.insert(c.picks, id)
        c.picks[id] = data
    else
        c.debug_1("Drop to be added, please check data sent.")
    end
end

function c.pick.NewID()
    local found = false
    local new = nil
    repeat
        new = c.rng.chars(20)
        if c.picks[new] then
            found = true
        end
    until found == false 
    return new
end

function c.pick.Exist(id)
    if c.picks[id] then
        return true
    end
    return false
end

function c.pick.Clean()
    if type(c.picks) == "table" then
        for k,v in pairs(c.picks) do
            if v then        
                if (v.Time - os.time()) <= conf.file.clean then
                    table.remove(c.picks, k)            
                end
            end
        end
    end
end

function c.pick.CleanUp()
    local function Do()
        c.pick.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end