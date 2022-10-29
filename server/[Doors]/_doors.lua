-- ====================================================================================--

c.door = {} -- functions
c.doors = {} -- cached doors

-- ====================================================================================--

--[[    
{
    {
    ['Model'] = -903733315,
    ['Info'] = {
        ['Rotation'] = vec3(0.000000, -0.000000, -135.878677),
        ['Arch'] = "gabz_firedept_wooden_door",
        ['Matrix'] = vec3(0.696180, -0.717867, 0.000000)
    },
    ['Ords'] = vec3(200.405685, -1645.355225, 28.797325),
    ['Job'] = "fire",
    ['Name'] = "FireDept"
},
        {
            [#] = {joaat, model, coords, jobs, locked, time, item},
        }
]] --


--- func desc
---@param coords any
function c.door.Find(coords)
    for k,v in pairs(c.doors) do
        -- is the door in the table?
        if (v[3] == coords) then
            return true, k
        end
    end    
    return false, false
end

--- func desc
---@param coords any
function c.door.FindHash(hash)
    for k,v in pairs(c.doors) do
        -- is the door in the table?
        if (v[1] == hash) then
            return true, k
        end
    end    
    return false, false
end

--- func desc
---@param coords any
function c.door.SetState(hash, state)
    local cache = c.json.Read("Doors")
    for k,v in pairs(cache) do
        -- is the door in the table?
        if (v[1] == hash) then
            v[5] = state
            c.json.Write("Doors", cache)
        end
    end    
end

--- func desc
---@param coords any
function c.door.ChangeState(hash)
    local cache = c.json.Read("Doors")
    for k,v in pairs(cache) do
        -- is the door in the table?
        if (v[1] == hash) then
            v[5] = not v[5]
            c.json.Write("Doors", cache)
        end
    end    
end

--- func desc
---@param model any
---@param coords any
---@param locked any
function c.door.Add(Doors)

        for k, v in pairs(Doors) do 
            if not c.door.Find(v.Ords) then
                local n = #c.doors + 1
                local hash, model, coords, jobs, locked, item, time = joaat("DOOR_"..n), v.Model, v.Ords, v.Job, (v.State or 1), (v.Item or false), (v.Time or false)
                c.doors[n] = {hash, model, coords, jobs, locked, item, time}
                if v.Time then
                    if v.Time.h and v.Time.m and v.Time.s then
                        c.cron.RunAt(v.Time.h, v.Time.m, c.door.SetState, hash, v.Time.s)
                        
                    end
                end
            else
                print("Ignoring duplicate door : "..c.table.Dump(v))
            end
        end
        c.json.Write("Doors", c.doors)
end

--- func desc
function c.door.GetDoors()
    local cache = c.json.Read("Doors")
    return cache
end

RegisterNetEvent("Server:Doors:SetState", function(hash, state)
    c.door.SetState(hash, state)
    TriggerClientEvent("Client:Doors:Sync", -1, hash, state)
end)

RegisterCommand("aaa", function () print(c.table.Dump(c.crons))end

)