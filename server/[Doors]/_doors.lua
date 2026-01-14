-- ====================================================================================--
ig.door = {} -- functions
ig.doors = {} -- cached doors
-- ====================================================================================--

--[[    
    {
    ['Model'] = 1934132135,
    ['Info'] = {
        ['Rotation'] = vec3(-5.235569, 0.000090, 140.000015),
        ['Arch'] = "gabz_firedept_garage_door",
        ['Matrix'] = vec3(-0.640105, -0.762849, -0.091251)
    },
    ['Ords'] = vec3(208.989471, -1641.075439, 30.918621),
    ['Job'] = "fire",
    ['Name'] = "FireDept",
    ['State'] = 1,
    ['Item'] = false,
    ['Time'] = false
    }
    {
        [#] = {joaat, model, coords, jobs, locked, time, item},
    }
]]--

--- Finds a door in the doors table by coordinates
---@param coords vector3 "Door coordinates to search for"
---@return boolean Found status
---@return integer|boolean Index in doors table or false
function ig.door.Find(coords)
    for k, v in pairs(ig.doors) do
        -- is the door in the table?
        if (v[3] == coords) then
            return true, k
        end
    end
    return false, false
end

--- Finds a door in the doors table by model hash
---@param hash integer "Door model hash to search for"
---@return boolean Found status
---@return integer|boolean Index in doors table or false
function ig.door.FindHash(hash)
    for k, v in pairs(ig.doors) do
        -- is the door in the table?
        if (v[1] == hash) then
            return true, k
        end
    end
    return false, false
end

--- Sets a door's locked state by model hash
---@param hash integer "Door model hash"
---@param state boolean "Door state (true=locked, false=unlocked)"
function ig.door.SetState(hash, state)
    for k, v in pairs(ig.doors) do
        -- is the door in the table?
        if (v[1] == hash) then
            v[5] = state
            ig.json.Write("Doors", ig.doors)
        end
    end
end

--- Toggles a door's locked state by model hash
---@param hash integer "Door model hash"
function ig.door.ChangeState(hash)
    for k, v in pairs(ig.doors) do
        -- is the door in the table?
        if (v[1] == hash) then
            v[5] = not v[5]
            ig.json.Write("Doors", ig.doors)
        end
    end
end

--- Adds multiple doors from a Doors table to the door registry
---@param Doors table "Table of door definitions with Ords (coordinates) property"
function ig.door.Add(Doors)
    for k, v in pairs(Doors) do
        if not ig.door.Find(v.Ords) then
            local n = #ig.doors + 1
            local hash, model, coords, jobs, locked, item, time = joaat("DOOR_" .. n), v.Model, v.Ords, v.Job,
                (v.State or 1), (v.Item or false), (v.Time or false)
            ig.doors[n] = {hash, model, coords, jobs, locked, item, time}
            if v.Time then
                if v.Time.h and v.Time.m and v.Time.s then
                    ig.cron.RunAt(v.Time.h, v.Time.m, ig.door.SetState, hash, v.Time.s)
                end
            end
        else
            print("Ignoring duplicate door : " .. ig.table.Dump(v))
        end
    end
    ig.json.Write("Doors", ig.doors)
end

--- func desc
function ig.door.GetDoors()
    return ig.table.Clone(ig.doors)
end

-- Migrated to callback for security
RegisterServerCallback({
    eventName = "Server:Doors:SetState",
    eventCallback = function(source, hash, state)
        local src = source
        -- TODO: Add ACL/permission checks here if needed
        -- For now, allow all door changes
        ig.door.SetState(hash, state)
        TriggerClientEvent("Client:Doors:Sync", -1, hash, state)
        return { success = true }
    end
})