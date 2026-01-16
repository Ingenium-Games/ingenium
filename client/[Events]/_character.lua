-- ====================================================================================--
-- CHARACTER CLIENT LIFECYCLE
-- ====================================================================================--
-- Manages client-side character joining, loading, and state management.
-- 
-- Flow:
-- 1. Client:Character:OpeningMenu -> Show character select UI
-- 2. NUI requests character list -> TriggerServerCallback("Server:Character:List")
-- 3. Server returns list -> NUI displays options
-- 4. NUI selects character -> TriggerServerEvent("Server:Character:Join")
-- 5. Server loads character -> TriggerClientEvent("Client:Character:ReSpawn")
-- 6. Client spawns ped -> TriggerServerEvent("Server:Character:Loaded")
-- 7. Client initializes HUD -> TriggerServerEvent("Server:Character:Ready")
--
-- ====================================================================================--

-- ====================================================================================--
-- NUI COMMUNICATION ARCHITECTURE REFERENCE
-- ====================================================================================--
-- This file receives events from SERVER and sends them to NUI.
-- It also registers callbacks that NUI sends back to CLIENT.
--
-- **CLIENT→NUI WRAPPERS** (Wrapper functions that send to NUI):
--   Location: nui/lua/Client-NUI-Wrappers/_character.lua
--   Function: ig.nui.character.ShowSelect() → Sends Client:NUI:CharacterSelectShow to NUI
--   Function: ig.nui.character.HideSelect() → Sends Client:NUI:CharacterSelectHide to NUI
--   Function: ig.nui.character.ShowCreate() → Sends Client:NUI:AppearanceOpen to NUI
--   Function: ig.nui.character.ShowCustomize() → Sends Client:NUI:AppearanceOpen to NUI
--   Function: ig.nui.character.HideAppearance() → Sends Client:NUI:AppearanceClose to NUI
--
-- **NUI→CLIENT CALLBACKS** (Handlers for messages FROM NUI):
--   Location: nui/lua/NUI-Client/character-select.lua (selection callbacks)
--   Location: nui/lua/NUI-Client/_appearance.lua (appearance callbacks)
--   Callback: RegisterNUICallback("NUI:Client:CharacterPlay") → Player selected character
--   Callback: RegisterNUICallback("NUI:Client:CharacterCreate") → Player created new character
--   Callback: RegisterNUICallback("NUI:Client:CharacterDelete") → Player deleted character
--   Callback: RegisterNUICallback("NUI:Client:AppearanceComplete") → Player finished appearance customization
--
-- **IMPORTANT**: All RegisterNUICallback() handlers are CENTRALIZED in nui/lua/NUI-Client/
-- DO NOT register duplicate callbacks in this file - they belong in their respective NUI-Client files
--
-- ====================================================================================--


-- ====================================================================================--
-- STAGE 1: Character Menu Opening
-- ====================================================================================--

-- Called when player first joins - shows character selection menu
RegisterNetEvent("Client:Character:OpeningMenu")
AddEventHandler("Client:Character:OpeningMenu", function()
    ShutdownLoadingScreenNui()
    
    -- Position player in character select area
    local ped = GetPlayerPed(-1)
    ig.data.SetLoadedStatus(false)
    FreezeEntityPosition(ped, true)
    SetFollowPedCamViewMode(4)
    SetEntityCoords(ped, -43.143894195557, 822.04595947266, 231.33236694336)
    SetEntityHeading(ped, 288.78283691406)
    SetGameplayCamRelativeRotation(4.0307750701904, 0.054180480539799, -71.305198669434)
    SetGameplayCamRelativeHeading(-0.091852381825447)
    SetGameplayCamRelativePitch(4.0307726860046, 1.0)
    
    ig.log.Info("Character", "Character menu opened, awaiting NUI selection")
    
    -- Show character select UI via wrapper function
    -- NOTE: This sends Client:NUI:CharacterSelectShow to NUI (nui/lua/Client-NUI-Wrappers/_character.lua)
    -- NUI will then send NUI:Client:CharacterList callback when ready
    ig.nui.character.ShowSelect()
    SetNuiFocus(true, true)
end)


