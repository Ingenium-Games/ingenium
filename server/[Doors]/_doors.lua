-- ====================================================================================--

c.door = {} -- functions
c.doors = {} -- cached doors
c._doors = nil -- becasue something is fucked, temp obj returns values but the c.doors doesnt??

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
        if v[3] == coords then
            return true, k
        end
    end    
    return false, false
end

--- func desc
---@param coords any
function c.door.FindHash(hash)
    for k,v in pairs(c._doors) do
        -- is the door in the table?
        if v[1] == hash then
            return true, k
        end
    end    
    return false, false
end

--- func desc
---@param model any
---@param coords any
---@param locked any
function c.door.Add(Doors)
    for k, v in pairs(Doors) do 
        if not c.door.Find(v.Ords) then
            local n = #c.doors + 1
            local hash, model, coords, jobs, locked, item, time = joaat("DOOR_"..n), v.Model, v.Ords, v.Job, 1, false, false
            c.doors[n] = {hash, model, coords, jobs, locked, item, time}
        else
            print("Ignoring duplicate door : "..c.table.Dump(v))
        end
    end
end

--- func desc
function c.door.GetDoors()
    local doors = c._temp_doors
    return doors
end

RegisterNetEvent("Server:Doors:State", function(hash, state)
    local found, id = c.door.FindHash(hash)
    if found then
        c._doors[id][5] = state
    end
    TriggerClientEvent("Client:Doors:Sync", -1, hash, state)
end)