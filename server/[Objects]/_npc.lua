-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.npc = {} -- function level
c.npcs = {} -- database pull - If ever used?	
c.ndex = {} -- the index/store for currently used vehciles prior to writing to db.
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
function c.npc.Find(net)
    for k,v in ipairs(c.ndex) do
        if k == net and type(v) == "table"  then
            return true
        end
    end
    return false
end

-- Runs off net id's within the table
function c.npc.CleanOne(net)
    local ent = NetworkGetEntityFromNetworkId(net)
    if not DoesEntityExist(ent) then
        table.remove(c.ndex, net)
    end
end

-- Runs off net id's within the table
function c.npc.CleanAll()
    for k,v in ipairs(c.ndex) do
        -- Check the entities do not exist.
        if not DoesEntityExist(v.Entity) then
            table.remove(c.ndex, k)
        end
    end
end

function c.npc.CleanUp()
    local function Do()
        c.npc.CleanAll()
        SetTimeout(conf.cleanup, Do)
    end
    SetTimeout(conf.cleanup, Do)
end