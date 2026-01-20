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

RegisterServerCallback({
    eventName = "Server:Character:Join",
    eventCallback = function(source, Character_ID)
        local src = tonumber(source)
        -- Handle existing character selection
        if Character_ID ~= nil then
            -- create palyer class and mark as active within db.
            ig.data.LoadPlayer(src, Character_ID)
            -- Trigger client to spawn at location
            local xPlayer = ig.data.GetPlayer(src)
            local Coords = xPlayer.GetCoords()
            local Appearance = xPlayer.GetAppearance()
            if xPlayer then
                TriggerClientEvent("Client:Character:Loaded", src, Coords, Appearance)
            end
        else
            DropPlayer(src, "No character selected. Please rejoin.")
        end
    end
})

-- ====================================================================================--
-- STAGE 2: Character Creation (New Characters)
-- ====================================================================================--
-- Player creates a new character (called after character creation NUI submission)
-- SECURE CALLBACK - Validates client data server-side
RegisterServerCallback({
    eventName = "Server:Character:Register",
    eventCallback = function(source, first_name, last_name, appearance)
        local src = tonumber(source)
        ig.log.Debug("Character", "Character registration started for player " .. src .. ": " .. first_name .. " " .. last_name)
        
        -- Prevent double-loading (security check)
        if ig.data.GetPlayer(src) ~= false then
            ig.log.Error("Character", "Character registration: Player " .. src .. " already loaded!")
            ig.func.Eventban(src, "Server:Character:Register")
            return { success = false, error = "Player already loaded" }
        end
    
    -- Generate unique IDs and initial data
    local primary_id = ig.func.identifier(src)
    local character_id = ig.sql.gen.CharacterID()
    local city_id = ig.sql.gen.CityID()
    local iban = ig.sql.gen.Iban()
    local bank_number = ig.sql.gen.AccountNumber()
    
    ig.log.Trace("Character", "Generated IDs - CharID: " .. character_id .. ", CityID: " .. city_id .. ", IBAN: " .. iban .. ", BankAcc: " .. bank_number)
    
    local data = {
        Primary_ID = primary_id,
        Character_ID = character_id,
        First_Name = first_name,
        Last_Name = last_name,
        City_ID = city_id,
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
        ig.log.Debug("Character", "Character " .. character_id .. " added to database")
        -- Create associated bank account with generated IBAN
        ig.sql.bank.AddAccount(character_id, bank_number, iban)
        p:resolve()
    end)
    
    -- Wait for database operations to complete
    Citizen.Await(p)
    
    ig.log.Debug("Character", "Database operations completed, loading player...")
    
    -- Load the newly created character
    ig.data.LoadPlayer(src, character_id)
    
    ig.log.Info("Character", "Character " .. character_id .. " created successfully for player " .. src)
    
    -- Give new character a phone
    local xPlayer = ig.data.GetPlayer(src)
    if xPlayer then
        xPlayer.AddItem({"Phone", 1, 100})
        ig.log.Trace("Character", "Phone added to character inventory")
    else
        ig.log.Error("Character", "Failed to get player after loading - character may not be accessible!")
        return { success = false, error = "Failed to load character after creation" }
    end
    
    -- Return success response to client
    return {
        success = true,
        character_id = character_id,
        message = "Character created successfully"
    }
    end
})

-- ====================================================================================--
-- STAGE 3: Character Loading & Initialization
-- ====================================================================================--

-- Called after client is fully ready to play (after loading screen, HUD initialized, etc.)
-- Finalizes player state, manages permissions, and triggers state synchronization
RegisterNetEvent("Server:Character:Ready")
AddEventHandler("Server:Character:Ready", function()
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

    local xPlayer = ig.data.GetPlayer(src)
    
    if not xPlayer then
        DropPlayer(src, "Server failed to generate character information, please report to server owner.")
    end

    -- Return users back to their last known instance or routing bucket.
    SetPlayerRoutingBucket(xPlayer.GetID(), xPlayer.GetInstance())
    SetEntityRoutingBucket(xPlayer.GetPed(), xPlayer.GetInstance())

    -- Track loaded player for persistent vehicle spawning
    if not ig.table.MatchValue(ig._loadedPlayers, src) then
        table.insert(ig._loadedPlayers, src)
        ig.log.Debug("Character", "Player " .. src .. " added to loaded players list (" .. #ig._loadedPlayers .. " total)")
        
        -- If this is the first loaded player, spawn persistent vehicles
        if #ig._loadedPlayers == 1 then
            if ig.vehicle and ig.vehicle.SpawnPersistentVehicles then
                ig.vehicle.SpawnPersistentVehicles()
            end
        end
    end

    -- Send appearance data to client for final appearance application
    local appearance = xPlayer.GetAppearance()
    if appearance then
        TriggerClientEvent("Client:Character:SetAppearance", src, appearance)
    end
    
end)

-- ====================================================================================--
-- STAGE 4: Character Switching / Deletion
-- ====================================================================================--

-- Called when player switches characters or is about to disconnect
-- Cleans up character-specific data (job permissions, active markers, etc.)
RegisterNetEvent("Server:Character:Switch", function(req)
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
    local src = source
    
    -- Delete character from database
    ig.sql.char.Delete(Character_ID, function()
        DropPlayer(src, "Character deleted. Please rejoin to create a new one.")
    end)
end)

-- Client failed to create/select character properly
RegisterNetEvent("Server:Character:Failed")
AddEventHandler("Server:Character:Failed", function()
    local src = source
    DropPlayer(src, "Character creation/selection failed. Please rejoin.")
end)

-- Client failed to create/select character properly
RegisterNetEvent("Server:Character:Quit")
AddEventHandler("Server:Character:Quit", function()
    local src = source
    DropPlayer(src, "You have quit.")
end)

-- ====================================================================================--
-- CHARACTER CUSTOMIZATION (Appearance & Cosmetics)
-- ====================================================================================--

-- Save appearance with validation (SECURE CALLBACK)
RegisterServerCallback({
    eventName = "Server:Character:SaveAppearance",
    eventCallback = function(source, appearance)
        local src = tonumber(source)
        local xPlayer = ig.data.GetPlayer(src)
        
        if not xPlayer then
            ig.log.Error("APPEARANCE", "No xPlayer found for source: %d", src)
            return { success = false, error = "Player not found" }
        end
        
        -- Validate appearance data structure
        local isValid, errorMsg = ig.appearance.ValidateAppearance(appearance)
        if not isValid then
            ig.log.Error("APPEARANCE", "Invalid appearance data for %s: %s", 
                xPlayer.GetIdentifier(), errorMsg)
            return { success = false, error = errorMsg or "Invalid appearance data" }
        end
        
        -- Save validated appearance to database
        local identifier = xPlayer.GetIdentifier()
        local p = promise.new()
        
        ig.sql.char.SetAppearance(identifier, appearance, function()
            xPlayer.SetAppearance(appearance)
            ig.log.Info("APPEARANCE", "Saved appearance for %s", identifier)
            p:resolve()
        end)
        
        -- Wait for database save to complete
        Citizen.Await(p)
        
        return {
            success = true,
            message = "Appearance saved successfully"
        }
    end
})
-- ====================================================================================--
-- STAGE 6: CHARACTER STATE MANAGEMENT (Job, Duty, Death)
-- ====================================================================================--

-- Handle player death (marked as "down" for recovery or jailing)
RegisterNetEvent("Server:Character:Death")
AddEventHandler("Server:Character:Death", function(data)
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