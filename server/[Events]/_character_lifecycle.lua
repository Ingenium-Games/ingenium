-- ====================================================================================--
-- CHARACTER LIFECYCLE MANAGEMENT
-- ====================================================================================--
-- Manages the complete character lifecycle from join through load and customization.
--
-- ┌─────────────────────────────────────────────────────────────────────────────────┐
-- │                      CHARACTER JOINING FLOW (Critical Path)                     │
-- ├─────────────────────────────────────────────────────────────────────────────────┤
-- │                                                                                 │
-- │  Server.lua: playerConnecting                                                   │
-- │    └─> Validates license, adds to index, waits for NUI                         │
-- │                                                                                 │
-- │  NUI: Character Select Screen                                                   │
-- │    └─> SendNuiMessage("character:list")                                        │
-- │                                                                                 │
-- │  Server: Server:Character:List (RegisterServerCallback)                        │
-- │    ├─> Get player slots from database                                          │
-- │    ├─> Fetch all available characters                                          │
-- │    └─> Place player in isolated instance (ig.inst.SetPlayer)                   │
-- │                                                                                 │
-- │  Player Selects Character or Creates New                                        │
-- │    │                                                                            │
-- │    ├─> If "New": Server:Character:Register                                     │
-- │    │    └─> Creates character, bank account, gives phone                       │
-- │    │    └─> Calls ig.data.LoadPlayer() → Server:Character:Spawn               │
-- │    │                                                                            │
-- │    └─> If Existing: Server:Character:Join                                      │
-- │         └─> Calls ig.data.LoadPlayer() → Client:Character:ReSpawn             │
-- │                                                                                 │
-- │  Client: Character:ReSpawn (Client receives coords)                            │
-- │    └─> Spawns ped, loads appearance, triggers Client:Character:Loaded         │
-- │                                                                                 │
-- │  Server: Server:Character:Loaded (OnChardataReceived)                          │
-- │    └─> Sets ped config flags (arrest, fire immunity, etc.)                     │
-- │                                                                                 │
-- │  Client: HUD initialized, loading screen hidden                                │
-- │    └─> Triggers Server:Character:Ready (Ready to play)                        │
-- │                                                                                 │
-- │  Server: Server:Character:Ready (Final Init)                                   │
-- │    ├─> Update instance bucket                                                  │
-- │    ├─> Re-assign job ACL permissions                                           │
-- │    └─> Trigger state synchronization (cash, bank)                              │
-- │                                                                                 │
-- │  ✓ CHARACTER FULLY LOADED AND READY                                            │
-- │                                                                                 │
-- └─────────────────────────────────────────────────────────────────────────────────┘
--
-- ====================================================================================--

-- Shared security check function for all character events
-- @param eventName string - Name of the event being called (for logging)
-- @return boolean - True if resource is calling this event legitimately
local function isValidCharacterEvent(eventName)
    if GetInvokingResource() ~= conf.resourcename then
        return false
    end
    return true
end

-- ====================================================================================--
-- STAGE 1: Character List & Selection
-- ====================================================================================--

-- Retrieve character list for the connecting player (called from Client:Character:OpeningMenu)
RegisterServerCallback({
    eventName = "Server:Character:List",
    eventCallback = function(source)
        local src = tonumber(source)
        local Primary_ID = ig.func.identifier(src)
        
        -- Get player's character slots and available characters
        local Slots = ig.sql.user.GetSlots(Primary_ID)
        local Characters = ig.sql.char.GetAllPermited(Primary_ID, Slots)
        
        -- Place player in isolated instance until character selection is complete
        ig.inst.SetPlayer(src)
        
        -- Return character list to NUI for selection menu
        return {
            Characters = Characters,
            Slots = Slots
        }
    end
})

