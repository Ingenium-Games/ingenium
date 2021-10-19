-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.object = {} -- function level
c.objects = {} -- database pull - If ever used?	
c.odex = {} -- the iodex/store for currently used vehciles prior to writing to db.
--[[
NOTES.
    - Some natives use entity
    - Some natives use NetworkID.
    - Network ID should be for the server and entity for the individual user is different.
    - data getters within the _data file.
]]--
math.randomseed(c.Seed)
-- ====================================================================================--

---@param net integer "Network ID 16 bit integer"
function c.object.Find(net)
    for k,v in ipairs(c.odex) do
        if k == net and type(v) == "table" then
            return true
        end
    end
    return false
end


-- Runs off net id's within the table
function c.object.CleanOne(net)
    local ent = NetworkGetEntityFromNetworkId(net)
    if not DoesEntityExist(ent) then
        table.remove(c.odex, net)
    end
end

-- Runs off net id's within the table
function c.object.CleanAll()
    for k,v in ipairs(c.odex) do
        -- Check the entities do not exist.
        if not DoesEntityExist(v.Entity) then
            table.remove(c.odex, k)
        end
    end
end

function c.object.CleanUp()
    local function Do()
        c.object.CleanAll()
        SetTimeout(conf.cleanup, Do)
    end
    SetTimeout(conf.cleanup, Do)
end