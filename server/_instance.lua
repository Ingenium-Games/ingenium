-- ====================================================================================--
--  MIT License 2020 : Twiitchter
-- ====================================================================================--
c.inst = {}
--[[
NOTES.
    -
    -
    -
]] --

math.randomseed(c.Seed)
-- ====================================================================================--

local count = 1

-- There is no longer a limit on instaces/buckets.
--- Rotate through a list of numbers to generate a new instance with.
function c.inst.New()
    count = count + 1
    return count
end

--- Sets the player and their ped entity to a routing bucket.
---@param source number ""
---@param num number "The number of the istance/routing bucket"
function c.inst.SetPlayer(source, num)
    local src = tonumber(source)
    local xPlayer = c.data.GetPlayer(src)
    local current = GetPlayerRoutingBucket(src)
    if not xPlayer then
        SetPlayerRoutingBucket(src, num)
        SetEntityRoutingBucket(GetPlayerPed(src), num)
    else
        if current ~= num then
            -- to add mumble changes based on either pmavoice or frazzles mumble script
            SetPlayerRoutingBucket(src, num)
            SetEntityRoutingBucket(GetPlayerPed(src), num)
            xPlayer.SetInstance(num)
            c.sql.char.SetInstance(xPlayer.GetIdentifier(), num, c.debug(xPlayer.Name.." added to Instance: "..num))
        end
    end
end

--- Sets the entity to the 
---@param entity any ""
---@param num number "The number of the istance/routing bucket"
function c.inst.SetEntity(entity, num)
    local current = GetEntityRoutingBucket(entity)
    if current ~= num then
        SetEntityRoutingBucket(entity, num)
    end
end

--- Get player routing bucket
---@param source number
function c.inst.GetPlayerInstance(source)
    return GetPlayerRoutingBucket(source)
end

--- Get entity routing bucket
---@param entity any
function c.inst.GetEntityInstance(entity)
    return GetEntityRoutingBucket(entity)
end

--- Set the player and their ped to the default global instance/routing bucket.
---@param source number
function c.inst.SetPlayerDefault(source)
    local src = tonumber(source)
    local xPlayer = c.data.GetPlayer(source)
    SetPlayerRoutingBucket(source, conf.instancedefault)
    SetEntityRoutingBucket(GetPlayerPed(source), conf.instancedefault)
    xPlayer.SetInstance(conf.instancedefault)
    c.sql.char.SetInstance(xPlayer.GetIdentifier(), conf.instancedefault, c.debug(xPlayer.Name.." added to Global Instance."))
end

--- Set entity routing bucket
---@param entity any
function c.inst.SetEntityDefault(entity)
    SetEntityRoutingBucket(entity, conf.instancedefault)
end

-- only called once client is character ready.
-- check instance on reload of character
AddEventHandler("Server:Character:Ready", function()
    local src = tonumber(source)
    local xPlayer = c.data.GetPlayer(source)
    SetPlayerRoutingBucket(source, xPlayer.GetInstance())
    SetEntityRoutingBucket(GetPlayerPed(source), xPlayer.GetInstance())
end)