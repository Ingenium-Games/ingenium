-- ====================================================================================--
ig.gsr = {} -- function level
ig.gsrs = {} -- dropped items table
-- ====================================================================================--
 
--[[    
        {
            [ID] = {
                ["Coords"] = {0,0,0} -- Vecotr3
                ["Cash"] = NUMBER
                ["Model"] = hash
                ["Serial"] = SERIAL_ID
                ["Time"] = TIME  -- os.time() when created.
            },

        }
]]--
    
--- func desc
---@param . any
function ig.gsr.Load()
    if ig.json.Exists(conf.file.gsr) then
        ig.gsrs = ig.json.Read(conf.file.gsr)
    else
        ig.gsrs = {}
        ig.json.Write(conf.file.gsr, ig.gsrs)
    end
    ig.gsr.Update()
end


--- func desc
function ig.gsr.Update()
    local function Do()
        ig.json.Write(conf.file.gsr, ig.gsrs)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param data any
function ig.gsr.Add(data)
    if type(data) == "table" then
        table.insert(ig.gsrs, data)
    else
        ig.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function ig.gsr.Exist(id)
    if ig.gsrs[id] then
        return true
    end
    return false
end

--- func desc
function ig.gsr.Clean()
    if type(ig.gsrs) == "table" then
        for k,v in pairs(ig.gsrs) do
            if v then
                if (os.time() - v.Time) >= conf.file.cleanup then
                    table.remove(ig.gsrs, k)            
                end
            end
        end
    end
end

--- func desc
function ig.gsr.CleanUp()
    local function Do()
        ig.gsr.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end

-- ====================================================================================--
-- Enhanced GSR (Gunshot Residue) System Helpers
-- Tracks gunshot residue on players for forensic/police RP
-- ====================================================================================--

---Create GSR record for player
---@param source number Player source
---@param weaponHash number Weapon used
---@param ammoType string Ammo type
---@return string GSR ID
function ig.gsr.Create(source, weaponHash, ammoType)
    local xPlayer = ig.data.GetPlayer(source)
    if not xPlayer then
        return nil
    end
    
    local id = ig.rng.UUID()
    local coords = xPlayer.GetCoords()
    
    local gsr = {
        ID = id,
        Character_ID = xPlayer.GetCharacter_ID(),
        Coords = coords,
        Cash = xPlayer.GetCash(),
        Model = weaponHash,
        Serial = ig.rng.chars(10), -- Weapon serial if needed
        Time = os.time(),
        AmmoType = ammoType,
        Shots = 1
    }
    
    ig.gsrs[id] = gsr
    
    ig.func.Debug_3("Created GSR record " .. id .. " for player " .. source)
    
    return id
end

---Get GSR by ID
---@param id string GSR ID
---@return table|nil GSR data or nil
function ig.gsr.GetByID(id)
    return ig.gsrs[id]
end

---Get all GSR records
---@return table All GSR records
function ig.gsr.GetAll()
    return ig.gsrs
end

---Get GSR records for character
---@param characterId string Character ID
---@return table Array of GSR records
function ig.gsr.GetByCharacter(characterId)
    local result = {}
    
    for id, gsr in pairs(ig.gsrs) do
        if gsr.Character_ID == characterId then
            table.insert(result, {id = id, gsr = gsr})
        end
    end
    
    -- Sort by time (newest first)
    table.sort(result, function(a, b) return a.gsr.Time > b.gsr.Time end)
    
    return result
end

---Get recent GSR records (within time window)
---@param maxAge number Max age in seconds (default 300 = 5 minutes)
---@return table Array of recent GSR records
function ig.gsr.GetRecent(maxAge)
    local maxAge = maxAge or 300
    local now = os.time()
    local result = {}
    
    for id, gsr in pairs(ig.gsrs) do
        if (now - gsr.Time) <= maxAge then
            table.insert(result, {id = id, gsr = gsr, age = now - gsr.Time})
        end
    end
    
    -- Sort by age (newest first)
    table.sort(result, function(a, b) return a.age < b.age end)
    
    return result
end

---Get GSR records by weapon
---@param weaponHash number Weapon hash
---@return table Array of GSR records
function ig.gsr.GetByWeapon(weaponHash)
    local result = {}
    
    for id, gsr in pairs(ig.gsrs) do
        if gsr.Model == weaponHash then
            table.insert(result, {id = id, gsr = gsr})
        end
    end
    
    return result
end

---Get GSR records near coordinates
---@param coords vector3 Center coordinates
---@param radius number Search radius
---@return table Array of nearby GSR records
function ig.gsr.GetNearby(coords, radius)
    local nearby = {}
    
    for id, gsr in pairs(ig.gsrs) do
        if gsr.Coords then
            local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(gsr.Coords.x, gsr.Coords.y, gsr.Coords.z))
            if dist <= radius then
                table.insert(nearby, {id = id, gsr = gsr, distance = dist})
            end
        end
    end
    
    -- Sort by distance
    table.sort(nearby, function(a, b) return a.distance < b.distance end)
    
    return nearby
end

---Check if character has recent GSR
---@param characterId string Character ID
---@param maxAge number|nil Max age in seconds (default 300)
---@return boolean True if has recent GSR
---@return table|nil Most recent GSR record
function ig.gsr.HasRecent(characterId, maxAge)
    local maxAge = maxAge or 300
    local now = os.time()
    local mostRecent = nil
    
    for id, gsr in pairs(ig.gsrs) do
        if gsr.Character_ID == characterId and (now - gsr.Time) <= maxAge then
            if not mostRecent or gsr.Time > mostRecent.Time then
                mostRecent = gsr
            end
        end
    end
    
    return mostRecent ~= nil, mostRecent
