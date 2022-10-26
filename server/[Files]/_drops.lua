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
]] --

--- func desc
---@param . any
function c.drop.Load()
    if c.json.Exists(conf.file.drops) then
        local file = c.json.Read(conf.file.drops)
        c.drops = file
    else
        c.drops = {}
        c.json.Write(conf.file.drops, c.drops)
    end
    c.drop.Update()
end

--- func desc
function c.drop.Update()
    local function Do()
        c.json.Write(conf.file.drops, c.drops)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param data any
function c.drop.Add(data)
    if type(data) == "table" then
        table.insert(c.drops, data)
    else
        c.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function c.drop.Exist(id)
    if c.drops[id] then
        return true
    end
    return false
end

--- func desc
function c.drop.Clean()
    if type(c.drops) == "table" then
        for k, v in pairs(c.drops) do
            if v then
                if (os.time() - v.Time) >= conf.file.cleanup then
                    table.remove(c.drops, k)
                end
            end
        end
    end
end

--- func desc
function c.drop.CleanUp()
    local function Do()
        c.drop.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end

--- func desc
function c.drop.Resync()
    local drops = c.drops
    TriggerClientEvent("Client:Drops:Update", -1, drops)
end