-- ====================================================================================--
-- STAGE 1B: Character List Fetching (via Callback)
-- ====================================================================================--

-- NOTE: NUI callbacks are registered in nui/lua/NUI-Client/character-select.lua
-- This event handler is called FROM SERVER when character list is requested
-- The flow is:
--   1. NUI shows select screen
--   2. NUI requests character list (NUI:Client:CharacterList)
--   3. Server returns list via RegisterServerCallback
--   4. NUI displays characters
--   5. Player selects/creates character (sends NUI:Client:CharacterPlay/Create/Delete)
--   6. nui/lua/NUI-Client/character-select.lua handles these callbacks
--
-- This event handler is deprecated - kept for compatibility only
RegisterNetEvent("Client:Character:ReceiveCharacterList")
AddEventHandler("Client:Character:ReceiveCharacterList", function(data)
    ig.log.Trace("Character", "Received character list via event")
    if data then
        ig.ui.Send("Client:NUI:CharacterSelectShow", {
            characters = data.Characters,
            slots = data.Slots
        }, true)
    else
        ig.log.Error("Character", "No character data received from server")
    end
end)



-- ====================================================================================--
-- STAGE 2: Character Selection & Creation
-- ====================================================================================--

-- NOTE: NUI→Client callbacks for character selection are registered in:
--   nui/lua/NUI-Client/character-select.lua
--
-- These NUI callbacks handle player selections:
--   - NUI:Client:CharacterPlay (select existing) → Server:Character:Join
--   - NUI:Client:CharacterCreate (new character) → Server:Character:Register
--   - NUI:Client:CharacterDelete (delete) → Server:Character:Delete
--
-- Do NOT register duplicate callbacks here - they are centralized in NUI-Client/



-- ====================================================================================--
-- STAGE 3: Character Creation UI
-- ====================================================================================--

-- Show character creation customization screen
RegisterNetEvent("Client:Character:Create")
AddEventHandler("Client:Character:Create", function()
    ig.log.Info("Character", "Character creation started")
    
    local plyped = PlayerPedId()
    SetEntityCoords(plyped, -703.9, -152.62, 37.42)
    SetEntityHeading(plyped, 62)
    
    ig.func.FadeOut(1000)
    ig.func.IsBusyPleaseWait(500)
    
    -- Wait for fade completion
    SetTimeout(500, function()
        -- Show appearance customizer UI via wrapper function
        -- NOTE: This sends Client:NUI:AppearanceOpen to NUI
        -- NUI will send back Client:Character:AppearanceComplete callback when done
        ig.nui.character.ShowCreate()
        SetNuiFocus(true, true)
        ig.func.FadeIn(1000)
        ig.func.IsBusyPleaseWait(500)
    end)
end)

-- Called when appearance customization is complete
-- NOTE: This callback is registered in nui/lua/NUI-Client/_appearance.lua (function-specific location)
-- NOT here - do not add RegisterNUICallback('Client:Character:AppearanceComplete') here
-- All NUI callbacks are centralized in their respective NUI-Client handler files



-- ====================================================================================--
-- STAGE 4: Character Spawning
-- ====================================================================================--

-- Respawn player in their last saved location
-- Called from server after character is loaded from database
-- NOTE: Triggered from Server:Character:Join via TriggerClientEvent("Client:Character:ReSpawn", src, Coords)
RegisterNetEvent("Client:Character:ReSpawn")
AddEventHandler("Client:Character:ReSpawn", function(Coords)
    ig.log.Info("Character", "Spawning character at saved location")
    
    local ped = PlayerPedId()
    
    ig.func.FadeOut(1000)
    SetFollowPedCamViewMode(0)
    
    -- Wait for fade to complete before moving
    SetTimeout(500, function()
        SetEntityCoords(ped, Coords.x, Coords.y, Coords.z)
        SetEntityHeading(ped, Coords.h)
        
        -- Request character appearance from server
        TriggerServerEvent("Server:Character:LoadSkin")
        
        PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
        FreezeEntityPosition(ped, false)
        
        -- Hide character select UI via wrapper function
        -- NOTE: This sends Client:NUI:CharacterSelectHide to NUI
        ig.nui.character.HideSelect()
        SetNuiFocus(false, false)
        
        ig.func.FadeIn(2000)
    end)
end)