-- Player selects a character from the NUI menu
RegisterNetEvent("Server:Character:Join")
AddEventHandler("Server:Character:Join", function(Character_ID)
    if not isValidCharacterEvent("Server:Character:Join") then
        CancelEvent()
        return
    end
    
    local src = source
    
    -- Handle new character creation
    if Character_ID == "New" then
        TriggerClientEvent("Client:Character:Create", src)
        return
    end
    
    -- Handle existing character selection
    if Character_ID ~= nil then
        local Coords = ig.sql.char.GetCoords(Character_ID)
        ig.data.LoadPlayer(src, Character_ID)
        
        -- Trigger client to spawn at location
        TriggerClientEvent("Client:Character:ReSpawn", src, Coords)
        
        -- Send character appearance to client after a short delay (allow spawn to complete)
        SetTimeout(500, function()
            local xPlayer = ig.data.GetPlayer(src)
            if xPlayer then
                local appearance = xPlayer.GetAppearance()
                TriggerClientEvent("Client:Character:LoadSkin", src, appearance)
            end
        end)
        
        return
    end
    
    -- Invalid state - no character selected
    DropPlayer(src, "No character selected. Please rejoin.")
end)

-- ====================================================================================--
-- STAGE 2: Character Creation (New Characters)
-- ====================================================================================--

-- Player creates a new character (called after character creation NUI submission)
RegisterNetEvent("Server:Character:Register")
AddEventHandler("Server:Character:Register", function(first_name, last_name, appearance)
    if not isValidCharacterEvent("Server:Character:Register") then
        CancelEvent()
        return
    end
    
    local src = source
    
    -- Prevent double-loading (security check)
    if ig.data.GetPlayer(src) ~= false then
        ig.func.Eventban(src, "Server:Character:Register")
        return
    end
    
    -- Generate unique IDs and initial data
    local primary_id = ig.func.identifier(src)
    local character_id = ig.sql.gen.CharacterID()
    local city_id = ig.sql.gen.CityID()
    local phone_number = ig.sql.gen.PhoneNumber()
    local iban = ig.sql.gen.Iban()
    local bank_number = ig.sql.gen.AccountNumber()
    
    local data = {
        Primary_ID = primary_id,
        Character_ID = character_id,
        First_Name = first_name,
        Last_Name = last_name,
        City_ID = city_id,
        Phone = phone_number,
        Iban = iban,
        Coords = json.encode(conf.spawn),
        Job = json.encode(conf.default.job),
        Modifiers = json.encode(conf.default.modifiers),
        Skills = json.encode(conf.default.skills),
        Appearance = json.encode(appearance)
    }
    
    local p = promise.new()
    
    -- Insert character into database and chain related operations
    ig.sql.char.Add(data, function()
        -- Create associated bank account with generated IBAN
        ig.sql.bank.AddAccount(character_id, bank_number, iban)
        p:resolve()
    end)
    
    -- Wait for database operations to complete
    Citizen.Await(p)
    
    -- Load the newly created character
    ig.data.LoadPlayer(src, character_id)
    
    -- Trigger character creation event (for custom spawn logic, etc.)
    TriggerEvent("Server:Character:Spawn", src)
    
    -- Give new character a phone
    local xPlayer = ig.data.GetPlayer(src)
    xPlayer.AddItem({"Phone", 1, 100})
end)

-- Alternate spawn trigger (used after character creation)
RegisterNetEvent("Server:Character:Spawn", function(req)
    if not isValidCharacterEvent("Server:Character:Spawn") then
        CancelEvent()
        return
    end
    
    local src = tonumber(req)
    local xPlayer = ig.data.GetPlayer(src)
    
    if xPlayer then
        TriggerClientEvent("Client:Character:ReSpawn", src, xPlayer.GetCoords())
    end
end)

-- ====================================================================================--
-- STAGE 3: Character Loading & Initialization
-- ====================================================================================--

