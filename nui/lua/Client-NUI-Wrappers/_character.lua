-- ====================================================================================--
-- CHARACTER CLIENT-NUI WRAPPER FUNCTIONS
-- ====================================================================================--
-- Centralized wrapper functions for character system NUI operations.
-- These functions send messages FROM CLIENT TO NUI.
--
-- Call these from client/[Events]/_character.lua:
--   - ig.nui.character.ShowSelect()     => Client:NUI:CharacterSelectShow
--   - ig.nui.character.HideSelect()     => Client:NUI:CharacterSelectHide
--   - ig.nui.character.ShowCreate()     => Client:NUI:AppearanceOpen (mode: create)
--   - ig.nui.character.ShowCustomize()  => Client:NUI:AppearanceOpen (mode: customize)
--   - ig.nui.character.HideAppearance() => Client:NUI:AppearanceClose
--
-- ====================================================================================--
-- Show character selection UI
-- Called from: Client:Character:OpeningMenu
-- NOTE: NUI will request character data via Client:Request:CharacterList callback when mounted
function ig.nui.character.ShowSelect()
    ig.ui.Send("Client:NUI:CharacterSelectShow", {}, true)
end

-- Hide character selection UI
-- Called from: Client:Character:ReSpawn
function ig.nui.character.HideSelect()
    ig.ui.Send("Client:NUI:CharacterSelectHide", {}, false)
end

-- Show appearance creation UI
-- Called from: Client:Character:Create
function ig.nui.character.ShowCreate()
    ig.log.Info("NUI-Wrapper", "ShowCreate: Starting appearance creation UI")
    
    -- Log what we have in ig.peds before attempting callback
    local pedsCount = 0
    if ig.peds then
        for _ in pairs(ig.peds) do pedsCount = pedsCount + 1 end
    end
    ig.log.Info("NUI-Wrapper", "ShowCreate: ig.peds has %d entries before callback", pedsCount)
    ig.log.Info("NUI-Wrapper", "ShowCreate: ig.peds type: %s", type(ig.peds))
    
    -- Get appearance constants (check cache first, fallback to server request)
    local constants = ig.appearance_constants
    if not constants or ig.table.SizeOf(constants) == 0 then
        ig.log.Warn("NUI-Wrapper", "ShowCreate: ig.appearance_constants is empty, fetching from server")
        constants = ig.callback.Await('ig:GameData:GetAppearanceConstants')
    end
    ig.log.Info("NUI-Wrapper", "ShowCreate: Constants loaded: %s (keys: %d)", constants and "YES" or "NIL", constants and ig.table.SizeOf(constants) or 0)
    
    -- Get ped data from server if needed (check cache first, fallback to server request)
    local peds = ig.peds
    if not peds or ig.table.SizeOf(peds) == 0 then
        ig.log.Warn("NUI-Wrapper", "ShowCreate: ig.peds is empty, fetching from server")
        peds = ig.callback.Await('ig:GameData:GetPeds')
        ig.log.Info("NUI-Wrapper", "ShowCreate: Server returned peds type: %s", type(peds))
    end
    
    local pedsCountAfter = 0
    if peds then
        for _ in pairs(peds) do pedsCountAfter = pedsCountAfter + 1 end
    end
    ig.log.Info("NUI-Wrapper", "ShowCreate: Peds loaded: %d entries", pedsCountAfter)
    
    -- Get tattoo data (check cache first, fallback to server request)
    local tattoos = ig.tattoos
    if not tattoos or ig.table.SizeOf(tattoos) == 0 then
        ig.log.Warn("NUI-Wrapper", "ShowCreate: ig.tattoos is empty, fetching from server")
        tattoos = ig.callback.Await('ig:GameData:GetTattoos')
    end
    ig.log.Info("NUI-Wrapper", "ShowCreate: Tattoos loaded: %s (keys: %d)", tattoos and "YES" or "NIL", tattoos and ig.table.SizeOf(tattoos) or 0)
    
    -- Get default appearance for new character with proper structure
    local defaultAppearance = {
        model = "mp_m_freemode_01",
        headBlend = {
            shapeFirst = 0,
            shapeSecond = 0,
            skinFirst = 0,
            skinSecond = 0,
            shapeMix = 0.5,
            skinMix = 0.5,
            thirdMix = 0.0
        },
        faceFeatures = {},
        headOverlays = {},
        hair = {
            style = 0,
            color = 0,
            highlight = 0
        },
        eyeColor = 0,
        components = {},
        props = {},
        tattoos = {}
    }
    
    -- Override with constants default if available
    if constants and constants.defaultAppearance then
        for k, v in pairs(constants.defaultAppearance) do
            defaultAppearance[k] = v
        end
    end
    
    ig.log.Info("NUI-Wrapper", "ShowCreate: Default appearance model=%s", defaultAppearance.model)
    
    -- Config for character creation (allow model change, allow tattoos)
    local config = {
        allowModelChange = true,
        allowTattoos = true,
        isCharacterCreation = true
    }
    
    local data = {
        appearance = defaultAppearance,
        constants = constants,
        peds = peds,
        tattoos = tattoos,
        config = config,
        mode = "create",
        onComplete = "Client:Character:AppearanceComplete"
    }
    
    ig.log.Info("NUI-Wrapper", "ShowCreate: Sending to NUI - appearance model=%s, peds=%s, constants=%s", 
        data.appearance.model, 
        data.peds and "YES" or "NIL",
        data.constants and "YES" or "NIL")
    
    ig.log.Info("NUI-Wrapper", "ShowCreate: Sending appearance data to NUI with %d peds, %d tattoo entries", 
        peds and ig.table.SizeOf(peds) or 0,
        tattoos and ig.table.SizeOf(tattoos) or 0)
    
    ig.ui.Send("Client:NUI:AppearanceOpen", data, true)
    
    ig.log.Debug("NUI-Wrapper", "ShowCreate: Complete - NUI focus should now be active")
end

-- Show appearance customization UI
-- Called from: other resources for appearance editing
function ig.nui.character.ShowCustomize()
    -- Get appearance constants (check cache first, fallback to server request)
    local constants = ig.appearance_constants or ig.callback.Await('ig:GameData:GetAppearanceConstants')
    
    -- Get ped data from server if needed (check cache first, fallback to server request)
    local peds = ig.peds or ig.callback.Await('ig:GameData:GetPeds')
    
    -- Get tattoo data (check cache first, fallback to server request)
    local tattoos = ig.tattoos or ig.callback.Await('ig:GameData:GetTattoos')
    
    -- Get current player appearance
    local currentAppearance = ig.appearance.GetAppearance()
    
    -- Config for appearance customization
    local config = {
        allowModelChange = true,
        allowTattoos = true,
        isCharacterCreation = false
    }
    
    ig.ui.Send("Client:NUI:AppearanceOpen", {
        appearance = currentAppearance,
        constants = constants,
        peds = peds,
        tattoos = tattoos,
        config = config,
        mode = "customize",
        onComplete = "Client:Character:AppearanceComplete"
    }, true)
end

-- Hide appearance UI
-- Called from: Client:Character:AppearanceComplete or user cancel
function ig.nui.character.HideAppearance()
    ig.ui.Send("Client:NUI:AppearanceClose", {}, false)
end

ig.log.Info("Client-NUI", "Character wrapper functions loaded")
