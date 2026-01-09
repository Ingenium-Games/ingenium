-- ====================================================================================--
-- VOIP Configuration
-- Ingenium Voice Over IP System Configuration
-- ====================================================================================--
conf.voip = {}
-- ====================================================================================--

--[[
VOIP ENABLE :
    Enable or disable the VOIP system entirely.
]]--
conf.voip.enabled = true

--[[
VOICE MODES :
    Available voice modes for proximity chat.
    Each mode has a distance in game units (1 unit ≈ 1 meter).
]]--
conf.voip.modes = {
    {
        name = "Whisper",
        distance = 3.0,
        description = "Very close range"
    },
    {
        name = "Normal",
        distance = 8.0,
        description = "Normal conversation distance"
    },
    {
        name = "Shout",
        distance = 15.0,
        description = "Shouting distance"
    }
}

--[[
DEFAULT VOICE MODE :
    The default voice mode when a player first joins (1-based index).
]]--
conf.voip.defaultMode = 2 -- Normal

--[[
VOICE RANGE KEY :
    The key used to cycle through voice modes.
    Default: "F6" (can be changed or set to nil to disable)
]]--
conf.voip.rangeKey = "F6"

--[[
RADIO SYSTEM :
    Enable/disable radio communication system.
]]--
conf.voip.radioEnabled = true

--[[
RADIO CHANNEL RANGE :
    Valid radio channel numbers.
]]--
conf.voip.radioChannelMin = 1
conf.voip.radioChannelMax = 999

--[[
PHONE/CALL SYSTEM :
    Enable/disable phone call system.
]]--
conf.voip.callEnabled = true

--[[
CONNECTION SYSTEM :
    Enable/disable web-based connection system (browser calls, video chats, etc).
]]--
conf.voip.connectionEnabled = true

--[[
ADMIN CALL SYSTEM :
    Enable/disable admin call system where admins can speak directly to players.
]]--
conf.voip.adminCallEnabled = true

--[[
ADMIN CALL ACE PERMISSION :
    The ACE permission required to use admin call features.
]]--
conf.voip.adminCallAce = "voip.admincall"

--[[
VOICE EFFECTS :
    Enable voice effects like muffling, echo, etc.
]]--
conf.voip.effectsEnabled = true

--[[
SUBMIX EFFECTS :
    Enable submix effects for radio (requires native audio).
    Provides radio-like audio filtering.
]]--
conf.voip.submixEnabled = true

--[[
3D AUDIO :
    Enable 3D positional audio (directional voice).
]]--
conf.voip.audio3D = true

--[[
NATIVE AUDIO :
    Use GTA's native audio system for voice (enables effects and submixes).
]]--
conf.voip.nativeAudio = true

--[[
VOICE INDICATOR :
    Show visual indicator when players are talking.
]]--
conf.voip.showIndicator = true

--[[
VOICE INDICATOR POSITION :
    Position of the voice indicator (above head, on screen, etc).
]]--
conf.voip.indicatorPosition = "above_head"

--[[
GRID SYSTEM :
    Use grid-based proximity detection for performance.
]]--
conf.voip.useGrid = true

--[[
GRID SIZE :
    Size of each grid cell in game units (larger = better performance, less precision).
]]--
conf.voip.gridSize = 50.0

--[[
ROUTING BUCKET ISOLATION :
    Isolate voice by routing bucket (players in different buckets can't hear each other).
    When enabled, proximity voice will only work between players in the same routing bucket.
    Note: Radio, phone calls, and admin calls work ACROSS routing buckets by design.
    This is enforced on both client and server side for maximum security.
]]--
conf.voip.routingBucketIsolation = true

--[[
VEHICLE MUFFLING :
    Muffle voice when players are in vehicles.
]]--
conf.voip.vehicleMuffling = true

--[[
BUILDING MUFFLING :
    Muffle voice when players are in different buildings.
]]--
conf.voip.buildingMuffling = true

--[[
VOICE FADE DISTANCE :
    Distance over which voice fades out (beyond max distance).
]]--
conf.voip.fadeDistance = 5.0

--[[
UPDATE RATE :
    How often to update voice targets (in milliseconds).
]]--
conf.voip.updateRate = 500

--[[
DEBUG MODE :
    Enable debug logging for VOIP system.
]]--
conf.voip.debug = conf.debug_1 or false

-- ====================================================================================--