-- Called after client receives character data and has spawned the ped
-- Sets critical ped flags and game state
RegisterNetEvent("Server:Character:Loaded")
AddEventHandler("Server:Character:Loaded", function()
    if not isValidCharacterEvent("Server:Character:Loaded") then
        CancelEvent()
        return
    end
    
    local src = source
    local ped = GetPlayerPed(src)
    
    if not ped or ped == 0 then
        return
    end
    
    -- Set ped configuration flags to ensure proper game state
    local pedFlags = {
        42,   -- CPED_CONFIG_FLAG_DontInfluenceWantedLevel
        155,  -- CPED_CONFIG_FLAG_CanPerformArrest
        156,  -- CPED_CONFIG_FLAG_CanPerformUncuff
        157,  -- CPED_CONFIG_FLAG_CanBeArrested
        430,  -- CPED_CONFIG_FLAG_IgnoreBeingOnFire
        434   -- CPED_CONFIG_FLAG_DisableHomingMissileLockon
    }
    
    for _, flag in ipairs(pedFlags) do
        SetPedConfigFlag(ped, flag, false)
    end
    
    ig.log.Info("Character", "Player " .. src .. " character loaded - ped flags configured")
    
    -- Trigger final client-side initialization
    SetTimeout(500, function()
        TriggerClientEvent("Client:Character:Loaded", src)
    end)
end)

-- Called after client is fully ready to play (after loading screen, HUD initialized, etc.)
-- Finalizes player state, manages permissions, and triggers state synchronization
RegisterNetEvent("Server:Character:Ready")
AddEventHandler("Server:Character:Ready", function()
    if not isValidCharacterEvent("Server:Character:Ready") then
        CancelEvent()
        return
    end
    
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    -- Update instance bucket based on character's assigned instance
    ig.inst.SetPlayer(src, xPlayer.GetInstance())
    
    -- Remove player from previous job ACL group (clean transition)
    ExecuteCommand(("remove_principal identifier.%s job.%s"):format(
        xPlayer.GetIdentifier(), 
        xPlayer.GetJob().Name
    ))
    
    -- Re-assign to current job ACL group (triggers ACE permission sync)
    local job = xPlayer.GetJob()
    xPlayer.SetJob(job.Name, job.Grade)
    
    -- Trigger state synchronization for cash and bank (ensures clients see updates)
    xPlayer.GetCash()
    xPlayer.GetBank()
end)

-- ====================================================================================--
-- STAGE 4: Character Switching / Deletion
-- ====================================================================================--

-- Called when player switches characters or is about to disconnect
-- Cleans up character-specific data (job permissions, active markers, etc.)
RegisterNetEvent("Server:Character:Switch", function(req)
    if not isValidCharacterEvent("Server:Character:Switch") then
        CancelEvent()
        return
    end
    
    local src = req or source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    -- Remove player from job ACL group (cleanup on character switch)
    ExecuteCommand(("remove_principal identifier.%s job.%s"):format(
        xPlayer.GetIdentifier(), 
        xPlayer.GetJob().Name
    ))
end)

-- Player deletes a character from the selection menu
RegisterNetEvent("Server:Character:Delete")
AddEventHandler("Server:Character:Delete", function(Character_ID)
    if not isValidCharacterEvent("Server:Character:Delete") then
        CancelEvent()
        return
    end
    
    local src = source
    
    -- Delete character from database
    ig.sql.char.Delete(Character_ID, function()
        DropPlayer(src, "Character deleted. Please rejoin to create a new one.")
    end)
end)

-- Client failed to create/select character properly
RegisterNetEvent("Server:Character:Failed")
AddEventHandler("Server:Character:Failed", function()
    if not isValidCharacterEvent("Server:Character:Failed") then
        CancelEvent()
        return
    end
    
    local src = source
    DropPlayer(src, "Character creation/selection failed. Please rejoin.")
end)

-- ====================================================================================--
-- CHARACTER CUSTOMIZATION (Appearance & Cosmetics)
-- ====================================================================================--

-- Load appearance from database
RegisterNetEvent("Server:Character:LoadSkin")
AddEventHandler("Server:Character:LoadSkin", function()
    if not isValidCharacterEvent("Server:Character:LoadSkin") then
        CancelEvent()
        return
    end
    
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    local appearance = xPlayer.GetAppearance()
    TriggerClientEvent("Client:Character:LoadSkin", src, appearance)
end)