end

---Increment shot count for existing GSR
---@param characterId string Character ID
---@param maxAge number|nil Time window to find existing GSR (default 60s)
---@return boolean True if incremented existing, false if need new record
function ig.gsr.IncrementShots(characterId, maxAge)
    local maxAge = maxAge or 60
    local now = os.time()
    
    -- Find recent GSR for this character
    for id, gsr in pairs(ig.gsrs) do
        if gsr.Character_ID == characterId and (now - gsr.Time) <= maxAge then
            gsr.Shots = (gsr.Shots or 1) + 1
            gsr.Time = now -- Update time
            return true
        end
    end
    
    return false
end

---Remove GSR by ID
---@param id string GSR ID
---@return boolean True if removed
function ig.gsr.Remove(id)
    if ig.gsrs[id] then
        ig.gsrs[id] = nil
        ig.func.Debug_3("Removed GSR record " .. id)
        return true
    end
    
    return false
end

---Clean old GSR records
---@param maxAge number|nil Max age in seconds (uses config if nil)
---@return number Number of records removed
function ig.gsr.CleanOld(maxAge)
    local maxAge = maxAge or conf.file.cleanup
    local now = os.time()
    local removed = 0
    
    for id, gsr in pairs(ig.gsrs) do
        if gsr.Time and (now - gsr.Time) >= maxAge then
            ig.gsrs[id] = nil
            removed = removed + 1
        end
    end
    
    if removed > 0 then
        ig.func.Debug_2("Cleaned up " .. removed .. " old GSR records")
    end
    
    return removed
end

---Get GSR statistics
---@return table Statistics about GSR records
function ig.gsr.GetStats()
    local total = 0
    local byWeapon = {}
    local byCharacter = {}
    local totalShots = 0
    
    for _, gsr in pairs(ig.gsrs) do
        total = total + 1
        totalShots = totalShots + (gsr.Shots or 1)
        
        -- Count by weapon
        local weaponKey = tostring(gsr.Model)
        byWeapon[weaponKey] = (byWeapon[weaponKey] or 0) + 1
        
        -- Count by character
        byCharacter[gsr.Character_ID] = (byCharacter[gsr.Character_ID] or 0) + 1
    end
    
    return {
        total = total,
        totalShots = totalShots,
        byWeapon = byWeapon,
        byCharacter = byCharacter,
        averageShots = total > 0 and (totalShots / total) or 0
    }
end

---Test player for GSR (police command)
---@param source number Police officer source
---@param targetSource number Target player source
---@return boolean, table True if positive test, GSR data
function ig.gsr.Test(source, targetSource)
    local xTarget = ig.data.GetPlayer(targetSource)
    if not xTarget then
        return false, nil
    end
    
    local hasGSR, gsrData = ig.gsr.HasRecent(xTarget.GetCharacter_ID(), 300)
    
    if hasGSR then
        -- Calculate confidence based on age
        local age = os.time() - gsrData.Time
        local confidence = math.max(0, 100 - (age / 3)) -- 100% at 0s, 0% at 300s
        
        return true, {
            positive = true,
            confidence = confidence,
            age = age,
            shots = gsrData.Shots,
            weapon = gsrData.Model
        }
    end
    
    return false, {
        positive = false,
        confidence = 0
    }
end

---Clear GSR from character (washing hands, gloves)
---@param characterId string Character ID
---@return number Number of records cleared
function ig.gsr.Clear(characterId)
    local cleared = 0
    
    for id, gsr in pairs(ig.gsrs) do
        if gsr.Character_ID == characterId then
            ig.gsrs[id] = nil
            cleared = cleared + 1
        end
    end
    
    if cleared > 0 then
        ig.func.Debug_3("Cleared " .. cleared .. " GSR records for " .. characterId)
    end
    
    return cleared
end

---Get GSR count
---@return number Total GSR records
function ig.gsr.GetCount()
    local count = 0
    for _ in pairs(ig.gsrs) do
        count = count + 1
    end
    return count
end

-- Auto-cleanup thread
if conf.file.cleanup then
    CreateThread(function()
        while true do
            Wait(300000) -- Every 5 minutes
            ig.gsr.CleanOld()
        end
    end)
end

-- Register shot fired event
RegisterNetEvent("Server:GSR:Shot", function(weaponHash, ammoType)
    local source = source
    
    -- Try to increment existing GSR first
    local xPlayer = ig.data.GetPlayer(source)
    if xPlayer then
        local incremented = ig.gsr.IncrementShots(xPlayer.GetCharacter_ID(), 60)
        
        if not incremented then
            -- Create new GSR record
            ig.gsr.Create(source, weaponHash, ammoType)
        end
    end
end)

-- Police command to test for GSR
RegisterNetEvent("Server:GSR:Test", function(targetSource)
    local source = source
    local xOfficer = ig.data.GetPlayer(source)
    
    if not xOfficer or xOfficer.GetJob().Name ~= "police" then
        return
    end
    
    local positive, data = ig.gsr.Test(source, targetSource)
    
    TriggerClientEvent("Client:GSR:TestResult", source, positive, data)
end)