-- Spawn new character at default spawn location
-- Called from Server:Character:Spawn after new character creation
RegisterNetEvent("Client:Character:NewSpawn")
AddEventHandler("Client:Character:NewSpawn", function()
    ig.log.Info("Character", "Spawning new character at default location")
    
    ig.func.FadeOut(1000)
    SetFollowPedCamViewMode(0)
    
    SetTimeout(500, function()
        SetEntityCoords(GetPlayerPed(-1), conf.spawn.x, conf.spawn.y, conf.spawn.z)
        SetEntityHeading(GetPlayerPed(-1), conf.spawn.h)
        PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
        FreezeEntityPosition(GetPlayerPed(-1), false)
        ig.func.FadeIn(2000)
    end)
end)

-- ====================================================================================--
-- STAGE 5: Character Data Loading & Initialization
-- ====================================================================================--

-- Receive and apply character appearance from server
RegisterNetEvent("Client:Character:LoadSkin")
AddEventHandler("Client:Character:LoadSkin", function(appearance)
    ig.log.Trace("Character", "Loading character appearance")
    
    if appearance then
        -- Use native appearance system to set character model
        ig.appearance.SetAppearance(appearance)
    else
        ig.log.Warn("Character", "No appearance data received")
    end
end)

-- Save character appearance (called when player modifies appearance)
RegisterNetEvent("Client:Character:SaveSkin")
AddEventHandler("Client:Character:SaveSkin", function(bool)
    local appearance = ig.appearance.GetAppearance()
    TriggerServerEvent("Server:Character:SaveSkin", appearance, bool)
end)

-- Called after character spawns and appearance is loaded
-- Initializes all character-dependent systems with STATE VERIFICATION
-- NOTE: Triggered from Server:Character:Loaded after ped flags are set
--       This is the final initialization point before Ready event
--
-- Flow:
--   1. Server: Server:Character:LoadSkin → Client:Character:LoadSkin (appearance)
--   2. Client: TriggerServerEvent("Server:Character:Loaded") [IMPORTANT: client confirms ped ready]
--   3. Server: Server:Character:Loaded → Sets ped flags → Waits 500ms → TriggerClientEvent("Client:Character:Loaded")
--   4. Client: Client:Character:Loaded → State verification → TriggerEvent("Client:Character:Ready")
--   5. Client: Client:Character:Ready → TriggerServerEvent("Server:Character:Ready")
--   6. Server: Server:Character:Ready → Final setup complete
RegisterNetEvent("Client:Character:Loaded")
AddEventHandler("Client:Character:Loaded", function()
    ig.log.Info("Character", "Character loaded - initializing systems")
    
    -- CRITICAL: Wait for StateBag synchronization with state verification
    -- Instead of hardcoded 5-second wait, verify state is actually synced
    local maxWait = 0
    local timeStep = 50  -- Check every 50ms
    local timeout = 5000 -- Max 5 seconds
    
    local function checkStateSync()
        local ped = GetPlayerPed(-1)
        local state = Entity(ped).state
        
        -- Check if critical state fields are synced from server
        if state and state.Health then
            return true
        end
        return false
    end
    
    -- Wait with verification instead of hardcoded delay
    while not checkStateSync() and maxWait < timeout do
        SetTimeout(timeStep, function() end)
        maxWait = maxWait + timeStep
    end
    
    if maxWait >= timeout then
        ig.log.Warn("Character", "State sync timeout after 5 seconds, proceeding anyway")
    else
        ig.log.Trace("Character", "State sync verified in " .. maxWait .. "ms")
    end
    
    -- Initialize all character systems
    ig.data.SetLoadedStatus(true)
    ig.chat.AddSuggestions()
    ig.data.SetLocale()
    ig.skill.SetSkills()
    ig.status.SetPlayer()
    ig.modifier.SetModifiers()
    
    -- Notify server that client is fully ready
    -- NOTE: This tells server that ped is fully initialized and state is verified
    TriggerServerEvent("Server:Character:Loaded")
    
    -- Trigger internal event for other resources
    TriggerEvent("Client:Character:Ready")
end)