-- Save appearance (legacy, kept for compatibility)
RegisterNetEvent("Server:Character:SaveSkin")
AddEventHandler("Server:Character:SaveSkin", function(appearance, bool)
    if not isValidCharacterEvent("Server:Character:SaveSkin") then
        CancelEvent()
        return
    end
    
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    local identifier = xPlayer.GetIdentifier()
    ig.sql.char.SetAppearance(identifier, appearance, function()
        xPlayer.SetAppearance(appearance)
    end)
    
    -- Reset to default instance if requested
    if type(bool) == "boolean" and bool == true then
        ig.inst.SetPlayerDefault(src)
    end
end)

-- Save appearance with validation
RegisterNetEvent("Server:Character:SaveAppearance")
AddEventHandler("Server:Character:SaveAppearance", function(appearance)
    if not isValidCharacterEvent("Server:Character:SaveAppearance") then
        CancelEvent()
        return
    end
    
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        ig.log.Error("APPEARANCE", "No xPlayer found for source: %d", src)
        return
    end
    
    -- Validate appearance data structure
    local isValid, errorMsg = ig.appearance.ValidateAppearance(appearance)
    if not isValid then
        ig.log.Error("APPEARANCE", "Invalid appearance data for %s: %s", 
            xPlayer.GetIdentifier(), errorMsg)
        return
    end
    
    -- Save validated appearance to database
    local identifier = xPlayer.GetIdentifier()
    ig.sql.char.SetAppearance(identifier, appearance, function()
        xPlayer.SetAppearance(appearance)
        ig.log.Info("APPEARANCE", "Saved appearance for %s", identifier)
    end)
end)
-- ====================================================================================--
-- STAGE 6: CHARACTER STATE MANAGEMENT (Job, Duty, Death)
-- ====================================================================================--

-- Handle player death (marked as "down" for recovery or jailing)
RegisterNetEvent("Server:Character:Death")
AddEventHandler("Server:Character:Death", function(data)
    if not isValidCharacterEvent("Server:Character:Death") then
        CancelEvent()
        return
    end
    
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    -- Mark character as dead in database
    ig.sql.char.SetDead(xPlayer.GetCharacter_ID(), true, data)
    
    -- Handle death logging if applicable
    if data.Log then
        local agro = data.Log.Source  -- Source ID or -1 for server
        if data.Cause == "Weapon" then
            -- Log weapon death
        elseif data.Cause == "Vehicle" then
            -- Log vehicle death
        elseif data.Cause == "Object" then
            -- Log object death
        end
    end
    
    xPlayer.Notify("You have been downed, you must wait for someone to assist you.", "black", 15000)
    xPlayer.Notify("If you do not wait, or leave, you will be unable to use this character for 7 days.", "red", 10000)
end)

-- Set character job (with ACL permissions)
-- @param data table - {Name = "police", Grade = 0}
RegisterNetEvent("Server:Character:SetJob")
AddEventHandler("Server:Character:SetJob", function(data)
    if not isValidCharacterEvent("Server:Character:SetJob") then
        CancelEvent()
        return
    end
    
    local src = source
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    -- Force duty to false when changing jobs
    xPlayer.SetDuty(false)
    
    -- Add new job ACL permissions
    ExecuteCommand(("add_principal identifier.%s job.%s"):format(
        xPlayer.GetLicense_ID(), 
        xPlayer.GetJob().Name
    ))
    
    -- If unemployed, automatically set on duty
    if data.Name == "none" then
        xPlayer.SetDuty(true)
    end
end)

-- Toggle on-duty status (if configured)
RegisterNetEvent("Server:Character:Duty")
AddEventHandler("Server:Character:Duty", function(boolean)
    if not isValidCharacterEvent("Server:Character:Duty") then
        CancelEvent()
        return
    end
    
    local src = source
    
    if not conf.enableduty then
        ig.log.Trace("Character", "Ability to go on/off duty has been disabled")
        return
    end
    
    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        return
    end
    
    xPlayer.SetDuty(boolean)
end)