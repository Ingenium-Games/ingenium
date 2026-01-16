-- ====================================================================================--
-- Ingenium VOIP - Shared Voice Utilities
-- ====================================================================================--
ig.voip = ig.voip or {}
-- ====================================================================================--

--- Voice mode types
---@class VoiceMode
---@field name string The display name of the voice mode
---@field distance number The distance in game units (meters)
---@field description string Description of the voice mode
ig.voip.VoiceModes = {}

-- Initialize voice modes from configuration
if conf and conf.voip and conf.voip.modes then
    for index, mode in ipairs(conf.voip.modes) do
        ig.voip.VoiceModes[index] = {
            name = mode.name,
            distance = mode.distance,
            description = mode.description
        }
    end
end

--- Voice state types
ig.voip.StateType = {
    NONE = 0,
    VOICE = 1,      -- Proximity voice (InVoice)
    CALL = 2,       -- Phone call (InCall)
    RADIO = 3,      -- Radio communication
    CONNECTION = 4, -- Web connection (InConnection)
    ADMIN = 5       -- Admin call (InAdminCall)
}

--- Get voice mode by index
---@param modeIndex number The 1-based index of the voice mode
---@return VoiceMode|nil The voice mode or nil if not found
function ig.voip.GetVoiceMode(modeIndex)
    if not modeIndex or modeIndex < 1 or modeIndex > #ig.voip.VoiceModes then
        return nil
    end
    return ig.voip.VoiceModes[modeIndex]
end

--- Get voice mode count
---@return number The total number of voice modes
function ig.voip.GetVoiceModeCount()
    return #ig.voip.VoiceModes
end

--- Get the next voice mode index (cycles through modes)
---@param currentIndex number The current voice mode index
---@return number The next voice mode index
function ig.voip.GetNextVoiceMode(currentIndex)
    local modeCount = ig.voip.GetVoiceModeCount()
    if currentIndex >= modeCount then
        return 1
    else
        return currentIndex + 1
    end
end

--- Get the previous voice mode index (cycles through modes)
---@param currentIndex number The current voice mode index
---@return number The previous voice mode index
function ig.voip.GetPreviousVoiceMode(currentIndex)
    local modeCount = ig.voip.GetVoiceModeCount()
    if currentIndex <= 1 then
        return modeCount
    else
        return currentIndex - 1
    end
end

--- Check if a radio channel is valid
---@param channel number The radio channel number
---@return boolean True if the channel is valid
function ig.voip.IsValidRadioChannel(channel)
    if not conf or not conf.voip then
        return false
    end
    if type(channel) ~= "number" then
        return false
    end
    return channel >= conf.voip.radioChannelMin and channel <= conf.voip.radioChannelMax
end

--- Calculate distance between two 3D positions
---@param x1 number X coordinate of position 1
---@param y1 number Y coordinate of position 1
---@param z1 number Z coordinate of position 1
---@param x2 number X coordinate of position 2
---@param y2 number Y coordinate of position 2
---@param z2 number Z coordinate of position 2
---@return number The distance between the two positions
function ig.voip.GetDistance(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

--- Calculate grid cell from position (for grid-based proximity)
---@param x number X coordinate
---@param y number Y coordinate
---@return number, number Grid cell X and Y
function ig.voip.GetGridCell(x, y)
    if not conf or not conf.voip or not conf.voip.useGrid then
        return 0, 0
    end
    
    local gridSize = conf.voip.gridSize or 50.0
    return math.floor(x / gridSize), math.floor(y / gridSize)
end

--- Get surrounding grid cells (for efficient proximity checks)
---@param gridX number The center grid cell X
---@param gridY number The center grid cell Y
---@return table Array of {x, y} grid cell coordinates
function ig.voip.GetSurroundingGridCells(gridX, gridY)
    local cells = {}
    
    -- Include center cell and 8 surrounding cells (3x3 grid)
    for dx = -1, 1 do
        for dy = -1, 1 do
            table.insert(cells, {x = gridX + dx, y = gridY + dy})
        end
    end
    
    return cells
end

--- VOIP logging helper (integrated with ig.log system)
---@param message string The debug message
function ig.voip.Debug(message)
    if ig and ig.log and ig.log.Debug then
        ig.log.Debug("VOIP", message)
    end
end

-- ====================================================================================--