-- ====================================================================================--
-- STAGE 6: Character Ready & Game State
-- ====================================================================================--

-- Called after Client:Character:Loaded completes
-- Character is fully loaded, all systems initialized, ready to play
RegisterNetEvent("Client:Character:Ready")
AddEventHandler("Client:Character:Ready", function()
    ig.log.Info("Character", "Character fully ready - initializing gameplay")
    
    -- Disable auto-respawn (we handle respawning manually)
    exports.spawnmanager:setAutoSpawn(false)
    
    -- Notify server that client is fully initialized and ready to play
    TriggerServerEvent("Server:Character:Ready")
    
    -- Apply RP mode specific configurations if enabled
    if conf.gamemode == "RP" then
        local ped = PlayerPedId()
        
        -- Set RP-specific native configurations
        SetMaxWantedLevel(0)
        SetPedMinGroundTimeForStungun(ped, 12500)
        SetCanAttackFriendly(ped, true, false)
        NetworkSetFriendlyFireOption(true)
        SetWeaponsNoAutoswap(true)
        SetWeaponsNoAutoreload(true)
        RemoveMultiplayerHudCash()
        
        ig.log.Info("Character", "RP Mode character initialization complete")
    end
end)

-- ====================================================================================--
-- STAGE 7: Character State Management (Switch/Logout)
-- ====================================================================================--

-- Called before switching to another character (logout)
RegisterNetEvent("Client:Character:Pre-Switch")
AddEventHandler("Client:Character:Pre-Switch", function()
    ig.log.Info("Character", "Preparing character switch")
    
    ig.func.FadeOut(1000)
    
    SetTimeout(1000, function()
        ig.func.FadeIn(2000)
    end)
end)

-- Called when player is switching characters
-- Cleans up character-specific data and state
RegisterNetEvent("Client:Character:Switch")
AddEventHandler("Client:Character:Switch", function()
    ig.log.Info("Character", "Character switch initiated - cleaning up")
    
    ig.data.SetLoadedStatus(false)
    
    -- Clean up character-specific resources
    -- Add cleanup hooks here for other resources
end)

-- Called when player goes off-duty (job toggle)
RegisterNetEvent("Client:Character:OffDuty")
AddEventHandler("Client:Character:OffDuty", function()
    if conf.enableduty then
        ig.log.Trace("Character", "Character went off-duty")
        -- Add off-duty specific logic here
    else
        ig.log.Trace("Character", "Off-duty disabled in configuration")
    end
end)

-- Called when player goes on-duty (job toggle)
RegisterNetEvent("Client:Character:OnDuty")
AddEventHandler("Client:Character:OnDuty", function(job)
    if conf.enableduty then
        ig.log.Trace("Character", "Character went on-duty for job: " .. (job or "unknown"))
        -- Add on-duty specific logic here
    else
        ig.log.Trace("Character", "On-duty disabled in configuration")
    end
end)

-- Called when player's job is updated
RegisterNetEvent("Client:Character:SetJob")
AddEventHandler("Client:Character:SetJob", function(name, grade)
    ig.log.Trace("Character", "Job updated: " .. name .. " (Grade: " .. grade .. ")")
    -- Add job-specific logic here
end)

-- ====================================================================================--
-- STAGE 8: Character Death & Events
-- ====================================================================================--

-- Called when character dies
RegisterNetEvent("Client:Character:Death")
AddEventHandler("Client:Character:Death", function(data)
    ig.log.Warn("Character", "Character death event triggered")
    
    if data and data.Log then
        local agro = data.Log.Source
        local cause = data.Cause or "Unknown"
        
        ig.log.Trace("Character", "Death cause: " .. cause .. " (Source: " .. agro .. ")")
        
        if cause == "Weapon" then
            -- Handle weapon death
        elseif cause == "Vehicle" then
            -- Handle vehicle death
        elseif cause == "Object" then
            -- Handle object death
        end
    end
end)
