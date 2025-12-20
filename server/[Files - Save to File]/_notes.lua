-- ====================================================================================--
ig.note = {} -- function level
ig.notes = false -- dropped items table
-- ====================================================================================--
    
--[[    
        {
            [ID] = {   
                ["Coords"] = {0,0,0} -- Vecotr3
                ["Note"] = Multiline String
                ["Time"] = TIME  -- os.time() when created.
                ["Event"] = Trigger()
            },

        }
]]--

--- func desc
function ig.note.Load()
    if ig.json.Exists(conf.file.notes) then
        local file = ig.json.Read(conf.file.notes)
        ig.notes = file
    else
        ig.notes = {}
        ig.json.Write(conf.file.notes, ig.notes)
    end
    ig.note.Update()
end

--- func desc
function ig.note.Update()
    local function Do()
        ig.json.Write(conf.file.notes, ig.notes)
        SetTimeout(conf.file.save, Do)
    end
    SetTimeout(conf.file.save, Do)
end

--- func desc
---@param data any
function ig.note.Add(data)
    if type(data) == "table" then
        table.insert(ig.notes, data)
    else
        ig.func.Debug_1("Drop to be added, please check data sent.")
    end
end

--- func desc
---@param id any
function ig.note.Exist(id)
    if ig.notes[id] then
        return true
    end
    return false
end

--- func desc
function ig.note.Clean()
    if type(ig.notes) == "table" then
        for k,v in pairs(ig.notes) do
            if v then
                if (os.time() - v.Time) >= conf.file.cleanup then
                    table.remove(ig.notes, k)            
                end
            end
        end
    end    
end

--- func desc
function ig.note.CleanUp()
    local function Do()
        ig.note.Clean()
        SetTimeout(conf.file.cleanup, Do)
    end
    SetTimeout(conf.file.cleanup, Do)
end

-- ====================================================================================--
-- Enhanced Notes System Helpers
-- World notes/messages that can be left at locations (sticky notes, graffiti, etc.)
-- ====================================================================================--

---Create a new note at coordinates
---@param coords table Coordinates {x, y, z, h}
---@param note string Note text content
---@param author string|nil Author name/ID
---@param event string|nil Event to trigger on read
---@param data table|nil Additional data
---@return string Note ID
function ig.note.Create(coords, note, author, event, data)
    local id = ig.rng.UUID()
    
    local noteData = {
        ID = id,
        Coords = coords,
        Note = note,
        Author = author,
        Time = os.time(),
        Event = event,
        Data = data or {},
        ReadCount = 0,
        Active = true
    }
    
    ig.notes[id] = noteData
    
    -- Sync to nearby clients
    TriggerClientEvent("Client:Notes:Add", -1, noteData)
    
    ig.func.Debug_2("Created note " .. id .. " at " .. json.encode(coords))
    
    return id
end

---Remove a note by ID
---@param id string Note ID
---@return boolean True if removed
function ig.note.Remove(id)
    if ig.notes[id] then
        ig.notes[id] = nil
        
        -- Sync to clients
        TriggerClientEvent("Client:Notes:Remove", -1, id)
        
        ig.func.Debug_2("Removed note " .. id)
        return true
    end
    
    return false
end

---Get note by ID
---@param id string Note ID
---@return table|nil Note data or nil
function ig.note.GetByID(id)
    return ig.notes[id]
end

---Get all notes
---@return table All notes
function ig.note.GetAll()
    return ig.notes
end

---Get notes near coordinates
---@param coords vector3 Center coordinates
---@param radius number Search radius
---@return table Array of nearby notes
function ig.note.GetNearby(coords, radius)
    local nearby = {}
    
    for id, note in pairs(ig.notes) do
        if note.Coords and note.Active then
            local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(note.Coords.x, note.Coords.y, note.Coords.z))
            if dist <= radius then
                table.insert(nearby, {id = id, note = note, distance = dist})
            end
        end
    end
    
    -- Sort by distance
    table.sort(nearby, function(a, b) return a.distance < b.distance end)
    
    return nearby
