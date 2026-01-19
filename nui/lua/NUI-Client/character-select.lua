-- ====================================================================================--
-- CHARACTER NUI→CLIENT CALLBACK HANDLERS
-- ====================================================================================--
-- Processes messages FROM NUI TO CLIENT for character operations.
-- These callbacks receive data from NUI and communicate with the server.
--
-- NUI sends these messages:
--   - NUI:Client:CharacterPlay      => TriggerServerEvent("Server:Character:Join")
--   - NUI:Client:CharacterDelete    => TriggerServerEvent("Server:Character:Delete")
--   - NUI:Client:CharacterCreate    => TriggerServerEvent("Server:Character:Register")
--
-- ====================================================================================--

-- Player selects an existing character from NUI
RegisterNUICallback("NUI:Client:CharacterPlay", function(data, cb)
    if not data.ID then
        cb({
            message = "error",
            data = "NUI:Client:CharacterPlay: missing data.ID"
        })
        return
    end
    
    -- Verify player is not already loaded
    if not ig.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        ig.log.Trace("Character", "NUI: Player selected character " .. data.ID)
        
        -- Send to server for validation and loading
        -- NOTE: server/[Events]/_character_lifecycle.lua handles Server:Character:Join
        TriggerServerEvent("Server:Character:Join", data.ID)

        cb({
            message = "ok",
            data = nil
        })
    else
        cb({
            message = "error",
            data = "NUI:Client:CharacterPlay: Player already has a character loaded"
        })
    end
end)

-- Player deletes a character from NUI
RegisterNUICallback("NUI:Client:CharacterDelete", function(data, cb)
    if not data.ID then
        cb({
            message = "error",
            data = "NUI:Client:CharacterDelete: missing data.ID"
        })
        return
    end
    
    -- Verify player is not already loaded
    if not ig.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        ig.log.Trace("Character", "NUI: Player deleting character " .. data.ID)
        
        -- Send to server for validation and deletion
        -- NOTE: server/[Events]/_character_lifecycle.lua handles Server:Character:Delete
        TriggerServerEvent("Server:Character:Delete", data.ID)
        
        cb({
            message = "ok",
            data = nil
        })
    else
        cb({
            message = "error",
            data = "NUI:Client:CharacterDelete: Player already has a character loaded"
        })
    end
end)

-- Start new character creation - opens appearance customizer
-- Called FIRST when player clicks "New Character" - shows appearance customization screen
-- NOTE: Name form is shown by NUI AFTER this completes
RegisterNUICallback("NUI:Client:NewCharacter", function(data, cb)
    if not ig.data.IsPlayerLoaded() then
        ig.log.Info("Character", "NUI: Starting new character creation - opening appearance customizer")
        -- Hide character select UI immediately
        ig.nui.character.HideSelect()
            -- Show appearance customizer UI via wrapper function
            -- NOTE: This sends Client:NUI:AppearanceOpen to NUI
            -- NUI will show name form AFTER player completes appearance customization
        ig.nui.character.ShowCreate()
        
        ig.log.Debug("Character", "Appearance customizer opened, awaiting completion")

        
        cb({
            message = "ok",
            data = "Appearance customizer opened"
        })
    else
        cb({
            message = "error",
            data = "Player already has a character loaded"
        })
    end
end)

