-- ====================================================================================--
-- Instance management (ig.inst initialized in server/_var.lua)
-- ====================================================================================--
-- ROUTING BUCKET NOTES:
-- Routing buckets are used to isolate players from each other. Players in different
-- routing buckets cannot see, hear (via VOIP), or interact with each other.
-- - Character selection: Players are placed in their own bucket (source ID)
-- - Character creation: Players remain in their isolated bucket during appearance customization
-- - Active gameplay: Players are moved to the default bucket (conf.instancedefault, usually 0)
-- - VOIP system respects routing buckets and enforces voice isolation
-- ====================================================================================--

--- Sets the player and their ped entity to a routing bucket.
---@param source number The source player ID
---@param num number The number of the instance/routing bucket
function ig.inst.SetPlayer(source, num)
    if not num then num = source end
    local src = tonumber(source)
    local xPlayer = ig.data.GetPlayer(src)
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
            ig.func.Debug_1(xPlayer.GetName().." added to Instance: "..num)
            if num ~= conf.instancedefault then
                SetRoutingBucketPopulationEnabled(num, false)
            elseif num == conf.instancedefault then
                SetRoutingBucketPopulationEnabled(num, true)
            end
        end
    end
end

--- Sets the entity to the specified routing bucket
---@param entity integer "Entity handle/ID"
---@param num integer "The number of the instance/routing bucket"
function ig.inst.SetEntity(entity, num)
    local current = GetEntityRoutingBucket(entity)
    if current ~= num then
        SetEntityRoutingBucket(entity, num)
    end
end

--- Get player routing bucket
---@param source number
function ig.inst.GetPlayerInstance(source)
    return GetPlayerRoutingBucket(source)
end

--- Gets entity's current routing bucket
---@param entity integer "Entity handle/ID"
---@return integer Current routing bucket number
function ig.inst.GetEntityInstance(entity)
    return GetEntityRoutingBucket(entity)
end

--- Set the player and their ped to the default global instance/routing bucket.
---@param source number
function ig.inst.SetPlayerDefault(source)
    local src = tonumber(source)
    local xPlayer = ig.data.GetPlayer(source)
    SetPlayerRoutingBucket(source, conf.instancedefault)
    SetEntityRoutingBucket(GetPlayerPed(source), conf.instancedefault)
    xPlayer.SetInstance(conf.instancedefault)
    SetRoutingBucketPopulationEnabled(conf.instancedefault, true)
    ig.func.Debug_1(xPlayer.GetName().." added to Global Instance.")
end

--- Sets entity to default/global routing bucket
---@param entity integer "Entity handle/ID"
function ig.inst.SetEntityDefault(entity)
    SetEntityRoutingBucket(entity, conf.instancedefault)
end