end

---Get notes by author
---@param author string Author name/ID
---@return table Array of notes by author
function ig.note.GetByAuthor(author)
    local result = {}
    
    for id, note in pairs(ig.notes) do
        if note.Author == author then
            table.insert(result, {id = id, note = note})
        end
    end
    
    -- Sort by time (newest first)
    table.sort(result, function(a, b) return a.note.Time > b.note.Time end)
    
    return result
end

---Search notes by content
---@param searchTerm string Text to search for
---@return table Array of matching notes
function ig.note.Search(searchTerm)
    local result = {}
    local lowerSearch = searchTerm:lower()
    
    for id, note in pairs(ig.notes) do
        if note.Note and note.Note:lower():find(lowerSearch) then
            table.insert(result, {id = id, note = note})
        end
    end
    
    return result
end

---Mark note as read (increment counter)
---@param id string Note ID
---@param reader string|nil Reader name/ID
---@return boolean True if marked
function ig.note.MarkRead(id, reader)
    local note = ig.notes[id]
    if not note then
        return false
    end
    
    note.ReadCount = (note.ReadCount or 0) + 1
    note.LastRead = os.time()
    note.LastReader = reader
    
    -- Trigger event if set
    if note.Event then
        TriggerEvent(note.Event, id, reader, note.Data)
    end
    
    ig.func.Debug_3("Note " .. id .. " read by " .. (reader or "unknown"))
    
    return true
end

---Update note content
---@param id string Note ID
---@param newContent string New note text
---@param editor string|nil Editor name/ID
---@return boolean True if updated
function ig.note.Update(id, newContent, editor)
    local note = ig.notes[id]
    if not note then
        return false
    end
    
    note.Note = newContent
    note.LastEdit = os.time()
    note.LastEditor = editor
    
    -- Sync to clients
    TriggerClientEvent("Client:Notes:Update", -1, id, note)
    
    ig.func.Debug_3("Note " .. id .. " updated by " .. (editor or "unknown"))
    
    return true
end

---Clean old notes
---@param maxAge number|nil Max age in seconds (uses config if nil)
---@return number Number of notes removed
function ig.note.CleanOld(maxAge)
    local maxAge = maxAge or conf.file.cleanup
    local now = os.time()
    local removed = 0
    
    for id, note in pairs(ig.notes) do
        if note.Time and (now - note.Time) >= maxAge then
            ig.note.Remove(id)
            removed = removed + 1
        end
    end
    
    if removed > 0 then
        ig.func.Debug_2("Cleaned up " .. removed .. " old notes")
    end
    
    return removed
end