-- Complete new character creation - called AFTER appearance customization is done
-- At this point NUI has collected: firstName, lastName, AND appearance data
RegisterNUICallback("NUI:Client:CharacterCreate", function(data, cb)
    if not ig.data.IsPlayerLoaded() then
        SetNuiFocus(false, false)
        
        -- Get name fields (NUI sends camelCase: firstName, lastName)
        local firstName = data.firstName or data.First_Name
        local lastName = data.lastName or data.Last_Name
        local appearance = data.appearance or data.Appearance
        
        -- Validate that we have ALL required data
        if not firstName or not lastName then
            ig.log.Error("Character", "NUI: CharacterCreate missing name data: " .. json.encode(data or {}))
            cb({
                message = "error",
                data = "Missing first name or last name"
            })
            return
        end
        
        if not appearance then
            ig.log.Error("Character", "NUI: CharacterCreate missing appearance data")
            cb({
                message = "error",
                data = "Missing appearance customization"
            })
            return
        end
        
        ig.log.Info("Character", "NUI: Creating new character - First: " .. firstName .. ", Last: " .. lastName)
        ig.log.Debug("Character", "Character appearance data: " .. json.encode(appearance))
        
        -- Send to server with ALL character data (name + appearance) using SECURE CALLBACK
        ig.log.Debug("Character", "Sending Server:Character:Register with complete data")
        ig.callback.Async("Server:Character:Register", function(result)
            if result and result.success then
                ig.log.Info("Character", "Character created successfully: " .. (result.character_id or "unknown"))
            else
                ig.log.Error("Character", "Character creation failed: " .. (result and result.error or "Unknown error"))
            end
        end, firstName, lastName, appearance)
        
        cb({
            message = "ok",
            data = "Character creation submitted"
        })
    else
        cb({
            message = "error",
            data = "NUI:Client:CharacterCreate: Player already has a character loaded"
        })
    end
end)

-- Cancel character creation - return to selection screen
RegisterNUICallback("NUI:Client:CancelCharacterCreation", function(data, cb)
    ig.log.Info("Character", "NUI: Canceling character creation")
    
    -- IMPORTANT: Use HideAppearance() not HideCreate() - HideCreate doesn't exist!
    -- HideAppearance sends Client:NUI:AppearanceClose to NUI which triggers appearanceStore.close()
    ig.nui.character.HideAppearance()
    
    -- Delete/hide the ped (it will be recreated when they try again)
    local ped = PlayerPedId()
    if DoesEntityExist(ped) then
        SetEntityVisible(ped, false, false)
    end
    
    cb({
        message = "ok",
        data = "Character creation canceled"
    })
end)

-- Quit server - drop player
RegisterNUICallback("NUI:Client:QuitServer", function(data, cb)
    ig.log.Info("Character", "NUI: Player quitting server")
    
    SetNuiFocus(false, false)
    
    -- Add dissconnect logic here.
    TriggerServerEvent("Server:Character:Quit")
    
    cb({
        message = "ok",
        data = "Disconnecting from server"
    })
end)

-- NUI requests character list from client
-- This is called by NUI when App.vue mounts to get character data
RegisterNUICallback("Client:Request:OnJoinGetCharactersFromServer", function(data, cb)
    ig.log.Trace("Character", "NUI: Requesting character list")
    ---
    --- THIS IS THE INIT LOGGIC FOR MAKING THE CHARACTER BE AT A CERTAIN PLACE.
    ---
    ig.func.IsBusyPleaseWait(3000)

    ig.data.SetLoadedStatus(false)
    --
    local ped = PlayerPedId()
    if DoesEntityExist(ped) then
        SetEntityVisible(ped, true, true)
    end
    --
    SetEntityCoords(ped, -550.21, 1340.24, 559.22)
    SetEntityHeading(ped, 189.21)
    --
    FreezeEntityPosition(ped, true)
    --
    ig.func.IsBusyPleaseWait(500)
    -- Request character list from server using ig.callback.Async wrapper
    ig.callback.Async("Server:Character:List", function(result)
        ig.log.Debug("Character", "Server callback returned: " .. json.encode(result or "nil"))
        
        if result then
            ig.log.Trace("Character", "Received character list from server - Characters: " .. #(result.Characters or {}) .. ", Slots: " .. (result.Slots or 0))
            ig.func.IsBusyPleaseWait(1000)
            ShutdownLoadingScreenNui()
            -- Send character data to NUI using standard ig.ui.Send wrapper
            ig.ui.Send("Client:NUI:CharacterSelectShow", {
                characters = result.Characters or {},
                slots = result.Slots or 1
            }, true)
            
            ig.log.Debug("Character", "Sent NUI message with " .. #(result.Characters or {}) .. " characters")
            
            -- Return success to callback
            cb({
                message = "ok",
                data = "Character list loaded"
            })
        else
            ig.log.Error("Character", "Failed to retrieve character list from server")
            cb({
                message = "error",
                data = "Failed to retrieve character list"
            })
        end
    end)
end)

ig.log.Info("NUI-Client", "Character callbacks registered")
