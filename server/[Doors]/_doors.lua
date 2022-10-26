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
}
        {
            [#] = {joaat, model, coords, jobs, locked, time, item},
        }
]] --

--- func desc
---@param . any
function c.door.Load()
    if c.json.Exists(conf.file.doors) then
        local file = c.json.Read(conf.file.doors)
        c.doors = file
        c.door.Update()
    else
        c.doors = {}
        c.json.Write(conf.file.doors, c.doors)
        c.door.Update()
    end
end

--- func desc
function c.door.Update()
    local function Do()
        c.json.Write(conf.file.doors, c.doors)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param model any
---@param coords any
---@param locked any
function c.door.Add(Doors)
    local hash, model, coords, jobs, locked, item, time
    for k, v in pairs(Doors) do 
        if not c.door.Find(v.Ords) then
            local n = #c.doors + 1
            hash, model, coords, jobs, locked, item, time = joaat("DOOR_"..n), v.Model, v.Ords, v.Job, false, false, false
            c.doors[n] = {hash, model, coords, jobs, locked, item, time}
        else
            print("Ignoring duplicate door : "..c.table.Dump(v))
        end
    end
end

--- func desc
function c.door.Resync()
    local doors = c.doors
    TriggerClientEvent("Client:Doors:Initialize", -1, doors)
end

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
function c.door.Toggle(coords)
    local bool, door = c.door.Find(coords)
    if door then
        c.doors[door].locked = not bool
        TriggerClientEvent("Client:Doors:Set", -1, door, c.doors[door].locked)
    end
end