---Hide note (don't remove, just make invisible)
---@param id string Note ID
---@return boolean True if hidden
function ig.note.Hide(id)
    local note = ig.notes[id]
    if not note then
        return false
    end
    
    note.Active = false
    
    -- Sync to clients
    TriggerClientEvent("Client:Notes:Update", -1, id, note)
    
    return true
end

---Show hidden note
---@param id string Note ID
---@return boolean True if shown
function ig.note.Show(id)
    local note = ig.notes[id]
    if not note then
        return false
    end
    
    note.Active = true
    
    -- Sync to clients
    TriggerClientEvent("Client:Notes:Update", -1, id, note)
    
    return true
end

---Get note count
---@return number Total notes, number Active notes
function ig.note.GetCount()
    local total = 0
    local active = 0
    
    for _, note in pairs(ig.notes) do
        total = total + 1
        if note.Active then
            active = active + 1
        end
    end
    
    return total, active
end

---Get most read notes
---@param limit number|nil Number of results (default 10)
---@return table Array of most read notes
function ig.note.GetMostRead(limit)
    local limit = limit or 10
    local result = {}
    
    for id, note in pairs(ig.notes) do
        table.insert(result, {id = id, note = note})
    end
    
    -- Sort by read count (highest first)
    table.sort(result, function(a, b) 
        return (a.note.ReadCount or 0) > (b.note.ReadCount or 0)
    end)
    
    -- Limit results
    local limited = {}
    for i = 1, math.min(limit, #result) do
        table.insert(limited, result[i])
    end
    
    return limited
end

---Get recent notes
---@param maxAge number|nil Max age in seconds (default 3600 = 1 hour)
---@return table Array of recent notes
function ig.note.GetRecent(maxAge)
    local maxAge = maxAge or 3600
    local now = os.time()
    local result = {}
    
    for id, note in pairs(ig.notes) do
        if (now - note.Time) <= maxAge then
            table.insert(result, {id = id, note = note, age = now - note.Time})
        end
    end
    
    -- Sort by age (newest first)
    table.sort(result, function(a, b) return a.age < b.age end)
    
    return result
end

---Create bulletin board note (persistent public note)
---@param coords table Coordinates
---@param title string Note title
---@param content string Note content
---@param author string Author name
---@return string Note ID
function ig.note.CreateBulletin(coords, title, content, author)
    local fullNote = string.format("=== %s ===\n%s\n\n- %s", title, content, author)
    
    return ig.note.Create(coords, fullNote, author, nil, {
        type = "bulletin",
        title = title
    })
end

---Create graffiti note (shorter, more casual)
---@param coords table Coordinates
---@param message string Graffiti message
---@param author string|nil Author (can be anonymous)
---@return string Note ID
function ig.note.CreateGraffiti(coords, message, author)
    return ig.note.Create(coords, message, author or "Anonymous", nil, {
        type = "graffiti"
    })
end

---Create evidence note (police/forensics)
---@param coords table Coordinates
---@param evidence string Evidence description
---@param officer string Officer name
---@param caseId string|nil Case ID
---@return string Note ID
function ig.note.CreateEvidence(coords, evidence, officer, caseId)
    local fullNote = string.format("EVIDENCE LOG\nCase: %s\n\n%s\n\nLogged by: %s", 
        caseId or "N/A", evidence, officer)
    
    return ig.note.Create(coords, fullNote, officer, nil, {
        type = "evidence",
        caseId = caseId
    })
end

---Get notes by type
---@param noteType string Type (bulletin, graffiti, evidence, etc.)
---@return table Array of notes of type
function ig.note.GetByType(noteType)
    local result = {}
    
    for id, note in pairs(ig.notes) do
        if note.Data and note.Data.type == noteType then
            table.insert(result, {id = id, note = note})
        end
    end
    
    return result
end

---Validate note data
---@param noteData table Note data to validate
---@return boolean, string True if valid, or false with error
function ig.note.ValidateData(noteData)
    if type(noteData) ~= "table" then
        return false, "Note data must be a table"
    end
    
    if not noteData.ID or type(noteData.ID) ~= "string" then
        return false, "Missing or invalid ID"
    end
    
    if not noteData.Coords or type(noteData.Coords) ~= "table" then
        return false, "Missing or invalid Coords"
    end
    
    if not noteData.Note or type(noteData.Note) ~= "string" then
        return false, "Missing or invalid Note content"
    end
    
    -- Check note length
    if #noteData.Note > 2000 then
        return false, "Note content too long (max 2000 characters)"
    end
    
    return true, "Valid"
end

---Resync all notes to clients
function ig.note.ResyncAll()
    TriggerClientEvent("Client:Notes:Sync", -1, ig.notes)
    ig.func.Debug_2("Resynced all notes to clients")
end

-- Register read event
RegisterNetEvent("Server:Note:Read", function(id)
    local source = source
    local xPlayer = ig.data.GetPlayer(source)
    
    if xPlayer then
        ig.note.MarkRead(id, xPlayer.GetCharacter_ID())
    end
end)